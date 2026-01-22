import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingTreasureChest = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
                .accessibilityLabel("Home")
                .accessibilityHint("Navigate to home screen")

            AlphabetHubView()
                .tabItem {
                    Image(
                        systemName: selectedTab == 1
                            ? "character.book.closed.fill" : "character.book.closed")
                    Text("Alphabet")
                }
                .tag(1)
                .accessibilityLabel("Alphabet")
                .accessibilityHint("Learn Telugu letters")

            GamesHubView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                    Text("Games")
                }
                .tag(2)
                .accessibilityLabel("Games")
                .accessibilityHint("Play learning games")

            ProfessionalMoreView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "ellipsis.circle.fill" : "ellipsis.circle")
                    Text("More")
                }
                .tag(3)
                .accessibilityLabel("More")
                .accessibilityHint("Access settings and additional features")
        }
        .tint(.professionalBlue)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(.systemBackground), for: .tabBar)
        .toolbarColorScheme(nil, for: .tabBar)
        .onChange(of: selectedTab) {
            HapticsManager.shared.selection()
        }
        .onChange(of: session.gamificationService.treasureChestReward != nil) { _, hasReward in
            showingTreasureChest = hasReward
        }
        .sheet(isPresented: $showingTreasureChest) {
            if let reward = session.gamificationService.treasureChestReward {
                TreasureChestView(
                    stickerReward: reward.sticker,
                    xpReward: reward.xp,
                    onDismiss: {
                        session.gamificationService.dismissTreasureChest()
                        showingTreasureChest = false
                    }
                )
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(AppleHIGDesign.CornerRadius.xl)
            }
        }
    }
}
