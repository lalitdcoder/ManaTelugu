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
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Recent Badges")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            if recentBadges.isEmpty {
                VStack(spacing: ElegantDesign.Spacing.md) {
                    Text("🏆")
                        .font(.system(size: 40))
                    
                    Text("No badges yet")
                        .font(ElegantDesign.Typography.body)
                        .foregroundColor(ElegantDesign.Colors.textSecondary)
                    
                    Text("Complete lessons to earn your first badge!")
                        .font(ElegantDesign.Typography.caption)
                        .foregroundColor(ElegantDesign.Colors.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(ElegantDesign.Spacing.lg)
            } else {
                HStack(spacing: ElegantDesign.Spacing.md) {
                    ForEach(Array(recentBadges.enumerated()), id: \.offset) { index, badge in
                        VStack(spacing: ElegantDesign.Spacing.sm) {
                            Text(badge.emoji)
                                .font(.system(size: 30))
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(ElegantDesign.Colors.primary.opacity(0.1))
                                )
                            
                            Text(badge.name)
                                .font(ElegantDesign.Typography.caption)
                                .foregroundColor(ElegantDesign.Colors.textSecondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .elegantCard()
    }
}
