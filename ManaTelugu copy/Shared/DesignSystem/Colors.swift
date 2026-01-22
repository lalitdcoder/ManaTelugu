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
    
    // Text colors
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let tertiaryText = Color(.tertiaryLabel)
    
    // Professional accent colors - sophisticated and mature
    static let accent = Color("MTAccentColor") // Professional blue
    static let funBlue = Color("MTFunBlueColor") // Deep blue
    static let funGreen = Color("MTFunGreenColor") // Forest green
    static let funYellow = Color("MTFunYellowColor") // Muted gold
    static let funPink = Color("MTFunPinkColor") // Deep rose
    static let funPurple = Color(red: 0.5, green: 0.3, blue: 0.8) // Royal purple
    
    // Telugu cultural colors - sophisticated and elegant
    static let teluguBlue = Color(red: 0.1, green: 0.4, blue: 0.8) // Navy blue
    static let teluguGreen = Color(red: 0.1, green: 0.6, blue: 0.3) // Forest green
    static let teluguSaffron = Color(red: 0.9, green: 0.7, blue: 0.1) // Refined gold
    static let culturalOrange = Color(red: 0.9, green: 0.5, blue: 0.1) // Muted saffron
    static let culturalRed = Color(red: 0.8, green: 0.2, blue: 0.2) // Deep burgundy
    static let culturalGold = Color(red: 0.9, green: 0.7, blue: 0.1) // Refined gold
    static let culturalGreen = Color(red: 0.1, green: 0.6, blue: 0.3) // Forest green
    static let culturalBlue = Color(red: 0.1, green: 0.4, blue: 0.8) // Navy blue
    static let culturalPurple = Color(red: 0.5, green: 0.2, blue: 0.7) // Deep purple
    
    // Card backgrounds
    static let cardBackground = Color(.secondarySystemBackground)
}
