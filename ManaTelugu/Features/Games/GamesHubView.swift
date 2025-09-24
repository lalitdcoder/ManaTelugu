import SwiftUI

// MARK: - Professional Games Hub View
// Clean, vertical layout with engaging visual appeal

struct ProfessionalGamesHubView: View {
    @EnvironmentObject var session: AppSession
    @State private var navigationPath = NavigationPath()
    
    // Mock games data for professional presentation
    private let games: [ProfessionalGame] = [
        ProfessionalGame(
            id: "1",
            title: "Sentence Builder",
            description: "Arrange words to create perfect Telugu sentences",
            icon: "text.bubble.fill",
            difficulty: .beginner,
            estimatedTime: "5 min",
            isCompleted: false,
            isLocked: false,
            highScore: 0,
            color: .professionalBlue
        ),
        ProfessionalGame(
            id: "2",
            title: "Listening Challenge",
            description: "Listen and choose the correct meaning",
            icon: "ear.fill",
            difficulty: .intermediate,
            estimatedTime: "8 min",
            isCompleted: true,
            isLocked: false,
            highScore: 850,
            color: .professionalGreen
        ),
        ProfessionalGame(
            id: "3",
            title: "Card Match",
            description: "Match Telugu words with English meanings",
            icon: "arrow.left.arrow.right",
            difficulty: .beginner,
            estimatedTime: "6 min",
            isCompleted: false,
            isLocked: false,
            highScore: 0,
            color: .professionalOrange
        ),
        ProfessionalGame(
            id: "4",
            title: "Sound Match",
            description: "Listen and pick the right sound",
            icon: "speaker.wave.2.fill",
            difficulty: .intermediate,
            estimatedTime: "7 min",
            isCompleted: false,
            isLocked: false,
            highScore: 0,
            color: .professionalPurple
        ),
        ProfessionalGame(
            id: "5",
            title: "Trace Letters",
            description: "Practice writing Telugu letters",
            icon: "pencil.tip",
            difficulty: .beginner,
            estimatedTime: "10 min",
            isCompleted: false,
            isLocked: false,
            highScore: 0,
            color: .professionalPink
        ),
        ProfessionalGame(
            id: "6",
            title: "Word Puzzle",
            description: "Solve challenging word puzzles",
            icon: "puzzlepiece.fill",
            difficulty: .advanced,
            estimatedTime: "15 min",
            isCompleted: false,
            isLocked: true,
            highScore: 0,
            color: .professionalBlue
        )
    ]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Professional gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.4, blue: 0.9),
                        Color(red: 0.4, green: 0.2, blue: 0.8),
                        Color(red: 0.8, green: 0.3, blue: 0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                ScrollView {
                    LazyVStack(spacing: ProfessionalSpacing.large.value) {
                        // Hero Section
                        heroSection
                            .padding(.top, ProfessionalSpacing.extraLarge.value)
                        
                        // Game Stats
                        gameStatsSection
                        
                        // Featured Game
                        featuredGameSection
                        
                        // All Games
                        allGamesSection
                        
                        // Bottom padding for tab bar
                        Color.clear
                            .frame(height: 120)
                    }
                    .padding(.horizontal, ProfessionalSpacing.medium.value)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        ProfessionalCard(type: .hero) {
            VStack(alignment: .leading, spacing: ProfessionalSpacing.large.value) {
                ProfessionalText(
                    "Learning Games",
                    style: .heroTitle,
                    color: .textPrimary
                )
                
                ProfessionalText(
                    "Master Telugu through fun and engaging games",
                    style: .bodyText,
                    color: .textSecondary
                )
                
                HStack(spacing: ProfessionalSpacing.large.value) {
                    ProfessionalStatCard(
                        icon: "gamecontroller.fill",
                        value: "\(games.count)",
                        label: "Games",
                        color: .professionalBlue
                    )
                    
                    ProfessionalStatCard(
                        icon: "trophy.fill",
                        value: "3",
                        label: "Won",
                        color: .professionalOrange
                    )
                }
            }
        }
    }
    
    // MARK: - Game Stats Section
    private var gameStatsSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Your Progress",
                subtitle: "Track your gaming achievements"
            )
            
            HStack(spacing: ProfessionalSpacing.medium.value) {
                ProfessionalStatCard(
                    icon: "star.fill",
                    value: "1,250",
                    label: "Total Score",
                    color: .professionalGreen
                )
                
                ProfessionalStatCard(
                    icon: "clock.fill",
                    value: "45m",
                    label: "Play Time",
                    color: .professionalPurple
                )
                
                ProfessionalStatCard(
                    icon: "flame.fill",
                    value: "5",
                    label: "Streak",
                    color: .professionalOrange
                )
            }
        }
    }
    
    // MARK: - Featured Game Section
    private var featuredGameSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Featured Game",
                subtitle: "Try this popular game"
            )
            
            if let featuredGame = games.first(where: { $0.isCompleted && !$0.isLocked }) {
                ProfessionalFeaturedGameCard(game: featuredGame)
            } else if let firstGame = games.first(where: { !$0.isLocked }) {
                ProfessionalFeaturedGameCard(game: firstGame)
            }
        }
    }
    
    // MARK: - All Games Section
    private var allGamesSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "All Games",
                subtitle: "Choose your challenge"
            )
            
            VStack(spacing: ProfessionalSpacing.medium.value) {
                ForEach(games, id: \.id) { game in
                    ProfessionalGameCard(game: game)
                }
            }
        }
    }
}

// MARK: - Professional Game Model
struct ProfessionalGame {
    let id: String
    let title: String
    let description: String
    let icon: String
    let difficulty: DifficultyLevel
    let estimatedTime: String
    let isCompleted: Bool
    let isLocked: Bool
    let highScore: Int
    let color: Color
    
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

// MARK: - Professional Featured Game Card
struct ProfessionalFeaturedGameCard: View {
    let game: ProfessionalGame
    
    var body: some View {
        ProfessionalCard(type: .hero, isInteractive: true) {
            HStack(spacing: ProfessionalSpacing.large.value) {
                // Game Icon
                ZStack {
                    Circle()
                        .fill(game.color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: game.icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(game.color)
                }
                
                // Game Content
                VStack(alignment: .leading, spacing: ProfessionalSpacing.small.value) {
                    ProfessionalText(
                        game.title,
                        style: .cardTitle,
                        color: .textPrimary
                    )
                    
                    ProfessionalText(
                        game.description,
                        style: .bodyText,
                        color: .textSecondary
                    )
                    
                    HStack {
                        // Difficulty Badge
                        Text(game.difficulty.displayName)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(game.difficulty.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(game.difficulty.color.opacity(0.15))
                            )
                        
                        // Time
                        ProfessionalText(
                            game.estimatedTime,
                            style: .caption,
                            color: .textSecondary
                        )
                        
                        Spacer()
                        
                        // High Score
                        if game.highScore > 0 {
                            ProfessionalText(
                                "High: \(game.highScore)",
                                style: .caption,
                                color: game.color
                            )
                        }
                    }
                }
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Professional Game Card
struct ProfessionalGameCard: View {
    let game: ProfessionalGame
    @State private var isPressed = false
    
    var body: some View {
        ProfessionalCard(
            type: game.isLocked ? .secondary : .interactive,
            isInteractive: !game.isLocked
        ) {
            HStack(spacing: ProfessionalSpacing.medium.value) {
                // Game Icon
                ZStack {
                    Circle()
                        .fill(game.isLocked ? Color.gray.opacity(0.3) : game.color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    if game.isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.gray)
                    } else {
                        Image(systemName: game.icon)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(game.color)
                    }
                }
                
                // Game Content
                VStack(alignment: .leading, spacing: ProfessionalSpacing.small.value) {
                    HStack {
                        ProfessionalText(
                            game.title,
                            style: .cardTitle,
                            color: game.isLocked ? .textSecondary : .textPrimary
                        )
                        
                        Spacer()
                        
                        // Difficulty Badge
                        Text(game.difficulty.displayName)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(game.difficulty.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(game.difficulty.color.opacity(0.15))
                            )
                    }
                    
                    ProfessionalText(
                        game.description,
                        style: .bodyText,
                        color: game.isLocked ? .textTertiary : .textSecondary
                    )
                    
                    HStack {
                        ProfessionalText(
                            game.estimatedTime,
                            style: .caption,
                            color: .textSecondary
                        )
                        
                        Spacer()
                        
                        if game.highScore > 0 {
                            ProfessionalText(
                                "High: \(game.highScore)",
                                style: .caption,
                                color: game.color
                            )
                        }
                    }
                }
                
                // Arrow or Lock
                if game.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }
}

// MARK: - Replace the original GamesHubView
typealias GamesHubView = ProfessionalGamesHubView
