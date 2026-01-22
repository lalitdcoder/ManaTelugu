import SwiftUI

enum RefinedColors {
    // Text colors
    static let charcoal = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let mediumGray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let lightGray = Color(red: 0.8, green: 0.8, blue: 0.8)
    
    // Professional accent colors
    static let warmYellow = Color(red: 0.9, green: 0.7, blue: 0.1) // Muted gold
    static let vibrantBlue = Color(red: 0.0, green: 0.4, blue: 0.8) // Professional blue
    static let freshGreen = Color(red: 0.1, green: 0.6, blue: 0.3) // Forest green
    static let softGreen = Color(red: 0.2, green: 0.6, blue: 0.4) // Sage green
    static let glassWhiteOpaque = Color.white.opacity(0.9) // More opaque
    static let vibrantPink = Color(red: 0.8, green: 0.3, blue: 0.5) // Deep rose
    static let richPurple = Color(red: 0.5, green: 0.3, blue: 0.8) // Royal purple
    
    // Glassmorphism background gradients
    static let background = Color(red: 0.4, green: 0.5, blue: 0.9) // #667eea
    static let secondaryBackground = Color(red: 0.46, green: 0.29, blue: 0.64) // #764ba2
    static let tertiaryBackground = Color(red: 0.94, green: 0.58, blue: 0.98) // #f093fb
    static let groupedBackground = Color(.systemGroupedBackground)
    
    // Glass effect colors
    static let glassWhite = Color.white.opacity(0.1)
    static let glassBorder = Color.white.opacity(0.2)
    static let glassHighlight = Color.white.opacity(0.3)
    static let glassShadow = Color.black.opacity(0.1)
    
    // Gradient background colors for glassmorphism
    static let gradientBlue = Color(red: 0.4, green: 0.5, blue: 0.9) // #667eea
    static let gradientPurple = Color(red: 0.46, green: 0.29, blue: 0.64) // #764ba2
    static let gradientPink = Color(red: 0.94, green: 0.58, blue: 0.98) // #f093fb
    static let gradientOrange = Color(red: 0.96, green: 0.58, blue: 0.98) // #f093fb variant
    
    // Semantic colors
    static let primary = Color(.systemBlue)
    static let secondary = Color(.systemGreen)
    static let success = Color(.systemGreen)
    static let warning = Color(.systemOrange)
    static let error = Color(.systemRed)
}






