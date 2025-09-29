import SwiftUI

struct ImprovedGamesHubView: View {
    @EnvironmentObject var session: AppSession
    @State private var navigationPath = NavigationPath()
    @State private var selectedGame: String? = nil
    
    private let games: [GameInfo] = [
        GameInfo(
            id: "sentence_builder",
            title: "Sentence Builder",
            description: "Arrange words to create perfect Telugu sentences",
            icon: "text.bubble.fill",
            difficulty: "Beginner",
            estimatedTime: "5 min",
            color: Color(red: 0.2, green: 0.6, blue: 1.0)
        ),
        GameInfo(
            id: "listening_challenge", 
            title: "Listening Challenge",
            description: "Listen and choose the correct meaning",
            icon: "ear.fill",
            difficulty: "Intermediate",
            estimatedTime: "8 min",
            color: Color(red: 0.8, green: 0.4, blue: 0.9)
        ),
        GameInfo(
            id: "letter_tracing",
            title: "Letter Tracing",
            description: "Practice writing Telugu letters",
            icon: "pencil.tip",
            difficulty: "Beginner",
            estimatedTime: "10 min",
            color: Color(red: 1.0, green: 0.6, blue: 0.2)
        ),
        GameInfo(
            id: "sound_match",
            title: "Sound Match",
            description: "Match sounds with their letters",
            icon: "speaker.wave.2.fill",
            difficulty: "Intermediate", 
            estimatedTime: "6 min",
            color: Color(red: 0.3, green: 0.8, blue: 0.5)
        )
    ]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.92, green: 0.95, blue: 0.98)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerSection
                            .padding(.top, 20)
                        
                        gamesGrid
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Practice Games")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: String.self) { gameId in
                gameDestination(for: gameId)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Your Game")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Practice Telugu through fun interactive games")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var gamesGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(games, id: \.id) { game in
                GameCard(game: game, isSelected: selectedGame == game.id) {
                    selectGame(game.id)
                }
            }
        }
    }
    
    private func selectGame(_ gameId: String) {
        session.hapticsService.lightImpact()
        selectedGame = gameId
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            navigationPath.append(gameId)
            selectedGame = nil
        }
    }
    
    @ViewBuilder
    private func gameDestination(for gameId: String) -> some View {
        switch gameId {
        case "sentence_builder":
            SentenceBuilderGameView()
        case "listening_challenge":
            ListeningChallengeGameView()
        case "letter_tracing":
            TraceGameView()
        case "sound_match":
            SoundMatchGameView()
        default:
            Text("Game not found")
        }
    }
}

struct GameCard: View {
    let game: GameInfo
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(game.color.opacity(0.15))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: game.icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(game.color)
                    }
                    
                    Spacer()
                    
                    Text(game.difficulty)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(game.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(game.color.opacity(0.1))
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(game.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(game.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(game.estimatedTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(game.color)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(
                        color: isSelected ? game.color.opacity(0.3) : Color.black.opacity(0.05),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}
