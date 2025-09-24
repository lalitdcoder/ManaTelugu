import SwiftUI
import Combine

// MARK: - Navigation Service for Enhanced Navigation Handling
class NavigationService: ObservableObject {
    static let shared = NavigationService()
    
    @Published var isLoading = false
    @Published var loadingMessage: String?
    @Published var navigationPath = NavigationPath()
    @Published var showingError = false
    @Published var errorMessage = ""

    private var cancellables = Set<AnyCancellable>()
    private var lastNavigationTime: Date = Date.distantPast
    private let navigationDebounceInterval: TimeInterval = 0.5 // 500ms debounce
    private var isNavigating = false
    
    private init() {}
    
    // MARK: - Navigation with Loading State
    func navigateWithLoading<Destination: Hashable>(
        to destination: Destination,
        loadingMessage: String? = nil,
        delay: TimeInterval = 0.3
    ) {
        // Prevent multiple rapid navigation calls
        guard !isNavigating else {
            print("DEBUG: Navigation blocked - already navigating")
            return
        }
        
        // Debounce navigation calls
        let now = Date()
        guard now.timeIntervalSince(lastNavigationTime) >= navigationDebounceInterval else {
            print("DEBUG: Navigation debounced - too soon since last navigation")
            return
        }
        
        isNavigating = true
        lastNavigationTime = now
        
        print("DEBUG: NavigationService.navigateWithLoading called for: \(destination)")
        
        // Show loading state
        withAnimation(.easeInOut(duration: 0.2)) {
            isLoading = true
            self.loadingMessage = loadingMessage
        }
        
        // Simulate loading delay for smooth transition
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isLoading = false
                self.loadingMessage = nil
            }
            
            // Navigate to destination
            print("DEBUG: NavigationService appending destination: \(destination)")
            self.navigationPath.append(destination)
            
            // Reset navigation flag after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isNavigating = false
            }
        }
    }
    
    // MARK: - Async Navigation with Loading
    func navigateWithAsyncLoading<Destination: Hashable>(
        to destination: Destination,
        loadingMessage: String? = nil,
        asyncOperation: @escaping () async throws -> Void
    ) {
        // Show loading state
        withAnimation(.easeInOut(duration: 0.2)) {
            isLoading = true
            self.loadingMessage = loadingMessage
        }
        
        // Execute async operation
        Task {
            do {
                try await asyncOperation()
                
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.isLoading = false
                        self.loadingMessage = nil
                    }
                    
                    // Navigate to destination
                    self.navigationPath.append(destination)
                }
            } catch {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.isLoading = false
                        self.loadingMessage = nil
                    }
                    
                    // Show error
                    self.showError(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Action with Loading and Result
    func performActionWithLoading(
        loadingMessage: String? = nil,
        successMessage: String? = nil,
        errorMessage: String? = nil,
        action: @escaping () async throws -> Void
    ) {
        // Show loading state
        withAnimation(.easeInOut(duration: 0.2)) {
            isLoading = true
            self.loadingMessage = loadingMessage
        }
        
        // Execute async action
        Task {
            do {
                try await action()
                
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.isLoading = false
                        self.loadingMessage = nil
                    }
                    
                    // Show success message if provided
                    if let successMessage = successMessage {
                        self.showSuccess(successMessage)
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.isLoading = false
                        self.loadingMessage = nil
                    }
                    
                    // Show error message
                    self.showError(errorMessage ?? error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Error Handling
    func showError(_ message: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            errorMessage = message
            showingError = true
        }
        
        // Auto-hide error after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.showingError = false
            }
        }
    }
    
    func showSuccess(_ message: String) {
        // You can implement a success toast or notification here
        print("Success: \(message)")
    }
    
    // MARK: - Navigation Control
    func popToRoot() {
        withAnimation(.easeInOut(duration: 0.3)) {
            navigationPath = NavigationPath()
        }
    }
    
    func pop() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        }
    }
    
    // MARK: - Loading State Control
    func setLoading(_ loading: Bool, message: String? = nil) {
        withAnimation(.easeInOut(duration: 0.2)) {
            isLoading = loading
            loadingMessage = message
        }
    }
}

// MARK: - Navigation Loading Overlay
struct NavigationLoadingOverlay: View {
    @ObservedObject var navigationService: NavigationService
    
    var body: some View {
        if navigationService.isLoading {
            ZStack {
                // Blurred background
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .blur(radius: 2)
                
                // Loading container
                VStack(spacing: 16) {
                    PulsingSpinner()
                    
                    if let message = navigationService.loadingMessage {
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                )
            }
            .transition(.opacity.combined(with: .scale))
        }
    }
}

// MARK: - Error Toast
struct ErrorToast: View {
    let message: String
    let isVisible: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        if isVisible {
            VStack {
                Spacer()
                
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button("Dismiss") {
                        onDismiss()
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 100) // Account for tab bar
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

// MARK: - Enhanced Navigation View (using existing one from EnhancedTransitions)
// Note: EnhancedNavigationView is already defined in EnhancedTransitions.swift
