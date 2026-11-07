import SwiftUI
import UIKit

struct RootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingTreasureChest = false
    @State private var showingBadgePopUp = false
    @State private var currentBadge: GamificationBadge? = nil
    @State private var selectedTab = 0
    @State private var xpChange: Int?
    @State private var showingOnboarding = false

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
                    }
                )
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(AppleHIGDesign.CornerRadius.xl)
            }
            .fullScreenCover(isPresented: $showingOnboarding) {
                OnboardingView()
                    .environmentObject(session)
            }
            .overlay(alignment: .top) {
                xpOverlay
            }
            .onChange(of: session.gamificationService.lastXPChange) { _, amount in
                if let amount = amount {
                    handleXPChange(amount)
                }
            }
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "isOnboardingCompleted") {
                    showingOnboarding = true
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
            learnTab
            practiceTab
            moreTab
        }
        .tint(AppleHIGDesign.Colors.primary)
        .toolbarBackground(.visible, for: .tabBar)
        .onChange(of: selectedTab) { _, _ in
            AppleHIGDesign.Haptics.selection()
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

    private var learnTab: some View {
        LearnView()
            .tabItem {
                Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                Text("Learn")
            }
            .tag(1)
            .accessibilityLabel("Learn")
            .accessibilityHint("Explore the 48-module Telugu course")
    }

    private var practiceTab: some View {
        PracticeView()
            .tabItem {
                Image(systemName: selectedTab == 2 ? "bolt.fill" : "bolt")
                Text("Practice")
            }
            .tag(2)
            .accessibilityLabel("Practice")
            .accessibilityHint("Practice games and targeted review")
    }

    private var moreTab: some View {
        ProfessionalMoreView()
            .tabItem {
                Image(systemName: selectedTab == 3 ? "ellipsis.circle.fill" : "ellipsis.circle")
                Text("More")
            }
            .tag(3)
            .accessibilityLabel("More")
            .accessibilityHint("Access settings, alphabet reference, and features")
    }

    @ViewBuilder
    private var xpOverlay: some View {
        if let amount = xpChange {
            XPPopUp(amount: amount)
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.top, 60)
        }
    }

    private func handleXPChange(_ amount: Int) {
        if amount > 0 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                xpChange = amount
            }

            AppleHIGDesign.Haptics.success()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    xpChange = nil
                }
            }
        }
    }
}
