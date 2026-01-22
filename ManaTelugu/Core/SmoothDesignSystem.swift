import SwiftUI

// MARK: - Smooth Design System
struct SmoothDesign {
    
    // MARK: - Colors
    struct Colors {
        static let primary = Color("AppPrimaryColor")
        static let secondary = Color("AppSecondaryColor")
        static let accent = Color("AccentColor")
        static let success = Color("SuccessColor")
        static let warning = Color("WarningColor")
        static let error = Color("ErrorColor")
        
        // Background colors
        static let backgroundPrimary = Color("BackgroundPrimaryColor")
        static let backgroundSecondary = Color("BackgroundSecondaryColor")
        static let cardBackground = Color("CardBackgroundColor")
        
        // Text colors
        static let textPrimary = Color("AppTextPrimary")
        static let textSecondary = Color("AppTextSecondary")
        static let textTertiary = Color("AppTextTertiary")
        static let surfaceOverlay = Color("SurfaceOverlayColor")
        static let shadow = Color("ShadowColor")
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
        static let round: CGFloat = 50 // For circular elements
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let light = (color: SmoothDesign.Colors.shadow.opacity(0.05), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        static let medium = (color: SmoothDesign.Colors.shadow.opacity(0.1), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
        static let heavy = (color: SmoothDesign.Colors.shadow.opacity(0.15), radius: CGFloat(12), x: CGFloat(0), y: CGFloat(6))
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title1 = Font.title.weight(.bold)
        static let title2 = Font.title2.weight(.bold)
        static let title3 = Font.title3.weight(.semibold)
        static let headline = Font.headline.weight(.semibold)
        static let body = Font.body
        static let bodyBold = Font.body.weight(.semibold)
        static let caption = Font.caption
        static let captionBold = Font.caption.weight(.medium)
    }
    
    // MARK: - Animations
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let smooth = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
        static let bouncy = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
        static let gentle = SwiftUI.Animation.easeInOut(duration: 0.4)
    }
}

// MARK: - Smooth Background Gradient
struct SmoothGradient: View {
    var body: some View {
        LinearGradient(
            colors: [
                SmoothDesign.Colors.backgroundPrimary,
                SmoothDesign.Colors.backgroundSecondary
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Smooth Card View
struct SmoothCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let cornerRadius: CGFloat
    let shadowStyle: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)
    
    init(
        padding: CGFloat = SmoothDesign.Spacing.xl,
        cornerRadius: CGFloat = SmoothDesign.CornerRadius.extraLarge,
        shadowStyle: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = SmoothDesign.Shadow.light,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowStyle = shadowStyle
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(SmoothDesign.Colors.cardBackground)
                    .shadow(
                        color: shadowStyle.color,
                        radius: shadowStyle.radius,
                        x: shadowStyle.x,
                        y: shadowStyle.y
                    )
            )
    }
}

// MARK: - Smooth Button
struct SmoothButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let action: () -> Void
    
    @State private var isPressed = false
    
    enum ButtonStyle {
        case primary
        case secondary
        case accent
        case outline
        
        var backgroundColor: Color {
            switch self {
            case .primary: return SmoothDesign.Colors.primary
            case .secondary: return SmoothDesign.Colors.secondary
            case .accent: return SmoothDesign.Colors.accent
            case .outline: return Color.clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary, .secondary, .accent: return SmoothDesign.Colors.textPrimary
            case .outline: return SmoothDesign.Colors.primary
            }
        }
        
        var borderColor: Color? {
            switch self {
            case .outline: return SmoothDesign.Colors.primary
            default: return nil
            }
        }
    }
    
    init(
        _ title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            HStack(spacing: SmoothDesign.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                
                Text(title)
                    .font(SmoothDesign.Typography.bodyBold)
            }
            .foregroundColor(style.foregroundColor)
            .padding(.horizontal, SmoothDesign.Spacing.xl)
            .padding(.vertical, SmoothDesign.Spacing.lg)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: SmoothDesign.CornerRadius.medium)
                    .fill(style.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: SmoothDesign.CornerRadius.medium)
                            .stroke(style.borderColor ?? Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(SmoothDesign.Animation.bouncy, value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(SmoothDesign.Animation.quick) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Smooth Text Field
struct SmoothTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String?
    
    init(_ placeholder: String, text: Binding<String>, icon: String? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: SmoothDesign.Spacing.md) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(SmoothDesign.Colors.textSecondary)
            }
            
            TextField(placeholder, text: $text)
                .font(SmoothDesign.Typography.body)
        }
        .padding(SmoothDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: SmoothDesign.CornerRadius.medium)
                .fill(SmoothDesign.Colors.surfaceOverlay.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: SmoothDesign.CornerRadius.medium)
                        .stroke(SmoothDesign.Colors.surfaceOverlay.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Smooth Progress Bar
struct SmoothProgressBar: View {
    let progress: Double
    let color: Color
    let height: CGFloat
    
    init(progress: Double, color: Color = SmoothDesign.Colors.primary, height: CGFloat = 8) {
        self.progress = progress
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
                    .animation(SmoothDesign.Animation.smooth, value: progress)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Smooth Icon Button
struct SmoothIconButton: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let backgroundColor: Color?
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(
        icon: String,
        size: CGFloat = 24,
        color: Color = SmoothDesign.Colors.primary,
        backgroundColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(color)
                .frame(width: size + 16, height: size + 16)
                .background(
                    Circle()
                        .fill(backgroundColor ?? Color.clear)
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(SmoothDesign.Animation.bouncy, value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(SmoothDesign.Animation.quick) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Smooth Badge
struct SmoothBadge: View {
    let text: String
    let color: Color
    let backgroundColor: Color?
    
    init(_ text: String, color: Color = SmoothDesign.Colors.textPrimary, backgroundColor: Color? = SmoothDesign.Colors.primary) {
        self.text = text
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Text(text)
            .font(SmoothDesign.Typography.captionBold)
            .foregroundColor(color)
            .padding(.horizontal, SmoothDesign.Spacing.sm)
            .padding(.vertical, SmoothDesign.Spacing.xs)
            .background(
                Capsule()
                    .fill(backgroundColor ?? SmoothDesign.Colors.primary)
            )
    }
}

// MARK: - View Extensions for Smooth Styling
extension View {
    func smoothCard(
        padding: CGFloat = SmoothDesign.Spacing.xl,
        cornerRadius: CGFloat = SmoothDesign.CornerRadius.extraLarge,
        shadowStyle: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = SmoothDesign.Shadow.light
    ) -> some View {
        self
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(SmoothDesign.Colors.cardBackground)
                    .shadow(
                        color: shadowStyle.color,
                        radius: shadowStyle.radius,
                        x: shadowStyle.x,
                        y: shadowStyle.y
                    )
            )
    }
    
    func smoothBackground() -> some View {
        self.background(SmoothGradient().ignoresSafeArea(.all))
    }
    
    func smoothPressEffect() -> some View {
        self.scaleEffect(1.0)
            .animation(SmoothDesign.Animation.bouncy, value: UUID())
    }
}
