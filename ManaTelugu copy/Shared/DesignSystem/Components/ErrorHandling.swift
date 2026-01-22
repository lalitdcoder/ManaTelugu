import SwiftUI

// MARK: - Error Handling Components
struct ErrorHandling {
    
    // MARK: - Error Alert
    struct ErrorAlert: View {
        let title: String
        let message: String
        let isPresented: Binding<Bool>
        let primaryAction: (() -> Void)?
        let secondaryAction: (() -> Void)?
        
        init(
            title: String,
            message: String,
            isPresented: Binding<Bool>,
            primaryAction: (() -> Void)? = nil,
            secondaryAction: (() -> Void)? = nil
        ) {
            self.title = title
            self.message = message
            self.isPresented = isPresented
            self.primaryAction = primaryAction
            self.secondaryAction = secondaryAction
        }
        
        var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.red)
                
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 12) {
                    if let secondaryAction = secondaryAction {
                        Button("Cancel") {
                            secondaryAction()
                            isPresented.wrappedValue = false
                        }
                        .buttonStyle(.secondary())
                    }
                    
                    Button("OK") {
                        primaryAction?()
                        isPresented.wrappedValue = false
                    }
                    .buttonStyle(.primary())
                }
            }
            .padding(24)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 10)
        }
    }
    
    // MARK: - Success Toast
    struct SuccessToast: View {
        let message: String
        let isPresented: Binding<Bool>
        let duration: TimeInterval
        
        init(message: String, isPresented: Binding<Bool>, duration: TimeInterval = 2.0) {
            self.message = message
            self.isPresented = isPresented
            self.duration = duration
        }
        
        var body: some View {
            if isPresented.wrappedValue {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    Text(message)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 4)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isPresented.wrappedValue = false
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Inline Error Message
    struct InlineErrorMessage: View {
        let message: String
        let isVisible: Bool
        
        var body: some View {
            if isVisible {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    Spacer()
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    // MARK: - Retry Button
    struct RetryButton: View {
        let action: () -> Void
        let isLoading: Bool
        
        var body: some View {
            Button(action: action) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Image(systemName: "arrow.clockwise")
                        Text("Retry")
                    }
                }
            }
            .buttonStyle(.primary(isEnabled: !isLoading, isLoading: isLoading))
        }
    }
}

// MARK: - Error Handling Modifier
extension View {
    func errorHandling() -> some View {
        self
    }
}
