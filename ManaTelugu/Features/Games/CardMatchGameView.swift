import SwiftUI

struct CardMatchGameView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var words: [Word] = []
    @State private var cards: [Card] = []
    @State private var flippedIndices: Set<Int> = []
    @State private var matchedIndices: Set<Int> = []
    @State private var moves = 0
    @State private var gameCompleted = false
    @State private var showHeartDepleted = false

    struct Card: Identifiable {
        let id = UUID()
        let word: Word
        let isTelugu: Bool  // true for Telugu side, false for English side
    }

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

            VStack(spacing: ModernDesignSystem.Spacing.lg) {
                // Header with moves counter
                HStack {
                    Text("Moves: \(moves)")
                        .font(ModernDesignSystem.Typography.body)
                        .fontWeight(.bold)

                    Spacer()

                    if gameCompleted {
                        Text("Completed!")
                            .font(ModernDesignSystem.Typography.body)
                            .fontWeight(.bold)
                            .foregroundColor(ModernDesignSystem.Colors.success)
                    }
                }
                .padding(.horizontal)

                // Game board
                if !cards.isEmpty {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 3),
                        spacing: ModernDesignSystem.Spacing.md
                    ) {
                        ForEach(cards.indices, id: \.self) { index in
                            let card = cards[index]
                            let isFlipped = flippedIndices.contains(index)
                            let isMatched = matchedIndices.contains(index)

                            // Check if card can be tapped (not already matched, not already flipped, and not 2 cards already flipped)
                            let canTap = !isMatched && !isFlipped && flippedIndices.count < 2

                            CardMatchCardView(
                                card: card,
                                isFlipped: isFlipped,
                                isMatched: isMatched
                            )
                            .onTapGesture {
                                // Only respond to tap if card can be tapped
                                if canTap {
                                    HapticsManager.shared.impact(.light)
                                    flipCard(at: index)
                                }
                            }
                            // Don't use .disabled() as it prevents tap gestures from working
                            .opacity(canTap ? 1.0 : 0.6)  // Visual feedback instead
                        }
                    }
                    .padding(.horizontal)
                } else {
                    Text("Loading game...")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                }

                // Reset button
                Button(action: {
                    HapticsService.shared.importantAction()
                    resetGame()
                }) {
                    Text("Reset Game")
                        .font(ModernDesignSystem.Typography.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, ModernDesignSystem.Spacing.lg)
                        .padding(.vertical, ModernDesignSystem.Spacing.md)
                        .background(ModernDesignSystem.Colors.primary)
                        .cornerRadius(30)
                }

                Spacer()
            }
        }
        .onAppear {
            HapticsManager.shared.impact(.light)  // game start
            loadData()
            setupGame()
        }
        .navigationTitle("Card Match")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Exit") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $showHeartDepleted) {
            HeartDepletedView(
                onRefill: {
                    showHeartDepleted = false
                },
                onWait: {
                    showHeartDepleted = false
                    dismiss()
                }
            )
            .environmentObject(session)
        }
    }

    private func loadData() {
        words = Array(session.dataRepository.words.prefix(8))
    }

    private func setupGame() {
        // Create pairs of cards
        var gameCards: [Card] = []

        for word in words {
            gameCards.append(Card(word: word, isTelugu: true))
            gameCards.append(Card(word: word, isTelugu: false))
        }

        cards = gameCards.shuffled()
        flippedIndices = []
        matchedIndices = []
        moves = 0
        gameCompleted = false
    }

    private func flipCard(at index: Int) {
        // Don't flip if already flipped or matched
        guard !flippedIndices.contains(index) && !matchedIndices.contains(index) else { return }

        // Don't flip if two cards are already flipped
        guard flippedIndices.count < 2 else { return }

        flippedIndices.insert(index)

        // Check for match when two cards are flipped
        if flippedIndices.count == 2 {
            moves += 1
            checkForMatch()
        }
    }

    private func checkForMatch() {
        let flippedCards = flippedIndices.map { cards[$0] }

        if flippedCards.count == 2 {
            let card1 = flippedCards[0]
            let card2 = flippedCards[1]

            // Check if they're a matching pair (same word, different sides)
            let isMatch = card1.word.id == card2.word.id && card1.isTelugu != card2.isTelugu

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if isMatch {
                    // Add to matched indices
                    matchedIndices.formUnion(flippedIndices)
                    HapticsManager.shared.notification(.success)

                    // Award XP for successful match
                    session.gamificationService.awardXP(
                        10, type: .quizCompleted, description: "Card match success")
                    session.gamificationService.onActivityCompleted()

                    // Check if game is completed
                    if matchedIndices.count == cards.count {
                        gameCompleted = true
                        HapticsManager.shared.impact(.heavy)
                        HapticsManager.shared.notification(.success)
                        // Award bonus XP for completing the game
                        session.gamificationService.awardXP(
                            50, type: .quizCompleted, description: "Game completed")
                        session.gamificationService.onActivityCompleted()
                    }
                } else {
                    HapticsManager.shared.notification(.error)
                    // Deduct heart for mismatch
                    session.deductHeart()
                    if session.hearts == 0 {
                        showHeartDepleted = true
                    }
                }

                // Reset flipped indices
                flippedIndices = []
            }
        }
    }

    private func resetGame() {
        if session.hearts > 0 {
            setupGame()
        } else {
            showHeartDepleted = true
        }
    }
}

struct CardMatchCardView: View {
    let card: CardMatchGameView.Card
    let isFlipped: Bool
    let isMatched: Bool

    var body: some View {
        ZStack {
            LiquidGlassView(
                intensity: 0.1,
                cornerRadius: 22,
                padding: 0
            ) {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(isMatched ? ModernDesignSystem.Colors.success.opacity(0.05) : Color.clear)
                    .aspectRatio(1, contentMode: .fit)
            }

            if isFlipped || isMatched {
                VStack(spacing: ModernDesignSystem.Spacing.sm) {
                    Text(card.isTelugu ? card.word.telugu : card.word.english)
                        .font(card.isTelugu ? .title : .body)
                        .fontWeight(.semibold)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                        .multilineTextAlignment(.center)

                    if !card.isTelugu {
                        Text(card.word.transliteration)
                            .font(.caption)
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.7))
                    }
                }
                .padding(ModernDesignSystem.Spacing.sm)
            } else {
                Image(systemName: "questionmark")
                    .font(.title)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.5))
            }
        }
        .scaleEffect(isMatched ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isFlipped)
    }
}
