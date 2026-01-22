import SwiftUI

struct GamesHubView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var selectedGame: String? = nil
    
    private let games: [GameInfo] = [
        GameInfo(
            id: "1",
            title: "Sentence Builder",
            description: "Arrange words to create perfect Telugu sentences",
            icon: "text.alignleft",
            difficulty: "Beginner",
            estimatedTime: "5 min",
            color: .blue,
            isRecommended: false
        ),
        GameInfo(
            id: "2", 
            title: "Listening Challenge",
            description: "Listen and choose the correct meaning",
            icon: "ear.fill",
            difficulty: "Intermediate",
            estimatedTime: "8 min",
            color: .purple,
            isRecommended: false
        ),
        GameInfo(
            id: "3",
            title: "Letter Tracing",
            description: "Practice writing Telugu letters",
            icon: "pencil",
            difficulty: "Beginner",
            estimatedTime: "10 min",
            color: .orange,
            isRecommended: false
        ),
        GameInfo(
            id: "4",
            title: "Sound Match",
            description: "Match sounds with their letters",
            icon: "waveform",
            difficulty: "Intermediate", 
            estimatedTime: "6 min",
            color: .green,
            isRecommended: false
        )
    ]
    
    var body: some View {
        ZStack {
            // Stronger gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Header
                    headerSection
                        .padding(.top, -20)
                    
                    // Games Grid
                    gamesGrid
                    
                    // Bottom padding
                    Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Games")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.1),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.08)
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(.blue)
            }
        }
        .fullScreenCover(item: Binding<GameInfo?>(
            get: { games.first { $0.id == selectedGame } },
            set: { _ in selectedGame = nil }
        )) { game in
            NavigationStack {
                gameDestination(for: game.id)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Practice Games")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            Text("Practice Telugu through fun interactive games")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }
    
    // MARK: - Games Grid
    private var gamesGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(Array(games.enumerated()), id: \.element.id) { index, game in
                Button {
                    print("🎮 Game tapped: \(game.title)")
                    HapticsService.shared.buttonTap()
                    selectedGame = game.id
                } label: {
                    ModernGameCard(game: game)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
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

// MARK: - Modern Game Card
struct ModernGameCard: View {
    let game: GameInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: Icon and Time badge
            HStack(alignment: .top) {
                Image(systemName: game.icon)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(game.color)
                
                Spacer()
                
                // Time badge
                Text(game.estimatedTime)
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(.secondary.opacity(0.15))
                    )
            }
            
            // Title
            Text(game.title)
                .font(.headline.bold())
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // Description
            Text(game.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            // Level tag
            HStack {
                Text(game.difficulty)
                    .font(.caption.bold())
                    .foregroundColor(levelColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(levelColor.opacity(0.15))
                    )
                
                Spacer()
            }
        }
        .padding(16)
        .frame(height: 200)
        .contentShape(Rectangle())
        .background(
            Group {
                if game.isRecommended {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(game.color.opacity(0.08))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(game.isRecommended ? game.color.opacity(0.3) : .clear, lineWidth: 1)
        )
        .shadow(
            color: game.isRecommended ? game.color.opacity(0.15) : .black.opacity(0.05),
            radius: game.isRecommended ? 6 : 2,
            x: 0,
            y: 1
        )
        .foregroundColor(.primary)
    }
    
    private var levelColor: Color {
        game.difficulty == "Beginner" ? .green : .orange
    }
}

// MARK: - Game Info Model
struct GameInfo: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let difficulty: String
    let estimatedTime: String
    let color: Color
    let isRecommended: Bool
}

// MARK: - Preview
#Preview {
    NavigationStack {
        GamesHubView()
            .environmentObject(AppSession())
    }
}
