import SwiftUI
import UIKit

// MARK: - Dark Mode Configuration for Mana Telugu App

struct DarkModeConfiguration {

    // MARK: - Setup Methods
    static func configureAppForDarkMode() {
        configureOtherUIElements()
    }

    // MARK: - Other UI Elements Configuration
    private static func configureOtherUIElements() {
        // Configure switches
        UISwitch.appearance().onTintColor = UIColor.systemBlue

        // Configure sliders
        UISlider.appearance().tintColor = UIColor.systemBlue

        // Configure progress views
        UIProgressView.appearance().tintColor = UIColor.systemBlue
        UIProgressView.appearance().trackTintColor = UIColor.systemGray5

        // Configure activity indicators
        UIActivityIndicatorView.appearance().color = UIColor.systemBlue

        // Configure text fields
        UITextField.appearance().tintColor = UIColor.systemBlue

        // Configure text views
        UITextView.appearance().tintColor = UIColor.systemBlue
    }
}

// MARK: - Dark Mode Aware Colors Extension
extension Color {

    // MARK: - Semantic Colors for Dark Mode
    static let adaptiveBackground = Color(.systemBackground)
    static let adaptiveSecondaryBackground = Color(.secondarySystemBackground)
    static let adaptiveTertiaryBackground = Color(.tertiarySystemBackground)

    static let adaptiveLabel = Color(.label)
    static let adaptiveSecondaryLabel = Color(.secondaryLabel)
    static let adaptiveTertiaryLabel = Color(.tertiaryLabel)

    static let adaptiveSeparator = Color(.separator)
    static let adaptiveOpaqueSeparator = Color(.opaqueSeparator)

    static let adaptiveGroupedBackground = Color(.systemGroupedBackground)
    static let adaptiveSecondaryGroupedBackground = Color(.secondarySystemGroupedBackground)
    static let adaptiveTertiaryGroupedBackground = Color(.tertiarySystemGroupedBackground)

    // MARK: - Custom App Colors with Dark Mode Support
    static let teluguPrimary = Color("ModernPrimaryColor")
    static let teluguSecondary = Color("ModernSecondaryColor")
    static let teluguAccent = Color("ModernAccentColor")

    static let teluguBackground = Color("ModernBackgroundColor")
    static let teluguSurface = Color("ModernSurfaceColor")
    static let teluguCardBackground = Color("ModernCardBackgroundColor")

    static let teluguTextPrimary = Color("ModernTextPrimaryColor")
    static let teluguTextSecondary = Color("ModernTextSecondaryColor")
    static let teluguTextTertiary = Color("ModernTextTertiaryColor")
}

// MARK: - Dark Mode Aware View Modifiers
extension View {

    /// Applies adaptive background that works in both light and dark mode
    func adaptiveBackground() -> some View {
        self.background(Color.adaptiveBackground)
    }

    /// Applies adaptive card styling that works in both light and dark mode
    func adaptiveCard(cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 4) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.adaptiveSecondaryBackground)
                    .shadow(
                        color: Color.adaptiveSeparator.opacity(0.3),
                        radius: shadowRadius,
                        x: 0,
                        y: 2
                    )
            )
    }

    /// Applies adaptive text color that works in both light and dark mode
    func adaptiveTextColor(_ level: TextLevel = .primary) -> some View {
        self.foregroundColor(level.color)
    }

    /// Applies adaptive border that works in both light and dark mode
    func adaptiveBorder(width: CGFloat = 1, cornerRadius: CGFloat = 8) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.adaptiveSeparator, lineWidth: width)
        )
    }
}

// MARK: - Text Level Enum
enum TextLevel {
    case primary
    case secondary
    case tertiary

    var color: Color {
        switch self {
        case .primary:
            return Color.adaptiveLabel
        case .secondary:
            return Color.adaptiveSecondaryLabel
        case .tertiary:
            return Color.adaptiveTertiaryLabel
        }
    }
}

// MARK: - Dark Mode Detection
extension ColorScheme {
    var isDark: Bool {
        return self == .dark
    }

    var isLight: Bool {
        return self == .light
    }
}

// MARK: - Environment Values Extension
extension EnvironmentValues {
    var isDarkMode: Bool {
        return colorScheme == .dark
    }
}

// MARK: - Usage Instructions
/*
 To use this dark mode configuration:

 1. Call DarkModeConfiguration.configureAppForDarkMode() in your app's initialization
 2. Use Color.adaptive* colors instead of hardcoded colors
 3. Use .adaptiveBackground(), .adaptiveCard(), etc. modifiers
 4. Use Color.telugu* colors for app-specific branding that supports dark mode
 5. Check @Environment(\.colorScheme) or @Environment(\.isDarkMode) for conditional styling
 6. Tab bar and navigation bar styling is now handled by SwiftUI's .toolbarBackground() modifiers

 Example usage:

 VStack {
     Text("Hello")
         .adaptiveTextColor(.primary)

     Text("World")
         .adaptiveTextColor(.secondary)
 }
 .adaptiveCard()
 .adaptiveBackground()
 */
