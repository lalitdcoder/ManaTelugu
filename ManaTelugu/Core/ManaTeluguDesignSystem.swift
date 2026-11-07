import SwiftUI
import UIKit

// MARK: - ManaTelugu Unified Design System (Apple HIG Compliant)
/// Premium Apple-quality design system for ManaTelugu with subtle Telugu cultural identity.
/// Supports Light and Dark modes with dynamic type, accessibility, and high performance.
struct ManaTheme {

    // MARK: - Color Palette
    struct Colors {
        // Primary Brand Colors (Warm Saffron Gold)
        static let primary = Color(red: 0.94, green: 0.54, blue: 0.12)
        static let primaryLight = Color(red: 0.98, green: 0.68, blue: 0.26)
        static let primaryDark = Color(red: 0.78, green: 0.40, blue: 0.08)

        // Accent / Telugu Identity Colors
        static let peacockBlue = Color(red: 0.10, green: 0.52, blue: 0.68)
        static let deepIndigo = Color(red: 0.22, green: 0.16, blue: 0.46)
        static let royalIndigo = Color(red: 0.30, green: 0.18, blue: 0.60)
        static let emeraldGreen = Color(red: 0.14, green: 0.58, blue: 0.40)
        static let terracotta = Color(red: 0.86, green: 0.38, blue: 0.26)

        // Semantic Background Colors (Adaptive Light/Dark)
        static let background = Color(UIColor.systemBackground)
        static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)

        static let groupedBackground = Color(UIColor.systemGroupedBackground)
        static let secondaryGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
        static let tertiaryGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)

        // Semantic Aliases
        static let systemBackground = background
        static let secondarySystemBackground = secondaryBackground
        static let tertiarySystemBackground = tertiaryBackground

        static let systemGroupedBackground = groupedBackground
        static let secondarySystemGroupedBackground = secondaryGroupedBackground
        static let tertiarySystemGroupedBackground = tertiaryGroupedBackground

        // Text & Label Colors
        static let label = Color(UIColor.label)
        static let secondaryLabel = Color(UIColor.secondaryLabel)
        static let tertiaryLabel = Color(UIColor.tertiaryLabel)
        static let quaternaryLabel = Color(UIColor.quaternaryLabel)

        // Fill & Overlay Colors
        static let fill = Color(UIColor.systemFill)
        static let secondaryFill = Color(UIColor.secondarySystemFill)
        static let tertiaryFill = Color(UIColor.tertiarySystemFill)
        static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
        static let separator = Color(UIColor.separator)
        static let opaqueSeparator = Color(UIColor.opaqueSeparator)

        static let secondarySystemFill = secondaryFill
        static let tertiarySystemFill = tertiaryFill

        // Feedback / State Colors
        static let success = Color(UIColor.systemGreen)
        static let warning = Color(UIColor.systemOrange)
        static let error = Color(UIColor.systemRed)
        static let info = Color(UIColor.systemBlue)

        static let systemRed = error
        static let systemGreen = success
        static let systemBlue = info
        static let systemOrange = warning
        static let systemYellow = Color(UIColor.systemYellow)
        static let systemPink = Color(UIColor.systemPink)
        static let systemPurple = Color(UIColor.systemPurple)
        static let systemTeal = Color(UIColor.systemTeal)
        static let systemIndigo = Color(UIColor.systemIndigo)

        // Learning Category Colors
        static let vowelColor = peacockBlue
        static let consonantColor = emeraldGreen
        static let numberColor = primary
        static let wordColor = royalIndigo
        static let sentenceColor = terracotta

        // Cultural Gradients
        static var heroGradient: LinearGradient {
            LinearGradient(
                colors: [deepIndigo, royalIndigo, Color(red: 0.14, green: 0.10, blue: 0.32)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        static var saffronGradient: LinearGradient {
            LinearGradient(
                colors: [primary, primaryLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        static var peacockGradient: LinearGradient {
            LinearGradient(
                colors: [peacockBlue, Color(red: 0.08, green: 0.38, blue: 0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        static var emeraldGradient: LinearGradient {
            LinearGradient(
                colors: [emeraldGreen, Color(red: 0.08, green: 0.45, blue: 0.30)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    // MARK: - Typography Hierarchy
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title1 = Font.title.weight(.bold)
        static let title2 = Font.title2.weight(.bold)
        static let title3 = Font.title3.weight(.semibold)

        static let headline = Font.headline.weight(.semibold)
        static let body = Font.body
        static let bodyEmphasized = Font.body.weight(.semibold)
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption1 = Font.caption
        static let caption2 = Font.caption2

        // Telugu Typography Tokens
        static let teluguHero = Font.system(size: 64, weight: .bold, design: .default)
        static let teluguLarge = Font.system(size: 44, weight: .bold, design: .default)
        static let teluguTitle = Font.system(size: 32, weight: .bold, design: .default)
        static let teluguMedium = Font.system(size: 24, weight: .semibold, design: .default)
        static let teluguSmall = Font.system(size: 20, weight: .medium, design: .default)
        static let teluguSubheadline = Font.system(size: 16, weight: .medium, design: .default)
        static let teluguBody = Font.system(size: 18, weight: .medium, design: .default)

        // Rounded typography
        static let roundedTitle = Font.system(size: 28, weight: .bold, design: .rounded)
        static let roundedBody = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let roundedCaption = Font.system(size: 13, weight: .medium, design: .rounded)
        static let minimumText = Font.system(size: 11, weight: .regular, design: .default)
    }

    // MARK: - Spacing System
    struct Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
        static let xxxxl: CGFloat = 48

        static let minimumTouchTarget: CGFloat = 44
        static let recommendedTouchTarget: CGFloat = 48
        static let largeTouchTarget: CGFloat = 56
        static let screenMargin: CGFloat = 16
        static let screenMarginLarge: CGFloat = 20
    }

    // MARK: - Corner Radius Tokens
    struct CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let pill: CGFloat = 50
        static let round: CGFloat = 50

        static let card: CGFloat = 18
        static let cardLarge: CGFloat = 22
        static let button: CGFloat = 14
        static let buttonLarge: CGFloat = 18
        static let hero: CGFloat = 24
    }

    // MARK: - Shadows
    struct Shadow {
        static let subtle = (color: Color.black.opacity(0.04), radius: CGFloat(6), x: CGFloat(0), y: CGFloat(2))
        static let medium = (color: Color.black.opacity(0.08), radius: CGFloat(10), x: CGFloat(0), y: CGFloat(4))
        static let elevated = (color: Color.black.opacity(0.12), radius: CGFloat(16), x: CGFloat(0), y: CGFloat(6))
        static let card = (color: Color.black.opacity(0.06), radius: CGFloat(10), x: CGFloat(0), y: CGFloat(3))
    }

    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.18)
        static let smooth = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.8)
        static let bouncy = SwiftUI.Animation.spring(response: 0.35, dampingFraction: 0.65)
        static let gentle = SwiftUI.Animation.easeInOut(duration: 0.35)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.55)

        static let buttonPress = SwiftUI.Animation.easeInOut(duration: 0.12)
        static let buttonRelease = SwiftUI.Animation.spring(response: 0.28, dampingFraction: 0.65)
    }

    // MARK: - Haptic Feedback
    struct Haptics {
        static func light() {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        static func medium() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        static func heavy() {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        static func success() {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        static func error() {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        static func warning() {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }
        static func selection() {
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
}

// MARK: - Typealias Alias Bridge for AppleHIGDesign
typealias AppleHIGDesign = ManaTheme

// MARK: - Telugu Cultural Design Palette Extensions
extension ManaTheme {
    struct TeluguPalette {
        static let midnightIndigo = Color(red: 0.16, green: 0.12, blue: 0.38)
        static let deepIndigo = Color(red: 0.22, green: 0.17, blue: 0.52)
        static let royalIndigo = Color(red: 0.30, green: 0.18, blue: 0.60)
        static let saffronGold = Color(red: 0.94, green: 0.54, blue: 0.12)
        static let saffronLight = Color(red: 0.98, green: 0.68, blue: 0.26)
        static let peacockBlue = Color(red: 0.10, green: 0.52, blue: 0.68)
        static let emeraldGreen = Color(red: 0.14, green: 0.58, blue: 0.40)
        static let terracotta = Color(red: 0.86, green: 0.38, blue: 0.26)

        static var heroGradient: LinearGradient { ManaTheme.Colors.heroGradient }
        static var saffronGradient: LinearGradient { ManaTheme.Colors.saffronGradient }
        static var peacockGradient: LinearGradient { ManaTheme.Colors.peacockGradient }
        static var emeraldGradient: LinearGradient { ManaTheme.Colors.emeraldGradient }
    }
}

// MARK: - Reusable Mana Components

// MARK: - Premium Mana Card
struct ManaCard<Content: View>: View {
    let style: CardStyle
    let padding: CGFloat
    let content: Content

    enum CardStyle {
        case elevated, filled, outlined
    }

    init(
        style: CardStyle = .elevated,
        padding: CGFloat = ManaTheme.Spacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous)
                    .stroke(strokeColor, lineWidth: strokeWidth)
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowY
            )
    }

    private var backgroundColor: Color {
        switch style {
        case .elevated, .filled:
            return ManaTheme.Colors.secondaryGroupedBackground
        case .outlined:
            return ManaTheme.Colors.groupedBackground
        }
    }

    private var strokeColor: Color {
        switch style {
        case .elevated:
            return ManaTheme.Colors.separator.opacity(0.25)
        case .filled:
            return Color.clear
        case .outlined:
            return ManaTheme.Colors.separator
        }
    }

    private var strokeWidth: CGFloat {
        style == .outlined ? 1.0 : 0.5
    }

    private var shadowColor: Color {
        style == .elevated ? ManaTheme.Shadow.subtle.color : .clear
    }

    private var shadowRadius: CGFloat {
        style == .elevated ? ManaTheme.Shadow.subtle.radius : 0
    }

    private var shadowY: CGFloat {
        style == .elevated ? ManaTheme.Shadow.subtle.y : 0
    }
}

// MARK: - Apple HIG Card Compatibility Bridge
typealias AppleHIGCard = ManaCard

// MARK: - Premium Mana Button Style
struct ManaButtonStyle: ButtonStyle {
    let variant: Variant
    let size: Size

    enum Variant {
        case primary, secondary, tertiary, destructive, glass
    }

    enum Size {
        case small, medium, large

        var height: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return ManaTheme.Spacing.recommendedTouchTarget
            case .large: return ManaTheme.Spacing.largeTouchTarget
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14)
            case .medium: return EdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18)
            case .large: return EdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24)
            }
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(fontForSize)
            .foregroundColor(foregroundColor)
            .padding(size.padding)
            .frame(minHeight: size.height)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.button, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.button, style: .continuous)
                    .stroke(borderColor, lineWidth: variant == .secondary ? 1.5 : 0)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(ManaTheme.Animation.quick, value: configuration.isPressed)
    }

    private var fontForSize: Font {
        switch size {
        case .small: return ManaTheme.Typography.footnote.weight(.semibold)
        case .medium: return ManaTheme.Typography.body.weight(.semibold)
        case .large: return ManaTheme.Typography.headline
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary, .destructive: return .white
        case .secondary: return ManaTheme.Colors.primary
        case .tertiary: return ManaTheme.Colors.label
        case .glass: return .white
        }
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        let base: Color
        switch variant {
        case .primary: base = ManaTheme.Colors.primary
        case .secondary: base = ManaTheme.Colors.primary.opacity(0.12)
        case .tertiary: base = ManaTheme.Colors.fill
        case .destructive: base = ManaTheme.Colors.error
        case .glass: base = Color.white.opacity(0.2)
        }
        return isPressed ? base.opacity(0.85) : base
    }

    private var borderColor: Color {
        variant == .secondary ? ManaTheme.Colors.primary.opacity(0.3) : .clear
    }
}

// MARK: - Apple HIG Button Style Compatibility Bridge
struct AppleHIGButtonStyle: ButtonStyle {
    let style: ButtonStyleType
    let size: ButtonSize

    enum ButtonStyleType {
        case primary, secondary, tertiary, destructive
    }

    enum ButtonSize {
        case small, medium, large

        var height: CGFloat {
            switch self {
            case .small: return ManaTheme.Spacing.minimumTouchTarget
            case .medium: return ManaTheme.Spacing.recommendedTouchTarget
            case .large: return ManaTheme.Spacing.largeTouchTarget
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium: return EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
            case .large: return EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
            }
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(fontForSize)
            .foregroundColor(foregroundColor(isPressed: configuration.isPressed))
            .padding(size.padding)
            .frame(minHeight: size.height)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .cornerRadius(ManaTheme.CornerRadius.button)
            .overlay(
                RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.button)
                    .stroke(borderColor, lineWidth: style == .secondary ? 1.5 : 0)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(ManaTheme.Animation.quick, value: configuration.isPressed)
    }

    private var fontForSize: Font {
        switch size {
        case .small: return ManaTheme.Typography.footnote.weight(.semibold)
        case .medium: return ManaTheme.Typography.body.weight(.semibold)
        case .large: return ManaTheme.Typography.headline
        }
    }

    private func foregroundColor(isPressed: Bool) -> Color {
        switch style {
        case .primary: return .white
        case .secondary: return ManaTheme.Colors.primary
        case .tertiary: return ManaTheme.Colors.label
        case .destructive: return .white
        }
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        let baseColor: Color
        switch style {
        case .primary: baseColor = ManaTheme.Colors.primary
        case .secondary: baseColor = ManaTheme.Colors.primary.opacity(0.10)
        case .tertiary: baseColor = ManaTheme.Colors.secondaryFill
        case .destructive: baseColor = ManaTheme.Colors.error
        }

        return isPressed ? baseColor.opacity(0.85) : baseColor
    }

    private var borderColor: Color {
        style == .secondary ? ManaTheme.Colors.primary.opacity(0.3) : .clear
    }
}

// MARK: - Smooth Animated Progress Bar
struct ManaProgressBar: View {
    let progress: Double
    let color: Color
    let height: CGFloat

    init(progress: Double, color: Color = ManaTheme.Colors.primary, height: CGFloat = 8) {
        self.progress = max(0, min(1, progress))
        self.color = color
        self.height = height
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(ManaTheme.Colors.secondaryFill)
                    .frame(height: height)

                Capsule()
                    .fill(color)
                    .frame(width: geo.size.width * CGFloat(progress), height: height)
                    .animation(ManaTheme.Animation.smooth, value: progress)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Reusable Header Component
struct ManaHeaderBar: View {
    let title: String
    let subtitle: String?
    let teluguGlyph: String?
    let backAction: (() -> Void)?

    init(
        title: String,
        subtitle: String? = nil,
        teluguGlyph: String? = nil,
        backAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.teluguGlyph = teluguGlyph
        self.backAction = backAction
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ManaTheme.Colors.heroGradient

            if let glyph = teluguGlyph {
                Text(glyph)
                    .font(.system(size: 130, weight: .bold))
                    .foregroundColor(.white.opacity(0.06))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    .offset(x: 10, y: 15)
                    .allowsHitTesting(false)
            }

            VStack(alignment: .leading, spacing: 6) {
                if let backAction = backAction {
                    Button(action: backAction) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .bold))
                            Text("Back")
                                .font(ManaTheme.Typography.subheadline.weight(.semibold))
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 4)
                }

                Text(title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(ManaTheme.Typography.subheadline)
                        .foregroundColor(.white.opacity(0.75))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, backAction != nil ? 44 : 54)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - View Extensions
extension View {
    func appleHIGAccessibility(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = [],
        value: String? = nil
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
            .accessibilityValue(value ?? "")
    }

    func minimumTouchTarget() -> some View {
        self.frame(minWidth: ManaTheme.Spacing.minimumTouchTarget,
                   minHeight: ManaTheme.Spacing.minimumTouchTarget)
    }

    func recommendedTouchTarget() -> some View {
        self.frame(minWidth: ManaTheme.Spacing.recommendedTouchTarget,
                   minHeight: ManaTheme.Spacing.recommendedTouchTarget)
    }

    func properTextSpacing() -> some View {
        self.lineSpacing(ManaTheme.Spacing.xs)
    }

    func highContrastText() -> some View {
        self.foregroundColor(ManaTheme.Colors.label)
    }

    func systemAlignment() -> some View {
        self.multilineTextAlignment(.leading)
    }
}
