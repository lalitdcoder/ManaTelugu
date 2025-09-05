import SwiftUI

struct LessonCompletionView: View {
    let lesson: Lesson
    let xpEarned: Int
    let timeSpent: TimeInterval
    let scores: (reading: Double, writing: Double, speaking: Double)
    let onDismiss: () -> Void
    
    @EnvironmentObject var session: AppSession
    @State private var showingXPAnimation = false
    @State private var showingStreakAnimation = false
    @State private var animatedXP = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: MTSpacing.large) {
                Spacer()
                
                // Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .scaleEffect(showingXPAnimation ? 1.2 : 1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingXPAnimation)
                
                // Completion Message
                VStack(spacing: MTSpacing.small) {
                    Text("Lesson Complete!")
                        .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    
                    Text(lesson.title)
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                // Stats Cards
                VStack(spacing: MTSpacing.medium) {
                    // XP Earned
                    LessonStatCard(
                        title: "XP Earned",
                        value: "\(animatedXP)",
                        icon: "star.fill",
                        color: Color.yellow,
                        animated: showingXPAnimation
                    )
                    
                    // Time Spent
                    LessonStatCard(
                        title: "Time Spent",
                        value: formatTime(timeSpent),
                        icon: "clock.fill",
                        color: Color.blue,
                        animated: false
                    )
                    
                    // Streak
                    LessonStatCard(
                        title: "Streak",
                        value: "\(session.userProfile.streakDays + 1) days",
                        icon: "flame.fill",
                        color: Color.orange,
                        animated: showingStreakAnimation
                    )
                    .onAppear {
                        if showingStreakAnimation {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                // Add celebratory animation for streak milestone
                                if (session.userProfile.streakDays + 1) % 5 == 0 {
                                    // Trigger milestone animation
                                    showMilestoneCelebration()
                                }
                            }
                        }
                    }
                
                    // Performance Scores
                    VStack(alignment: .leading, spacing: MTSpacing.small) {
                        Text("Performance")
                            .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        
                        ScoreRow(title: "Reading", score: scores.reading)
                        ScoreRow(title: "Writing", score: scores.writing)
                        ScoreRow(title: "Speaking", score: scores.speaking)
                    }
                    .padding()
                    .background(MTColors.surfaceAlt)
                    .cornerRadius(12)
                    .onAppear {
                        // Add badge unlock logic
                        Task {
                            if scores.reading > 90 {
                                await unlockBadge("Reading Master")
                            }
                            if scores.writing > 90 {
                                await unlockBadge("Writing Prodigy")
                            }
                            if scores.speaking > 90 {
                                await unlockBadge("Speaking Star")
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    onDismiss()
                }) {
                    Text("Continue Learning")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(MTColors.primary)
                        .cornerRadius(12)
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                print("LessonCompletionView appeared with lesson: \(lesson.title), xpEarned: \(xpEarned), timeSpent: \(timeSpent)")
                startAnimations()
            }
        }
    }
    
    private func startAnimations() {
        // XP Animation
        withAnimation(.easeOut(duration: 1.0)) {
            showingXPAnimation = true
        }
        
        // Animate XP counter
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if animatedXP < xpEarned {
                animatedXP += max(1, xpEarned / 20)
                if animatedXP >= xpEarned {
                    animatedXP = xpEarned
                    timer.invalidate()
                }
            }
        }
        
        // Streak Animation (delayed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showingStreakAnimation = true
            }
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
    
    private func showMilestoneCelebration() {
        // Trigger haptic feedback for milestone
        session.hapticsService.success()
        
        // Add visual celebration animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            // Could add more celebration effects here
        }
    }
    
    private func unlockBadge(_ badgeName: String) async {
        // Use the async version from DataRepository
        await DataRepository.shared.unlockBadge(badgeName, session: session)
        
        // Award XP for badge unlock
        session.awardXP(50)
    }
}

struct LessonStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let animated: Bool
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        HStack(spacing: MTSpacing.medium) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .scaleEffect(animated ? 1.3 : 1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animated)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.7))
                
                Text(value)
                    .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
            }
            
            Spacer()
        }
        .padding()
        .background(MTColors.surfaceAlt)
        .cornerRadius(12)
    }
}

struct ScoreRow: View {
    let title: String
    let score: Double
    @EnvironmentObject var session: AppSession
    
    private var scoreColor: Color {
        switch score {
        case 0.8...1.0: return .green
        case 0.6..<0.8: return .orange
        default: return .red
        }
    }
    
    private var scoreText: String {
        switch score {
        case 0.8...1.0: return "Excellent"
        case 0.6..<0.8: return "Good"
        case 0.4..<0.6: return "Fair"
        default: return "Needs Practice"
        }
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            Spacer()
            
            HStack(spacing: MTSpacing.tiny) {
                Text(scoreText)
                    .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                    .foregroundColor(scoreColor)
                
                // Star rating
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: Double(star) <= score * 5 ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundColor(scoreColor)
                    }
                }
            }
        }
    }
}

// Investigating potential issues in LessonCompletionView.swift
// Adding debug logs or comments to identify problematic areas
