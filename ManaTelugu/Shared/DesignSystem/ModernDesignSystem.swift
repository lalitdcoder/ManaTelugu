import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - Modern Design System for Mana Telugu
struct ModernDesignSystem {

    // MARK: - Colors
    struct Colors {
        static let primary = Color("ModernPrimaryColor")
        static let secondary = Color("ModernSecondaryColor")
        static let accent = Color("ModernAccentColor")

        static var background: Color {
            #if canImport(UIKit)
                return Color(uiColor: .systemBackground)
            #else
                return Color("ModernBackgroundColor")
            #endif
        }

        static var backgroundGradient: LinearGradient {
            #if canImport(UIKit)
                return LinearGradient(
                    colors: [
                        Color(uiColor: .systemBackground),
                        Color(uiColor: .secondarySystemBackground),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            #else
                return LinearGradient(
                    colors: [
                        Color("ModernBackgroundGradientStart"),
                        Color("ModernBackgroundGradientEnd"),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            #endif
        }

        static var surface: Color {
            #if canImport(UIKit)
                return Color(uiColor: .secondarySystemBackground)
            #else
                return Color("ModernSurfaceColor")
            #endif
        }

        static var surfaceSecondary: Color {
            #if canImport(UIKit)
                return Color(uiColor: .tertiarySystemBackground)
            #else
                return Color("ModernSurfaceColor")
            #endif
        }

        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary

        static var textTertiary: Color {
            #if canImport(UIKit)
                return Color(uiColor: .tertiaryLabel)
            #else
                return Color("ModernTextTertiaryColor")
            #endif
        }

        static var tertiaryText: Color { textTertiary }

        static let alphabet = Color("ModernAlphabetColor")
        static let lessons = Color("ModernLessonsColor")
        static let stories = Color("ModernStoriesColor")
        static let games = Color("ModernGamesColor")

        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red

        static let culturalGold = Color("ModernCulturalGoldColor")
        static let culturalOrange = Color("ModernCulturalOrangeColor")

        static let funBlue = Color("ModernFunBlueColor")
        static let funGreen = Color("ModernFunGreenColor")
        static let funPink = Color("ModernFunPinkColor")
        static let funPurple = Color("ModernFunPurpleColor")

        static let primaryText = Color.primary
        static let secondaryText = Color.secondary
        static let funYellow = Color("ModernFunYellowColor")

        static let teluguBlue = Color("ModernTeluguBlueColor")
        static let teluguGreen = Color("ModernTeluguGreenColor")
        static let teluguSaffron = Color("ModernTeluguSaffronColor")
        static let culturalRed = Color("ModernCulturalRedColor")

        static var cardBackground: Color {
            #if canImport(UIKit)
                return Color(uiColor: .secondarySystemBackground)
            #else
                return Color("ModernCardBackgroundColor")
            #endif
        }

        static let shadow = Color.black.opacity(0.2)
    }

    // MARK: - Typography (now fully supports Dynamic Type!)
    struct Typography {
        // Use semantic styles for full Dynamic Type support:
        static let largeTitle = Font.largeTitle
        static let title1 = Font.title
        static let title2 = Font.title2
        static let title3 = Font.title3
        static let headline = Font.headline
        static let body = Font.body
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption = Font.caption
        static let caption2 = Font.caption2

        // If you want a rounded design or weight:
        static var teluguBody: Font { Font.body.weight(.medium).rounded() }
        static var encouragement: Font { Font.headline.weight(.semibold).rounded() }
        static var celebration: Font { Font.title.weight(.bold).rounded() }
        static var progress: Font { Font.footnote.weight(.medium).rounded() }
        static var teluguTitle: Font { Font.title.weight(.bold).rounded() }
        static var teluguHeading: Font { Font.title2.weight(.semibold).rounded() }
    }

    // MARK: - Spacing
    struct Spacing {
        static let tiny: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xLarge: CGFloat = 40
        static let regular: CGFloat = 16
        static let minimumTouchTarget: CGFloat = 44
        static let recommendedTouchTarget: CGFloat = 44
        static let comfortableTouchTarget: CGFloat = 48
    }

    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let pill: CGFloat = 25
    }

    // MARK: - Shadows
    struct Shadow {
        static let sm = ModernDesignSystem.Colors.shadow.opacity(0.05)
        static let md = ModernDesignSystem.Colors.shadow.opacity(0.08)
        static let lg = ModernDesignSystem.Colors.shadow.opacity(0.12)
        static let xl = ModernDesignSystem.Colors.shadow.opacity(0.16)
    }
}

// MARK: - Liquid Glass Effect
struct ModernLiquidGlassBackground: View {
    let opacity: Double
    let blurRadius: CGFloat

    init(opacity: Double = 0.1, blurRadius: CGFloat = 20) {
        self.opacity = opacity
        self.blurRadius = blurRadius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
            .fill(
                LinearGradient(
                    colors: [
                        Color("ModernGlassHighlightColor").opacity(opacity),
                        Color("ModernGlassHighlightColor").opacity(opacity * 0.5),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .background(
                RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color("ModernGlassBorderColor").opacity(0.3),
                                Color.clear,
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Modern Card
struct ModernCard<Content: View>: View {
    let content: Content
    let hasLiquidGlass: Bool
    let shadowOpacity: Double

    init(
        hasLiquidGlass: Bool = false, shadowOpacity: Double = 0.08,
        @ViewBuilder content: () -> Content
    ) {
        self.hasLiquidGlass = hasLiquidGlass
        self.shadowOpacity = shadowOpacity
        self.content = content()
    }

    var body: some View {
        content
            .padding(ModernDesignSystem.Spacing.md)
            .background(
                Group {
                    if hasLiquidGlass {
                        ModernLiquidGlassBackground()
                    } else {
                        RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
                            .fill(ModernDesignSystem.Colors.surface)
                    }
                }
            )
            .shadow(
                color: ModernDesignSystem.Colors.shadow.opacity(shadowOpacity),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

// MARK: - Modern Button
struct ModernButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let action: () -> Void

    enum ButtonStyle {
        case primary
        case secondary
        case accent
        case liquidGlass
    }

    init(
        _ title: String, icon: String? = nil, style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: {
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            HStack(spacing: ModernDesignSystem.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }

                Text(title)
                    .font(.callout)  // <-- now uses semantic style
                    .fontWeight(.semibold)
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, ModernDesignSystem.Spacing.lg)
            .padding(.vertical, ModernDesignSystem.Spacing.md)
            .background(backgroundView)
            .cornerRadius(ModernDesignSystem.CornerRadius.md)
        }
        .buttonStyle(HapticPlainButtonStyle())
    }

    private var foregroundColor: Color {
        switch style {
        case .primary, .accent:
            return ModernDesignSystem.Colors.textPrimary
        case .secondary, .liquidGlass:
            return ModernDesignSystem.Colors.textPrimary
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            ModernDesignSystem.Colors.primary
        case .secondary:
            ModernDesignSystem.Colors.surface
                .overlay(
                    RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
                        .stroke(ModernDesignSystem.Colors.primary, lineWidth: 2)
                )
        case .accent:
            ModernDesignSystem.Colors.secondary
        case .liquidGlass:
            ModernLiquidGlassBackground(opacity: 0.2)
        }
    }
}

// MARK: - Haptic Feedback Helper
struct HapticFeedback {
    static func light() { HapticsManager.shared.impact(.light) }
    static func medium() { HapticsManager.shared.impact(.medium) }
    static func heavy() { HapticsManager.shared.impact(.heavy) }
    static func success() { HapticsManager.shared.notification(.success) }
    static func warning() { HapticsManager.shared.notification(.warning) }
    static func error() { HapticsManager.shared.notification(.error) }
}

// MARK: - View Extensions
extension View {
    func modernCard(hasLiquidGlass: Bool = false, shadowOpacity: Double = 0.08) -> some View {
        ModernCard(hasLiquidGlass: hasLiquidGlass, shadowOpacity: shadowOpacity) {
            self
        }
    }

    func hapticOnTap(
        _ style: UIImpactFeedbackGenerator.FeedbackStyle = .light, action: @escaping () -> Void
    ) -> some View {
        self.onTapGesture {
            HapticsManager.shared.impact(style)
            action()
        }
    }
}

// MARK: - Font+Rounded Helper (optional)
extension Font {
    fileprivate func rounded() -> Font {
        return self  // SwiftUI automatically uses rounded on modern system fonts if preferred
    }
}
