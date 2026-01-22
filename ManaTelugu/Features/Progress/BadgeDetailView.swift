import SwiftUI

struct BadgeDetailView: View {
    let badge: Badge
    let isUnlocked: Bool
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss

    private var badgeIcon: String {
        if !isUnlocked {
            return "lock.fill"
        }

        switch badge.id {
        case "badge_first_star":
            return "star.fill"
        case "badge_alphabet_hero":
            return "textformat.abc"
        case "badge_word_wizard":
            return "wand.and.stars"
        case "badge_streak_superstar":
            return "flame.fill"
        case "badge_level_champion":
            return "crown.fill"
        default:
            return "star.fill"
        }
    }

    private var badgeColor: Color {
        if !isUnlocked {
            return Color.gray
        }

        switch badge.id {
        case "badge_first_star":
            return ModernDesignSystem.Colors.funYellow
        case "badge_alphabet_hero":
            return ModernDesignSystem.Colors.funBlue
        case "badge_word_wizard":
            return ModernDesignSystem.Colors.funPink
        case "badge_streak_superstar":
            return ModernDesignSystem.Colors.warning
        case "badge_level_champion":
            return ModernDesignSystem.Colors.funGreen
        default:
            return ModernDesignSystem.Colors.funYellow
        }
    }

    private var currentProgress: Int {
        switch badge.criteria {
        case .streak:
            return session.gamificationService.gamificationState.streakCount
        case .lettersMastered:
            // Count letters mastered from XP history
            return session.gamificationService.gamificationState.xpHistory.filter {
                $0.type == .wordLearned
            }.count
        case .lessonsCompleted:
            // Count lessons completed from XP history
            return session.gamificationService.gamificationState.xpHistory.filter {
                $0.type == .quizCompleted
            }.count
        case .wordsMastered:
            // Count words mastered from XP history
            return session.gamificationService.gamificationState.xpHistory.filter {
                $0.type == .wordLearned
            }.count
        case .storiesCompleted:
            // Count stories completed from XP history
            return session.gamificationService.gamificationState.xpHistory.filter {
                $0.type == .storyCompleted
            }.count
        }
    }

    private var progressPercentage: Double {
        let target = badge.criteria.targetValue()
        return min(1.0, Double(currentProgress) / Double(target))
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced background gradient for Liquid Glass effect
                Color.clear
                    .liquidGlassBackground()
                    .ignoresSafeArea()

                EnhancedScrollView {
                    VStack(spacing: 32) {
                        // Badge Icon
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                badgeColor.opacity(0.3),
                                                badgeColor.opacity(0.1),
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Circle()
                                            .stroke(badgeColor.opacity(0.3), lineWidth: 3)
                                    )

                                Image(systemName: badgeIcon)
                                    .font(.system(size: 56, weight: .bold))
                                    .foregroundColor(badgeColor)
                                    .shadow(color: badgeColor.opacity(0.3), radius: 4, x: 0, y: 2)
                            }

                            Text(badge.name)
                                .font(ModernDesignSystem.Typography.title1)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                        }

                        // Status Card
                        LiquidGlassCard(cornerRadius: 16, padding: 16) {
                            VStack(spacing: 16) {
                                HStack {
                                    Image(
                                        systemName: isUnlocked
                                            ? "checkmark.circle.fill" : "clock.fill"
                                    )
                                    .font(.system(size: 24))
                                    .foregroundColor(
                                        isUnlocked
                                            ? ModernDesignSystem.Colors.funGreen
                                            : ModernDesignSystem.Colors.funBlue)

                                    Text(isUnlocked ? "Achievement Unlocked!" : "Keep Going!")
                                        .font(ModernDesignSystem.Typography.headline)
                                        .foregroundColor(.primary)

                                    Spacer()
                                }

                                Text(badge.criteria.description())
                                    .font(ModernDesignSystem.Typography.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                        }

                        // Progress Card
                        LiquidGlassCard(cornerRadius: 16, padding: 16) {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Progress")
                                        .font(ModernDesignSystem.Typography.headline)
                                        .foregroundColor(.primary)

                                    Spacer()

                                    Text("\(currentProgress)/\(badge.criteria.targetValue())")
                                        .font(ModernDesignSystem.Typography.body)
                                        .foregroundColor(.secondary)
                                }

                                // Progress Bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.secondary.opacity(0.2))
                                            .frame(height: 16)

                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        ModernDesignSystem.Colors.funBlue,
                                                        ModernDesignSystem.Colors.funGreen,
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(
                                                width: geometry.size.width * progressPercentage,
                                                height: 16)
                                    }
                                }
                                .frame(height: 16)

                                // Progress Percentage
                                HStack {
                                    Spacer()
                                    Text("\(Int(progressPercentage * 100))% Complete")
                                        .font(ModernDesignSystem.Typography.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }

                        // Tips Card
                        LiquidGlassCard(cornerRadius: 16, padding: 16) {
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(ModernDesignSystem.Colors.funYellow)

                                    Text("Tips to Earn This Badge")
                                        .font(ModernDesignSystem.Typography.headline)
                                        .foregroundColor(.primary)

                                    Spacer()
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(tipsForBadge(), id: \.self) { tip in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .font(ModernDesignSystem.Typography.body)
                                                .foregroundColor(.accentColor)
                                            Text(tip)
                                                .font(ModernDesignSystem.Typography.body)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }

                        Spacer(minLength: 20)
                    }
                    .padding()
                }
            }
            .navigationTitle("Badge Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        HapticsService.shared.navigationTap()
                        dismiss()
                    }
                    .foregroundColor(.accentColor)
                }
            }
        }
    }

    private func tipsForBadge() -> [String] {
        switch badge.criteria {
        case .streak:
            return [
                "Practice Telugu every day, even for just 5 minutes",
                "Set a daily reminder to study",
                "Complete at least one lesson or game each day",
            ]
        case .lettersMastered:
            return [
                "Focus on one letter at a time",
                "Practice writing the letter multiple times",
                "Use the alphabet games to reinforce learning",
            ]
        case .lessonsCompleted:
            return [
                "Start with beginner lessons and work your way up",
                "Review completed lessons to reinforce learning",
                "Take your time to understand each concept",
            ]
        case .wordsMastered:
            return [
                "Learn new words daily through vocabulary lessons",
                "Practice using words in sentences",
                "Use flashcards to memorize word meanings",
            ]
        case .storiesCompleted:
            return [
                "Read stories regularly to improve comprehension",
                "Try to understand the moral of each story",
                "Re-read stories to practice fluency",
            ]
        }
    }
}

#Preview {
    BadgeDetailView(
        badge: Badge(
            id: "test",
            name: "First Star!",
            criteria: .lessonsCompleted(1),
            emoji: "⭐"
        ),
        isUnlocked: false
    )
    .environmentObject(AppSession())
}
