import SwiftUI

struct CardMatchGameView: View {
    @EnvironmentObject var session: AppSession
    @State private var words: [Word] = []
    @State private var cards: [Card] = []
    @State private var flippedIndices: Set<Int> = []
    @State private var matchedIndices: Set<Int> = []
    @State private var moves = 0
    @State private var gameCompleted = false
    
    struct Card: Identifiable {
        let id = UUID()
        let word: Word
        let isTelugu: Bool  // true for Telugu side, false for English side
    }
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            VStack(spacing: MTSpacing.large) {
            // Header with moves counter
            HStack {
                Text("Moves: \(moves)")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .fontWeight(.bold)
                
                Spacer()
                
                if gameCompleted {
                    Text("Completed!")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .fontWeight(.bold)
                        .foregroundColor(MTColors.success)
                }
            }
            .padding(.horizontal)
            
            // Game board
            if !cards.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: MTSpacing.medium) {
                    ForEach(cards.indices, id: \.self) { index in
                        let card = cards[index]
                        let isFlipped = flippedIndices.contains(index)
                        let isMatched = matchedIndices.contains(index)
                        
                        CardMatchCardView(
                            card: card,
                            isFlipped: isFlipped,
                            isMatched: isMatched
                        )
                        .onTapGesture {
                            flipCard(at: index)
                        }
                        .disabled(isMatched || isFlipped || flippedIndices.count >= 2)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("Loading game...")
                    .font(MTTypography.body())
                    .foregroundColor(MTColors.text)
            }
            
            // Reset button
            Button(action: resetGame) {
                Text("Reset Game")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, MTSpacing.large)
                    .padding(.vertical, MTSpacing.medium)
                    .background(MTColors.primary)
                    .cornerRadius(30)
            }
            
            Spacer()
            }
        }
        .onAppear {
            Task {
                await loadData()
                setupGame()
            }
        }
        .navigationTitle("Card Match")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func loadData() async {
        words = await session.dataRepository.words().prefix(8).map { $0 }
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
                    session.hapticsService.success()
                    
                    // Award XP for successful match
                    session.awardXP(10)
                    
                    // Check if game is completed
                    if matchedIndices.count == cards.count {
                        gameCompleted = true
                        // Award bonus XP for completing the game
                        session.awardXP(50)
                    }
                } else {
                    session.hapticsService.warning()
                }
                
                // Reset flipped indices
                flippedIndices = []
            }
        }
    }
    
    private func resetGame() {
        setupGame()
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
                    .fill(isMatched ? MTColors.success.opacity(0.05) : Color.clear)
                    .aspectRatio(1, contentMode: .fit)
            }
            
            if isFlipped || isMatched {
                VStack(spacing: MTSpacing.small) {
                    Text(card.isTelugu ? card.word.telugu : card.word.english)
                        .font(card.isTelugu ? .title : .body)
                        .fontWeight(.semibold)
                        .foregroundColor(MTColors.text)
                        .multilineTextAlignment(.center)
                    
                    if !card.isTelugu {
                        Text(card.word.transliteration)
                            .font(.caption)
                            .foregroundColor(MTColors.text.opacity(0.7))
                    }
                }
                .padding(MTSpacing.small)
            } else {
                Image(systemName: "questionmark")
                    .font(.title)
                    .foregroundColor(MTColors.text.opacity(0.5))
            }
        }
        .scaleEffect(isMatched ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isFlipped)
    }
}