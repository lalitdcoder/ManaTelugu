import SwiftUI

// MARK: - Improved Content Layouts
struct BreathingRoomLayout<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.xLarge) {
            content
        }
        .padding(.horizontal, ModernDesignSystem.Spacing.lg)
        .padding(.vertical, ModernDesignSystem.Spacing.md)
    }
}

// MARK: - Clean Card Layout
struct CleanCardLayout<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: Content
    
    init(title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
                Text(title)
                    .font(Font.system(size: 20, weight: .semibold))
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(Font.system(size: 14, weight: .regular))
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                }
            }
            
            content
        }
        .padding(ModernDesignSystem.Spacing.lg)
        .background(ModernDesignSystem.Colors.surface)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}

// MARK: - Grid Improvements
struct ImprovedGrid<Content: View>: View {
    let columns: Int
    let spacing: CGFloat
    let content: Content
    
    init(columns: Int = 2, spacing: CGFloat = ModernDesignSystem.Spacing.md, @ViewBuilder content: () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns),
            spacing: spacing
        ) {
            content
        }
    }
}
