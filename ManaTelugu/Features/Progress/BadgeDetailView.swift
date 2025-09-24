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
            return MTColors.funYellow
        case "badge_alphabet_hero":
            return MTColors.funBlue
        case "badge_word_wizard":
            return MTColors.funPink
        case "badge_streak_superstar":
            return MTColors.warning
        case "badge_level_champion":
            return MTColors.funGreen
        default:
            return MTColors.funYellow
        }
    }
    
    private var currentProgress: Int {
        switch badge.criteria {
        case .streak:
            return session.gamificationService.gamificationState.streakCount
        case .lettersMastered:
            // Count letters mastered from XP history
            return session.gamificationService.gamificationState.xpHistory.filter { $0.type == .wordLearned }.count
        case .lessonsCompleted:
            // Count lessons completed from XP history
            return session.gamificationService.gamificationState.xpHistory.filter { $0.type == .quizCompleted }.count
        case .wordsMastered:
            // Count words mastered from XP history
            return session.gamificationService.gamificationState.xpHistory.filter { $0.type == .wordLearned }.count
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
                                                badgeColor.opacity(0.1)
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
                                .font(MTTypography.title())
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Status Card
                        LiquidGlassCard(cornerRadius: 16, padding: 16) {
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: isUnlocked ? "checkmark.circle.fill" : "clock.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(isUnlocked ? MTColors.funGreen : MTColors.funBlue)
                                    
                                    Text(isUnlocked ? "Achievement Unlocked!" : "Keep Going!")
                                        .font(MTTypography.heading())
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                
                                Text(badge.criteria.description())
                                    .font(MTTypography.body())
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        // Progress Card
                        LiquidGlassCard(cornerRadius: 16, padding: 16) {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Progress")
                                        .font(MTTypography.heading())
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text("\(currentProgress)/\(badge.criteria.targetValue())")
                                        .font(MTTypography.body())
                                        .foregroundColor(.secondary)
                                }
                                
                                // Progress Bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.secondary.opacity(0.2))
                                            .frame(height: 16)
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [MTColors.funBlue, MTColors.funGreen]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ))
                                            .frame(width: geometry.size.width * progressPercentage, height: 16)
                                    }
                                }
                                .frame(height: 16)
                                
                                // Progress Percentage
                                HStack {
                                    Spacer()
                                    Text("\(Int(progressPercentage * 100))% Complete")
                                        .font(MTTypography.caption())
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
                                        .foregroundColor(MTColors.funYellow)
                                    
                                    Text("Tips to Earn This Badge")
                                        .font(MTTypography.heading())
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(tipsForBadge(), id: \.self) { tip in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .font(MTTypography.body())
                                                .foregroundColor(.accentColor)
                                            Text(tip)
                                                .font(MTTypography.body())
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
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
                "Complete at least one lesson or game each day"
            ]
        case .lettersMastered:
            return [
                "Focus on one letter at a time",
                "Practice writing the letter multiple times",
                "Use the alphabet games to reinforce learning"
            ]
        case .lessonsCompleted:
            return [
                "Start with beginner lessons and work your way up",
                "Review completed lessons to reinforce learning",
                "Take your time to understand each concept"
            ]
        case .wordsMastered:
            return [
                "Learn new words daily through vocabulary lessons",
                "Practice using words in sentences",
                "Use flashcards to memorize word meanings"
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
            imageName: "star_badge.png"
        ),
        isUnlocked: false
    )
    .environmentObject(AppSession())
}
