import SwiftUI
import UIKit

// MARK: - Professional Typography System
// Clear visual hierarchy with proper contrast and readability

enum ProfessionalTypographyStyle {
    case heroTitle        // 32pt, bold, high contrast - for main headlines
    case sectionHeader    // 24pt, semibold - for section titles
    case cardTitle        // 18pt, medium - for card titles
    case bodyText         // 16pt, regular - for main content
    case caption          // 14pt, regular, secondary color - for supporting text
    case buttonText       // 16pt, semibold - for button labels
    case statValue        // 28pt, bold - for statistics
    case statLabel        // 12pt, medium - for stat labels
    case teluguTitle      // 20pt, semibold - for Telugu text
    case teluguBody       // 16pt, regular - for Telugu content
}

struct ProfessionalTypography {
    static func font(for style: ProfessionalTypographyStyle) -> Font {
        switch style {
        case .heroTitle:
            return .system(size: 32, weight: .bold, design: .default)
        case .sectionHeader:
            return .system(size: 24, weight: .semibold, design: .default)
        case .cardTitle:
            return .system(size: 18, weight: .medium, design: .default)
        case .bodyText:
            return .system(size: 16, weight: .regular, design: .default)
        case .caption:
            return .system(size: 14, weight: .regular, design: .default)
        case .buttonText:
            return .system(size: 16, weight: .semibold, design: .default)
        case .statValue:
            return .system(size: 28, weight: .bold, design: .default)
        case .statLabel:
            return .system(size: 12, weight: .medium, design: .default)
        case .teluguTitle:
            return .system(size: 20, weight: .semibold, design: .default)
        case .teluguBody:
            return .system(size: 16, weight: .regular, design: .default)
        }
    }
    
    static func color(for style: ProfessionalTypographyStyle) -> Color {
        switch style {
        case .heroTitle, .sectionHeader, .cardTitle, .buttonText, .statValue, .teluguTitle:
            return .primary
        case .bodyText, .teluguBody:
            return .primary.opacity(0.9)
        case .caption, .statLabel:
            return .secondary
        }
    }
    
    static func lineSpacing(for style: ProfessionalTypographyStyle) -> CGFloat {
        switch style {
        case .heroTitle:
            return 4
        case .sectionHeader:
            return 6
        case .cardTitle:
            return 4
        case .bodyText, .teluguBody:
            return 6
        case .caption, .statLabel:
            return 4
        case .buttonText:
            return 2
        case .statValue:
            return 2
        case .teluguTitle:
            return 4
        }
    }
}

// MARK: - Professional Text View
struct ProfessionalText: View {
    let text: String
    let style: ProfessionalTypographyStyle
    let color: Color?
    let alignment: TextAlignment
    let maxLines: Int?
    
    init(
        _ text: String,
        style: ProfessionalTypographyStyle,
        color: Color? = nil,
        alignment: TextAlignment = .leading,
        maxLines: Int? = nil
    ) {
        self.text = text
        self.style = style
        self.color = color
        self.alignment = alignment
        self.maxLines = maxLines
    }
    
    var body: some View {
        Text(text)
            .font(ProfessionalTypography.font(for: style))
            .foregroundColor(color ?? ProfessionalTypography.color(for: style))
            .multilineTextAlignment(alignment)
            .lineSpacing(ProfessionalTypography.lineSpacing(for: style))
            .lineLimit(maxLines)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 1,
                x: 0,
                y: 1
            )
    }
}

// MARK: - Professional Spacing System
enum ProfessionalSpacing: CGFloat, CaseIterable {
    case tiny = 4
    case small = 8
    case medium = 16
    case large = 24
    case extraLarge = 32
    case huge = 48
    
    var value: CGFloat {
        return self.rawValue
    }
}

// MARK: - Professional Color System
extension Color {
    // Primary brand colors
    static let professionalBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let professionalOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let professionalGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let professionalPurple = Color(red: 0.6, green: 0.3, blue: 0.9)
    static let professionalPink = Color(red: 1.0, green: 0.3, blue: 0.6)
    
    // Glass card backgrounds
    static let cardPrimary = Color.white.opacity(0.25)
    static let cardSecondary = Color.white.opacity(0.15)
    static let cardInteractive = Color.white.opacity(0.3)
    static let cardHighlight = Color.white.opacity(0.4)
    
    // Text colors with proper contrast
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textTertiary = Color.secondary.opacity(0.7)
    static let textOnGlass = Color.primary
    static let textOnDark = Color.white
}

// MARK: - Professional Card Types
enum ProfessionalCardType {
    case hero          // Main content cards - large, prominent
    case primary       // Important content cards
    case secondary     // Supporting information cards
    case interactive   // Tappable action cards
    case stat          // Statistics display cards
    case compact       // Small, dense information cards
}

// MARK: - Professional Card Configuration
struct ProfessionalCardConfig {
    let type: ProfessionalCardType
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let shadowOffset: CGFloat
    let borderWidth: CGFloat
    let padding: CGFloat
    let backgroundColor: Color
    let borderColor: Color
    let shadowColor: Color
    let shadowOpacity: Double
    
    static func config(for type: ProfessionalCardType) -> ProfessionalCardConfig {
        switch type {
        case .hero:
            return ProfessionalCardConfig(
                type: type,
                cornerRadius: 24,
                shadowRadius: 32,
                shadowOffset: 16,
                borderWidth: 2,
                padding: 24,
                backgroundColor: .cardPrimary,
                borderColor: .white.opacity(0.4),
                shadowColor: .black,
                shadowOpacity: 0.25
            )
        case .primary:
            return ProfessionalCardConfig(
                type: type,
                cornerRadius: 20,
                shadowRadius: 24,
                shadowOffset: 12,
                borderWidth: 1.5,
                padding: 20,
                backgroundColor: .cardPrimary,
                borderColor: .white.opacity(0.3),
                shadowColor: .black,
                shadowOpacity: 0.2
            )
        case .secondary:
            return ProfessionalCardConfig(
                type: type,
                cornerRadius: 16,
                shadowRadius: 16,
                shadowOffset: 8,
                borderWidth: 1,
                padding: 16,
                backgroundColor: .cardSecondary,
                borderColor: .white.opacity(0.2),
                shadowColor: .black,
                shadowOpacity: 0.15
            )
        case .interactive:
            return ProfessionalCardConfig(
                type: type,
                cornerRadius: 18,
                shadowRadius: 20,
                shadowOffset: 10,
                borderWidth: 1.2,
                padding: 18,
                backgroundColor: .cardInteractive,
                borderColor: .white.opacity(0.35),
                shadowColor: .black,
                shadowOpacity: 0.18
            )
        case .stat:
            return ProfessionalCardConfig(
                type: type,
                cornerRadius: 16,
                shadowRadius: 12,
                shadowOffset: 6,
                borderWidth: 1,
                padding: 16,
                backgroundColor: .cardSecondary,
                borderColor: .white.opacity(0.25),
                shadowColor: .black,
                shadowOpacity: 0.12
            )
        case .compact:
            return ProfessionalCardConfig(
                type: type,
                cornerRadius: 12,
                shadowRadius: 8,
                shadowOffset: 4,
                borderWidth: 0.8,
                padding: 12,
                backgroundColor: .cardSecondary,
                borderColor: .white.opacity(0.15),
                shadowColor: .black,
                shadowOpacity: 0.1
            )
        }
    }
}

// MARK: - Professional Animation System
struct ProfessionalAnimation {
    static let cardPress = SwiftUI.Animation.easeOut(duration: 0.15)
    static let cardRelease = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)
    static let pageTransition = SwiftUI.Animation.easeInOut(duration: 0.3)
    static let progressUpdate = SwiftUI.Animation.easeInOut(duration: 0.5)
    static let shimmer = SwiftUI.Animation.linear(duration: 2.0).repeatForever(autoreverses: false)
    static let pulse = SwiftUI.Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
}

// MARK: - Professional Haptic Feedback
class ProfessionalHaptics {
    static func light() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    static func medium() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    static func heavy() {
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
    
    static func success() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }
    
    static func warning() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
    }
    
    static func error() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.error)
    }
}
