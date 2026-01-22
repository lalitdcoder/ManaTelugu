import SwiftUI

@main
struct ManaTeluguApp: App {
    @StateObject private var session = AppSession()
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                AppleHIGSplashView()
                    .preferredColorScheme(session.preferredColorScheme)
                    .onAppear {
                        setupAppleHIGAppearance()
                        Task {
                            await session.preloadData()
                            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isLoading = false
                            }
                        }
                    }
            } else {
                // Use the original working root view
                RootTabView()
                    .environmentObject(session)
                    .preferredColorScheme(session.preferredColorScheme)
                    .onAppear {
                        session.gamificationService.onAppLaunch()
                    }
            }
        }
    }
    
    private func setupAppleHIGAppearance() {
        // Configure comprehensive dark mode support
        DarkModeConfiguration.configureAppForDarkMode()

        // Configure comprehensive accessibility support
        AccessibilityEnhancements.configureAppForAccessibility()
    }
}

// MARK: - Apple HIG Splash View
struct AppleHIGSplashView: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var progressValue: Double = 0.0
    
    var body: some View {
        ZStack {
            // Background using system colors
            AppleHIGDesign.Colors.systemBackground
                .ignoresSafeArea()
            
            VStack(spacing: AppleHIGDesign.Spacing.xxxl) {
                // App logo and title
                VStack(spacing: AppleHIGDesign.Spacing.lg) {
                    // Telugu text logo
                    VStack(spacing: AppleHIGDesign.Spacing.sm) {
                        Text("మన")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(AppleHIGDesign.Colors.primary)
                        
                        Text("తెలుగు")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(AppleHIGDesign.Colors.secondary)
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    
                    // English subtitle
                    Text("Learn Telugu with Joy")
                        .font(AppleHIGDesign.Typography.title3)
                        .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                        .opacity(logoOpacity)
                }
                
                // Loading indicator
                VStack(spacing: AppleHIGDesign.Spacing.md) {
                    SwiftUI.ProgressView(value: progressValue)
                        .tint(AppleHIGDesign.Colors.primary)
                        .scaleEffect(y: 2)
                        .frame(width: 200)
                    
                    Text("Loading your Telugu journey...")
                        .font(AppleHIGDesign.Typography.subheadline)
                        .foregroundColor(AppleHIGDesign.Colors.tertiaryLabel)
                }
                .opacity(logoOpacity)
            }
        }
        .onAppear {
            // Animate logo appearance
            withAnimation(.easeOut(duration: 1.0)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            // Animate progress bar
            withAnimation(.easeInOut(duration: 2.0)) {
                progressValue = 1.0
            }
        }
    }
}

