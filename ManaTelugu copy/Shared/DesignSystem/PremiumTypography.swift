import UIKit
import SwiftUI

// MARK: - Premium Typography System
// High-quality typography with proper contrast and hierarchy

// MARK: - Typography Hierarchy
enum PremiumTextStyle {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption1
    case caption2
    case teluguTitle
    case teluguHeadline
    case teluguBody
    case teluguCaption
    
    var font: UIFont {
        switch self {
        case .largeTitle:
            return UIFont.systemFont(ofSize: 34, weight: .bold)
        case .title1:
            return UIFont.systemFont(ofSize: 28, weight: .bold)
        case .title2:
            return UIFont.systemFont(ofSize: 22, weight: .bold)
        case .title3:
            return UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .headline:
            return UIFont.systemFont(ofSize: 17, weight: .semibold)
        case .body:
            return UIFont.systemFont(ofSize: 17, weight: .regular)
        case .callout:
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .subheadline:
            return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .footnote:
            return UIFont.systemFont(ofSize: 13, weight: .regular)
        case .caption1:
            return UIFont.systemFont(ofSize: 12, weight: .regular)
        case .caption2:
            return UIFont.systemFont(ofSize: 11, weight: .regular)
        case .teluguTitle:
            return UIFont.systemFont(ofSize: 32, weight: .bold)
        case .teluguHeadline:
            return UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .teluguBody:
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .teluguCaption:
            return UIFont.systemFont(ofSize: 12, weight: .medium)
        }
    }
    
    var dynamicFont: UIFont {
        switch self {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title1:
            return UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)
        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .caption1:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            return UIFont.preferredFont(forTextStyle: .caption2)
        case .teluguTitle:
            return UIFont.systemFont(ofSize: 32, weight: .bold)
        case .teluguHeadline:
            return UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .teluguBody:
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .teluguCaption:
            return UIFont.systemFont(ofSize: 12, weight: .medium)
        }
    }
}

// MARK: - Premium Text Colors
enum PremiumTextColor {
    case primary
    case secondary
    case tertiary
    case quaternary
    case accent
    case teluguGold
    case teluguBlue
    case teluguPurple
    case success
    case warning
    case error
    case onGlass
    case onGlassSecondary
    
    var color: UIColor {
        switch self {
        case .primary:
            return UIColor.label
        case .secondary:
            return UIColor.secondaryLabel
        case .tertiary:
            return UIColor.tertiaryLabel
        case .quaternary:
            return UIColor.quaternaryLabel
        case .accent:
            return UIColor.systemBlue
        case .teluguGold:
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ?
                UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) :
                UIColor(red: 0.95, green: 0.76, blue: 0.0, alpha: 1.0)
            }
        case .teluguBlue:
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ?
                UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0) :
                UIColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 1.0)
            }
        case .teluguPurple:
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ?
                UIColor(red: 0.6, green: 0.35, blue: 0.71, alpha: 1.0) :
                UIColor(red: 0.4, green: 0.25, blue: 0.51, alpha: 1.0)
            }
        case .success:
            return UIColor.systemGreen
        case .warning:
            return UIColor.systemOrange
        case .error:
            return UIColor.systemRed
        case .onGlass:
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ?
                UIColor.white.withAlphaComponent(0.9) :
                UIColor.black.withAlphaComponent(0.8)
            }
        case .onGlassSecondary:
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ?
                UIColor.white.withAlphaComponent(0.7) :
                UIColor.black.withAlphaComponent(0.6)
            }
        }
    }
}

// MARK: - Premium Text Styling
struct PremiumTextConfiguration {
    let textStyle: PremiumTextStyle
    let color: PremiumTextColor
    let alignment: NSTextAlignment
    let lineSpacing: CGFloat
    let letterSpacing: CGFloat?
    
    init(
        textStyle: PremiumTextStyle,
        color: PremiumTextColor = .primary,
        alignment: NSTextAlignment = .left,
        lineSpacing: CGFloat = 0,
        letterSpacing: CGFloat? = nil
    ) {
        self.textStyle = textStyle
        self.color = color
        self.alignment = alignment
        self.lineSpacing = lineSpacing
        self.letterSpacing = letterSpacing
    }
    
    func apply(to label: UILabel) {
        label.font = textStyle.dynamicFont
        label.textColor = color.color
        label.textAlignment = alignment
        
        if lineSpacing > 0 || letterSpacing != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = alignment
            
            var attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                .font: textStyle.dynamicFont,
                .foregroundColor: color.color
            ]
            
            if let letterSpacing = letterSpacing {
                attributes[.kern] = letterSpacing
            }
            
            if let text = label.text {
                label.attributedText = NSAttributedString(string: text, attributes: attributes)
            }
        }
    }
}

// MARK: - SwiftUI Typography Extensions
extension Font {
    static func premium(_ textStyle: PremiumTextStyle) -> Font {
        switch textStyle {
        case .largeTitle:
            return .largeTitle.weight(.bold)
        case .title1:
            return .title.weight(.bold)
        case .title2:
            return .title2.weight(.bold)
        case .title3:
            return .title3.weight(.semibold)
        case .headline:
            return .headline.weight(.semibold)
        case .body:
            return .body.weight(.regular)
        case .callout:
            return .callout.weight(.regular)
        case .subheadline:
            return .subheadline.weight(.regular)
        case .footnote:
            return .footnote.weight(.regular)
        case .caption1:
            return .caption.weight(.regular)
        case .caption2:
            return .caption2.weight(.regular)
        case .teluguTitle:
            return .custom("SF Pro Display", size: 32).weight(.bold)
        case .teluguHeadline:
            return .custom("SF Pro Display", size: 20).weight(.semibold)
        case .teluguBody:
            return .custom("SF Pro Text", size: 16).weight(.regular)
        case .teluguCaption:
            return .custom("SF Pro Text", size: 12).weight(.medium)
        }
    }
}

extension Color {
    static func premium(_ color: PremiumTextColor) -> Color {
        return Color(color.color)
    }
}

// MARK: - Premium Text View
struct PremiumTextView: View {
    let text: String
    let style: PremiumTextStyle
    let color: PremiumTextColor
    let alignment: TextAlignment
    let lineSpacing: CGFloat
    let letterSpacing: CGFloat?
    
    init(
        _ text: String,
        style: PremiumTextStyle,
        color: PremiumTextColor = .primary,
        alignment: TextAlignment = .leading,
        lineSpacing: CGFloat = 0,
        letterSpacing: CGFloat? = nil
    ) {
        self.text = text
        self.style = style
        self.color = color
        self.alignment = alignment
        self.lineSpacing = lineSpacing
        self.letterSpacing = letterSpacing
    }
    
    var body: some View {
        Text(text)
            .font(.premium(style))
            .foregroundColor(.premium(color))
            .multilineTextAlignment(alignment)
            .lineSpacing(lineSpacing)
            .kerning(letterSpacing ?? 0)
    }
}

// MARK: - Premium Button Text Styles
struct PremiumButtonTextStyle {
    static let primary = PremiumTextConfiguration(
        textStyle: .headline,
        color: .onGlass,
        alignment: .center,
        lineSpacing: 0
    )
    
    static let secondary = PremiumTextConfiguration(
        textStyle: .callout,
        color: .primary,
        alignment: .center,
        lineSpacing: 0
    )
    
    static let tertiary = PremiumTextConfiguration(
        textStyle: .subheadline,
        color: .secondary,
        alignment: .center,
        lineSpacing: 0
    )
}

// MARK: - Premium Card Text Styles
struct PremiumCardTextStyle {
    static let title = PremiumTextConfiguration(
        textStyle: .title3,
        color: .primary,
        alignment: .left,
        lineSpacing: 2
    )
    
    static let subtitle = PremiumTextConfiguration(
        textStyle: .subheadline,
        color: .secondary,
        alignment: .left,
        lineSpacing: 1
    )
    
    static let body = PremiumTextConfiguration(
        textStyle: .body,
        color: .primary,
        alignment: .left,
        lineSpacing: 4
    )
    
    static let caption = PremiumTextConfiguration(
        textStyle: .caption1,
        color: .tertiary,
        alignment: .left,
        lineSpacing: 0
    )
    
    static let teluguTitle = PremiumTextConfiguration(
        textStyle: .teluguTitle,
        color: .teluguGold,
        alignment: .center,
        lineSpacing: 2
    )
    
    static let teluguHeadline = PremiumTextConfiguration(
        textStyle: .teluguHeadline,
        color: .teluguBlue,
        alignment: .left,
        lineSpacing: 1
    )
    
    static let teluguBody = PremiumTextConfiguration(
        textStyle: .teluguBody,
        color: .primary,
        alignment: .left,
        lineSpacing: 3
    )
}

// MARK: - Premium Section Headers
struct PremiumSectionHeaderStyle {
    static let large = PremiumTextConfiguration(
        textStyle: .title2,
        color: .primary,
        alignment: .left,
        lineSpacing: 0
    )
    
    static let medium = PremiumTextConfiguration(
        textStyle: .headline,
        color: .primary,
        alignment: .left,
        lineSpacing: 0
    )
    
    static let small = PremiumTextConfiguration(
        textStyle: .callout,
        color: .secondary,
        alignment: .left,
        lineSpacing: 0
    )
}

// MARK: - Accessibility Text Styles
struct AccessibilityTextStyle {
    static func highContrast(_ baseStyle: PremiumTextConfiguration) -> PremiumTextConfiguration {
        return PremiumTextConfiguration(
            textStyle: baseStyle.textStyle,
            color: baseStyle.color == .primary ? .primary : baseStyle.color,
            alignment: baseStyle.alignment,
            lineSpacing: baseStyle.lineSpacing + 1,
            letterSpacing: (baseStyle.letterSpacing ?? 0) + 0.5
        )
    }
    
    static func largeText(_ baseStyle: PremiumTextConfiguration) -> PremiumTextConfiguration {
        let largerStyle: PremiumTextStyle
        switch baseStyle.textStyle {
        case .caption1, .caption2:
            largerStyle = .footnote
        case .footnote:
            largerStyle = .subheadline
        case .subheadline:
            largerStyle = .callout
        case .callout:
            largerStyle = .body
        case .body:
            largerStyle = .headline
        case .headline:
            largerStyle = .title3
        case .title3:
            largerStyle = .title2
        case .title2:
            largerStyle = .title1
        default:
            largerStyle = baseStyle.textStyle
        }
        
        return PremiumTextConfiguration(
            textStyle: largerStyle,
            color: baseStyle.color,
            alignment: baseStyle.alignment,
            lineSpacing: baseStyle.lineSpacing + 2,
            letterSpacing: baseStyle.letterSpacing
        )
    }
}
