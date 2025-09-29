import SwiftUI

struct ListeningChallengeGameView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentRound = 0
    @State private var score = 0
    @State private var timeRemaining: Int = 90
    @State private var gameState: GameState = .playing
    @State private var currentQuestion: ListeningQuestion?
    @State private var selectedAnswer: String?
    @State private var isPlaying = false
    @State private var showingFeedback = false
    @State private var isCorrect = false
    @State private var showingGameOver = false
    @State private var streak = 0
    @State private var feedbackMessage = ""
    @State private var xpEarned = 0
    
    enum GameState {
        case playing, paused, gameOver
    }
    
    struct ListeningQuestion: Identifiable {
        let id = UUID()
        let word: Word
        let options: [String]
        let correctAnswer: String
        let audioFile: String
    }
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Listening Challenge")
                            .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        Text("Round \(currentRound + 1)")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.7))
                    }
                    Spacer()
                    
                    // Game controls
                    HStack(spacing: 16) {
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
                    LiquidGlassStatsCard(title: "Score", value: "\(score)", icon: "star.fill", color: MTColors.funGreen)
                    LiquidGlassStatsCard(title: "Streak", value: "\(streak)", icon: "flame.fill", color: MTColors.funYellow)
                    LiquidGlassStatsCard(title: "Time", value: "\(timeRemaining)s", icon: "clock.fill", color: MTColors.funPink)
                }
                .padding(.horizontal)
                
                if let question = currentQuestion {
                    // Audio player section
                    VStack(spacing: 20) {
                        Text("Listen carefully to the word:")
                            .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        
                        // Audio button
                        Button(action: {
                            playAudio(question.audioFile)
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.3.fill")
                                    .font(.system(size: 32, weight: .medium))
                                Text(isPlaying ? "Stop" : "Play Word")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(MTColors.funBlue)
                            )
                            .shadow(color: MTColors.funBlue.opacity(0.3), radius: 12, x: 0, y: 6)
                        }
                        .buttonStyle(.plain)
                        
                        Text("Tap the correct meaning:")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.8))
                    }
                    .padding(.horizontal)
                    
                    // Answer options
                    VStack(spacing: 16) {
                        ForEach(question.options, id: \.self) { option in
                            AnswerOptionView(
                                text: option,
                                isSelected: selectedAnswer == option,
                                isCorrect: showingFeedback && option == question.correctAnswer,
                                isWrong: showingFeedback && selectedAnswer == option && option != question.correctAnswer,
                                onTap: {
                                    selectAnswer(option, correctAnswer: question.correctAnswer)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .disabled(showingFeedback)
                    
                    // Standardized feedback
                    if showingFeedback {
                        GameFeedbackView(
                            isCorrect: isCorrect,
                            message: feedbackMessage,
                            xpEarned: xpEarned,
                            correctAnswer: isCorrect ? nil : currentQuestion?.correctAnswer,
                            explanation: isCorrect ? "Great listening skills!" : "Listen carefully to the pronunciation and try again.",
                            onContinue: {
                                Task {
                                    await nextQuestion()
                                }
                            }
                        )
                    }
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .onAppear {
            Task {
                await setupGame()
            }
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
        .sheet(isPresented: $showingGameOver) {
            ListeningChallengeGameOverView(score: score, streak: streak) {
                Task {
                    await restartGame()
                }
            }
        }
    }
    
    // Game Logic
    
    private func setupGame() async {
        timeRemaining = 60
        score = 0
        streak = 0
        await loadNextQuestion()
    }
    
    private func loadNextQuestion() async {
        let animalWords = await session.dataRepository.words.filter { $0.theme == "Animals" }
        let colorWords = await session.dataRepository.words.filter { $0.theme == "Colors" }
        let numberWords = await session.dataRepository.words.filter { $0.theme == "Numbers" }
        let allWords = animalWords + colorWords + numberWords
        
        guard let randomWord = allWords.randomElement() else { return }
            
            // Create wrong options (other words from different themes)
            var wrongOptions: [String] = []
            let otherWords = allWords.filter { $0.id != randomWord.id }
            
            for _ in 0..<3 {
                if let wrongWord = otherWords.randomElement() {
                    wrongOptions.append(wrongWord.english)
                }
            }
            
            // Create question with correct and wrong answers
            var options = [randomWord.english] + wrongOptions
            options.shuffle()
            
            currentQuestion = ListeningQuestion(
                word: randomWord,
                options: options,
                correctAnswer: randomWord.english,
                audioFile: randomWord.audioFile
            )
            
            selectedAnswer = nil
            showingFeedback = false
    }
    
    private func playAudio(_ audioFile: String) {
        isPlaying = true
        session.audioService.play(name: audioFile, rate: 1.0)
        
        // Simulate playback completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isPlaying = false
        }
    }
    
    private func selectAnswer(_ answer: String, correctAnswer: String) {
        selectedAnswer = answer
        isCorrect = answer == correctAnswer
        
        if isCorrect {
            session.hapticsService.success()
            score += 10 + (streak * 2) // Bonus for streaks
            streak += 1
            feedbackMessage = "Correct! Well done!"
            xpEarned = 5 + (streak * 2)
            session.gamificationService.awardXP(xpEarned, type: .quizCompleted, description: "Listening challenge correct")
        } else {
            session.hapticsService.warning()
            streak = 0
            feedbackMessage = "Not quite right, but keep trying!"
            xpEarned = 0
        }
        
        showingFeedback = true
    }
    
    private func nextQuestion() async {
        currentQuestion = nil
        selectedAnswer = nil
        showingFeedback = false
        feedbackMessage = ""
        xpEarned = 0
        await loadNextQuestion()
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
        session.gamificationService.awardXP(xpEarned, type: .quizCompleted, description: "Listening challenge completed")
    }
    
    private func restartGame() async {
        await setupGame()
    }
}

// MARK: - Listening Challenge Stat Card
struct ListeningChallengeStatCard: View {
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

// MARK: - Answer Option View
struct AnswerOptionView: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(text)
                    .font(MTTypography.body(kidMode: false))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Spacer()
                
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(MTColors.funGreen)
                        .font(.title2)
                } else if isWrong {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
    
    private var backgroundColor: Color {
        if isCorrect {
            return MTColors.funGreen.opacity(0.2)
        } else if isWrong {
            return Color.red.opacity(0.1)
        } else if isSelected {
            return MTColors.funBlue.opacity(0.2)
        } else {
            return Color.white.opacity(0.95)
        }
    }
    
    private var textColor: Color {
        if isCorrect || isWrong {
            return MTColors.text
        } else {
            return MTColors.text
        }
    }
    
    private var shadowColor: Color {
        if isCorrect {
            return MTColors.funGreen.opacity(0.3)
        } else if isWrong {
            return Color.red.opacity(0.2)
        } else if isSelected {
            return MTColors.funBlue.opacity(0.3)
        } else {
            return MTColors.funBlue.opacity(0.1)
        }
    }
    
    private var shadowRadius: CGFloat {
        if isCorrect || isWrong || isSelected {
            return 8
        } else {
            return 4
        }
    }
    
    private var shadowOffset: CGFloat {
        if isCorrect || isWrong || isSelected {
            return 4
        } else {
            return 2
        }
    }
}

// MARK: - Listening Challenge Game Over View
struct ListeningChallengeGameOverView: View {
    let score: Int
    let streak: Int
    let onPlayAgain: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "ear.fill")
                .font(.system(size: 64))
                .foregroundColor(MTColors.funBlue)
            
            Text("Listening Challenge Complete!")
                .font(MTTypography.title(kidMode: false))
                .foregroundColor(MTColors.text)
            
            VStack(spacing: 16) {
                Text("Final Score")
                    .font(MTTypography.body(kidMode: false))
                    .foregroundColor(MTColors.text.opacity(0.7))
                Text("\(score)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(MTColors.funGreen)
                
                Text("Best Streak: \(streak)")
                    .font(MTTypography.body(kidMode: false))
                    .foregroundColor(MTColors.funYellow)
            }
            
            VStack(spacing: 16) {
                Button("Play Again") {
                    onPlayAgain()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(MTColors.funGreen)
                .controlSize(.large)
                
                Button("Exit to Hub") {
                    dismiss()
                }
                .tint(MTColors.funBlue)
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.95))
                .shadow(color: MTColors.funBlue.opacity(0.2), radius: 16, x: 0, y: 8)
        )
    }
}
