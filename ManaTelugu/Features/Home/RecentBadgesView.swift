import SwiftUI

struct RecentBadgesView: View {
    @EnvironmentObject var session: AppSession
    
    private var recentBadges: [GamificationBadge] {
        session.gamificationService.gamificationState.badges
            .filter { $0.isUnlocked }
            .suffix(3)
            .reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Recent Badges")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            if recentBadges.isEmpty {
                VStack(spacing: ModernDesignSystem.Spacing.md) {
                    Text("🏆")
                        .font(.system(size: 40))
                    
                    Text("No badges yet")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                    
                    Text("Complete lessons to earn your first badge!")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(ModernDesignSystem.Colors.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(ModernDesignSystem.Spacing.lg)
            } else {
                HStack(spacing: ModernDesignSystem.Spacing.md) {
                    ForEach(Array(recentBadges.enumerated()), id: \.offset) { index, badge in
                        VStack(spacing: ModernDesignSystem.Spacing.sm) {
                            Text(badge.emoji)
                                .font(.system(size: 30))
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(ModernDesignSystem.Colors.primary.opacity(0.1))
                                )
                            
                            Text(badge.name)
                                .font(ModernDesignSystem.Typography.caption)
                                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .modernCard()
    }
}
