import SwiftUI

struct ImprovedRootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Learn Tab (combines Alphabet + Lessons)
            ImprovedLearnView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "book.fill" : "book")
                    Text("Learn")
                }
                .tag(0)
            
            // Practice Tab (combines Games + Stories)
            ImprovedPracticeView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "gamecontroller.fill" : "gamecontroller")
                    Text("Practice")
                }
                .tag(1)
            
            // Progress Tab (Stats + Achievements)
            ImprovedProgressView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                    Text("Progress")
                }
                .tag(2)
            
            // More Tab (Settings + Help)
            ImprovedMoreView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "ellipsis.circle.fill" : "ellipsis.circle")
                    Text("More")
                }
                .tag(3)
        }
        .accentColor(MTColors.teluguBlue)
        .onChange(of: selectedTab) { _ in
            session.hapticsService.lightImpact()
        }
    }
}

// MARK: - Consolidated Learn View
struct ImprovedLearnView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationView {
            ZStack {
                MTColors.background.ignoresSafeArea()
                
                BreathingRoomLayout {
                    // Quick Access Section
                    VisualHierarchy.primaryContent {
                        quickAccessSection
                    }
                    
                    // Learning Paths
                    learningPathsSection
                    
                    // Recent Activity
                    VisualHierarchy.secondaryContent {
                        recentActivitySection
                    }
                }
            }
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var quickAccessSection: some View {
        CleanCardLayout(title: "Continue Learning") {
            VStack(spacing: MTSpacing.medium) {
                HStack {
                    VStack(alignment: .leading, spacing: MTSpacing.tiny) {
                        Text("Next Up")
                            .font(.caption)
                            .foregroundColor(MTColors.secondaryText)
                        
                        Text("Letter ఆ")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(MTColors.teluguBlue)
                    }
                    
                    Spacer()
                    
                    HIGPrimaryButton("Continue") {
                        // Continue learning
                    }
                }
            }
        }
    }
    
    private var learningPathsSection: some View {
        VStack(alignment: .leading, spacing: MTSpacing.medium) {
            Text("Learning Paths")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(MTColors.primaryText)
            
            VStack(spacing: MTSpacing.medium) {
                learningPathCard("Alphabet", "Master Telugu letters", "textformat.abc", MTColors.teluguBlue, 0.75)
                learningPathCard("Vocabulary", "Build your word bank", "book.fill", MTColors.teluguGreen, 0.45)
                learningPathCard("Lessons", "Structured learning", "graduationcap.fill", MTColors.teluguSaffron, 0.30)
            }
        }
    }
    
    private func learningPathCard(_ title: String, _ subtitle: String, _ icon: String, _ color: Color, _ progress: Double) -> some View {
        HIGAccessibleCard(
            label: title,
            hint: "Start \(title.lowercased()) learning",
            action: { /* Navigate */ }
        ) {
            HStack(spacing: MTSpacing.medium) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: MTSpacing.tiny) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(MTColors.primaryText)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(MTColors.secondaryText)
                    
                    ProgressView(value: progress)
                        .tint(color)
                }
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)
            }
            .padding(MTSpacing.medium)
            .background(MTColors.cardBackground)
            .cornerRadius(12)
        }
    }
    
    private var recentActivitySection: some View {
        CleanCardLayout(title: "Recent Activity") {
            VStack(spacing: MTSpacing.small) {
                activityRow("Completed Letter అ", "2 hours ago", MTColors.teluguGreen)
                activityRow("Vocabulary Quiz", "Yesterday", MTColors.teluguBlue)
                activityRow("Story: The Clever Fox", "2 days ago", MTColors.teluguSaffron)
            }
        }
    }
    
    private func activityRow(_ title: String, _ time: String, _ color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(title)
                .font(.body)
                .foregroundColor(MTColors.primaryText)
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(MTColors.secondaryText)
        }
    }
}

// MARK: - Consolidated Practice View
struct ImprovedPracticeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                MTColors.background.ignoresSafeArea()
                
                BreathingRoomLayout {
                    // Daily Challenge
                    VisualHierarchy.primaryContent {
                        dailyChallengeSection
                    }
                    
                    // Practice Options
                    practiceOptionsSection
                }
            }
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var dailyChallengeSection: some View {
        CleanCardLayout(
            title: "Daily Challenge",
            subtitle: "Complete today's challenge to earn bonus XP"
        ) {
            HStack {
                VStack(alignment: .leading, spacing: MTSpacing.tiny) {
                    Text("Word Match")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(MTColors.primaryText)
                    
                    Text("50 XP Bonus")
                        .font(.caption)
                        .foregroundColor(MTColors.teluguSaffron)
                }
                
                Spacer()
                
                HIGPrimaryButton("Start") {
                    // Start challenge
                }
            }
        }
    }
    
    private var practiceOptionsSection: some View {
        ImprovedGrid(columns: 2) {
            practiceCard("Games", "gamecontroller.fill", MTColors.teluguBlue)
            practiceCard("Stories", "books.vertical.fill", MTColors.teluguGreen)
            practiceCard("Quiz", "questionmark.circle.fill", MTColors.teluguSaffron)
            practiceCard("Review", "arrow.clockwise", MTColors.culturalRed)
        }
    }
    
    private func practiceCard(_ title: String, _ icon: String, _ color: Color) -> some View {
        HIGAccessibleCard(
            label: title,
            hint: "Start \(title.lowercased()) practice",
            action: { /* Navigate */ }
        ) {
            VStack(spacing: MTSpacing.medium) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(MTColors.primaryText)
            }
            .padding(MTSpacing.large)
            .background(MTColors.cardBackground)
            .cornerRadius(16)
            .frame(minHeight: 120)
        }
    }
}

// MARK: - Progress View
struct ImprovedProgressView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationView {
            ZStack {
                MTColors.background.ignoresSafeArea()
                
                BreathingRoomLayout {
                    // Stats Overview
                    VisualHierarchy.primaryContent {
                        statsOverviewSection
                    }
                    
                    // Achievements
                    achievementsSection
                    
                    // Learning Streak
                    VisualHierarchy.secondaryContent {
                        streakSection
                    }
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var statsOverviewSection: some View {
        ImprovedGrid(columns: 2) {
            statCard("Total XP", "\(session.userProfile.totalXP)", MTColors.teluguBlue)
            statCard("Level", "\(session.userProfile.level)", MTColors.teluguGreen)
            statCard("Streak", "\(session.userProfile.currentStreak) days", MTColors.teluguSaffron)
            statCard("Badges", "\(session.gamificationService.gamificationState.badges.filter { $0.isUnlocked }.count)", MTColors.culturalRed)
        }
    }
    
    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: MTSpacing.small) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(MTColors.secondaryText)
        }
        .padding(MTSpacing.large)
        .background(MTColors.cardBackground)
        .cornerRadius(16)
        .frame(minHeight: 100)
    }
    
    private var achievementsSection: some View {
        CleanCardLayout(title: "Recent Achievements") {
            VStack(spacing: MTSpacing.small) {
                achievementRow("First Letter", "Learned your first Telugu letter", MTColors.teluguGreen)
                achievementRow("Word Master", "Learned 50 vocabulary words", MTColors.teluguBlue)
                achievementRow("Streak Keeper", "Maintained 7-day streak", MTColors.teluguSaffron)
            }
        }
    }
    
    private func achievementRow(_ title: String, _ description: String, _ color: Color) -> some View {
        HStack(spacing: MTSpacing.medium) {
            Image(systemName: "star.fill")
                .font(.title3)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: MTSpacing.tiny) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(MTColors.primaryText)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(MTColors.secondaryText)
            }
            
            Spacer()
        }
    }
    
    private var streakSection: some View {
        CleanCardLayout(title: "Learning Streak") {
            HStack {
                VStack(alignment: .leading, spacing: MTSpacing.tiny) {
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
}

// MARK: - More View
struct ImprovedMoreView: View {
    var body: some View {
        NavigationView {
            ZStack {
                MTColors.background.ignoresSafeArea()
                
                BreathingRoomLayout {
                    VStack(spacing: MTSpacing.large) {
                        settingsSection
                        helpSection
                        aboutSection
                    }
                }
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var settingsSection: some View {
        CleanCardLayout(title: "Settings") {
            VStack(spacing: MTSpacing.medium) {
                settingRow("Kid Mode", "toggle.left.and.right")
                settingRow("Notifications", "bell.fill")
                settingRow("Audio Settings", "speaker.wave.2.fill")
            }
        }
    }
    
    private var helpSection: some View {
        CleanCardLayout(title: "Help & Support") {
            VStack(spacing: MTSpacing.medium) {
                settingRow("How to Use", "questionmark.circle.fill")
                settingRow("Contact Us", "envelope.fill")
                settingRow("FAQ", "doc.text.fill")
            }
        }
    }
    
    private var aboutSection: some View {
        CleanCardLayout(title: "About") {
            VStack(spacing: MTSpacing.medium) {
                settingRow("Privacy Policy", "hand.raised.fill")
                settingRow("Terms of Service", "doc.fill")
                settingRow("Version 1.0", "info.circle.fill")
            }
        }
    }
    
    private func settingRow(_ title: String, _ icon: String) -> some View {
        HStack(spacing: MTSpacing.medium) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(MTColors.teluguBlue)
                .frame(width: 24)
            
            Text(title)
                .font(.body)
                .foregroundColor(MTColors.primaryText)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(MTColors.secondaryText)
        }
    }
}
