import SwiftUI

// Import MTColors for consistent theming
extension MTColors {}

// MARK: - SwiftUI Glass Effect
// High-quality glass effects that actually render in SwiftUI

struct SwiftUIGlassEffect: ViewModifier {
    let glassType: GlassEffectType
    let isInteractive: Bool
    @State private var isPressed = false
    @State private var shimmerOffset: CGFloat = -1.0
    
    init(glassType: GlassEffectType = .card, isInteractive: Bool = false) {
        self.glassType = glassType
        self.isInteractive = isInteractive
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // True glassmorphism background
                    RoundedRectangle(cornerRadius: glassType.cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .background(
                            // Additional glass layer for depth
                            RoundedRectangle(cornerRadius: glassType.cornerRadius, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            ModernDesignSystem.Colors.surface.opacity(0.25),
ModernDesignSystem.Colors.surface.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            // Glass highlight effect
                            RoundedRectangle(cornerRadius: glassType.cornerRadius, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            ModernDesignSystem.Colors.surface.opacity(0.4),
                                            Color.clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .center
                                    )
                                )
                        )
                    
                    // Shimmer effect
                    if glassType.shimmerEnabled {
                        RoundedRectangle(cornerRadius: glassType.cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        ModernDesignSystem.Colors.surface.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset * 200)
                            .opacity(0.6)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false)) {
                                    shimmerOffset = 1.0
                                }
                            }
                    }
                    
                    // Glass border with enhanced visibility
                    RoundedRectangle(cornerRadius: glassType.cornerRadius, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    ModernDesignSystem.Colors.surface.opacity(0.6),
                                    ModernDesignSystem.Colors.surface.opacity(0.2),
ModernDesignSystem.Colors.surface.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: glassType.borderWidth
                        )
                }
            )
            .shadow(
                color: ModernDesignSystem.Colors.shadow.opacity(0.15),
                radius: glassType.shadowRadius,
                x: 0,
                y: glassType.shadowOffset
            )
            .shadow(
                color: ModernDesignSystem.Colors.shadow.opacity(0.08),
                radius: glassType.shadowRadius * 2,
                x: 0,
                y: glassType.shadowOffset * 2
            )
            .shadow(
                color: ModernDesignSystem.Colors.surface.opacity(0.1),
                radius: 2,
                x: 0,
                y: -1
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .opacity(isPressed ? 0.9 : 1.0)
            .onTapGesture {
                if isInteractive {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPressed = false
                        }
                    }
                }
            }
    }
}

// MARK: - Glass Effect Types
enum GlassEffectType {
    case card
    case button
    case modal
    case navigation
    case floating
    case subtle
    case ultraThin
    
    var cornerRadius: CGFloat {
        switch self {
        case .card:
            return 18
        case .button:
            return 12
        case .modal:
            return 24
        case .navigation:
            return 0
        case .floating:
            return 20
        case .subtle:
            return 12
        case .ultraThin:
            return 8
        }
    }
    
    var opacity: Double {
        switch self {
        case .card:
            return 1.0
        case .button:
            return 0.9
        case .modal:
            return 1.0
        case .navigation:
            return 0.8
        case .floating:
            return 1.0
        case .subtle:
            return 0.7
        case .ultraThin:
            return 0.6
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .card:
            return 1.2
        case .button:
            return 0.8
        case .modal:
            return 1.5
        case .navigation:
            return 0
        case .floating:
            return 1.0
        case .subtle:
            return 0.6
        case .ultraThin:
            return 0.4
        }
    }
    
    var shadowRadius: CGFloat {
        switch self {
        case .card:
            return 16
        case .button:
            return 8
        case .modal:
            return 24
        case .navigation:
            return 0
        case .floating:
            return 20
        case .subtle:
            return 6
        case .ultraThin:
            return 3
        }
    }
    
    var shadowOffset: CGFloat {
        switch self {
        case .card:
            return 6
        case .button:
            return 4
        case .modal:
            return 12
        case .navigation:
            return 0
        case .floating:
            return 8
        case .subtle:
            return 2
        case .ultraThin:
            return 1
        }
    }
    
    var shimmerEnabled: Bool {
        switch self {
        case .card, .floating:
            return true
        default:
            return false
        }
    }
}

// MARK: - View Extension
extension View {
    func glassEffect(_ glassType: GlassEffectType = .card, isInteractive: Bool = false) -> some View {
        self.modifier(SwiftUIGlassEffect(glassType: glassType, isInteractive: isInteractive))
    }
}

// MARK: - Premium Text Styles for SwiftUI
struct SwiftUIPremiumTextStyle {
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title1 = Font.title.weight(.bold)
    static let title2 = Font.title2.weight(.bold)
    static let title3 = Font.title3.weight(.semibold)
    static let headline = Font.headline.weight(.semibold)
    static let body = Font.body.weight(.regular)
    static let callout = Font.callout.weight(.regular)
    static let subheadline = Font.subheadline.weight(.regular)
    static let footnote = Font.footnote.weight(.regular)
    static let caption1 = Font.caption.weight(.regular)
    static let caption2 = Font.caption2.weight(.regular)
}

// MARK: - Premium Colors for SwiftUI
extension Color {
    static let premiumPrimary = Color.primary
    static let premiumSecondary = Color.secondary
    static let premiumTertiary = Color.secondary.opacity(0.6)
    static let premiumAccent = Color.accentColor
    static let premiumGold = Color(red: 0.95, green: 0.76, blue: 0.0)
    static let premiumBlue = Color(red: 0.0, green: 0.4, blue: 0.8)
    static let premiumPurple = Color(red: 0.4, green: 0.25, blue: 0.51)
    static let premiumGreen = Color(red: 0.1, green: 0.6, blue: 0.3)
    static let premiumOrange = Color(red: 0.9, green: 0.5, blue: 0.1)
    static let premiumPink = Color(red: 0.8, green: 0.3, blue: 0.5)
}

// MARK: - Liquid Glass Background Extension
extension View {
    func liquidGlassBackground() -> some View {
        self.background(
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.8),
                    Color(.systemGray6).opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    func softGradientBackground() -> some View {
        self.background(
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.4, blue: 0.8).opacity(0.08), // teluguBlue
                    Color(red: 0.9, green: 0.6, blue: 0.1).opacity(0.04), // teluguSaffron
                    Color(red: 0.1, green: 0.6, blue: 0.3).opacity(0.03)  // teluguGreen
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Premium Text View
struct PremiumText: View {
    let text: String
    let style: Font
    let color: Color
    let alignment: TextAlignment
    
    init(
        _ text: String,
        style: Font = .body,
        color: Color = .premiumPrimary,
        alignment: TextAlignment = .leading
    ) {
        self.text = text
        self.style = style
        self.color = color
        self.alignment = alignment
    }
    
    var body: some View {
        Text(text)
            .font(style)
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
    }
}
