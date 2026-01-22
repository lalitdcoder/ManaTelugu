import SwiftUI

// MARK: - iPad-Optimized Root Tab View
/// Adapts layout based on device size:
/// - iPad: Uses sidebar navigation with split view for better space utilization
/// - iPhone: Uses traditional tab bar at bottom
struct IPadOptimizedRootTabView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedTab = 0
    @State private var selectedSidebarItem: String = "home"

    var body: some View {
        ZStack {
            // Background gradient
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)

            if horizontalSizeClass == .regular {
                // iPad: Sidebar + Content Layout
                iPadLayout
            } else {
                // iPhone: Tab Bar Layout
                iPhoneLayout
            }
        }
        .onAppear {
            // Tab bar appearance is now handled by SwiftUI modifiers
        }
    }

    // MARK: - iPad Layout with Sidebar
    /// iPad-optimized layout using NavigationSplitView with sidebar navigation
    /// Provides better space utilization on larger screens
    private var iPadLayout: some View {
        NavigationSplitView {
            // Sidebar with menu items
            VStack(alignment: .leading, spacing: 0) {
                Text("Mana Telugu")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                Divider()

                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        // Home
                        sidebarButton(
                            label: "Home",
                            icon: "house.fill",
                            isSelected: selectedSidebarItem == "home"
                        ) {
                            selectedSidebarItem = "home"
                        }

                        // Learn
                        sidebarButton(
                            label: "Learn",
                            icon: "textformat.abc",
                            isSelected: selectedSidebarItem == "learn"
                        ) {
                            selectedSidebarItem = "learn"
                        }

                        // Practice
                        sidebarButton(
                            label: "Practice",
                            icon: "gamecontroller.fill",
                            isSelected: selectedSidebarItem == "practice"
                        ) {
                            selectedSidebarItem = "practice"
                        }

                        // More
                        sidebarButton(
                            label: "More",
                            icon: "ellipsis.circle.fill",
                            isSelected: selectedSidebarItem == "more"
                        ) {
                            selectedSidebarItem = "more"
                        }

                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                }
            }
            .background(Color(.systemGray6))
        } detail: {
            // Content Area - displays selected view based on sidebar selection
            Group {
                switch selectedSidebarItem {
                case "home":
                    HomeView()
                case "learn":
                    NavigationStack {
                        ModernAlphabetView()
                    }
                case "practice":
                    ModernGamesView()
                case "more":
                    ModernMoreView()
                default:
                    HomeView()
                }
            }
            .navigationTitle(navigationTitle(selectedSidebarItem))
        }
        .accentColor(ModernDesignSystem.Colors.primary)
    }

    // MARK: - Sidebar Button Helper
    /// Creates a styled sidebar button for navigation
    /// - Parameters:
    ///   - label: Button text label
    ///   - icon: SF Symbol icon name
    ///   - isSelected: Whether this button is currently selected
    ///   - action: Closure to execute when tapped
    private func sidebarButton(
        label: String,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 24)

                Text(label)
                    .font(.system(size: 16, weight: .semibold))

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? ModernDesignSystem.Colors.primary.opacity(0.2) : Color.clear)
            )
            .foregroundColor(isSelected ? ModernDesignSystem.Colors.primary : .primary)
        }
    }

    // MARK: - iPhone Layout with Tab Bar
    private var iPhoneLayout: some View {
        TabView(selection: $selectedTab) {
            // Home
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
                .accessibilityLabel("Home tab")
                .accessibilityHint("View your learning progress and continue lessons")

            // Learn
            NavigationStack {
                ModernAlphabetView()
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "textformat.abc" : "textformat.abc")
                Text("Learn")
            }
            .tag(1)
            .accessibilityLabel("Learn tab")
            .accessibilityHint("Learn Telugu alphabet and characters")

            // Practice
            ModernGamesView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                    Text("Practice")
                }
                .tag(2)
                .accessibilityLabel("Practice tab")
                .accessibilityHint("Play games to practice Telugu skills")

            // More
            ModernMoreView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "ellipsis.circle.fill" : "ellipsis.circle")
                    Text("More")
                }
                .tag(3)
                .accessibilityLabel("More tab")
                .accessibilityHint("Access settings, progress, and additional features")
        }
        .accentColor(ModernDesignSystem.Colors.primary)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(.systemBackground), for: .tabBar)
        .toolbarColorScheme(nil, for: .tabBar)
        .onChange(of: selectedTab) {
            HapticsManager.shared.impact(.light)
        }
    }

    // MARK: - Helper Methods

    private func navigationTitle(_ selection: String) -> String {
        switch selection {
        case "home": return "Home"
        case "learn": return "Learn"
        case "practice": return "Practice"
        case "more": return "More"
        default: return "Mana Telugu"
        }
    }
}

// MARK: - Preview
#Preview {
    IPadOptimizedRootTabView()
        .environmentObject(AppSession())
}
