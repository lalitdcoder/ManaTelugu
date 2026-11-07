import SwiftUI

// MARK: - Premium Games Hub View (iOS 17+ HIG Native)
struct GamesHubView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var selectedGame: String? = nil

    private let games: [GameInfo] = [
        GameInfo(
            id: "1",
            title: "Sentence Builder",
            description: "Arrange words to construct grammatically correct Telugu sentences",
            icon: "text.alignleft",
            difficulty: "Beginner",
            estimatedTime: "5 min",
            color: AppleHIGDesign.Colors.vowelColor,
            isRecommended: false
        ),
        GameInfo(
            id: "2",
            title: "Listening Challenge",
            description: "Listen to native audio and select matching Telugu terms",
            icon: "ear.fill",
            difficulty: "Intermediate",
            estimatedTime: "8 min",
            color: AppleHIGDesign.Colors.wordColor,
            isRecommended: false
        ),
        GameInfo(
            id: "3",
            title: "Letter Tracing",
            description: "Practice letter strokes and handwriting accuracy",
            icon: "pencil.tip.crop.circle.fill",
            difficulty: "Beginner",
            estimatedTime: "10 min",
            color: AppleHIGDesign.TeluguPalette.terracotta,
            isRecommended: false
        ),
        GameInfo(
            id: "4",
            title: "Sound Match",
            description: "Match spoken Telugu phonemes with correct script characters",
            icon: "waveform",
            difficulty: "Intermediate",
            estimatedTime: "6 min",
            color: AppleHIGDesign.Colors.consonantColor,
            isRecommended: false
        ),
        GameInfo(
            id: "5",
            title: "Word Match",
            description: "Match English vocabulary with corresponding Telugu words",
            icon: "arrow.left.arrow.right",
            difficulty: "Beginner",
            estimatedTime: "5 min",
            color: AppleHIGDesign.Colors.primary,
            isRecommended: true
        ),
    ]

    var body: some View {
        ZStack {
            // Adaptive system background (Light/Dark aware)
            AppleHIGDesign.Colors.systemGroupedBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.lg) {
                    // Hero Header Banner
                    gamesHeroBanner

                    // Games Grid
                    VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.sm) {
                        Text("Available Games")
                            .font(AppleHIGDesign.Typography.title3)
                            .foregroundColor(AppleHIGDesign.Colors.label)

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: AppleHIGDesign.Spacing.md),
                                GridItem(.flexible(), spacing: AppleHIGDesign.Spacing.md),
                            ],
                            spacing: AppleHIGDesign.Spacing.md
                        ) {
                            ForEach(games) { game in
                                Button {
                                    AppleHIGDesign.Haptics.medium()
                                    selectedGame = game.id
                                } label: {
                                    NativeGameCard(game: game)
                                }
                                .buttonStyle(NativeCardButtonStyle())
                            }
                        }
                    }

                    Spacer().frame(height: 60)
                }
                .padding(.horizontal, AppleHIGDesign.Spacing.screenMargin)
                .padding(.top, AppleHIGDesign.Spacing.sm)
            }
        }
        .navigationTitle("Practice Games")
        .navigationBarTitleDisplayMode(.inline)
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

    // MARK: - Games Hero Banner
    private var gamesHeroBanner: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.xxl)
                .fill(AppleHIGDesign.TeluguPalette.heroGradient)
                .shadow(color: AppleHIGDesign.TeluguPalette.midnightIndigo.opacity(0.25), radius: 10, x: 0, y: 5)

            // Watermark
            Text("ఆట")
                .font(.system(size: 140, weight: .bold))
                .foregroundColor(.white.opacity(0.08))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                .offset(x: 15, y: 15)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.xs) {
                Text("INTERACTIVE LEARNING")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.2)
                    .foregroundColor(.white.opacity(0.80))

                Text("Practice Games • ఆటలు")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text("Reinforce your Telugu knowledge through fun, engaging mini-games")
                    .font(AppleHIGDesign.Typography.subheadline)
                    .foregroundColor(.white.opacity(0.80))
            }
            .padding(AppleHIGDesign.Spacing.xl)
        }
        .frame(minHeight: 150)
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

// MARK: - Native Game Card
struct NativeGameCard: View {
    let game: GameInfo

    var body: some View {
        AppleHIGCard(style: .elevated) {
            VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.xs) {
                // Top row: Icon and Time tag
                HStack(alignment: .top) {
                    Image(systemName: game.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(game.color)
                        .frame(width: 42, height: 42)
                        .background(game.color.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.md))

                    Spacer()

                    Text(game.estimatedTime)
                        .font(AppleHIGDesign.Typography.caption2.weight(.bold))
                        .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(AppleHIGDesign.Colors.secondarySystemFill)
                        .clipShape(Capsule())
                }

                Spacer().frame(height: 2)

                // Title
                Text(game.title)
                    .font(AppleHIGDesign.Typography.headline)
                    .foregroundColor(AppleHIGDesign.Colors.label)
                    .lineLimit(1)

                // Description
                Text(game.description)
                    .font(AppleHIGDesign.Typography.caption1)
                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                    .lineLimit(2)

                Spacer(minLength: 4)

                // Difficulty Tag
                HStack {
                    Text(game.difficulty)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(game.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(game.color.opacity(0.12))
                        .clipShape(Capsule())

                    Spacer()
                }
            }
            .padding(AppleHIGDesign.Spacing.xs)
        }
        .frame(height: 175)
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

// MARK: - Word Match Game View (HIG Native Refactored)
struct WordMatchGameView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss

    @State private var allWords: [Word] = []
    @State private var currentRoundWords: [Word] = []
    @State private var leftColumnItems: [Word] = []
    @State private var rightColumnItems: [Word] = []
    @State private var selectedLeftId: String? = nil
    @State private var selectedRightId: String? = nil
    @State private var matchedIds: Set<String> = []
    @State private var isWrongMatch = false
    @State private var isSuccessMatch = false
    @State private var showingCompletion = false
    @State private var score = 0

    private let wordsPerRound = Int.random(in: 5...6)

    var body: some View {
        ZStack {
            AppleHIGDesign.Colors.systemGroupedBackground
                .ignoresSafeArea()

            VStack(spacing: AppleHIGDesign.Spacing.md) {
                // Top Header Score
                HStack {
                    Text("Word Match • పదాల జత")
                        .font(AppleHIGDesign.Typography.title3)
                        .foregroundColor(AppleHIGDesign.Colors.label)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppleHIGDesign.Colors.primary)
                        Text("Score: \(score)")
                            .font(AppleHIGDesign.Typography.headline)
                            .foregroundColor(AppleHIGDesign.Colors.primary)
                    }
                }
                .padding(.horizontal, AppleHIGDesign.Spacing.screenMargin)

                if !currentRoundWords.isEmpty && !showingCompletion {
                    HStack(spacing: AppleHIGDesign.Spacing.md) {
                        // Left Column (English)
                        VStack(spacing: AppleHIGDesign.Spacing.sm) {
                            ForEach(leftColumnItems, id: \.id) { word in
                                MatchTileView(
                                    text: word.english,
                                    subtext: nil,
                                    isSelected: selectedLeftId == word.id,
                                    isMatched: matchedIds.contains(word.id),
                                    isWrong: isWrongMatch && selectedLeftId == word.id,
                                    color: AppleHIGDesign.Colors.vowelColor
                                )
                                .onTapGesture {
                                    handleLeftTap(word.id)
                                }
                                .disabled(matchedIds.contains(word.id))
                            }
                        }

                        // Right Column (Telugu)
                        VStack(spacing: AppleHIGDesign.Spacing.sm) {
                            ForEach(rightColumnItems, id: \.id) { word in
                                MatchTileView(
                                    text: word.telugu,
                                    subtext: word.transliteration,
                                    isSelected: selectedRightId == word.id,
                                    isMatched: matchedIds.contains(word.id),
                                    isWrong: isWrongMatch && selectedRightId == word.id,
                                    color: AppleHIGDesign.Colors.consonantColor
                                )
                                .onTapGesture {
                                    handleRightTap(word.id)
                                }
                                .disabled(matchedIds.contains(word.id))
                            }
                        }
                    }
                    .padding(.horizontal, AppleHIGDesign.Spacing.screenMargin)
                } else if showingCompletion {
                    AppleHIGCard(style: .elevated) {
                        VStack(spacing: AppleHIGDesign.Spacing.md) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 64, weight: .semibold))
                                .foregroundColor(AppleHIGDesign.Colors.consonantColor)

                            Text("Round Complete!")
                                .font(AppleHIGDesign.Typography.title2)
                                .foregroundColor(AppleHIGDesign.Colors.label)

                            Text("You matched all vocabulary pairs successfully!")
                                .font(AppleHIGDesign.Typography.body)
                                .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                                .multilineTextAlignment(.center)

                            VStack(spacing: 2) {
                                Text("Final Round Score")
                                    .font(AppleHIGDesign.Typography.caption1)
                                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)

                                Text("\(score)")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(AppleHIGDesign.Colors.primary)
                            }
                            .padding(AppleHIGDesign.Spacing.md)
                            .background(AppleHIGDesign.Colors.primary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.md))

                            Button("Next Round") {
                                startNewRound()
                            }
                            .buttonStyle(AppleHIGButtonStyle(style: .primary, size: .medium))
                        }
                        .padding(AppleHIGDesign.Spacing.md)
                    }
                    .padding(.horizontal, AppleHIGDesign.Spacing.screenMargin)
                }

                Spacer()
            }
            .padding(.top, AppleHIGDesign.Spacing.sm)
        }
        .onAppear {
            setupGame()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(AppleHIGDesign.Colors.primary)
            }
        }
    }

    private func setupGame() {
        allWords = session.dataRepository.words.shuffled()
        startNewRound()
    }

    private func startNewRound() {
        selectedLeftId = nil
        selectedRightId = nil
        matchedIds = []
        isWrongMatch = false
        isSuccessMatch = false
        showingCompletion = false

        let count = min(allWords.count, wordsPerRound)
        guard count > 0 else { return }

        currentRoundWords = Array(allWords.prefix(count))
        allWords.shuffle()

        leftColumnItems = currentRoundWords.shuffled()
        rightColumnItems = currentRoundWords.shuffled()
    }

    private func handleLeftTap(_ id: String) {
        guard !matchedIds.contains(id) else { return }
        AppleHIGDesign.Haptics.selection()
        selectedLeftId = id
        checkMatch()
    }

    private func handleRightTap(_ id: String) {
        guard !matchedIds.contains(id) else { return }
        if let word = currentRoundWords.first(where: { $0.id == id }) {
            session.audioService.play(name: word.audioFile, rate: 1.0)
        }
        AppleHIGDesign.Haptics.selection()
        selectedRightId = id
        checkMatch()
    }

    private func checkMatch() {
        guard let left = selectedLeftId, let right = selectedRightId else { return }

        if left == right {
            matchedIds.insert(left)
            score += 10
            isSuccessMatch = true
            AppleHIGDesign.Haptics.success()
            selectedLeftId = nil
            selectedRightId = nil

            if matchedIds.count == currentRoundWords.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    showingCompletion = true
                }
            }
        } else {
            isWrongMatch = true
            AppleHIGDesign.Haptics.error()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isWrongMatch = false
                selectedLeftId = nil
                selectedRightId = nil
            }
        }
    }
}

// MARK: - Match Tile View
struct MatchTileView: View {
    let text: String
    let subtext: String?
    let isSelected: Bool
    let isMatched: Bool
    let isWrong: Bool
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(text)
                .font(AppleHIGDesign.Typography.headline)
                .foregroundColor(textColor)

            if let subtext = subtext {
                Text(subtext)
                    .font(AppleHIGDesign.Typography.caption2)
                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: subtext != nil ? 65 : 55)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.md)
                .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
        )
        .scaleEffect(isSelected ? 1.04 : 1.0)
        .opacity(isMatched ? 0.0 : 1.0)
        .animation(AppleHIGDesign.Animation.smooth, value: isSelected)
        .animation(AppleHIGDesign.Animation.smooth, value: isMatched)
    }

    private var backgroundColor: Color {
        if isWrong { return AppleHIGDesign.Colors.systemRed.opacity(0.15) }
        if isSelected { return color.opacity(0.12) }
        return AppleHIGDesign.Colors.secondarySystemGroupedBackground
    }

    private var borderColor: Color {
        if isWrong { return AppleHIGDesign.Colors.systemRed }
        if isSelected { return color }
        return AppleHIGDesign.Colors.separator.opacity(0.5)
    }

    private var textColor: Color {
        if isWrong { return AppleHIGDesign.Colors.systemRed }
        if isSelected { return color }
        return AppleHIGDesign.Colors.label
    }
}
