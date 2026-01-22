import SwiftUI

// MARK: - Adaptive Layout Modifier for iPad/iPhone Support
/// This modifier provides responsive layout adjustments for different device sizes
/// iPad gets optimized multi-column layouts, larger spacing, and split views
struct AdaptiveLayoutModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    func body(content: Content) -> some View {
        content
    }
}

// MARK: - Device Size Helper
struct DeviceSizeHelper {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    /// Returns true if device is iPad (regular horizontal size class)
    var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    /// Returns true if device is in landscape orientation
    var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    /// Returns optimal number of columns for grid layouts
    var gridColumns: Int {
        if isIPad {
            return isLandscape ? 4 : 3
        } else {
            return isLandscape ? 3 : 2
        }
    }
    
    /// Returns optimal padding for current device
    var adaptivePadding: CGFloat {
        isIPad ? 32 : 20
    }
    
    /// Returns optimal spacing for current device
    var adaptiveSpacing: CGFloat {
        isIPad ? 24 : 16
    }
    
    /// Returns optimal card height for current device
    var adaptiveCardHeight: CGFloat {
        isIPad ? 200 : 160
    }
    
    /// Returns optimal font size multiplier
    var fontSizeMultiplier: CGFloat {
        isIPad ? 1.15 : 1.0
    }
}

// MARK: - Adaptive Grid Layout
struct AdaptiveGridLayout: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let items: [AnyHashable]
    let content: (AnyHashable) -> AnyView
    
    var body: some View {
        let columns = horizontalSizeClass == .regular ? 
            Array(repeating: GridItem(.flexible(), spacing: 20), count: 3) :
            Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
        
        LazyVGrid(columns: columns, spacing: horizontalSizeClass == .regular ? 20 : 12) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}

// MARK: - Adaptive Spacing View Modifier
extension View {
    /// Applies adaptive padding based on device size
    func adaptivePadding(_ edges: Edge.Set = .all) -> some View {
        modifier(AdaptivePaddingModifier(edges: edges))
    }
    
    /// Applies adaptive horizontal padding
    func adaptiveHorizontalPadding() -> some View {
        modifier(AdaptiveHorizontalPaddingModifier())
    }
}

struct AdaptivePaddingModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let edges: Edge.Set
    
    func body(content: Content) -> some View {
        let padding = horizontalSizeClass == .regular ? 32.0 : 20.0
        return content.padding(edges, padding)
    }
}

struct AdaptiveHorizontalPaddingModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    func body(content: Content) -> some View {
        let padding = horizontalSizeClass == .regular ? 32.0 : 20.0
        return content.padding(.horizontal, padding)
    }
}

// MARK: - Adaptive Font Modifier
extension View {
    /// Applies adaptive font size based on device
    func adaptiveFont(_ style: Font.TextStyle) -> some View {
        modifier(AdaptiveFontModifier(style: style))
    }
}

struct AdaptiveFontModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let style: Font.TextStyle
    
    func body(content: Content) -> some View {
        let multiplier = horizontalSizeClass == .regular ? 1.15 : 1.0
        return content.font(.system(style, design: .default))
            .scaleEffect(multiplier, anchor: .leading)
    }
}

// MARK: - Adaptive Column Count
struct AdaptiveColumnCount: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var columnCount: Int {
        if horizontalSizeClass == .regular {
            // iPad
            return verticalSizeClass == .compact ? 4 : 3
        } else {
            // iPhone
            return verticalSizeClass == .compact ? 3 : 2
        }
    }
    
    var body: some View {
        EmptyView()
    }
}

// MARK: - Adaptive Container
/// A container that adapts its layout based on device size
struct AdaptiveContainer<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let content: () -> Content
    
    var body: some View {
        if horizontalSizeClass == .regular {
            // iPad: Use wider layout with more padding
            VStack(spacing: 24) {
                content()
            }
            .padding(32)
        } else {
            // iPhone: Use standard layout
            VStack(spacing: 16) {
                content()
            }
            .padding(20)
        }
    }
}

// MARK: - Adaptive Split View Container
/// A container that uses NavigationSplitView on iPad and NavigationStack on iPhone
struct AdaptiveSplitContainer<Sidebar: View, Detail: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedItem: String?
    
    let sidebar: () -> Sidebar
    let detail: () -> Detail
    
    var body: some View {
        if horizontalSizeClass == .regular {
            // iPad: Use split view
            NavigationSplitView {
                sidebar()
            } detail: {
                detail()
            }
        } else {
            // iPhone: Use stack
            NavigationStack {
                sidebar()
            }
        }
    }
}

// MARK: - Preview Helper
#Preview {
    VStack {
        Text("Adaptive Layout Preview")
            .adaptiveFont(.title)
            .adaptivePadding()
    }
}
