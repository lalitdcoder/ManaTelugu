import SwiftUI

enum MTColors {
    // Apple's semantic color system - following HIG
    static let primary = Color(.systemBlue)
    static let secondary = Color(.systemGreen)
    static let success = Color(.systemGreen)
    static let warning = Color(.systemOrange)
    static let error = Color(.systemRed)
    static let surface = Color(.systemBackground)
    static let surfaceAlt = Color(.secondarySystemBackground)
    static let text = Color(.label)
    static let background = Color(.systemGroupedBackground)
    
    // Professional accent colors - sophisticated and mature
    static let accent = Color(red: 0.0, green: 0.48, blue: 0.8) // Professional blue
    static let funBlue = Color(red: 0.1, green: 0.5, blue: 0.9) // Deep blue
    static let funGreen = Color(red: 0.1, green: 0.6, blue: 0.3) // Forest green
    static let funYellow = Color(red: 0.9, green: 0.7, blue: 0.1) // Muted gold
    static let funPink = Color(red: 0.8, green: 0.3, blue: 0.5) // Deep rose
    static let funPurple = Color(red: 0.5, green: 0.3, blue: 0.8) // Royal purple
    
    // Telugu cultural colors - sophisticated and elegant
    static let culturalOrange = Color(red: 0.9, green: 0.5, blue: 0.1) // Muted saffron
    static let culturalRed = Color(red: 0.8, green: 0.2, blue: 0.2) // Deep burgundy
    static let culturalGold = Color(red: 0.9, green: 0.7, blue: 0.1) // Refined gold
    static let culturalGreen = Color(red: 0.1, green: 0.6, blue: 0.3) // Forest green
    static let culturalBlue = Color(red: 0.1, green: 0.4, blue: 0.8) // Navy blue
    static let culturalPurple = Color(red: 0.5, green: 0.2, blue: 0.7) // Deep purple
    
    // Additional semantic colors following Apple's guidelines
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let tertiaryText = Color(.tertiaryLabel)
    static let quaternaryText = Color(.quaternaryLabel)
    
    // High contrast colors for accessibility
    static let highContrastText = Color(.label)
    static let highContrastBackground = Color(.systemBackground)
    static let highContrastAccent = Color(.systemBlue)
    
    // Special colors
    static let separator = Color(.separator)
    static let fill = Color(.systemFill)
    static let quaternaryFill = Color(.quaternarySystemFill)
    static let tertiaryFill = Color(.tertiarySystemFill)
    static let secondaryFill = Color(.secondarySystemFill)
    
    // Legacy colors for backward compatibility
    static let star = Color(.systemYellow)
    static let badge = Color(.systemOrange)
    
    // Enhanced background gradients for premium Liquid Glass effect
    static let backgroundGradientLight = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.98, blue: 0.96), // Warm cream (sunset sky)
            Color(red: 0.99, green: 0.97, blue: 0.94), // Soft peach
            Color(red: 0.98, green: 0.95, blue: 0.90), // Gentle coral
            Color(red: 0.96, green: 0.93, blue: 0.87)  // Warm sand
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradientDark = LinearGradient(
        colors: [
            Color(red: 0.12, green: 0.08, blue: 0.06), // Warm dark brown (sunset horizon)
            Color(red: 0.10, green: 0.06, blue: 0.04), // Deep warm brown
            Color(red: 0.08, green: 0.04, blue: 0.02), // Rich dark brown
            Color(red: 0.06, green: 0.02, blue: 0.01)   // Deepest warm dark
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Glass effect colors
    static let glassStrokeLight = Color.white.opacity(0.4)
    static let glassStrokeDark = Color.white.opacity(0.15)
    static let glassInnerShadowLight = Color.black.opacity(0.03)
    static let glassInnerShadowDark = Color.white.opacity(0.05)
}

extension View {
    @ViewBuilder
    func liquidGlassBackground() -> some View {
        self.background(
            OptimizedGlobalAnimatedBackground()
        )
    }
}