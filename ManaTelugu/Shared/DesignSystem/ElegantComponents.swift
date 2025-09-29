import SwiftUI

// MARK: - Performance-Optimized Elegant Components
struct ElegantCard<Content: View>: View {
    let content: Content
    let style: CardStyle
    
    enum CardStyle {
        case standard, glass, elevated
    }
    
    init(style: CardStyle = .standard, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(ElegantDesign.Spacing.md)
            .background {
                cardBackground
                    .drawingGroup() // Performance optimization for complex backgrounds
            }
    }
    
    @ViewBuilder
    private var cardBackground: some View {
        switch style {
        case .standard:
            RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                .fill(ElegantDesign.Colors.surface)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        case .glass:
            RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                        .stroke(ElegantDesign.Colors.primary.opacity(0.2), lineWidth: 1)
                }
        case .elevated:
            RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                .fill(ElegantDesign.Colors.surface)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Lazy Loading List Component
struct ElegantLazyList<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content
    
    init(_ items: [Item], @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.content = content
    }
    
    var body: some View {
        LazyVStack(spacing: ElegantDesign.Spacing.md) {
            ForEach(items) { item in
                content(item)
                    .id(item.id) // Ensure proper identity for performance
            }
        }
    }
}

// MARK: - Cached Gradient Component
struct ElegantGradient: View {
    @State private var gradientCache: LinearGradient?
    
    var body: some View {
        Group {
            if let cached = gradientCache {
                cached
            } else {
                createGradient()
                    .onAppear {
                        gradientCache = createGradient()
                    }
            }
        }
    }
    
    private func createGradient() -> LinearGradient {
        LinearGradient(
            colors: [
                ElegantDesign.Colors.primary.opacity(0.8),
                ElegantDesign.Colors.secondary.opacity(0.6),
                ElegantDesign.Colors.accent.opacity(0.4)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - View Extensions for Performance
extension View {
    func elegantCard() -> some View {
        self
            .padding(ElegantDesign.Spacing.md)
            .background {
                RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                    .fill(ElegantDesign.Colors.surface)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
    }
    
    // Optimized haptic feedback
    func elegantHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        self.onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: style)
            impactFeedback.impactOccurred()
        }
    }
    
    // Memory-efficient animations
    func elegantAnimation<V: Equatable>(_ value: V) -> some View {
        self.animation(.easeInOut(duration: 0.3), value: value)
    }
}
