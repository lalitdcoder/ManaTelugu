import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var weeklyData: [ProgressDataPoint] = []
    
    struct ProgressDataPoint: Identifiable {
        let id = UUID()
        let day: String
        let minutes: Int
        let accuracy: Double
    }
    
    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: ModernDesignSystem.Spacing.xl) {
                    // Header
                    headerSection
                        .padding(.top, ModernDesignSystem.Spacing.xl)
                    
                    // Stats Overview
                    statsOverview
                    
                    // Weekly Progress
                    weeklyProgress
                    
                    // Achievements
                    achievementsSection
                }
                .padding(.horizontal, ModernDesignSystem.Spacing.md)
                .padding(.bottom, ModernDesignSystem.Spacing.xl)
            }
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
        .onAppear {
            loadWeeklyData()
        }
    }

    // Placeholder for loading weekly data
    private func loadWeeklyData() {
        // Implement data loading for weekly progress chart here
        // For now, it's an empty function to resolve the build error.
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
            Text("Track your Telugu learning journey")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .modernCard()
    }
    
    private var statsOverview: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.md), count: 2), spacing: ModernDesignSystem.Spacing.md) {
            statCard("Total XP", "\(session.gamificationService.gamificationState.totalXP)", "star.fill", ModernDesignSystem.Colors.accent)
            statCard("Streak", "\(session.gamificationService.gamificationState.streakCount) days", "flame.fill", ModernDesignSystem.Colors.primary)
            statCard("Lessons", "\(session.progressTrackingService.completedLessonsCount)/\(session.progressTrackingService.totalLessonsCount)", "book.fill", ModernDesignSystem.Colors.secondary)
            statCard("Accuracy", "\(Int(session.progressTrackingService.overallAccuracy * 100))%", "target", ModernDesignSystem.Colors.success)
        }
    }
    
    private var weeklyProgress: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("This Week")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            // Placeholder for dynamic weekly data
            Text("Weekly progress data will be displayed here.")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                .padding()
        }
        .modernCard()
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Recent Achievements")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            // Removed badge achievements section
        }
        .modernCard()
    }
    
    private func statCard(_ title: String, _ value: String, _ icon: String, _ color: Color) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(ModernDesignSystem.Typography.title3)
                .fontWeight(.bold)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            Text(title)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .modernCard()
    }
    
    private func achievementRow(_ title: String, _ description: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                Text(title)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                
                Text(description)
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
        }
    }
    

}
