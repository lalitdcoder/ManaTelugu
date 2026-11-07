import SwiftUI

// MARK: - Leaderboard Entry Component
struct LeaderboardCardView: View {
    let leaderboard: [LeaderboardEntry]

    var body: some View {
        ManaCard(style: .elevated) {
            VStack(spacing: ManaTheme.Spacing.md) {
                HStack {
                    Text("League Leaderboard")
                        .font(ManaTheme.Typography.headline)
                        .foregroundColor(ManaTheme.Colors.label)

                    Spacer()

                    Text("Bronze Division")
                        .font(ManaTheme.Typography.caption1.weight(.semibold))
                        .foregroundColor(ManaTheme.Colors.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ManaTheme.Colors.primary.opacity(0.12))
                        .clipShape(Capsule())
                }

                VStack(spacing: 0) {
                    ForEach(leaderboard.prefix(5)) { entry in
                        HStack {
                            Text("\(entry.rank)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ManaTheme.Colors.secondaryLabel)
                                .frame(width: 24)

                            Text(entry.name)
                                .font(ManaTheme.Typography.body)
                                .fontWeight(entry.isCurrentUser ? .bold : .regular)
                                .foregroundColor(entry.isCurrentUser ? ManaTheme.Colors.primary : ManaTheme.Colors.label)

                            if entry.isCurrentUser {
                                Text("(You)")
                                    .font(ManaTheme.Typography.caption2)
                                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
                            }

                            Spacer()

                            Text("\(entry.score) XP")
                                .font(ManaTheme.Typography.subheadline.weight(.semibold))
                                .foregroundColor(ManaTheme.Colors.secondaryLabel)
                        }
                        .padding(.vertical, 10)

                        if entry.id != leaderboard.prefix(5).last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Premium Apple Fitness-Style Gamification Dashboard
struct GamificationDashboardView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingBadgeGallery = false
    @State private var showingXPHistory = false

    var gamification: GamificationState {
        session.gamificationService.gamificationState
    }

    var body: some View {
        ZStack {
            ManaTheme.Colors.groupedBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: ManaTheme.Spacing.lg) {
                    // Level & XP Hero Progress Ring
                    levelRingHeroCard

                    // Streak & Heart Summary
                    statsSummaryRow

                    // Daily Goal Target Card
                    dailyGoalCard

                    // Leaderboard Snapshot
                    LeaderboardCardView(leaderboard: session.leaderboardService.leaderboard)

                    // Recent Badges Gallery
                    recentBadgesCard

                    // Sticker Album & Actions
                    quickActionsSection

                    Spacer().frame(height: 60)
                }
                .padding(.horizontal, ManaTheme.Spacing.screenMarginLarge)
                .padding(.top, ManaTheme.Spacing.sm)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Progress & XP")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            session.gamificationService.onActivityCompleted()
        }
        .sheet(isPresented: $showingBadgeGallery) {
            BadgeGalleryView(gamification: gamification)
        }
        .sheet(isPresented: $showingXPHistory) {
            XPHistoryView(gamification: gamification)
        }
    }

    // MARK: - Level Ring Hero Card
    private var levelRingHeroCard: some View {
        ManaCard(style: .elevated) {
            VStack(spacing: ManaTheme.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("CURRENT LEVEL \(gamification.currentLevel.level)")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(1.0)
                            .foregroundColor(ManaTheme.Colors.primary)

                        Text(gamification.currentLevel.teluguName)
                            .font(ManaTheme.Typography.title2)
                            .foregroundColor(ManaTheme.Colors.label)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(gamification.totalXP) XP")
                            .font(ManaTheme.Typography.roundedTitle)
                            .foregroundColor(ManaTheme.Colors.primary)

                        Text("Total Experience")
                            .font(ManaTheme.Typography.caption2)
                            .foregroundColor(ManaTheme.Colors.secondaryLabel)
                    }
                }

                // Smooth Progress to Next Level
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Progress to Next Level")
                            .font(ManaTheme.Typography.caption1)
                            .foregroundColor(ManaTheme.Colors.secondaryLabel)

                        Spacer()

                        if let nextLevel = gamification.nextLevel {
                            Text(nextLevel.teluguName)
                                .font(ManaTheme.Typography.caption1.weight(.semibold))
                                .foregroundColor(ManaTheme.Colors.primary)
                        }
                    }

                    ManaProgressBar(
                        progress: gamification.progressToNextLevel,
                        color: ManaTheme.Colors.primary,
                        height: 10
                    )
                }
            }
        }
    }

    // MARK: - Stats Summary Row
    private var statsSummaryRow: some View {
        HStack(spacing: ManaTheme.Spacing.sm) {
            ManaCard(style: .elevated, padding: ManaTheme.Spacing.sm) {
                VStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(ManaTheme.Colors.primary)

                    Text("\(gamification.streakCount) Days")
                        .font(ManaTheme.Typography.headline)
                        .foregroundColor(ManaTheme.Colors.label)

                    Text("Current Streak")
                        .font(ManaTheme.Typography.caption2)
                        .foregroundColor(ManaTheme.Colors.secondaryLabel)
                }
                .frame(maxWidth: .infinity)
            }

            ManaCard(style: .elevated, padding: ManaTheme.Spacing.sm) {
                VStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(ManaTheme.Colors.error)

                    Text("\(session.hearts)")
                        .font(ManaTheme.Typography.headline)
                        .foregroundColor(ManaTheme.Colors.label)

                    Text("Hearts Left")
                        .font(ManaTheme.Typography.caption2)
                        .foregroundColor(ManaTheme.Colors.secondaryLabel)
                }
                .frame(maxWidth: .infinity)
            }

            ManaCard(style: .elevated, padding: ManaTheme.Spacing.sm) {
                VStack(spacing: 4) {
                    Image(systemName: "character.book.closed.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(ManaTheme.Colors.peacockBlue)

                    Text("\(session.learnedLetters)")
                        .font(ManaTheme.Typography.headline)
                        .foregroundColor(ManaTheme.Colors.label)

                    Text("Letters Mastered")
                        .font(ManaTheme.Typography.caption2)
                        .foregroundColor(ManaTheme.Colors.secondaryLabel)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Daily Goal Card
    private var dailyGoalCard: some View {
        ManaCard(style: .elevated) {
            VStack(spacing: ManaTheme.Spacing.md) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "target")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(ManaTheme.Colors.emeraldGreen)

                        Text("Daily Learning Target")
                            .font(ManaTheme.Typography.headline)
                            .foregroundColor(ManaTheme.Colors.label)
                    }

                    Spacer()

                    Text("+\(gamification.dailyGoal.xpTarget) XP Reward")
                        .font(ManaTheme.Typography.caption1.weight(.semibold))
                        .foregroundColor(ManaTheme.Colors.emeraldGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ManaTheme.Colors.emeraldGreen.opacity(0.12))
                        .clipShape(Capsule())
                }

                Text("Learn \(gamification.dailyGoal.wordsToLearn) new words or concepts today")
                    .font(ManaTheme.Typography.subheadline)
                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 8) {
                    ForEach(0..<gamification.dailyGoal.wordsToLearn, id: \.self) { index in
                        Circle()
                            .fill(index < 3 ? ManaTheme.Colors.emeraldGreen : ManaTheme.Colors.fill)
                            .frame(width: 12, height: 12)
                    }
                    Spacer()
                }
            }
        }
    }

    // MARK: - Recent Badges Card
    private var recentBadgesCard: some View {
        ManaCard(style: .elevated) {
            VStack(alignment: .leading, spacing: ManaTheme.Spacing.md) {
                HStack {
                    Text("Earned Badges")
                        .font(ManaTheme.Typography.headline)
                        .foregroundColor(ManaTheme.Colors.label)

                    Spacer()

                    Button("View Gallery") {
                        showingBadgeGallery = true
                    }
                    .font(ManaTheme.Typography.caption1.weight(.semibold))
                    .foregroundColor(ManaTheme.Colors.primary)
                }

                if gamification.badges.filter({ $0.isUnlocked }).isEmpty {
                    HStack(spacing: 12) {
                        Image(systemName: "award.fill")
                            .font(.system(size: 24))
                            .foregroundColor(ManaTheme.Colors.tertiaryLabel)

                        Text("Complete lessons & games to unlock achievement badges!")
                            .font(ManaTheme.Typography.subheadline)
                            .foregroundColor(ManaTheme.Colors.secondaryLabel)
                    }
                    .padding(.vertical, 8)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: ManaTheme.Spacing.md) {
                            ForEach(gamification.badges.filter { $0.isUnlocked }) { badge in
                                VStack(spacing: 4) {
                                    ZStack {
                                        Circle()
                                            .fill(ManaTheme.Colors.primary.opacity(0.15))
                                            .frame(width: 56, height: 56)

                                        Text(badge.emoji)
                                            .font(.system(size: 24))
                                    }

                                    Text(badge.name)
                                        .font(ManaTheme.Typography.caption2)
                                        .foregroundColor(ManaTheme.Colors.label)
                                        .lineLimit(1)
                                }
                                .frame(width: 72)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        HStack(spacing: ManaTheme.Spacing.md) {
            NavigationLink(destination: StickerAlbumView()) {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .foregroundColor(ManaTheme.Colors.peacockBlue)
                    Text("Sticker Album")
                        .font(ManaTheme.Typography.bodyEmphasized)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(ManaTheme.Colors.tertiaryLabel)
                }
                .padding(ManaTheme.Spacing.md)
                .background(ManaTheme.Colors.secondaryGroupedBackground)
                .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous)
                        .stroke(ManaTheme.Colors.separator.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            Button(action: { showingXPHistory = true }) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(ManaTheme.Colors.emeraldGreen)
                    Text("XP Log")
                        .font(ManaTheme.Typography.bodyEmphasized)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(ManaTheme.Colors.tertiaryLabel)
                }
                .padding(ManaTheme.Spacing.md)
                .background(ManaTheme.Colors.secondaryGroupedBackground)
                .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous)
                        .stroke(ManaTheme.Colors.separator.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}
