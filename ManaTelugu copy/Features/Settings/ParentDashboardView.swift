import SwiftUI

struct ParentDashboardView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            EnhancedScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text("Parent Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Child's Progress Summary
                VStack(alignment: .leading, spacing: 15) {
                    Text("Progress Summary for \(session.userProfile.name)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack {
                        ProfessionalStatCard(icon: "star.fill", value: "\(session.gamificationService.gamificationState.totalXP)", label: "Total XP", color: .professionalOrange)
                        ProfessionalStatCard(icon: "flame.fill", value: "\(session.gamificationService.gamificationState.streakCount)", label: "Streak Days", color: .professionalOrange)
                    }
                }
                
                // This Week's Progress
                VStack(alignment: .leading, spacing: 15) {
                    let weeklyStats = session.gamificationService.getWeeklyStats()
                    
                    Text("This Week's Progress")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack {
                        ProfessionalStatCard(icon: "text.book.closed.fill", value: "\(weeklyStats.wordsLearned)", label: "Words Learned", color: .professionalBlue)
                        ProfessionalStatCard(icon: "sparkles", value: "\(weeklyStats.xpGained)", label: "XP Gained", color: .professionalPurple)
                        ProfessionalStatCard(icon: "rosette", value: "\(weeklyStats.badgesEarned)", label: "Badges Earned", color: .professionalGreen)
                    }
                }
                
                // Learning Insights
                LearningInsightsView()

                // Help & Support Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Help & Support")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 16))
                            Text("Email Support")
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        
                        Link(destination: URL(string: "mailto:manateluguhelp@gmail.com")!) {
                            HStack(spacing: 6) {
                                Text("manateluguhelp@gmail.com")
                                    .font(.body)
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.leading, 24)
                        
                        Text("Get help with the app, report issues, or share feedback. We typically respond within 24 hours.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 24)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }

                // Coming Soon Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("More Features Coming Soon!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("We're working on detailed weekly reports, learning insights, and more tools to help you guide your child's learning journey.")
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
            }
        }
        .navigationTitle("Dashboard")
    }
}

