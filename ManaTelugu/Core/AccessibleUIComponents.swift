import SwiftUI

// MARK: - Minimal Accessible UI Components

struct AccessibleTabView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
                .accessibilityLabel("Home")
                .accessibilityHint("View your learning progress and continue lessons")
            
            ModernAlphabetView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "textformat.abc" : "textformat.abc")
                    Text("Learn")
                }
                .tag(1)
                .accessibilityLabel("Learn")
                .accessibilityHint("Learn Telugu alphabet and characters")
            
            ModernGamesView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                    Text("Practice")
                }
                .tag(2)
                .accessibilityLabel("Practice")
                .accessibilityHint("Play games to practice Telugu skills")
            
            ModernMoreView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "ellipsis.circle.fill" : "ellipsis.circle")
                    Text("More")
                }
                .tag(3)
                .accessibilityLabel("More")
                .accessibilityHint("Access settings, progress, and additional features")
        }
        .onChange(of: selectedTab) { _, newTab in
            // Announce tab change for VoiceOver users
            let tabNames = ["Home", "Learn", "Practice", "More"]
            if newTab < tabNames.count {
                AccessibilityAnnouncer.announce("\(tabNames[newTab]) tab selected")
            }
        }
    }
}
