import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingBadgeUnlock = false
    @State private var showingTreasureChest = false
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            // Clean background gradient
            LinearGradient(
                colors: [
                    MTColors.teluguBlue.opacity(0.1),
                    MTColors.teluguSaffron.opacity(0.05),
                    MTColors.teluguGreen.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all, edges: .all)

            // Simple tab view with improved UI
            TabView(selection: $selectedTab) {
                SimpleImprovedHomeView()
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        Text("Home")
                    }
                    .tag(0)
                
                AlphabetHubView()
                    .tabItem {
                        Image(systemName: selectedTab == 1 ? "textformat.abc" : "textformat.abc")
                        Text("Alphabet")
                    }
                    .tag(1)
                
                GamesHubView()
                    .tabItem {
                        Image(systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                        Text("Games")
                    }
                    .tag(2)
                
                ProfessionalMoreView()
                    .tabItem {
                        Image(systemName: selectedTab == 3 ? "ellipsis.circle.fill" : "ellipsis.circle")
                        Text("More")
                    }
                    .tag(3)
            }
            .accentColor(MTColors.teluguBlue)
            .onChange(of: selectedTab) { _ in
                session.hapticsService.lightImpact()
            }
        }
        .onChange(of: session.gamificationService.newlyUnlockedBadges.isEmpty) {
            showingBadgeUnlock = !session.gamificationService.newlyUnlockedBadges.isEmpty
        }
        .onChange(of: session.gamificationService.treasureChestReward != nil) {
            showingTreasureChest = session.gamificationService.treasureChestReward != nil
        }
        .sheet(isPresented: $showingBadgeUnlock) {
            if let badge = session.gamificationService.newlyUnlockedBadges.first {
                BadgeUnlockedView(badge: badge) {
                    session.gamificationService.dismissNewlyUnlockedBadge()
                    showingBadgeUnlock = false
                }
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(20)
            }
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
                .presentationCornerRadius(20)
            }
        }
    }
}
