import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject var session: AppSession
    @State private var weeklyData: [ProgressDataPoint] = []
    
    struct ProgressDataPoint: Identifiable {
        let id = UUID()
        let day: String
        let minutes: Int
        let accuracy: Double
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ElegantGradient()
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ElegantDesign.Spacing.xl) {
                        // Header
                        headerSection
                            .padding(.top, ElegantDesign.Spacing.xl)
                        
                        // Stats Overview
                        statsOverview
                        
                        // Weekly Progress
                        weeklyProgress
                        
                        // Achievements
                        achievementsSection
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadWeeklyData()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
            Text("Track your Telugu learning journey")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .elegantCard()
    }
    
    private var statsOverview: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ElegantDesign.Spacing.md), count: 2), spacing: ElegantDesign.Spacing.md) {
            statCard("Total XP", "1,250", "star.fill", ElegantDesign.Colors.accent)
            statCard("Streak", "5 days", "flame.fill", ElegantDesign.Colors.primary)
            statCard("Lessons", "8/12", "book.fill", ElegantDesign.Colors.secondary)
            statCard("Accuracy", "85%", "target", ElegantDesign.Colors.success)
        }
    }
    
    private var weeklyProgress: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("This Week")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            HStack {
                ForEach(weeklyData) { data in
                    VStack(spacing: ElegantDesign.Spacing.xs) {
                        Text(data.day)
                            .font(ElegantDesign.Typography.caption)
                            .foregroundColor(ElegantDesign.Colors.textSecondary)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(ElegantDesign.Colors.primary)
                            .frame(width: 20, height: CGFloat(data.minutes * 2))
                        
                        Text("\(data.minutes)")
                            .font(ElegantDesign.Typography.caption)
                            .foregroundColor(ElegantDesign.Colors.textTertiary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .elegantCard()
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Recent Achievements")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            achievementRow("First Lesson", "Completed your first lesson", "checkmark.circle.fill", ElegantDesign.Colors.success)
            achievementRow("5-Day Streak", "Learned for 5 days in a row", "flame.fill", ElegantDesign.Colors.primary)
            achievementRow("Vowel Master", "Mastered all vowel letters", "star.fill", ElegantDesign.Colors.accent)
        }
        .elegantCard()
    }
    
    private func statCard(_ title: String, _ value: String, _ icon: String, _ color: Color) -> some View {
        VStack(spacing: ElegantDesign.Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(ElegantDesign.Typography.title3)
                .fontWeight(.bold)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Text(title)
                .font(ElegantDesign.Typography.caption)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .elegantCard()
    }
    
    private func achievementRow(_ title: String, _ description: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: ElegantDesign.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                Text(title)
                    .font(ElegantDesign.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                
                Text(description)
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
            }
            
            Spacer()
        }
    }
    
    private func loadWeeklyData() {
        weeklyData = [
            ProgressDataPoint(day: "Mon", minutes: 15, accuracy: 0.85),
            ProgressDataPoint(day: "Tue", minutes: 20, accuracy: 0.90),
            ProgressDataPoint(day: "Wed", minutes: 10, accuracy: 0.75),
            ProgressDataPoint(day: "Thu", minutes: 25, accuracy: 0.95),
            ProgressDataPoint(day: "Fri", minutes: 18, accuracy: 0.88),
            ProgressDataPoint(day: "Sat", minutes: 0, accuracy: 0.0),
            ProgressDataPoint(day: "Sun", minutes: 12, accuracy: 0.82)
        ]
    }
}
