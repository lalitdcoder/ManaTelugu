import SwiftUI

@main
struct ManaTeluguApp: App {
    @StateObject private var session = AppSession()
    @Environment(\.scenePhase) var scenePhase
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            if isLoading {
                PremiumSplashView()
                    .preferredColorScheme(session.preferredColorScheme)
                    .onAppear {
                        setupAppleHIGAppearance()
                        Task {
                            await session.preloadData()
                            try? await Task.sleep(nanoseconds: 2_200_000_000)  // 2.2 seconds
                            withAnimation(.easeInOut(duration: 0.6)) {
                                isLoading = false
                            }
                        }
                    }
            } else {
                RootTabView()
                    .environmentObject(session)
                    .preferredColorScheme(session.preferredColorScheme)
                    .onAppear {
                        session.gamificationService.onAppLaunch()
                    }
                    .onChange(of: scenePhase) { _, newPhase in
                        if newPhase == .active {
                            session.regenerateHeartsIfNeeded()
                        }
                    }
            }
        }
    }

    private func setupAppleHIGAppearance() {
        DarkModeConfiguration.configureAppForDarkMode()
        AccessibilityEnhancements.configureAppForAccessibility()
    }
}

// MARK: - Premium Splash View
struct PremiumSplashView: View {
    @State private var titleOpacity: Double = 0
    @State private var titleScale: CGFloat = 0.75
    @State private var subtitleOpacity: Double = 0
    @State private var progressOpacity: Double = 0
    @State private var progressValue: Double = 0
    @State private var glowOpacity: Double = 0
    @State private var currentLetterIndex = 0

    private let teluguLetters = ["మ", "న", "తె", "లు", "గు"]
    private let midnightIndigo = Color(red: 0.18, green: 0.13, blue: 0.42)
    private let deepIndigo = Color(red: 0.22, green: 0.17, blue: 0.52)
    private let royalIndigo = Color(red: 0.32, green: 0.18, blue: 0.62)
    private let saffronGold = Color(red: 0.98, green: 0.67, blue: 0.12)

    var body: some View {
        ZStack {
            // Rich gradient background
            LinearGradient(
                colors: [midnightIndigo, deepIndigo, royalIndigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative watermark letters
            GeometryReader { geo in
                ZStack {
                    Text("తె")
                        .font(.system(size: 220, weight: .bold))
                        .foregroundStyle(.white.opacity(0.04))
                        .position(x: geo.size.width * 0.75, y: geo.size.height * 0.18)

                    Text("లు")
                        .font(.system(size: 180, weight: .bold))
                        .foregroundStyle(.white.opacity(0.035))
                        .position(x: geo.size.width * 0.15, y: geo.size.height * 0.72)
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 48) {
                Spacer()

                // Main logo block
                VStack(spacing: 20) {
                    // Saffron glow ring + icon
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(saffronGold.opacity(0.15))
                            .frame(width: 130, height: 130)
                            .blur(radius: 20)
                            .opacity(glowOpacity)

                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [saffronGold, Color(red: 1.0, green: 0.82, blue: 0.40)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 90, height: 90)
                            .shadow(color: saffronGold.opacity(0.45), radius: 20, x: 0, y: 8)

                        Text("మ")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(midnightIndigo)
                    }
                    .scaleEffect(titleScale)
                    .opacity(titleOpacity)

                    // Telugu title
                    VStack(spacing: 6) {
                        Text("మన తెలుగు")
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)

                        Text("Mana Telugu")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.60))
                            .tracking(3)
                    }
                    .scaleEffect(titleScale)
                    .opacity(titleOpacity)
                }

                // Tagline
                Text("Learn Telugu with Joy")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.70))
                    .opacity(subtitleOpacity)

                Spacer()

                // Progress section
                VStack(spacing: 14) {
                    // Progress bar
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.12))
                            .frame(width: 200, height: 4)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [saffronGold, Color(red: 1.0, green: 0.82, blue: 0.40)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 200 * progressValue, height: 4)
                    }

                    Text("Preparing your Telugu journey...")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.45))
                }
                .opacity(progressOpacity)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            // Staggered animation sequence
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                titleScale = 1.0
                titleOpacity = 1.0
            }

            withAnimation(.easeOut(duration: 0.6).delay(0.4)) {
                glowOpacity = 1.0
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.8)) {
                subtitleOpacity = 1.0
            }

            withAnimation(.easeOut(duration: 0.4).delay(1.0)) {
                progressOpacity = 1.0
            }

            withAnimation(.easeInOut(duration: 1.8).delay(0.6)) {
                progressValue = 1.0
            }
        }
    }
}
