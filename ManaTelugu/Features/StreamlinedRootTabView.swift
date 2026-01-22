import SwiftUI

struct StreamlinedRootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home - Streamlined without Quick Actions
            StreamlinedHomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)

            // Learn - Alphabet learning with smooth navigation
            AlphabetHubView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "textformat.abc" : "textformat.abc")
                    Text("Learn")
                }
                .tag(1)

            // Practice - Improved games with better responsiveness
            ImprovedGamesHubView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                    Text("Practice")
                }
                .tag(2)

            // Progress - Enhanced with integrated badge system
            EnhancedProgressView()
                .tabItem {
                    Image(
                        systemName: selectedTab == 3
                            ? "chart.line.uptrend.xyaxis" : "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
                .tag(3)

            // More - Simplified with only Contact Us and About Us
            SimplifiedMoreView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "ellipsis.circle.fill" : "ellipsis.circle")
                    Text("More")
                }
                .tag(4)
        }
        .accentColor(.blue)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(.systemBackground), for: .tabBar)
        .toolbarColorScheme(nil, for: .tabBar)
        .onChange(of: selectedTab) {
            HapticsManager.shared.impact(.light)
        }
    }
}

// Extension to add smooth tab switching animation
extension StreamlinedRootTabView {
    private func switchToTab(_ index: Int) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            selectedTab = index
        }

        // Add haptic feedback
        HapticsManager.shared.impact(.light)
    }
}
