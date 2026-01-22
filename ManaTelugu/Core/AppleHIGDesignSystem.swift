import SwiftUI

// MARK: - Apple HIG Compliant Design System
/// Complete design system following Apple Human Interface Guidelines
/// Optimized for Telugu learning with accessibility and modern iOS design
struct AppleHIGDesign {
    
    // MARK: - Colors (iOS 17+ Semantic Colors)
    struct Colors {
        // Primary brand colors for Telugu learning
        static let primary = Color.accentColor
        static let secondary = Color(UIColor.systemOrange)
        static let accent = Color.accentColor
        
        // Semantic colors following Apple HIG
        static let label = Color(UIColor.label)
        static let secondaryLabel = Color(UIColor.secondaryLabel)
        static let tertiaryLabel = Color(UIColor.tertiaryLabel)
        static let quaternaryLabel = Color(UIColor.quaternaryLabel)
        
        // Background colors
        static let systemBackground = Color(UIColor.systemBackground)
        static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
        static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
        
        // Grouped background colors
        static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
        static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
        static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
        
        // Fill colors
        static let systemFill = Color(UIColor.systemFill)
        static let secondarySystemFill = Color(UIColor.secondarySystemFill)
        static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
        static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
        
        // Separator colors
        static let separator = Color(UIColor.separator)
        static let opaqueSeparator = Color(UIColor.opaqueSeparator)
        
        // Status colors
        static let systemRed = Color(UIColor.systemRed)
        static let systemGreen = Color(UIColor.systemGreen)
        static let systemBlue = Color(UIColor.systemBlue)
        static let systemOrange = Color(UIColor.systemOrange)
        static let systemYellow = Color(UIColor.systemYellow)
        static let systemPink = Color(UIColor.systemPink)
        static let systemPurple = Color(UIColor.systemPurple)
        static let systemTeal = Color(UIColor.systemTeal)
        static let systemIndigo = Color(UIColor.systemIndigo)
        
        // Telugu-specific learning colors
        static let vowelColor = systemBlue
        static let consonantColor = systemGreen
        static let numberColor = systemOrange
        static let wordColor = systemPurple
        static let sentenceColor = systemTeal
    }
    
    // MARK: - Typography (Dynamic Type Support)
    struct Typography {
        // Large titles
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title1 = Font.title.weight(.bold)
        static let title2 = Font.title2.weight(.bold)
        static let title3 = Font.title3.weight(.semibold)
        
        // Headlines and body
        static let headline = Font.headline.weight(.semibold)
        static let body = Font.body
        static let bodyEmphasized = Font.body.weight(.semibold)
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption1 = Font.caption
        static let caption2 = Font.caption2
        
        // Telugu-specific fonts
        static let teluguLarge = Font.system(size: 48, weight: .medium, design: .default)
        static let teluguMedium = Font.system(size: 32, weight: .medium, design: .default)
        static let teluguSmall = Font.system(size: 24, weight: .medium, design: .default)
        
        // Kid-friendly fonts (rounded) - ensuring minimum 11pt
        static let kidTitle = Font.system(size: 28, weight: .bold, design: .rounded)
        static let kidBody = Font.system(size: 18, weight: .medium, design: .rounded)
        static let kidCaption = Font.system(size: 14, weight: .medium, design: .rounded) // Above 11pt minimum
        
        // Ensure no text below 11pt (Apple guideline)
        static let minimumText = Font.system(size: 11, weight: .regular, design: .default)
    }
    
    // MARK: - Spacing (8pt Grid System)
    struct Spacing {
        static let xxxs: CGFloat = 2   // 2pt
        static let xxs: CGFloat = 4    // 4pt
        static let xs: CGFloat = 8     // 8pt
        static let sm: CGFloat = 12    // 12pt
        static let md: CGFloat = 16    // 16pt
        static let lg: CGFloat = 20    // 20pt
        static let xl: CGFloat = 24    // 24pt
        static let xxl: CGFloat = 32   // 32pt
        static let xxxl: CGFloat = 40  // 40pt
        static let xxxxl: CGFloat = 48 // 48pt
        
        // Touch targets (Apple HIG compliant)
        static let minimumTouchTarget: CGFloat = 44
        static let recommendedTouchTarget: CGFloat = 48
        static let largeTouchTarget: CGFloat = 56
        
        // Screen margins
        static let screenMargin: CGFloat = 16
        static let screenMarginLarge: CGFloat = 20
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let round: CGFloat = 50
        
        // Card corner radius
        static let card: CGFloat = 16
        static let cardLarge: CGFloat = 20
        
        // Button corner radius
        static let button: CGFloat = 12
        static let buttonLarge: CGFloat = 16
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let light = (
            color: Color.black.opacity(0.05),
            radius: CGFloat(4),
            x: CGFloat(0),
            y: CGFloat(2)
        )
        
        static let medium = (
            color: Color.black.opacity(0.1),
            radius: CGFloat(8),
            x: CGFloat(0),
            y: CGFloat(4)
        )
        
        static let heavy = (
            color: Color.black.opacity(0.15),
            radius: CGFloat(16),
            x: CGFloat(0),
            y: CGFloat(8)
        )
        
        static let card = (
            color: Color.black.opacity(0.08),
            radius: CGFloat(12),
            x: CGFloat(0),
            y: CGFloat(6)
        )
    }
    
    // MARK: - Animations
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let smooth = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
        static let bouncy = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
        static let gentle = SwiftUI.Animation.easeInOut(duration: 0.4)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.6)
        
        // Button animations
        static let buttonPress = SwiftUI.Animation.easeInOut(duration: 0.1)
        static let buttonRelease = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.6)
    }
    
    // MARK: - Haptic Feedback
    struct Haptics {
        static func light() {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        
        static func medium() {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
        
        static func heavy() {
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
        }
        
        static func success() {
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
        }
        
        static func error() {
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.error)
        }
        
        static func warning() {
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.warning)
        }
        
        static func selection() {
            let selectionFeedback = UISelectionFeedbackGenerator()
            selectionFeedback.selectionChanged()
        }
    }
}

// MARK: - Apple HIG Button Style
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
            case .small: return AppleHIGDesign.Spacing.minimumTouchTarget
            case .medium: return AppleHIGDesign.Spacing.recommendedTouchTarget
            case .large: return AppleHIGDesign.Spacing.largeTouchTarget
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
            .cornerRadius(AppleHIGDesign.CornerRadius.button)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(AppleHIGDesign.Animation.buttonPress, value: configuration.isPressed)
            .shadow(
                color: AppleHIGDesign.Shadow.medium.color,
                radius: configuration.isPressed ? 2 : AppleHIGDesign.Shadow.medium.radius,
                x: AppleHIGDesign.Shadow.medium.x,
                y: configuration.isPressed ? 1 : AppleHIGDesign.Shadow.medium.y
            )
    }
    
    private var fontForSize: Font {
        switch size {
        case .small: return AppleHIGDesign.Typography.footnote.weight(.semibold)
        case .medium: return AppleHIGDesign.Typography.body.weight(.semibold)
        case .large: return AppleHIGDesign.Typography.headline
        }
    }
    
    private func foregroundColor(isPressed: Bool) -> Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return AppleHIGDesign.Colors.primary
        case .tertiary:
            return AppleHIGDesign.Colors.label
        case .destructive:
            return .white
        }
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        let baseColor: Color
        switch style {
        case .primary:
            baseColor = AppleHIGDesign.Colors.primary
        case .secondary:
            baseColor = AppleHIGDesign.Colors.secondarySystemBackground
        case .tertiary:
            baseColor = AppleHIGDesign.Colors.tertiarySystemBackground
        case .destructive:
            baseColor = AppleHIGDesign.Colors.systemRed
        }
        
        return isPressed ? baseColor.opacity(0.8) : baseColor
    }
}

// MARK: - Apple HIG Card View
struct AppleHIGCard<Content: View>: View {
    let content: Content
    let style: CardStyle
    
    enum CardStyle {
        case elevated, filled, outlined
    }
    
    init(style: CardStyle = .elevated, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppleHIGDesign.Spacing.md)
            .background(backgroundColor)
            .cornerRadius(AppleHIGDesign.CornerRadius.card)
            .overlay(
                RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.card)
                    .stroke(strokeColor, lineWidth: strokeWidth)
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowOffset.x,
                y: shadowOffset.y
            )
    }
    
    private var backgroundColor: Color {
        switch style {
        case .elevated, .filled:
            return AppleHIGDesign.Colors.secondarySystemBackground
        case .outlined:
            return AppleHIGDesign.Colors.systemBackground
        }
    }
    
    private var strokeColor: Color {
        switch style {
        case .elevated, .filled:
            return Color.clear
        case .outlined:
            return AppleHIGDesign.Colors.separator
        }
    }
    
    private var strokeWidth: CGFloat {
        switch style {
        case .elevated, .filled:
            return 0
        case .outlined:
            return 1
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .elevated:
            return AppleHIGDesign.Shadow.card.color
        case .filled, .outlined:
            return Color.clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .elevated:
            return AppleHIGDesign.Shadow.card.radius
        case .filled, .outlined:
            return 0
        }
    }
    
    private var shadowOffset: (x: CGFloat, y: CGFloat) {
        switch style {
        case .elevated:
            return (AppleHIGDesign.Shadow.card.x, AppleHIGDesign.Shadow.card.y)
        case .filled, .outlined:
            return (0, 0)
        }
    }
}

// MARK: - Accessibility Extensions
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
    
    // Apple Design Tip: 44pt minimum touch targets
    func minimumTouchTarget() -> some View {
        self.frame(minWidth: AppleHIGDesign.Spacing.minimumTouchTarget, 
                  minHeight: AppleHIGDesign.Spacing.minimumTouchTarget)
    }
    
    func recommendedTouchTarget() -> some View {
        self.frame(minWidth: AppleHIGDesign.Spacing.recommendedTouchTarget, 
                  minHeight: AppleHIGDesign.Spacing.recommendedTouchTarget)
    }
    
    // Apple Design Tip: Proper text spacing to avoid overlap
    func properTextSpacing() -> some View {
        self.lineSpacing(AppleHIGDesign.Spacing.xs) // 8pt line spacing
    }
    
    // Apple Design Tip: High contrast for readability
    func highContrastText() -> some View {
        self.foregroundColor(AppleHIGDesign.Colors.label) // System label color for proper contrast
    }
    
    // Apple Design Tip: Proper alignment for related content
    func systemAlignment() -> some View {
        self.multilineTextAlignment(.leading)
    }
}
