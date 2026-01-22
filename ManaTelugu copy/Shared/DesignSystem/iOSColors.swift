import UIKit
import SwiftUI

// MARK: - iOS Native Color System
// Adaptive colors that work perfectly in light/dark mode

extension UIColor {
    // MARK: - System Colors (iOS Native)
    static let teluguGold = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ? 
        UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) :
        UIColor(red: 0.95, green: 0.76, blue: 0.0, alpha: 1.0)
    }
    
    static let culturalPurple = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.6, green: 0.35, blue: 0.71, alpha: 1.0) :
        UIColor(red: 0.4, green: 0.25, blue: 0.51, alpha: 1.0)
    }
    
    static let teluguBlue = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0) :
        UIColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 1.0)
    }
    
    static let teluguGreen = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.3, green: 0.8, blue: 0.4, alpha: 1.0) :
        UIColor(red: 0.1, green: 0.6, blue: 0.3, alpha: 1.0)
    }
    
    static let teluguOrange = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0) :
        UIColor(red: 0.9, green: 0.5, blue: 0.1, alpha: 1.0)
    }
    
    static let teluguPink = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.9, green: 0.4, blue: 0.6, alpha: 1.0) :
        UIColor(red: 0.8, green: 0.3, blue: 0.5, alpha: 1.0)
    }
    
    // MARK: - Glass Effect Colors
    static let glassWhite = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor.white.withAlphaComponent(0.1) :
        UIColor.white.withAlphaComponent(0.2)
    }
    
    static let glassBorder = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor.white.withAlphaComponent(0.1) :
        UIColor.white.withAlphaComponent(0.3)
    }
    
    static let glassHighlight = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor.white.withAlphaComponent(0.2) :
        UIColor.white.withAlphaComponent(0.4)
    }
    
    static let glassShadow = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor.black.withAlphaComponent(0.3) :
        UIColor.black.withAlphaComponent(0.1)
    }
    
    // MARK: - Background Gradients
    static let primaryGradientStart = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.2, green: 0.3, blue: 0.6, alpha: 1.0) :
        UIColor(red: 0.4, green: 0.5, blue: 0.9, alpha: 1.0)
    }
    
    static let primaryGradientEnd = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.3, green: 0.2, blue: 0.5, alpha: 1.0) :
        UIColor(red: 0.46, green: 0.29, blue: 0.64, alpha: 1.0)
    }
    
    static let secondaryGradientStart = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.4, green: 0.2, blue: 0.6, alpha: 1.0) :
        UIColor(red: 0.6, green: 0.3, blue: 0.7, alpha: 1.0)
    }
    
    static let secondaryGradientEnd = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.8, green: 0.4, blue: 0.8, alpha: 1.0) :
        UIColor(red: 0.94, green: 0.58, blue: 0.98, alpha: 1.0)
    }
}

// MARK: - SwiftUI Color Extensions
extension Color {
    // MARK: - Telugu Learning Colors
    static let teluguGold = Color(UIColor.teluguGold)
    static let culturalPurple = Color(UIColor.culturalPurple)
    static let teluguBlue = Color(UIColor.teluguBlue)
    static let teluguGreen = Color(UIColor.teluguGreen)
    static let teluguOrange = Color(UIColor.teluguOrange)
    static let teluguPink = Color(UIColor.teluguPink)
    
    // MARK: - Glass Effect Colors
    static let glassWhite = Color(UIColor.glassWhite)
    static let glassBorder = Color(UIColor.glassBorder)
    static let glassHighlight = Color(UIColor.glassHighlight)
    static let glassShadow = Color(UIColor.glassShadow)
    
    // MARK: - Background Gradients
    static let primaryGradientStart = Color(UIColor.primaryGradientStart)
    static let primaryGradientEnd = Color(UIColor.primaryGradientEnd)
    static let secondaryGradientStart = Color(UIColor.secondaryGradientStart)
    static let secondaryGradientEnd = Color(UIColor.secondaryGradientEnd)
}

// MARK: - iOS Typography System
extension UIFont {
    // MARK: - Telugu Learning Typography
    static func teluguTitle(size: CGFloat = 28) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func teluguHeadline(size: CGFloat = 20) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func teluguBody(size: CGFloat = 16) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func teluguCaption(size: CGFloat = 12) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    // MARK: - Dynamic Type Support
    static func teluguTitleDynamic() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    }
    
    static func teluguHeadlineDynamic() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }
    
    static func teluguBodyDynamic() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
    
    static func teluguCaptionDynamic() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .caption1)
    }
}

// MARK: - SwiftUI Font Extensions
extension Font {
    // MARK: - Telugu Learning Fonts
    static let teluguTitle = Font.custom("SF Pro Display", size: 28).weight(.bold)
    static let teluguHeadline = Font.custom("SF Pro Display", size: 20).weight(.semibold)
    static let teluguBody = Font.custom("SF Pro Text", size: 16).weight(.regular)
    static let teluguCaption = Font.custom("SF Pro Text", size: 12).weight(.medium)
    
    // MARK: - Dynamic Type Support
    static let teluguTitleDynamic = Font.largeTitle.weight(.bold)
    static let teluguHeadlineDynamic = Font.headline.weight(.semibold)
    static let teluguBodyDynamic = Font.body.weight(.regular)
    static let teluguCaptionDynamic = Font.caption.weight(.medium)
}

// MARK: - iOS Accessibility Colors
extension UIColor {
    // MARK: - High Contrast Colors for Accessibility
    static let highContrastGold = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 1.0, green: 0.9, blue: 0.0, alpha: 1.0) :
        UIColor(red: 0.8, green: 0.6, blue: 0.0, alpha: 1.0)
    }
    
    static let highContrastPurple = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.8, green: 0.5, blue: 0.9, alpha: 1.0) :
        UIColor(red: 0.5, green: 0.3, blue: 0.7, alpha: 1.0)
    }
    
    static let highContrastBlue = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ?
        UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0) :
        UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
    }
}

// MARK: - iOS Glass Effect Presets
enum iOSGlassPreset {
    case card
    case button
    case modal
    case navigation
    case floating
    case shimmer
    case glow
    
    var glassType: iOSGlassEffectType {
        switch self {
        case .card:
            return .regular
        case .button:
            return .thin
        case .modal:
            return .thick
        case .navigation:
            return .ultraThin
        case .floating:
            return .regular
        case .shimmer:
            return .regular
        case .glow:
            return .thin
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .card:
            return 16
        case .button:
            return 12
        case .modal:
            return 24
        case .navigation:
            return 0
        case .floating:
            return 20
        case .shimmer:
            return 16
        case .glow:
            return 16
        }
    }
    
    var enableShimmer: Bool {
        return self == .shimmer
    }
    
    var enableVibrancy: Bool {
        return self == .modal || self == .navigation
    }
}
