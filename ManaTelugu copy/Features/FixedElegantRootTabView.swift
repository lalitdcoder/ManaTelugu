import SwiftUI

struct FixedElegantRootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            // Background gradient
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)

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
                        Image(
                            systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                        Text("Practice")
                    }
                    .tag(2)
                    .accessibilityLabel("Practice tab")
                    .accessibilityHint("Play games to practice Telugu skills")

                // More
                ModernMoreView()
                    .tabItem {
                        Image(
                            systemName: selectedTab == 3
                                ? "ellipsis.circle.fill" : "ellipsis.circle")
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
    }
}
