import SwiftUI

// MARK: - Parental Gate State
struct ParentalGateState {
    var isUnlocked: Bool = false
    var isPresented: Bool = false
    var isCompleted: Bool = false
}

// MARK: - Professional Home View
// Complete redesign with proper visual hierarchy and professional styling

struct HomeView: View {
    @EnvironmentObject var session: AppSession
    @StateObject private var navigationService = NavigationService.shared
    @State private var parentalGateState = ParentalGateState()
    @State private var isLoading = false
    @State private var scrollOffset: CGFloat = 0
    
    // Mock data for professional presentation
    private let dailyTip = DailyTip(
        title: "Word of the Day",
        content: "సంతోషం (santōṣaṁ) - Happiness",
        iconName: "sun.max.fill",
        color: .professionalOrange
    )
    
    private let learningModes: [ProfessionalLearningMode] = [
        ProfessionalLearningMode(
            title: "Alphabet Adventure",
            description: "Master Telugu letters through interactive activities",
            iconName: "textformat.abc",
            color: .professionalBlue,
            progress: 0.75,
            difficulty: .beginner
        ),
        ProfessionalLearningMode(
            title: "Vocabulary Quest",
            description: "Build your Telugu vocabulary with essential words",
            iconName: "book.fill",
            color: .professionalGreen,
            progress: 0.45,
            difficulty: .intermediate
        ),
        ProfessionalLearningMode(
            title: "Story Time",
            description: "Immerse yourself in rich Telugu stories and folklore",
            iconName: "book.closed.fill",
            color: .professionalPurple,
            progress: 0.30,
            difficulty: .advanced
        ),
        ProfessionalLearningMode(
            title: "Game Zone",
            description: "Learn through fun and engaging Telugu games",
            iconName: "gamecontroller.fill",
            color: .professionalOrange,
            progress: 0.60,
            difficulty: .beginner
        )
    ]
    
    var body: some View {
        NavigationStack(path: $navigationService.navigationPath) {
            ZStack {
                // Professional gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.4, blue: 0.9),   // Professional blue
                        Color(red: 0.4, green: 0.2, blue: 0.8),   // Professional purple
                        Color(red: 0.8, green: 0.3, blue: 0.6)    // Professional pink
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                // Professional scroll view with proper hierarchy
                ScrollView {
                    LazyVStack(spacing: ProfessionalSpacing.large.value) {
                        // Hero Welcome Section
                        heroWelcomeSection
                            .padding(.top, ProfessionalSpacing.extraLarge.value)
                        
                        // Stats Dashboard
                        statsDashboardSection
                        
                        // Continue Learning Hero Card
                        continueLearningHeroSection
                        
                        // Learning Modes Grid
                        learningModesSection
                        
                        // Word of the Day Feature
                        wordOfTheDaySection
                        
                        // Recent Achievements
                        recentAchievementsSection
                        
                        // Bottom padding for tab bar
                        Color.clear
                            .frame(height: 120)
                    }
                    .padding(.horizontal, ProfessionalSpacing.medium.value)
                }
                .scrollIndicators(.hidden)
                
                // Professional loading overlay
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea(.all, edges: .all)
                        
                        ProfessionalCard(type: .hero) {
                            VStack(spacing: ProfessionalSpacing.large.value) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                    .tint(.professionalBlue)
                                
                                ProfessionalText(
                                    "Loading your Telugu journey...",
                                    style: .cardTitle,
                                    color: .textPrimary,
                                    alignment: .center
                                )
                            }
                            .padding(ProfessionalSpacing.extraLarge.value)
                        }
                        .padding(.horizontal, ProfessionalSpacing.large.value)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Simulate loading for demonstration
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(ProfessionalAnimation.pageTransition) {
                        isLoading = false
                    }
                }
            }
            .navigationDestination(for: HomeNavigationDestination.self) { destination in
                destinationView(for: destination)
            }
        }
    }
    
    // MARK: - Hero Welcome Section
    private var heroWelcomeSection: some View {
        ProfessionalCard(type: .hero) {
            VStack(alignment: .leading, spacing: ProfessionalSpacing.large.value) {
                // Welcome message
                VStack(alignment: .leading, spacing: ProfessionalSpacing.small.value) {
                    ProfessionalText(
                        "Welcome back!",
                        style: .heroTitle,
                        color: .textPrimary
                    )
                    
                    ProfessionalText(
                        "Ready to continue your Telugu learning journey?",
                        style: .bodyText,
                        color: .textSecondary
                    )
                }
                
                // Motivational message
                ProfessionalText(
                    "🌟 Every word you learn brings you closer to fluency!",
                    style: .bodyText,
                    color: .professionalOrange,
                    alignment: .leading
                )
            }
        }
    }
    
    // MARK: - Stats Dashboard Section
    private var statsDashboardSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Your Progress",
                subtitle: "Track your learning journey"
            )
            
            HStack(spacing: ProfessionalSpacing.medium.value) {
                ProfessionalStatCard(
                    icon: "flame.fill",
                    value: "7",
                    label: "Day Streak",
                    color: .professionalOrange
                )
                
                ProfessionalStatCard(
                    icon: "star.fill",
                    value: "\(session.gamificationService.gamificationState.totalXP)",
                    label: "Total XP",
                    color: .professionalBlue
                )
                
                ProfessionalStatCard(
                    icon: "trophy.fill",
                    value: "\(session.gamificationService.gamificationState.badges.count)",
                    label: "Badges",
                    color: .professionalPurple
                )
            }
        }
    }
    
    // MARK: - Continue Learning Hero Section
    private var continueLearningHeroSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Continue Learning",
                subtitle: "Pick up where you left off"
            )
            
            ProfessionalCard(type: .hero, isInteractive: true) {
                HStack(spacing: ProfessionalSpacing.large.value) {
                    // Icon
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(.professionalGreen)
                        .frame(width: 64, height: 64)
                        .background(
                            Circle()
                                .fill(Color.professionalGreen.opacity(0.15))
                        )
                    
                    // Content
                    VStack(alignment: .leading, spacing: ProfessionalSpacing.small.value) {
                        ProfessionalText(
                            "Alphabet Adventure",
                            style: .cardTitle,
                            color: .textPrimary
                        )
                        
                        ProfessionalText(
                            "Continue learning Telugu letters",
                            style: .bodyText,
                            color: .textSecondary
                        )
                        
                        // Progress bar
                        HStack {
                            ProfessionalText(
                                "75% Complete",
                                style: .caption,
                                color: .professionalGreen
                            )
                            
                            Spacer()
                            
                            ProfessionalText(
                                "12 of 16 lessons",
                                style: .caption,
                                color: .textSecondary
                            )
                        }
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.black.opacity(0.1))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.professionalGreen)
                                    .frame(width: geometry.size.width * 0.75, height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                    
                    Spacer()
                    
                    // Arrow
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Learning Modes Section
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Learning Modes",
                subtitle: "Choose your learning style"
            )
            
            VStack(spacing: ProfessionalSpacing.medium.value) {
                                    ForEach(Array(learningModes.enumerated()), id: \.offset) { index, mode in
                                        ProfessionalLearningModeCard(
                                            title: mode.title,
                                            description: mode.description,
                                            icon: mode.iconName,
                                            color: mode.color,
                                            progress: mode.progress
                                        )
                                    }
            }
        }
    }
    
    // MARK: - Word of the Day Section
    private var wordOfTheDaySection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Word of the Day",
                subtitle: "Expand your vocabulary daily"
            )
            
            ProfessionalCard(type: .primary) {
                HStack(spacing: ProfessionalSpacing.large.value) {
                    // Telugu word
                    VStack(alignment: .leading, spacing: ProfessionalSpacing.small.value) {
                        ProfessionalText(
                            "సంతోషం",
                            style: .teluguTitle,
                            color: .textPrimary
                        )
                        
                        ProfessionalText(
                            "santōṣaṁ",
                            style: .bodyText,
                            color: .textSecondary
                        )
                        
                        ProfessionalText(
                            "Happiness",
                            style: .cardTitle,
                            color: .professionalOrange
                        )
                    }
                    
                    Spacer()
                    
                    // Icon
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.professionalOrange)
                        .frame(width: 48, height: 48)
                        .background(
                            Circle()
                                .fill(Color.professionalOrange.opacity(0.15))
                        )
                }
            }
        }
    }
    
    // MARK: - Recent Achievements Section
    private var recentAchievementsSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Recent Achievements",
                subtitle: "Celebrate your progress"
            )
            
            VStack(spacing: ProfessionalSpacing.medium.value) {
                ForEach(0..<3) { index in
                    ProfessionalCard(type: .secondary) {
                        HStack(spacing: ProfessionalSpacing.medium.value) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.professionalOrange)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(Color.professionalOrange.opacity(0.15))
                                )
                            
                            VStack(alignment: .leading, spacing: ProfessionalSpacing.tiny.value) {
                                ProfessionalText(
                                    "Badge \(index + 1)",
                                    style: .cardTitle,
                                    color: .textPrimary
                                )
                                
                                ProfessionalText(
                                    "Earned today",
                                    style: .caption,
                                    color: .textSecondary
                                )
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation Destination
    @ViewBuilder
    private func destinationView(for destination: HomeNavigationDestination) -> some View {
        switch destination {
        case .alphabet:
            AlphabetHubView()
        case .lesson(let id):
            // Navigate to lessons hub for now
            LessonsHubView()
        case .story(let id):
            // Navigate to story hub for now
            StorybookHubView()
        case .games:
            GamesHubView()
        case .vocabulary:
            VocabularyThemesView()
        case .progress:
            ProgressDashboardView()
        default:
            EmptyView()
        }
    }
}

// MARK: - Professional Learning Mode Model
struct ProfessionalLearningMode {
    let title: String
    let description: String
    let iconName: String
    let color: Color
    let progress: Double
    let difficulty: DifficultyLevel
    
    enum DifficultyLevel {
        case beginner
        case intermediate
        case advanced
        
        var displayName: String {
            switch self {
            case .beginner: return "Beginner"
            case .intermediate: return "Intermediate"
            case .advanced: return "Advanced"
            }
        }
        
        var color: Color {
            switch self {
            case .beginner: return .professionalGreen
            case .intermediate: return .professionalOrange
            case .advanced: return .professionalPurple
            }
        }
    }
}


// MARK: - Preview
#Preview {
    HomeView()
        .environmentObject(AppSession())
}
