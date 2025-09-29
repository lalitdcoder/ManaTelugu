import SwiftUI

// MARK: - Improved Visual Hierarchy System
struct VisualHierarchy {
    // Clear content prioritization
    static func primaryContent<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .font(Font.system(size: 24, weight: .bold))
            .foregroundColor(MTColors.text)
    }
    
    static func secondaryContent<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .font(Font.system(size: 18, weight: .medium))
            .foregroundColor(MTColors.secondaryText)
    }
    
    static func supportingContent<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .font(Font.system(size: 14, weight: .regular))
            .foregroundColor(MTColors.tertiaryText)
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
        case .primary: return MTSpacing.large
        case .normal: return MTSpacing.medium
        case .subtle: return MTSpacing.small
        }
    }
    
    var background: Color {
        switch self {
        case .primary: return MTColors.surface
        case .normal: return MTColors.surfaceAlt
        case .subtle: return MTColors.background
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
