import SwiftUI

struct SentenceBuilderGameView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentLevel = 1
    @State private var score = 0
    @State private var currentSentence: Sentence?
    @State private var selectedWords: [String] = []
    @State private var gameState: GameState = .playing
    @State private var showingHint = false
    @State private var timeRemaining: Int = 120
    @State private var showingGameOver = false
    
    enum GameState {
        case playing, paused, gameOver
    }
    
    struct Sentence: Identifiable {
        let id = UUID()
        let telugu: String
        let english: String
        let words: [String]
        let difficulty: Int // 1-3: Simple, Medium, Complex
        let category: String
    }
    
    let sentences: [Sentence] = [
        // Level 1 - Simple sentences (ages 4-8)
        Sentence(telugu: "నేను బడికి వెళ్తున్నాను", english: "I am going to school", words: ["నేను", "బడికి", "వెళ్తున్నాను"], difficulty: 1, category: "Daily Activities"),
        Sentence(telugu: "మా ఇంట్లో పిల్లి ఉంది", english: "There is a cat in our house", words: ["మా", "ఇంట్లో", "పిల్లి", "ఉంది"], difficulty: 1, category: "Family & Home"),
        Sentence(telugu: "నాకు నీళ్లు కావాలి", english: "I want water", words: ["నాకు", "నీళ్లు", "కావాలి"], difficulty: 1, category: "Basic Needs"),
        
        // Level 2 - Medium sentences (ages 9-12)
        Sentence(telugu: "రమేష్ మంచి విద్యార్థి", english: "Ramesh is a good student", words: ["రమేష్", "మంచి", "విద్యార్థి"], difficulty: 2, category: "Education"),
        Sentence(telugu: "మేము సినిమా చూస్తున్నాము", english: "We are watching a movie", words: ["మేము", "సినిమా", "చూస్తున్నాము"], difficulty: 2, category: "Entertainment"),
        Sentence(telugu: "ఈ పుస్తకం చాలా మంచిది", english: "This book is very good", words: ["ఈ", "పుస్తకం", "చాలా", "మంచిది"], difficulty: 2, category: "Objects"),
        
        // Level 3 - Complex sentences (ages 13-16)
        Sentence(telugu: "నేను రేపు ఉదయం తొమ్మిది గంటలకు ఆఫీసుకు వెళ్తాను", english: "I will go to the office tomorrow morning at nine o'clock", words: ["నేను", "రేపు", "ఉదయం", "తొమ్మిది", "గంటలకు", "ఆఫీసుకు", "వెళ్తాను"], difficulty: 3, category: "Advanced"),
        Sentence(telugu: "మీరు ఎప్పుడు భారతదేశానికి వచ్చారు?", english: "When did you come to India?", words: ["మీరు", "ఎప్పుడు", "భారతదేశానికి", "వచ్చారు?"], difficulty: 3, category: "Questions"),
        Sentence(telugu: "నాకు తెలుగు భాష నేర్చుకోవడం చాలా ఇష్టం", english: "I really like learning the Telugu language", words: ["నాకు", "తెలుగు", "భాష", "నేర్చుకోవడం", "చాలా", "ఇష్టం"], difficulty: 3, category: "Language Learning")
    ]
    
    var body: some View {
        ZStack {
            // Gentle pastel background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.97, green: 0.98, blue: 1.0), MTColors.funBlue.opacity(0.10), MTColors.funGreen.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sentence Builder")
                            .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        Text("Level \(currentLevel)")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.7))
                    }
                    Spacer()
                    
                    // Game controls
                    HStack(spacing: 16) {
                        // Hint button
                        Button(action: { showingHint.toggle() }) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(MTColors.funYellow)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.9))
                                )
                        }
                        .buttonStyle(.plain)
                        
                        // Pause button
                        Button(action: { gameState = .paused }) {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(MTColors.funBlue)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.9))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                
                // Game stats
                HStack(spacing: 32) {
                    SentenceBuilderStatCard(title: "Score", value: "\(score)", color: MTColors.funGreen)
                    SentenceBuilderStatCard(title: "Level", value: "\(currentLevel)", color: MTColors.funBlue)
                    SentenceBuilderStatCard(title: "Time", value: "\(timeRemaining)s", color: MTColors.funPink)
                }
                .padding(.horizontal)
                
                if let sentence = currentSentence {
                    // Target sentence display
                    VStack(spacing: 16) {
                        Text("Build this sentence:")
                            .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        
                        Text(sentence.english)
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(MTColors.funBlue.opacity(0.15))
                            )
                    }
                    .padding(.horizontal)
                    
                    // Current sentence being built
                    VStack(spacing: 16) {
                        Text("Your sentence:")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        
                        if selectedWords.isEmpty {
                            Text("Tap words below to build your sentence")
                                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text.opacity(0.5))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.1))
                                )
                        } else {
                            HStack(spacing: 8) {
                                ForEach(selectedWords, id: \.self) { word in
                                    Text(word)
                                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(MTColors.funGreen.opacity(0.2))
                                        )
                                        .onTapGesture {
                                            removeWord(word)
                                        }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.9))
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Available words
                    VStack(spacing: 16) {
                        Text("Available words:")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            ForEach(sentence.words, id: \.self) { word in
                                if !selectedWords.contains(word) {
                                    WordCardView(
                                        word: word,
                                        onTap: { addWord(word) }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action buttons
                    HStack(spacing: 20) {
                        Button("Clear") {
                            selectedWords.removeAll()
                            session.hapticsService.lightImpact()
                        }
                        .buttonStyle(.bordered)
                        .tint(MTColors.funPink)
                        .controlSize(.large)
                        
                        Button("Check") {
                            checkSentence()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(MTColors.funGreen)
                        .controlSize(.large)
                        .disabled(selectedWords.isEmpty)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .onAppear {
            setupGame()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if gameState == .playing {
                updateTimer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Exit") {
                    dismiss()
                }
                .foregroundColor(MTColors.funBlue)
            }
        }
        .sheet(isPresented: $showingHint) {
            HintView(sentence: currentSentence)
        }
        .sheet(isPresented: $showingGameOver) {
            SentenceBuilderGameOverView(score: score, level: currentLevel, onPlayAgain: restartGame)
        }
    }
    
    private func setupGame() {
        currentLevel = 1
        score = 0
        timeRemaining = 120
        selectedWords.removeAll()
        currentSentence = sentences.first { $0.difficulty == currentLevel }
        gameState = .playing
    }
    
    private func addWord(_ word: String) {
        selectedWords.append(word)
        session.hapticsService.lightImpact()
    }
    
    private func removeWord(_ word: String) {
        if let index = selectedWords.firstIndex(of: word) {
            selectedWords.remove(at: index)
            session.hapticsService.lightImpact()
        }
    }
    
    private func checkSentence() {
        guard let sentence = currentSentence else { return }
        
        let isCorrect = selectedWords == sentence.words
        
        if isCorrect {
            session.hapticsService.success()
            score += currentLevel * 10
            nextLevel()
        } else {
            session.hapticsService.warning()
            // Show correct answer briefly
            withAnimation(.easeInOut(duration: 0.5)) {
                selectedWords = sentence.words
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                selectedWords.removeAll()
            }
        }
    }
    
    private func nextLevel() {
        if currentLevel < 3 {
            currentLevel += 1
            currentSentence = sentences.first { $0.difficulty == currentLevel }
            selectedWords.removeAll()
        } else {
            // Game completed
            endGame()
        }
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            endGame()
        }
    }
    
    private func endGame() {
        gameState = .gameOver
        showingGameOver = true
        
        // Award XP based on score
        let xpEarned = score / 2
        session.awardXP(xpEarned)
    }
    
    private func restartGame() {
        setupGame()
        showingGameOver = false
    }
}

// MARK: - Sentence Builder Stat Card
struct SentenceBuilderStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(MTTypography.heading(kidMode: false))
                .foregroundColor(color)
                .fontWeight(.bold)
            Text(title)
                .font(MTTypography.caption(kidMode: false))
                .foregroundColor(MTColors.text.opacity(0.7))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .shadow(color: color.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Word Card View
struct WordCardView: View {
    let word: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(word)
                .font(MTTypography.body(kidMode: false))
                .foregroundColor(MTColors.text)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.95))
                        .shadow(color: MTColors.funBlue.opacity(0.15), radius: 4, x: 0, y: 2)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Hint View
struct HintView: View {
    let sentence: SentenceBuilderGameView.Sentence?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 64))
                .foregroundColor(MTColors.funYellow)
            
            Text("Hint")
                .font(MTTypography.title(kidMode: false))
                .foregroundColor(MTColors.text)
            
            if let sentence = sentence {
                VStack(spacing: 16) {
                    Text("The sentence has \(sentence.words.count) words")
                        .font(MTTypography.body(kidMode: false))
                        .foregroundColor(MTColors.text)
                    
                    Text("Category: \(sentence.category)")
                        .font(MTTypography.caption(kidMode: false))
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
            }
            
            Button("Got it!") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(MTColors.funGreen)
            .controlSize(.large)
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.95))
                .shadow(color: MTColors.funYellow.opacity(0.2), radius: 16, x: 0, y: 8)
        )
    }
}

// MARK: - Sentence Builder Game Over View
struct SentenceBuilderGameOverView: View {
    let score: Int
    let level: Int
    let onPlayAgain: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "star.fill")
                .font(.system(size: 64))
                .foregroundColor(MTColors.funYellow)
            
            Text("Game Complete!")
                .font(MTTypography.title(kidMode: false))
                .foregroundColor(MTColors.text)
            
            VStack(spacing: 16) {
                Text("Final Score")
                    .font(MTTypography.body(kidMode: false))
                    .foregroundColor(MTColors.text.opacity(0.7))
                Text("\(score)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(MTColors.funGreen)
                
                Text("Level reached: \(level)")
                    .font(MTTypography.body(kidMode: false))
                    .foregroundColor(MTColors.funBlue)
            }
            
            VStack(spacing: 16) {
                Button("Play Again") {
                    onPlayAgain()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(MTColors.funGreen)
                .controlSize(.large)
                
                Button("Exit") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                .tint(MTColors.funBlue)
                .controlSize(.large)
            }
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.95))
                .shadow(color: MTColors.funBlue.opacity(0.2), radius: 16, x: 0, y: 8)
        )
    }
}
