import SwiftUI

// MARK: - iPad-Optimized Games View
/// Adapts games hub for iPad with:
/// - 3-4 column grid layout (vs 2 on iPhone)
/// - Larger game cards with better readability
/// - Optimized spacing and touch targets
/// - Split view for game details on iPad
struct IPadOptimizedGamesView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedGame: GameInfo?
    
    private let games: [GameInfo] = [
        GameInfo(
            id: "1",
            title: "Sentence Builder",
            description: "Arrange words to create perfect Telugu sentences",
            icon: "text.bubble.fill",
            difficulty: "Beginner",
            estimatedTime: "5 min",
            color: ModernDesignSystem.Colors.primary,
            isRecommended: false
        ),
        GameInfo(
            id: "2",
            title: "Listening Challenge",
            description: "Listen and choose the correct meaning",
            icon: "ear.fill",
            difficulty: "Intermediate",
            estimatedTime: "8 min",
            color: ModernDesignSystem.Colors.secondary,
            isRecommended: false
        ),
        GameInfo(
            id: "3",
            title: "Letter Tracing",
            description: "Practice writing Telugu letters",
            icon: "pencil.tip",
            difficulty: "Beginner",
            estimatedTime: "10 min",
            color: ModernDesignSystem.Colors.games,
            isRecommended: false
        ),
        GameInfo(
            id: "4",
            title: "Sound Match",
            description: "Match sounds with their letters",
            icon: "speaker.wave.2.fill",
            difficulty: "Intermediate",
            estimatedTime: "6 min",
            color: ModernDesignSystem.Colors.success,
            isRecommended: false
        ),
        GameInfo(
            id: "5",
            title: "Word Builder",
            description: "Create words from letter combinations",
            icon: "square.and.pencil",
            difficulty: "Advanced",
            estimatedTime: "12 min",
            color: .purple,
            isRecommended: false
        ),
        GameInfo(
            id: "6",
            title: "Memory Match",
            description: "Match Telugu words with their meanings",
            icon: "brain.head.profile",
            difficulty: "Intermediate",
            estimatedTime: "7 min",
            color: .pink,
            isRecommended: false
        )
    ]
    
    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)
            
            if horizontalSizeClass == .regular {
                // iPad: Split view layout
                iPadSplitLayout
            } else {
                // iPhone: Standard scroll layout
                iPhoneLayout
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - iPad Split View Layout
    private var iPadSplitLayout: some View {
        NavigationSplitView {
            // Sidebar: Games List
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Practice Games")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                        
                        Text("Improve your Telugu skills through fun games")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ModernDesignSystem.Colors.surface)
                            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                    )
                    
                    // Games List (Vertical on sidebar)
                    VStack(spacing: 12) {
                        ForEach(games, id: \.id) { game in
                            Button(action: { selectedGame = game }) {
                                HStack(spacing: 16) {
                                    // Game Icon
                                    Image(systemName: game.icon)
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(game.color)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(game.color.opacity(0.15))
                                        )
                                    
                                    // Game Info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(game.title)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                                            .lineLimit(1)
                                        
                                        HStack(spacing: 8) {
                                            Text(game.difficulty)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(game.color)
                                            
                                            Text("•")
                                                .foregroundColor(ModernDesignSystem.Colors.textTertiary)
                                            
                                            Text(game.estimatedTime)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(ModernDesignSystem.Colors.textTertiary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedGame?.id == game.id {
                                        Image(systemName: "chevron.right.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(game.color)
                                    }
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            selectedGame?.id == game.id ?
                                            ModernDesignSystem.Colors.surface.opacity(0.8) :
                                            ModernDesignSystem.Colors.surface.opacity(0.5)
                                        )
                                )
                                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Color.clear.frame(height: 20)
                }
                .padding(.vertical, 20)
            }
            .scrollIndicators(.hidden)
        } detail: {
            // Detail: Game Information
            if let game = selectedGame {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Game Header
                        VStack(alignment: .leading, spacing: 20) {
                            // Large Icon
                            ZStack {
                                Circle()
                                    .fill(game.color.opacity(0.15))
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: game.icon)
                                    .font(.system(size: 60, weight: .semibold))
                                    .foregroundColor(game.color)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text(game.title)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                                
                                Text(game.description)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ModernDesignSystem.Colors.surface)
                                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                        )
                        
                        // Game Details
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Game Details")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                            
                            HStack(spacing: 20) {
                                // Difficulty
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Difficulty")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                                    
                                    HStack(spacing: 4) {
                                        ForEach(0..<difficultyStars(game.difficulty), id: \.self) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.orange)
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                // Time
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Estimated Time")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                                    
                                    Text(game.estimatedTime)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(game.color)
                                }
                                
                                Spacer()
                                
                                // Category
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Category")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                                    
                                    Text(game.difficulty)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(game.color)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ModernDesignSystem.Colors.surface)
                                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                            )
                        }
                        
                        // Play Button
                        Button(action: { /* Start game */ }) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 20))
                                
                                Text("Play Game")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(game.color)
                            )
                            .foregroundColor(.white)
                        }
                        
                        Color.clear.frame(height: 20)
                    }
                    .padding(24)
                }
                .scrollIndicators(.hidden)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "hand.point.left.fill")
                        .font(.system(size: 48))
                        .foregroundColor(ModernDesignSystem.Colors.textTertiary)
                    
                    Text("Select a game to view details")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ModernDesignSystem.Colors.backgroundGradient)
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    // MARK: - iPhone Standard Layout
    private var iPhoneLayout: some View {
        ScrollView {
            VStack(spacing: ModernDesignSystem.Spacing.xl) {
                // Header
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                    Text("Practice Games")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    
                    Text("Improve your Telugu skills through fun games")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, ModernDesignSystem.Spacing.xl)
                
                // Games Grid (2-3 columns on iPhone, 3-4 on iPad)
                let columns = Array(repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.md), count: 2)
                
                LazyVGrid(columns: columns, spacing: ModernDesignSystem.Spacing.md) {
                    ForEach(games, id: \.id) { game in
                        NavigationLink(destination: gameDestination(for: game.id)) {
                            gameCard(game)
                        }
                        .buttonStyle(HapticPlainButtonStyle())
                    }
                }
                
                Color.clear.frame(height: ModernDesignSystem.Spacing.xl)
            }
            .padding(.horizontal, ModernDesignSystem.Spacing.md)
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Game Card View
    private func gameCard(_ game: GameInfo) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: game.icon)
                .font(.system(size: 40))
                .foregroundColor(game.color)
            
            VStack(spacing: ModernDesignSystem.Spacing.xs) {
                Text(game.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(game.description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    Text(game.difficulty)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(game.color)
                    
                    Spacer()
                    
                    Text(game.estimatedTime)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ModernDesignSystem.Colors.textTertiary)
                }
            }
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ModernDesignSystem.Colors.surface)
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
    }
    
    // MARK: - Helper Methods
    @ViewBuilder
    private func gameDestination(for gameId: String) -> some View {
        switch gameId {
        case "1":
            SentenceBuilderGameView()
        case "2":
            ListeningChallengeGameView()
        case "3":
            TraceGameView()
        case "4":
            SoundMatchGameView()
        default:
            Text("Game not found")
        }
    }
    
    private func difficultyStars(_ difficulty: String) -> Int {
        switch difficulty.lowercased() {
        case "beginner":
            return 1
        case "intermediate":
            return 2
        case "advanced":
            return 3
        default:
            return 1
        }
    }
}

// MARK: - Preview
#Preview {
    IPadOptimizedGamesView()
        .environmentObject(AppSession())
}
