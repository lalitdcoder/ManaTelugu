import SwiftUI

// MARK: - Elegant Design System
// Minimalistic, modern design following Apple HIG

struct ElegantDesign {
    
    // MARK: - Colors
    struct Colors {
        // Primary palette - subtle and sophisticated
        static let primary = Color(red: 0.1, green: 0.4, blue: 0.8)      // Telugu Blue
        static let secondary = Color(red: 0.1, green: 0.6, blue: 0.3)    // Telugu Green
        static let accent = Color(red: 0.9, green: 0.6, blue: 0.1)       // Telugu Saffron
        
        // Neutral palette - clean and minimal
        static let surface = Color(.systemBackground)
        static let surfaceSecondary = Color(.secondarySystemBackground)
        static let surfaceTertiary = Color(.tertiarySystemBackground)
        
        // Text hierarchy
        static let textPrimary = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let textTertiary = Color(.tertiaryLabel)
        
        // Semantic colors
        static let success = Color(.systemGreen)
        static let warning = Color(.systemOrange)
        static let error = Color(.systemRed)
        
        // Glass effect colors
        static let glassBackground = ModernDesignSystem.Colors.surface.opacity(0.1)
        static let glassBorder = ModernDesignSystem.Colors.surface.opacity(0.2)
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let title1 = Font.system(.title, design: .rounded, weight: .semibold)
        static let title2 = Font.system(.title2, design: .rounded, weight: .semibold)
        static let title3 = Font.system(.title3, design: .rounded, weight: .medium)
        static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
        static let body = Font.system(.body, design: .rounded, weight: .regular)
        static let callout = Font.system(.callout, design: .rounded, weight: .medium)
        static let subheadline = Font.system(.subheadline, design: .rounded, weight: .regular)
        static let footnote = Font.system(.footnote, design: .rounded, weight: .regular)
        static let caption = Font.system(.caption, design: .rounded, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        
        // Touch targets
        static let minTouchTarget: CGFloat = 44
        static let preferredTouchTarget: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let pill: CGFloat = 999
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let subtle = (color: ModernDesignSystem.Colors.shadow.opacity(0.05), radius: CGFloat(2), x: CGFloat(0), y: CGFloat(1))
        static let soft = (color: ModernDesignSystem.Colors.shadow.opacity(0.1), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
        static let medium = (color: ModernDesignSystem.Colors.shadow.opacity(0.15), radius: CGFloat(16), x: CGFloat(0), y: CGFloat(8))
    }
}

// MARK: - Elegant Components

struct ElegantButton: View {
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case primary, secondary, tertiary, minimal
    }
    
    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            Text(title)
                .font(ElegantDesign.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
                .padding(.horizontal, ElegantDesign.Spacing.lg)
                .padding(.vertical, ElegantDesign.Spacing.md)
                .frame(minHeight: ElegantDesign.Spacing.minTouchTarget)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .overlay(overlayBorder)
        }
.buttonStyle(HapticPlainButtonStyle())
    }
    
    private var textColor: Color {
        switch style {
        case .primary: return ModernDesignSystem.Colors.textPrimary
        case .secondary: return ElegantDesign.Colors.primary
        case .tertiary: return ElegantDesign.Colors.textPrimary
        case .minimal: return ElegantDesign.Colors.primary
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return ElegantDesign.Colors.primary
        case .secondary: return ElegantDesign.Colors.primary.opacity(0.1)
        case .tertiary: return ElegantDesign.Colors.surfaceSecondary
        case .minimal: return Color.clear
        }
    }
    
    private var cornerRadius: CGFloat {
        switch style {
        case .minimal: return 0
        default: return ElegantDesign.CornerRadius.md
        }
    }
    
    @ViewBuilder
    private var overlayBorder: some View {
        switch style {
        case .secondary:
            RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                .stroke(ElegantDesign.Colors.primary.opacity(0.3), lineWidth: 1)
        default:
            EmptyView()
        }
    }
}

// MARK: - View Extensions
extension View {
    func elegantBackground() -> some View {
        self.background(
            LinearGradient(
                colors: [
                    ElegantDesign.Colors.primary.opacity(0.08),
                    ElegantDesign.Colors.secondary.opacity(0.06),
                    ElegantDesign.Colors.accent.opacity(0.04),
                    Color(.systemBackground).opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
