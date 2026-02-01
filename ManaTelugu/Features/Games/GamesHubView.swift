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
        ),
        GameInfo(
            id: "5",
            title: "Word Match",
            description: "Match English words with their Telugu meanings",
            icon: "arrow.left.arrow.right",
            difficulty: "Beginner",
            estimatedTime: "5 min",
            color: .pink,
            isRecommended: true
        ),
    ]

    var body: some View {
        ZStack {
            // Stronger gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2),
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
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.08),
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
        .fullScreenCover(
            item: Binding<GameInfo?>(
                get: { games.first { $0.id == selectedGame } },
                set: { _ in selectedGame = nil }
            )
        ) { game in
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
                GridItem(.flexible(), spacing: 16),
            ],
            spacing: 16
        ) {
            ForEach(Array(games.enumerated()), id: \.element.id) { index, game in
                Button {
                    print("🎮 Game tapped: \(game.title)")
                    HapticsManager.shared.trigger(.medium)
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
        case "5":
            WordMatchGameView()
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

struct WordMatchGameView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss

    @State private var allWords: [Word] = []
    @State private var currentRoundWords: [Word] = []

    // Split columns for randomization
    @State private var leftColumnItems: [Word] = []
    @State private var rightColumnItems: [Word] = []

    // Selection states
    @State private var selectedLeftId: String? = nil
    @State private var selectedRightId: String? = nil

    // Matched IDs
    @State private var matchedIds: Set<String> = []

    // Feedback states
    @State private var isWrongMatch = false
    @State private var isSuccessMatch = false
    @State private var showingCompletion = false
    @State private var gameStartTime = Date()
    @State private var score = 0

    private let wordsPerRound = 5

    var body: some View {
        ZStack {
            // Background
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()

            VStack(spacing: ModernDesignSystem.Spacing.lg) {
                // Header
                HStack {
                    Text("Word Match")
                        .font(ModernDesignSystem.Typography.title1)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    Spacer()
                    Text("Score: \(score)")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(ModernDesignSystem.Colors.funYellow)
                }
                .padding(.horizontal)

                if !currentRoundWords.isEmpty {
                    HStack(spacing: ModernDesignSystem.Spacing.xl) {
                        // Left Column (English)
                        VStack(spacing: ModernDesignSystem.Spacing.md) {
                            ForEach(leftColumnItems, id: \.id) { word in
                                CardView(
                                    text: word.english,
                                    isSelected: selectedLeftId == word.id,
                                    isMatched: matchedIds.contains(word.id),
                                    isWrong: isWrongMatch && selectedLeftId == word.id,
                                    color: ModernDesignSystem.Colors.funBlue
                                )
                                .onTapGesture {
                                    handleLeftTap(word.id)
                                }
                                .disabled(matchedIds.contains(word.id))
                            }
                        }

                        // Right Column (Telugu)
                        VStack(spacing: ModernDesignSystem.Spacing.md) {
                            ForEach(rightColumnItems, id: \.id) { word in
                                CardView(
                                    text: word.telugu,
                                    isSelected: selectedRightId == word.id,
                                    isMatched: matchedIds.contains(word.id),
                                    isWrong: isWrongMatch && selectedRightId == word.id,
                                    color: ModernDesignSystem.Colors.funGreen
                                )
                                .onTapGesture {
                                    handleRightTap(word.id)
                                }
                                .disabled(matchedIds.contains(word.id))
                            }
                        }
                    }
                    .padding()
                } else if showingCompletion {
                    // Completion View
                    VStack(spacing: ModernDesignSystem.Spacing.lg) {
                        Text("Round Complete!")
                            .font(ModernDesignSystem.Typography.celebration)
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                        Text("You matched all pairs!")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.textSecondary)

                        ModernButton("Next Round", icon: "arrow.right", style: .primary) {
                            startNewRound()
                        }
                    }
                    .padding()
                    .modernCard()
                }

                Spacer()
            }
            .padding(.top, ModernDesignSystem.Spacing.lg)
        }
        .onAppear {
            setupGame()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
    }

    private func setupGame() {
        allWords = session.dataRepository.words.shuffled()
        if allWords.isEmpty {
            allWords = []
        }
        startNewRound()
    }

    private func startNewRound() {
        // Reset states
        selectedLeftId = nil
        selectedRightId = nil
        matchedIds = []
        isWrongMatch = false
        isSuccessMatch = false
        showingCompletion = false
        gameStartTime = Date()

        // Pick next batch
        let count = min(allWords.count, wordsPerRound)
        guard count > 0 else { return }

        currentRoundWords = Array(allWords.prefix(count))
        // Rotate pool
        allWords.shuffle()

        // Randomize columns INDEPENDENTLY (Anti-Pattern)
        leftColumnItems = currentRoundWords.shuffled()
        rightColumnItems = currentRoundWords.shuffled()
    }

    private func handleLeftTap(_ id: String) {
        guard !matchedIds.contains(id) else { return }

        // Haptic
        HapticsManager.shared.selection()

        selectedLeftId = id
        checkMatch()
    }

    private func handleRightTap(_ id: String) {
        guard !matchedIds.contains(id) else { return }

        // Audio
        if let word = currentRoundWords.first(where: { $0.id == id }) {
            session.audioService.play(name: word.audioFile, rate: 1.0)
        }

        // Haptic
        HapticsManager.shared.selection()

        selectedRightId = id
        checkMatch()
    }

    private func checkMatch() {
        guard let left = selectedLeftId, let right = selectedRightId else { return }

        if left == right {
            // Match!
            matchedIds.insert(left)
            score += 10
            isSuccessMatch = true
            FeedbackCenter.correct()

            selectedLeftId = nil
            selectedRightId = nil

            // Check win condition
            if matchedIds.count == currentRoundWords.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showingCompletion = true
                    FeedbackCenter.correct()
                }
            }
        } else {
            // Mismatch
            isWrongMatch = true
            FeedbackCenter.wrong()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isWrongMatch = false
                selectedLeftId = nil
                selectedRightId = nil
            }
        }
    }

    // Subview for Cards
    struct CardView: View {
        let text: String
        let isSelected: Bool
        let isMatched: Bool
        let isWrong: Bool
        let color: Color

        var body: some View {
            Text(text)
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(backgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 2)
                )
                .shadow(color: isSelected ? color.opacity(0.4) : .clear, radius: 8)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .blur(radius: isMatched ? 1 : 0)  // Fade out matched items
                .opacity(isMatched ? 0.0 : 1.0)  // Hide matched items
                .animation(.spring(), value: isSelected)
                .animation(.easeIn, value: isMatched)
        }

        private var backgroundColor: Color {
            if isWrong { return ModernDesignSystem.Colors.error.opacity(0.2) }
            if isSelected { return color.opacity(0.2) }
            return ModernDesignSystem.Colors.surface
        }

        private var borderColor: Color {
            if isWrong { return ModernDesignSystem.Colors.error }
            if isSelected { return color }
            return ModernDesignSystem.Colors.surfaceSecondary
        }

        private var textColor: Color {
            if isWrong { return ModernDesignSystem.Colors.error }
            if isSelected { return color }
            return ModernDesignSystem.Colors.textPrimary
        }
    }
}
