import SwiftUI

struct GamificationDashboardView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingBadgeGallery = false
    @State private var showingXPHistory = false
    @State private var animateXP = false
    @State private var animateBadge = false
    
    var gamification: GamificationState {
        session.gamificationService.gamificationState
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Enhanced background gradient for Liquid Glass effect
                Color.clear
                    .liquidGlassBackground()
                    .ignoresSafeArea()
                
                EnhancedScrollView {
                    VStack(spacing: ModernDesignSystem.Spacing.lg) {
                        // Header with level and XP
                        LevelProgressCard(gamification: gamification, animateXP: $animateXP)
                            .padding(.horizontal)
                        
                        // Daily Goal Card
                        DailyGoalCard(gamification: gamification)
                            .padding(.horizontal)
                        
                        // Streak Card
                        StreakCard(title: "Streak", value: "\(gamification.streakCount)", icon: "flame.fill", color: ModernDesignSystem.Colors.funYellow)
                            .padding(.horizontal)
                        
                        // Recent Badges
                        RecentBadgesCard(gamification: gamification, animateBadge: $animateBadge)
                            .padding(.horizontal)
                        
                        // Quick Actions
                        QuickActionsCard(
                            showingBadgeGallery: $showingBadgeGallery,
                            showingXPHistory: $showingXPHistory
                        )
                        .padding(.horizontal)
                        
                        // Badges Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Badges")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(Array(gamification.badges.prefix(5).enumerated()), id: \.offset) { index, badge in
                                        VStack {
                                            Text(badge.emoji)
                                                .font(.title2)
                                                .foregroundColor(ModernDesignSystem.Colors.primary)
                                            Text(badge.name)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 80, height: 80)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Sticker Album Section
                        NavigationLink(destination: StickerAlbumView()) {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("Sticker Album")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .foregroundColor(.primary)
                        }

                        // XP History section removed - using sheet instead
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                session.gamificationService.onActivityCompleted()
            }
        }
        .sheet(isPresented: $showingBadgeGallery) {
            BadgeGalleryView(gamification: gamification)
        }
        .sheet(isPresented: $showingXPHistory) {
            XPHistoryView(gamification: gamification)
        }
    }
}

// MARK: - Level Progress Card
struct LevelProgressCard: View {
    @ObservedObject var gamification: GamificationState
    @Binding var animateXP: Bool
    
    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(gamification.currentLevel.level)")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(.primary)
                    Text(gamification.currentLevel.teluguName)
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(gamification.totalXP) XP")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(.primary)
                        .scaleEffect(animateXP ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: animateXP)
                    Text("Total Experience")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress to Next Level")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    if let nextLevel = gamification.nextLevel {
                        Text("\(nextLevel.teluguName)")
                            .font(ModernDesignSystem.Typography.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.accentColor)
                    }
                }
                
                ProgressView(value: gamification.progressToNextLevel)
                    .progressViewStyle(LinearProgressViewStyle(tint: ModernDesignSystem.Colors.primary))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - Daily Goal Card
struct DailyGoalCard: View {
    @ObservedObject var gamification: GamificationState
    
    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            HStack {
                Image(systemName: "target")
                    .font(.title2)
                    .foregroundColor(ModernDesignSystem.Colors.funGreen)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Goal")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(.primary)
                    Text("Learn \(gamification.dailyGoal.wordsToLearn) words today")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(gamification.dailyGoal.xpTarget) XP")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(ModernDesignSystem.Colors.funGreen)
                    Text("Reward")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress indicator
            HStack {
                ForEach(0..<gamification.dailyGoal.wordsToLearn, id: \.self) { index in
                    Circle()
                        .fill(index < 3 ? ModernDesignSystem.Colors.funGreen : Color(.systemGray4))
                        .frame(width: 12, height: 12)
                }
                Spacer()
            }
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// StreakCard is defined in EnhancedProgressView.swift

// MARK: - Recent Badges Card
struct RecentBadgesCard: View {
    @ObservedObject var gamification: GamificationState
    @Binding var animateBadge: Bool
    
    var recentBadges: [GamificationBadge] {
        gamification.badges.filter { $0.isUnlocked }.suffix(3).reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            HStack {
                Text("Recent Badges")
                    .font(ModernDesignSystem.Typography.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("View All") {
                    // Show badge gallery
                }
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(.accentColor)
            }
            
            if recentBadges.isEmpty {
                HStack {
                    Image(systemName: "star")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Complete activities to earn badges!")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, ModernDesignSystem.Spacing.md)
            } else {
                HStack(spacing: ModernDesignSystem.Spacing.md) {
                    ForEach(recentBadges) { badge in
                        BadgeIconView(badge: badge, size: 60)
                            .scaleEffect(animateBadge ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: animateBadge)
                    }
                }
            }
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - Quick Actions Card
struct QuickActionsCard: View {
    @Binding var showingBadgeGallery: Bool
    @Binding var showingXPHistory: Bool
    
    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            Text("Quick Actions")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: ModernDesignSystem.Spacing.md) {
                Button(action: { showingBadgeGallery = true }) {
                    VStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.title2)
                            .foregroundColor(ModernDesignSystem.Colors.funYellow)
                        Text("Badges")
                            .font(ModernDesignSystem.Typography.caption)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ModernDesignSystem.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.tertiarySystemGroupedBackground))
                    )
                }
                .buttonStyle(.plain)
                
                Button(action: { showingXPHistory = true }) {
                    VStack(spacing: 8) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title2)
                            .foregroundColor(ModernDesignSystem.Colors.funGreen)
                        Text("XP History")
                            .font(ModernDesignSystem.Typography.caption)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ModernDesignSystem.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.tertiarySystemGroupedBackground))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - Badge Icon View
struct BadgeIconView: View {
    let badge: GamificationBadge
    let size: CGFloat
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color(badge.color))
                    .frame(width: size, height: size)
                    .shadow(color: Color(badge.color).opacity(0.3), radius: 4, x: 0, y: 2)
                
                Text(badge.emoji)
                    .font(.system(size: size * 0.4, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text(badge.name)
                .font(ModernDesignSystem.Typography.caption2)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: size + 20)
    }
}

#Preview {
    GamificationDashboardView()
        .environmentObject(AppSession())
}
