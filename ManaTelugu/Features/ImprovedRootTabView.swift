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
        .accentColor(ModernDesignSystem.Colors.teluguBlue)
.onChange(of: selectedTab) { _, _ in
            HapticsManager.shared.impact(.light)
        }
    }
}

// MARK: - Consolidated Learn View
struct ImprovedLearnView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.background.ignoresSafeArea()
                
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
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
                        Text("Next Up")
                            .font(.caption)
                            .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                        
                        Text("Letter ఆ")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(ModernDesignSystem.Colors.teluguBlue)
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
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Learning Paths")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)
            
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                learningPathCard("Alphabet", "Master Telugu letters", "textformat.abc", ModernDesignSystem.Colors.teluguBlue, 0.75)
                learningPathCard("Vocabulary", "Build your word bank", "book.fill", ModernDesignSystem.Colors.teluguGreen, 0.45)
                learningPathCard("Lessons", "Structured learning", "graduationcap.fill", ModernDesignSystem.Colors.teluguSaffron, 0.30)
            }
        }
    }
    
    private func learningPathCard(_ title: String, _ subtitle: String, _ icon: String, _ color: Color, _ progress: Double) -> some View {
        HIGAccessibleCard(
            label: title,
            hint: "Start \(title.lowercased()) learning",
            action: { /* Navigate */ }
        ) {
            HStack(spacing: ModernDesignSystem.Spacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                    
                    ProgressView(value: progress)
                        .tint(color)
                }
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)
            }
            .padding(ModernDesignSystem.Spacing.md)
            .background(ModernDesignSystem.Colors.cardBackground)
            .cornerRadius(12)
        }
    }
    
    private var recentActivitySection: some View {
        CleanCardLayout(title: "Recent Activity") {
            VStack(spacing: ModernDesignSystem.Spacing.sm) {
                activityRow("Completed Letter అ", "2 hours ago", ModernDesignSystem.Colors.teluguGreen)
                activityRow("Vocabulary Quiz", "Yesterday", ModernDesignSystem.Colors.teluguBlue)
                activityRow("Story: The Clever Fox", "2 days ago", ModernDesignSystem.Colors.teluguSaffron)
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
                .foregroundColor(ModernDesignSystem.Colors.primaryText)
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)
        }
    }
}

// MARK: - Consolidated Practice View
struct ImprovedPracticeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.background.ignoresSafeArea()
                
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
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
                    Text("Word Match")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)
                    
                    Text("50 XP Bonus")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.teluguSaffron)
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
            practiceCard("Games", "gamecontroller.fill", ModernDesignSystem.Colors.teluguBlue)
            practiceCard("Stories", "books.vertical.fill", ModernDesignSystem.Colors.teluguGreen)
            practiceCard("Quiz", "questionmark.circle.fill", ModernDesignSystem.Colors.teluguSaffron)
            practiceCard("Review", "arrow.clockwise", ModernDesignSystem.Colors.culturalRed)
        }
    }
    
    private func practiceCard(_ title: String, _ icon: String, _ color: Color) -> some View {
        HIGAccessibleCard(
            label: title,
            hint: "Start \(title.lowercased()) practice",
            action: { /* Navigate */ }
        ) {
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.primaryText)
            }
            .padding(ModernDesignSystem.Spacing.lg)
            .background(ModernDesignSystem.Colors.cardBackground)
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
                ModernDesignSystem.Colors.background.ignoresSafeArea()
                
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
            statCard("Total XP", "\(session.userProfile.totalXP)", ModernDesignSystem.Colors.teluguBlue)
            statCard("Level", "\(session.userProfile.level)", ModernDesignSystem.Colors.teluguGreen)
            statCard("Streak", "\(session.userProfile.currentStreak) days", ModernDesignSystem.Colors.teluguSaffron)
            statCard("Badges", "\(session.gamificationService.gamificationState.badges.filter { $0.isUnlocked }.count)", ModernDesignSystem.Colors.culturalRed)
        }
    }
    
    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)
        }
        .padding(ModernDesignSystem.Spacing.lg)
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(16)
        .frame(minHeight: 100)
    }
    
    private var achievementsSection: some View {
        CleanCardLayout(title: "Recent Achievements") {
            VStack(spacing: ModernDesignSystem.Spacing.sm) {
                achievementRow("First Letter", "Learned your first Telugu letter", ModernDesignSystem.Colors.teluguGreen)
                achievementRow("Word Master", "Learned 50 vocabulary words", ModernDesignSystem.Colors.teluguBlue)
                achievementRow("Streak Keeper", "Maintained 7-day streak", ModernDesignSystem.Colors.teluguSaffron)
            }
        }
    }
    
    private func achievementRow(_ title: String, _ description: String, _ color: Color) -> some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: "star.fill")
                .font(.title3)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(ModernDesignSystem.Colors.primaryText)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(ModernDesignSystem.Colors.secondaryText)
            }
            
            Spacer()
        }
    }
    
    private var streakSection: some View {
        CleanCardLayout(title: "Learning Streak") {
            HStack {
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
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
}

// MARK: - More View
struct ImprovedMoreView: View {
    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.background.ignoresSafeArea()
                
                BreathingRoomLayout {
                    VStack(spacing: ModernDesignSystem.Spacing.lg) {
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
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                settingRow("Kid Mode", "toggle.left.and.right")
                settingRow("Notifications", "bell.fill")
                settingRow("Audio Settings", "speaker.wave.2.fill")
            }
        }
    }
    
    private var helpSection: some View {
        CleanCardLayout(title: "Help & Support") {
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                settingRow("How to Use", "questionmark.circle.fill")
                settingRow("Contact Us", "envelope.fill")
                settingRow("FAQ", "doc.text.fill")
            }
        }
    }
    
    private var aboutSection: some View {
        CleanCardLayout(title: "About") {
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                settingRow("Privacy Policy", "hand.raised.fill")
                settingRow("Terms of Service", "doc.fill")
                settingRow("Version 1.0", "info.circle.fill")
            }
        }
    }
    
    private func settingRow(_ title: String, _ icon: String) -> some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(ModernDesignSystem.Colors.teluguBlue)
                .frame(width: 24)
            
            Text(title)
                .font(.body)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)
        }
    }
}
