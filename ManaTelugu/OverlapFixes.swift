import SwiftUI

// MARK: - Comprehensive Overlap Fixes for Mana Telugu App

// MARK: - Fixed Modern Design System Extensions
extension View {
    /// Fixed modern card modifier that prevents overlap issues
    func fixedModernCard(hasLiquidGlass: Bool = false) -> some View {
        self
            .padding(ModernDesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
            )
    }

    /// Fixed haptic feedback that doesn't interfere with button interactions
    func fixedHapticOnTap<T>(
        _ style: UIImpactFeedbackGenerator.FeedbackStyle, action: @escaping () -> T
    ) -> some View {
        self.onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: style)
            impactFeedback.impactOccurred()
            _ = action()
        }
    }

    /// Safe area padding that prevents tab bar overlap
    func safeTabBarPadding() -> some View {
        self.padding(.bottom, 100)
    }
}

// MARK: - Fixed Haptic Feedback Service
struct FixedHapticFeedback {
    static func light() { HapticsService.shared.lightImpact() }
    static func medium() { HapticsService.shared.mediumImpact() }
    static func heavy() { HapticsService.shared.heavyImpact() }
}

// MARK: - Fixed Modern Progress Bar
struct FixedModernProgressBar: View {
    let progress: Double
    let color: Color
    let height: CGFloat

    init(progress: Double, color: Color = ModernDesignSystem.Colors.primary, height: CGFloat = 8) {
        self.progress = max(0, min(1, progress))  // Clamp between 0 and 1
        self.color = color
        self.height = height
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(SmoothDesign.Colors.surfaceOverlay.opacity(0.2))
                    .frame(height: height)

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geometry.size.width * progress, height: height)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Fixed Glass Effect Components
struct FixedGlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground).opacity(0.9))
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.tertiarySystemBackground).opacity(0.5))
                            .blur(radius: 0.5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.separator).opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color(.systemGray4).opacity(0.3), radius: 8, x: 0, y: 4)
            )
    }
}

// MARK: - Fixed Navigation Service
class FixedNavigationService: ObservableObject {
    static let shared = FixedNavigationService()

    @Published var navigationPath = NavigationPath()

    private init() {}

    func navigate(to destination: HomeNavigationDestination) {
        HapticsService.shared.lightImpact()
        navigationPath.append(destination)
    }

    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    func goToRoot() {
        navigationPath = NavigationPath()
    }
}

// MARK: - Fixed Button Styles
struct FixedButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Fixed Scroll View with Proper Spacing
struct FixedScrollView<Content: View>: View {
    let content: Content
    let showsIndicators: Bool

    init(showsIndicators: Bool = false, @ViewBuilder content: () -> Content) {
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                content

                // Safe area padding for tab bar
                Color.clear
                    .frame(height: 100)
            }
        }
    }
}

// MARK: - Usage Instructions
/*
 To fix overlap issues in your app:

 1. Replace ElegantRootTabView with FixedElegantRootTabView in ManaTeluguApp.swift
 2. Replace HomeView with FixedHomeView
 3. Replace ElegantLessonsView with FixedElegantLessonsView
 4. Use FixedModernProgressBar instead of ModernProgressBar
 5. Use fixedModernCard() instead of modernCard()
 6. Use FixedHapticFeedback instead of HapticFeedback
 7. Tab bar and navigation bar styling is now handled by SwiftUI .toolbarBackground() modifiers

 Key fixes implemented:
 - Removed problematic blur effects from tab bar
 - Added proper bottom padding to prevent tab bar overlap
 - Fixed progress bar calculations to prevent overflow
 - Improved glass effects with better opacity and blur values
 - Fixed button interactions and haptic feedback
 - Added proper spacing and sizing constraints
 - Improved shadow and border effects
 */
