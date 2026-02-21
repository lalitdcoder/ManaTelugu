import SwiftUI

// MARK: - Glass Card View Modifier
/// A reusable glassmorphism card component matching the Android 'GlassCard' design
/// Features: Translucent white background, blur effect, subtle border, and shadow
struct GlassCardModifier: ViewModifier {
    let cornerRadius: CGFloat
    let padding: CGFloat
    let shadowRadius: CGFloat
    let borderOpacity: Double

    init(
        cornerRadius: CGFloat = 24,
        padding: CGFloat = 16,
        shadowRadius: CGFloat = 10,
        borderOpacity: Double = 0.2
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.shadowRadius = shadowRadius
        self.borderOpacity = borderOpacity
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    // Glassmorphism background with blur
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)

                    // Translucent white overlay for glass effect
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .overlay(
                // Subtle border for definition
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(borderOpacity),
                                Color.white.opacity(borderOpacity * 0.3),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: Color.black.opacity(0.1),
                radius: shadowRadius,
                x: 0,
                y: 4
            )
    }
}

// MARK: - View Extension
extension View {
    /// Apply glassmorphism card styling to any view
    /// - Parameters:
    ///   - cornerRadius: Corner radius for the card (default: 24)
    ///   - padding: Internal padding (default: 16)
    ///   - shadowRadius: Shadow blur radius (default: 10)
    ///   - borderOpacity: Border opacity (default: 0.2)
    func glassCard(
        cornerRadius: CGFloat = 24,
        padding: CGFloat = 16,
        shadowRadius: CGFloat = 10,
        borderOpacity: Double = 0.2
    ) -> some View {
        self.modifier(
            GlassCardModifier(
                cornerRadius: cornerRadius,
                padding: padding,
                shadowRadius: shadowRadius,
                borderOpacity: borderOpacity
            )
        )
    }
}

// MARK: - Standalone Glass Card Component
/// A standalone glass card component for wrapping content
struct GlassCardView<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let padding: CGFloat

    init(
        cornerRadius: CGFloat = 24,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .glassCard(cornerRadius: cornerRadius, padding: padding)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.3),
                Color.purple.opacity(0.3),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 20) {
            // Example 1: Using the modifier
            VStack(alignment: .leading, spacing: 8) {
                Text("Glass Card Title")
                    .font(.headline)
                Text("This is a glass card using the modifier")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .glassCard()

            // Example 2: Using the component
            GlassCardView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Badge Unlocked!")
                            .font(.headline)
                    }
                    Text("You've earned the Explorer badge")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}
