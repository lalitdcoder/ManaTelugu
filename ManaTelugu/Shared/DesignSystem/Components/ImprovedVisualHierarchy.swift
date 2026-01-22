import SwiftUI

// MARK: - Improved Visual Hierarchy System
struct VisualHierarchy {
    // Clear content prioritization
    static func primaryContent<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .font(Font.system(size: 24, weight: .bold))
            .foregroundColor(ModernDesignSystem.Colors.textPrimary)
    }
    
    static func secondaryContent<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .font(Font.system(size: 18, weight: .medium))
            .foregroundColor(ModernDesignSystem.Colors.secondaryText)
    }
    
    static func supportingContent<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .font(Font.system(size: 14, weight: .regular))
            .foregroundColor(ModernDesignSystem.Colors.tertiaryText)
    }
}

// MARK: - Improved Card System
struct ImprovedCard<Content: View>: View {
    let content: Content
    let priority: CardPriority
    
    init(priority: CardPriority = .normal, @ViewBuilder content: () -> Content) {
        self.priority = priority
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(priority.padding)
            .background(priority.background)
            .cornerRadius(priority.cornerRadius)
            .shadow(color: .black.opacity(priority.shadowOpacity), radius: priority.shadowRadius)
    }
}

enum CardPriority {
    case primary, normal, subtle
    
    var padding: CGFloat {
        switch self {
        case .primary: return ModernDesignSystem.Spacing.lg
        case .normal: return ModernDesignSystem.Spacing.md
        case .subtle: return ModernDesignSystem.Spacing.sm
        }
    }
    
    var background: Color {
        switch self {
        case .primary: return ModernDesignSystem.Colors.surface
        case .normal: return ModernDesignSystem.Colors.surfaceSecondary
        case .subtle: return ModernDesignSystem.Colors.background
        }
    }
    
    var cornerRadius: CGFloat { 16 }
    
    var shadowOpacity: Double {
        switch self {
        case .primary: return 0.15
        case .normal: return 0.08
        case .subtle: return 0.03
        }
    }
    
    var shadowRadius: CGFloat {
        switch self {
        case .primary: return 8
        case .normal: return 4
        case .subtle: return 2
        }
    }
}
