import SwiftUI

struct ImprovedHomeView: View {
    @EnvironmentObject var session: AppSession
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Clean background
                LinearGradient(
                    colors: [ModernDesignSystem.Colors.teluguBlue.opacity(0.1), ModernDesignSystem.Colors.teluguSaffron.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                BreathingRoomLayout {
                    // Hero Section - Primary Focus
                    VisualHierarchy.primaryContent {
                        welcomeHeroSection
                    }
                    
                    // Quick Stats - Secondary Focus
                    VisualHierarchy.secondaryContent {
                        quickStatsSection
                    }
                    
                    // Learning Modes - Secondary Actions
                    learningModesSection
                }
            }
            .navigationTitle("మనతెలుగు")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var welcomeHeroSection: some View {
        CleanCardLayout(
            title: "Welcome back!",
            subtitle: "Ready to continue your Telugu journey?"
        ) {
            HStack {
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.sm) {
                    Text("Current Streak")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                    
                    Text("\(session.userProfile.currentStreak) days")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(ModernDesignSystem.Colors.teluguSaffron)
                }
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 32))
                    .foregroundColor(ModernDesignSystem.Colors.teluguSaffron)
            }
        }
    }
    
    private var quickStatsSection: some View {
        ImprovedGrid(columns: 3, spacing: ModernDesignSystem.Spacing.sm) {
            statCard("XP", "\(session.userProfile.totalXP)", ModernDesignSystem.Colors.teluguBlue)
            statCard("Level", "\(session.userProfile.level)", ModernDesignSystem.Colors.teluguGreen)
            statCard("Badges", "\(session.gamificationService.gamificationState.badges.filter { $0.isUnlocked }.count)", ModernDesignSystem.Colors.teluguSaffron)
        }
    }
    
    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.tiny) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(12)
    }
    
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Learning Modes")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)
            
            ImprovedGrid(columns: 2) {
                learningModeCard("Alphabet", "textformat.abc", ModernDesignSystem.Colors.teluguBlue, 0.75)
                learningModeCard("Vocabulary", "book.fill", ModernDesignSystem.Colors.teluguGreen, 0.45)
                learningModeCard("Stories", "books.vertical.fill", ModernDesignSystem.Colors.teluguSaffron, 0.30)
                learningModeCard("Games", "gamecontroller.fill", ModernDesignSystem.Colors.culturalRed, 0.60)
            }
        }
    }
    
    private func learningModeCard(_ title: String, _ icon: String, _ color: Color, _ progress: Double) -> some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(ModernDesignSystem.Colors.secondaryText)
            }
            
            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)
            
            ProgressView(value: progress)
                .tint(color)
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(12)
    }
}
