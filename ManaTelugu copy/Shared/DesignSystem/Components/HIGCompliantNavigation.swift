import SwiftUI

// MARK: - HIG Compliant Navigation System
// Standardizes navigation patterns across the app

struct HIGCompliantNavigationView<Content: View>: View {
    let title: String
    let displayMode: NavigationBarItem.TitleDisplayMode
    let showBackButton: Bool
    let trailingItems: [HIGNavigationItem]
    let content: Content
    
    init(
        title: String,
        displayMode: NavigationBarItem.TitleDisplayMode = .large,
        showBackButton: Bool = true,
        trailingItems: [HIGNavigationItem] = [],
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.displayMode = displayMode
        self.showBackButton = showBackButton
        self.trailingItems = trailingItems
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(displayMode)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        ForEach(trailingItems, id: \.id) { item in
                            HIGNavigationButton(item: item)
                        }
                    }
                }
        }
    }
}

struct HIGNavigationItem {
    let id = UUID()
    let icon: String
    let label: String
    let hint: String
    let action: () -> Void
}

struct HIGNavigationButton: View {
    @EnvironmentObject var session: AppSession
    let item: HIGNavigationItem
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            session.hapticsService.lightImpact()
            item.action()
        }) {
            Image(systemName: item.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(ModernDesignSystem.Colors.primary)
        }
        .frame(minWidth: ModernDesignSystem.Spacing.minimumTouchTarget, minHeight: ModernDesignSystem.Spacing.minimumTouchTarget)
        .accessibilityLabel(item.label)
        .accessibilityHint(item.hint)
        .accessibilityAddTraits(.isButton)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - HIG Compliant Tab Bar
struct HIGCompliantTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedTab = 0
    
    private let tabs: [HIGTabItem] = [
        HIGTabItem(title: "Home", icon: "house.fill", selectedIcon: "house.fill"),
        HIGTabItem(title: "Alphabet", icon: "textformat.abc", selectedIcon: "textformat.abc"),
        HIGTabItem(title: "Lessons", icon: "book", selectedIcon: "book.fill"),
        HIGTabItem(title: "Stories", icon: "books.vertical", selectedIcon: "books.vertical.fill"),
        HIGTabItem(title: "Games", icon: "gamecontroller", selectedIcon: "gamecontroller.fill"),
        HIGTabItem(title: "More", icon: "ellipsis.circle", selectedIcon: "ellipsis.circle.fill")
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                getViewForTab(index)
                    .tabItem {
                        Image(systemName: selectedTab == index ? tab.selectedIcon : tab.icon)
                        Text(tab.title)
                    }
                    .tag(index)
            }
        }
        .accentColor(ModernDesignSystem.Colors.primary)
        .onChange(of: selectedTab) {
            session.hapticsService.lightImpact()
        }
    }
    
    @ViewBuilder
    private func getViewForTab(_ index: Int) -> some View {
        switch index {
        case 0: HomeView()
        case 1: AlphabetHubView()
        case 2: LessonsHubView()
        case 3: StorybookHubView()
        case 4: GamesHubView()
        case 5: ProfessionalMoreView()
        default: HomeView()
        }
    }
}

struct HIGTabItem {
    let title: String
    let icon: String
    let selectedIcon: String
}

// MARK: - HIG Compliant Back Button
struct HIGBackButton: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    let customAction: (() -> Void)?
    @State private var isPressed = false
    
    init(customAction: (() -> Void)? = nil) {
        self.customAction = customAction
    }
    
    var body: some View {
        Button(action: {
            session.hapticsService.lightImpact()
            if let customAction = customAction {
                customAction()
            } else {
                dismiss()
            }
        }) {
            HStack(spacing: ModernDesignSystem.Spacing.tiny) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("Back")
                    .font(ModernDesignSystem.Typography.body)
            }
            .foregroundColor(ModernDesignSystem.Colors.primary)
        }
        .frame(minWidth: ModernDesignSystem.Spacing.minimumTouchTarget, minHeight: ModernDesignSystem.Spacing.minimumTouchTarget)
        .accessibilityLabel("Back")
        .accessibilityHint("Return to previous screen")
        .accessibilityAddTraits(.isButton)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}
