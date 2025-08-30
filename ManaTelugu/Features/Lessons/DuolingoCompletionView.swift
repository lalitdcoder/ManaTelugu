import SwiftUI

struct DuolingoCompletionView: View {
    let lesson: Lesson
    let responses: [ActivityResponse]
    let totalXP: Int
    let timeSpent: TimeInterval
    let onDismiss: () -> Void
    
    @EnvironmentObject var session: AppSession
    @State private var showingXPAnimation = false
    @State private var showingStreakAnimation = false
    @State private var animatedXP = 0
    @State private var showingStars = false
    
    private var correctAnswers: Int {
        responses.filter { $0.isCorrect }.count
    }
    
    private var accuracy: Double {
        guard !responses.isEmpty else { return 0 }
        return Double(correctAnswers) / Double(responses.count)
    }
    
    private var starRating: Int {
        switch accuracy {
        case 0.9...1.0: return 3
        case 0.7..<0.9: return 2
        case 0.5..<0.7: return 1
        default: return 0
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: MTSpacing.large) {
                Spacer()
                
                // Success Animation
                VStack(spacing: MTSpacing.medium) {
                    // Stars
                    HStack(spacing: MTSpacing.small) {
                        ForEach(0..<3, id: \.self) { index in
                            Image(systemName: index < starRating ? "star.fill" : "star")
                                .font(.system(size: 30))
                                .foregroundColor(index < starRating ? .yellow : MTColors.text.opacity(0.3))
                                .scaleEffect(showingStars && index < starRating ? 1.3 : 1.0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: showingStars)
                        }
                    }
                    
                    Text("Lesson Complete!")
                        .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                        .opacity(showingXPAnimation ? 1 : 0)
                        .animation(.easeIn(duration: 0.5), value: showingXPAnimation)
                }
                
                // Stats Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: MTSpacing.medium) {
                    DuolingoStatCard(
                        title: "XP Earned",
                        value: "\(animatedXP)",
                        icon: "star.fill",
                        color: .yellow
                    )
                    
                    DuolingoStatCard(
                        title: "Accuracy",
                        value: "\(Int(accuracy * 100))%",
                        icon: "target",
                        color: .green
                    )
                    
                    DuolingoStatCard(
                        title: "Time",
                        value: formatTime(timeSpent),
                        icon: "clock.fill",
                        color: .blue
                    )
                    
                    DuolingoStatCard(
                        title: "Streak",
                        value: "\(session.userProfile.streakDays + 1)",
                        icon: "flame.fill",
                        color: .orange
                    )
                }
                
                // Performance Message
                VStack(spacing: MTSpacing.small) {
                    Text(performanceMessage)
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                        .multilineTextAlignment(.center)
                    
                    Text(encouragementMessage)
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(MTColors.surfaceAlt)
                .cornerRadius(12)
                
                Spacer()
                
                // Continue Button
                Button(action: onDismiss) {
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
            .navigationBarHidden(true)
            .onAppear {
                startAnimations()
            }
        }
    }
    
    private var performanceMessage: String {
        switch starRating {
        case 3: return "Perfect! 🎉"
        case 2: return "Great job! 👏"
        case 1: return "Good effort! 👍"
        default: return "Keep practicing! 💪"
        }
    }
    
    private var encouragementMessage: String {
        switch starRating {
        case 3: return "You mastered this lesson! Ready for the next challenge?"
        case 2: return "You're making excellent progress! Keep it up!"
        case 1: return "You're learning! Try reviewing this lesson again."
        default: return "Practice makes perfect. Don't give up!"
        }
    }
    
    private func startAnimations() {
        // XP Animation
        withAnimation(.easeOut(duration: 1.0)) {
            showingXPAnimation = true
        }
        
        // Animate XP counter
        let _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if animatedXP < totalXP {
                animatedXP += max(1, totalXP / 20)
                if animatedXP >= totalXP {
                    animatedXP = totalXP
                    timer.invalidate()
                }
            }
        }
        
        // Stars Animation (delayed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                showingStars = true
            }
        }
        
        // Streak Animation (delayed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showingStreakAnimation = true
            }
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return minutes > 0 ? "\(minutes)m \(seconds)s" : "\(seconds)s"
    }
}

struct DuolingoStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        VStack(spacing: MTSpacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            Text(title)
                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(MTColors.surfaceAlt)
        .cornerRadius(12)
    }
}
