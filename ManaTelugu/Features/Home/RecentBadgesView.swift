import SwiftUI

struct RecentBadgesView: View {
    @EnvironmentObject var session: AppSession
    
    private var recentBadges: [GamificationBadge] {
        session.gamificationService.gamificationState.badges
            .filter { $0.isUnlocked }
            .sorted { $0.unlockedAt ?? Date.distantPast > $1.unlockedAt ?? Date.distantPast }
            .prefix(3)
            .map { $0 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                PulsingIcon(iconName: "rosette", color: RefinedColors.warmYellow, size: 24)
                Text("Recent Badges")
                    .font(EnhancedTypography.sectionTitle)
                    .foregroundColor(RefinedColors.charcoal)
                Spacer()
            }
            
            if recentBadges.isEmpty {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .opacity(0.6)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                RefinedColors.warmYellow.opacity(0.4),
                                                RefinedColors.warmYellow.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                        
                        Image(systemName: "rosette")
                            .font(.system(size: 36, weight: .medium))
                            .foregroundColor(RefinedColors.warmYellow)
                    }
                    
                    Text("Start learning to earn your first badge!")
                        .font(EnhancedTypography.bodyText)
                        .foregroundColor(RefinedColors.mediumGray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(32)
                .frame(maxWidth: .infinity)
            } else {
                HStack(spacing: 20) {
                    ForEach(recentBadges) { badge in
                        VStack(spacing: 16) {
                            // Enhanced liquid glass badge icon
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.8)
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color(badge.color).opacity(0.6),
                                                        Color(badge.color).opacity(0.2)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                
                                Image(systemName: badge.icon)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color(badge.color))
                                
                                // Sparkle effect for unlocked badges
                                Circle()
                                    .stroke(Color(badge.color).opacity(0.6), lineWidth: 1)
                                    .frame(width: 85, height: 85)
                                    .scaleEffect(1.1)
                                    .opacity(0.3)
                                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: true)
                            }
                            
                            Text(badge.name)
                                .font(EnhancedTypography.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(RefinedColors.charcoal)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(badge.color).opacity(0.05),
                                    Color(badge.color).opacity(0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .glassEffect(.subtle, shape: .rect(cornerRadius: 16))
                        )
                    }
                }
                .padding(24)
            }
        }
    }
}
