import SwiftUI

enum MTColors {
    // Apple's semantic color system
    static let primary = Color(.systemBlue)
    static let secondary = Color(.systemGreen)
    static let success = Color(.systemGreen)
    static let warning = Color(.systemOrange)
    static let error = Color(.systemRed)
    static let surface = Color(.systemBackground)
    static let surfaceAlt = Color(.secondarySystemBackground)
    static let text = Color(.label)
    static let background = Color(.systemGroupedBackground)
    
    // Accent colors for different features
    static let accent = Color(.systemBlue)
    static let funBlue = Color(.systemBlue)
    static let funGreen = Color(.systemGreen)
    static let funYellow = Color(.systemYellow)
    static let funPink = Color(.systemPink)
    
    // Legacy colors for backward compatibility
    static let mascot = Color(.systemPink)
    static let star = Color(.systemYellow)
    static let badge = Color(.systemOrange)
}