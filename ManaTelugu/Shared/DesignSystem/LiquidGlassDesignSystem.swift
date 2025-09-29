import SwiftUI

// MARK: - Liquid Glass Design System
struct LGDesign {
    
    // MARK: - Colors
    struct Colors {
        static let primary = LinearGradient(
            colors: [Color(red: 0.2, green: 0.4, blue: 1.0), Color(red: 0.4, green: 0.2, blue: 0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let background = LinearGradient(
            colors: [Color(.systemBackground), Color(.systemBackground).opacity(0.8)],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let text = Color.primary
        static let secondaryText = Color.secondary
        static let accent = Color.blue
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let title = Font.system(.title, design: .rounded, weight: .semibold)
        static let title2 = Font.system(.title2, design: .rounded, weight: .semibold)
        static let headline = Font.system(.headline, design: .rounded, weight: .medium)
        static let body = Font.system(.body, design: .default, weight: .regular)
        static let caption = Font.system(.caption, design: .default, weight: .medium)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct Radius {
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
    }
}

// MARK: - Components
// LiquidGlassCard and LiquidGlassButton are defined in MissingComponents.swift
