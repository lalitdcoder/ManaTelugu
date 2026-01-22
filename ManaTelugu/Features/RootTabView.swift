import SwiftUI
import UIKit

struct RootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingTreasureChest = false
    @State private var showingBadgePopUp = false
    @State private var currentBadge: GamificationBadge? = nil
    @State private var selectedTab = 0
    @State private var xpChange: Int?

    var body: some View {
        mainTabView
            .onChange(of: session.gamificationService.treasureChestReward != nil) { _, hasReward in
                showingTreasureChest = hasReward
            }
            .onChange(of: session.gamificationService.newlyUnlockedBadges.count) { _, count in
                if count > 0 && currentBadge == nil {
                    presentNextBadge()
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
                    .presentationCornerRadius(AppleHIGDesign.CornerRadius.xl)
                }
            }
            .sheet(item: $currentBadge) { badge in
                BadgeUnlockedView(
                    badge: badge,
                    onDismiss: {
                        session.gamificationService.dismissNewlyUnlockedBadge()
                        currentBadge = nil
                        // If there are more badges, they will be handled by the onChange
                    }
                )
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(AppleHIGDesign.CornerRadius.xl)
            }
            .overlay(alignment: .top) {
                xpOverlay
            }
            .onChange(of: session.gamificationService.lastXPChange) { _, amount in
                if let amount = amount {
                    handleXPChange(amount)
                }
            }
    }

    private func presentNextBadge() {
        if let first = session.gamificationService.newlyUnlockedBadges.first {
            currentBadge = first
        }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            homeTab
            alphabetTab
            gamesTab
            moreTab
        }
        .tint(.professionalBlue)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(uiColor: .systemBackground), for: .tabBar)
        .toolbarColorScheme(nil, for: .tabBar)
        .onChange(of: selectedTab) { _, _ in
            HapticsManager.shared.selection()
        }
    }

    private var homeTab: some View {
        HomeView()
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("Home")
            }
            .tag(0)
            .accessibilityLabel("Home")
            .accessibilityHint("Navigate to home screen")
    }

    private var alphabetTab: some View {
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
    }

    private var gamesTab: some View {
        GamesHubView()
            .tabItem {
                Image(systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                Text("Games")
            }
            .tag(2)
            .accessibilityLabel("Games")
            .accessibilityHint("Play learning games")
    }

    private var moreTab: some View {
        ProfessionalMoreView()
            .tabItem {
                Image(systemName: selectedTab == 3 ? "ellipsis.circle.fill" : "ellipsis.circle")
                Text("More")
            }
            .tag(3)
            .accessibilityLabel("More")
            .accessibilityHint("Access settings and additional features")
    }

    @ViewBuilder
    private var xpOverlay: some View {
        if let amount = xpChange {
            XPPopUp(amount: amount)
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.top, 60)  // Below dynamic island/notch
        }
    }

    private func handleXPChange(_ amount: Int) {
        if amount > 0 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                xpChange = amount
            }

            // Haptic feedback for XP
            HapticsManager.shared.notification(.success)

            // Hide after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    xpChange = nil
                }
            }
        }
    }
}
