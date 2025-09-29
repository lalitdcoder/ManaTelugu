import SwiftUI

struct ImprovedHomeView: View {
    @EnvironmentObject var session: AppSession
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Clean background
                LinearGradient(
                    colors: [MTColors.teluguBlue.opacity(0.1), MTColors.teluguSaffron.opacity(0.05)],
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
                    
                    // Continue Learning - Primary Action
                    continueLearningSection
                    
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
                VStack(alignment: .leading, spacing: MTSpacing.small) {
                    Text("Current Streak")
                        .font(.caption)
                        .foregroundColor(MTColors.secondaryText)
                    
                    Text("\(session.userProfile.currentStreak) days")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(MTColors.teluguSaffron)
                }
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 32))
                    .foregroundColor(MTColors.teluguSaffron)
            }
        }
    }
    
    private var quickStatsSection: some View {
        ImprovedGrid(columns: 3, spacing: MTSpacing.small) {
            statCard("XP", "\(session.userProfile.totalXP)", MTColors.teluguBlue)
            statCard("Level", "\(session.userProfile.level)", MTColors.teluguGreen)
            statCard("Badges", "\(session.gamificationService.gamificationState.badges.filter { $0.isUnlocked }.count)", MTColors.teluguSaffron)
        }
    }
    
    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: MTSpacing.tiny) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(MTColors.secondaryText)
        }
        .padding(MTSpacing.medium)
        .background(MTColors.cardBackground)
        .cornerRadius(12)
    }
    
    private var continueLearningSection: some View {
        ImprovedCard(priority: .primary) {
            VStack(alignment: .leading, spacing: MTSpacing.medium) {
                HStack {
                    Text("Continue Learning")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(MTColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(MTColors.teluguBlue)
                }
                
                Text("Pick up where you left off")
                    .font(.body)
                    .foregroundColor(MTColors.secondaryText)
                
                HIGPrimaryButton(
                    "Start Learning",
                    icon: "play.fill"
                ) {
                    // Navigate to last activity
                }
            }
        }
    }
    
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: MTSpacing.medium) {
            Text("Learning Modes")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(MTColors.primaryText)
            
            ImprovedGrid(columns: 2) {
                learningModeCard("Alphabet", "textformat.abc", MTColors.teluguBlue, 0.75)
                learningModeCard("Vocabulary", "book.fill", MTColors.teluguGreen, 0.45)
                learningModeCard("Stories", "books.vertical.fill", MTColors.teluguSaffron, 0.30)
                learningModeCard("Games", "gamecontroller.fill", MTColors.culturalRed, 0.60)
            }
        }
    }
    
    private func learningModeCard(_ title: String, _ icon: String, _ color: Color, _ progress: Double) -> some View {
        VStack(alignment: .leading, spacing: MTSpacing.small) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(MTColors.secondaryText)
            }
            
            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(MTColors.primaryText)
            
            ProgressView(value: progress)
                .tint(color)
        }
        .padding(MTSpacing.medium)
        .background(MTColors.cardBackground)
        .cornerRadius(12)
    }
}
