import SwiftUI

// MARK: - Improved Content Layouts
struct BreathingRoomLayout<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: MTSpacing.xLarge) {
            content
        }
        .padding(.horizontal, MTSpacing.large)
        .padding(.vertical, MTSpacing.medium)
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
        VStack(alignment: .leading, spacing: MTSpacing.medium) {
            VStack(alignment: .leading, spacing: MTSpacing.tiny) {
                Text(title)
                    .font(Font.system(size: 20, weight: .semibold))
                    .foregroundColor(MTColors.text)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(Font.system(size: 14, weight: .regular))
                        .foregroundColor(MTColors.secondaryText)
                }
            }
            
            content
        }
        .padding(MTSpacing.large)
        .background(MTColors.surface)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}

// MARK: - Grid Improvements
struct ImprovedGrid<Content: View>: View {
    let columns: Int
    let spacing: CGFloat
    let content: Content
    
    init(columns: Int = 2, spacing: CGFloat = MTSpacing.medium, @ViewBuilder content: () -> Content) {
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
