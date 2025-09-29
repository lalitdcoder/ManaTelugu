import SwiftUI

struct GamesHubView: View {
    @EnvironmentObject var session: AppSession
    @State private var navigationPath = NavigationPath()
    
    private let games: [GameInfo] = [
        GameInfo(
            id: "1",
            title: "Sentence Builder",
            description: "Arrange words to create perfect Telugu sentences",
            icon: "text.bubble.fill",
            difficulty: "Beginner",
            estimatedTime: "5 min",
            color: ElegantDesign.Colors.primary
        ),
        GameInfo(
            id: "2", 
            title: "Listening Challenge",
            description: "Listen and choose the correct meaning",
            icon: "ear.fill",
            difficulty: "Intermediate",
            estimatedTime: "8 min",
            color: ElegantDesign.Colors.secondary
        ),
        GameInfo(
            id: "3",
            title: "Letter Tracing",
            description: "Practice writing Telugu letters",
            icon: "pencil.tip",
            difficulty: "Beginner",
            estimatedTime: "10 min",
            color: ElegantDesign.Colors.accent
        ),
        GameInfo(
            id: "4",
            title: "Sound Match",
            description: "Match sounds with their letters",
            icon: "speaker.wave.2.fill",
            difficulty: "Intermediate", 
            estimatedTime: "6 min",
            color: ElegantDesign.Colors.success
        )
    ]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                ElegantGradient()
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ElegantDesign.Spacing.xl) {
                        // Header
                        headerSection
                            .padding(.top, ElegantDesign.Spacing.xl)
                        
                        // Games Grid
                        gamesGrid
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
                }
            }
            .navigationTitle("Games")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: String.self) { gameId in
                gameDestination(for: gameId)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
            Text("Practice Telugu through fun interactive games")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var gamesGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ElegantDesign.Spacing.md), count: 2), spacing: ElegantDesign.Spacing.md) {
            ForEach(games, id: \.id) { game in
                gameCard(game)
            }
        }
    }
    
    private func gameCard(_ game: GameInfo) -> some View {
        Button(action: {
            navigationPath.append(game.id)
        }) {
            VStack(spacing: ElegantDesign.Spacing.md) {
                Image(systemName: game.icon)
                    .font(.system(size: 32))
                    .foregroundColor(game.color)
                
                VStack(spacing: ElegantDesign.Spacing.xs) {
                    Text(game.title)
                        .font(ElegantDesign.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(ElegantDesign.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(game.description)
                        .font(ElegantDesign.Typography.caption)
                        .foregroundColor(ElegantDesign.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    HStack {
                        Text(game.difficulty)
                            .font(ElegantDesign.Typography.caption)
                            .foregroundColor(game.color)
                        
                        Spacer()
                        
                        Text(game.estimatedTime)
                            .font(ElegantDesign.Typography.caption)
                            .foregroundColor(ElegantDesign.Colors.textTertiary)
                    }
                }
            }
            .frame(height: 160)
            .frame(maxWidth: .infinity)
            .elegantCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
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
}

struct GameInfo {
    let id: String
    let title: String
    let description: String
    let icon: String
    let difficulty: String
    let estimatedTime: String
    let color: Color
}
