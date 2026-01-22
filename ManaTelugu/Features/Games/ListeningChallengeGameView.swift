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
    @State private var questions: [ListeningQuestion] = []
    
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
            Group {
                if session.isDarkModeActive {
                    Color.adaptiveBackground.ignoresSafeArea()
                } else {
                    ModernDesignSystem.Colors.backgroundGradient.ignoresSafeArea()
                }
            }
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Listening Challenge")
                            .font(ModernDesignSystem.Typography.title1)
                            .foregroundColor(session.isDarkModeActive ? Color.teluguTextPrimary : ModernDesignSystem.Colors.textPrimary)
                        Text("Round \(currentRound + 1)")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(session.isDarkModeActive ? Color.teluguTextSecondary : ModernDesignSystem.Colors.textPrimary.opacity(0.7))
                    }
                    Spacer()
                    
                    Button("Exit") {
                        dismiss()
                    }
                    .foregroundColor(session.isDarkModeActive ? Color.teluguAccent : ModernDesignSystem.Colors.primary)
                }
                .padding(.horizontal)
                
                // Game stats
                HStack(spacing: 32) {
                    VStack {
                        Text("Score")
                            .font(.caption)
                        Text("\(score)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    VStack {
                        Text("Streak")
                            .font(.caption)
                        Text("\(streak)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    VStack {
                        Text("Time")
                            .font(.caption)
                        Text("\(timeRemaining)s")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal)
                
                if let question = currentQuestion {
                    // Audio player section
                    VStack(spacing: 20) {
                        Text("Listen carefully to the word:")
                            .font(ModernDesignSystem.Typography.headline)
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                        
                        // Audio button
                        Button(action: {
                            HapticsService.shared.audioPlay()
                            playAudio(question.audioFile)
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.3.fill")
                                    .font(.system(size: 32, weight: .medium))
                                Text(isPlaying ? "Stop" : "Play Word")
                                    .font(ModernDesignSystem.Typography.body)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(ModernDesignSystem.Colors.primary)
                            )
                        }
                        .buttonStyle(.plain)
                        
                        Text("Tap the correct meaning:")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.8))
                    }
                    .padding(.horizontal)
                    
                    // Answer options
                    VStack(spacing: 16) {
                        ForEach(question.options, id: \.self) { option in
                            Button(action: {
                                selectAnswer(option, correctAnswer: question.correctAnswer)
                            }) {
                                Text(option)
                                    .font(ModernDesignSystem.Typography.body)
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedAnswer == option ? Color.blue.opacity(0.3) : ModernDesignSystem.Colors.surface)
                                    )
                            }
.buttonStyle(HapticPlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                } else {
                    // Loading state
                    VStack(spacing: 20) {
                        ProgressView()
                        Text("Loading question...")
                            .font(ModernDesignSystem.Typography.body)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical)
            
            // Feedback overlay
            if showingFeedback {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(isCorrect ? .green : .red)
                    
                    Text(feedbackMessage)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(isCorrect ? .green : .red)
                    
                    if isCorrect {
                        Text("+\(xpEarned) XP")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                )
                .scaleEffect(showingFeedback ? 1.0 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showingFeedback)
            }
        }
        .onAppear {
            HapticsManager.shared.impact(.light) // game start
            setupGame()
        }
        .onChange(of: showingGameOver) { _, isOver in
            if isOver {
                HapticsManager.shared.impact(.heavy)
                HapticsManager.shared.notification(.success)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Exit") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
        }
    }
    
    private func setupGame() {
        // Use only questions with audio files that exist in Resources/Sounds
        let availableQuestions: [ListeningQuestion] = [
            ListeningQuestion(
                word: Word(id: "dog", telugu: "కుక్క", transliteration: "kukka", english: "Dog", imageName: "dog", audioFile: "కుక్క.mp3", theme: "Animals"),
                options: ["Dog", "Cat", "Bird", "Fish"],
                correctAnswer: "Dog",
                audioFile: "కుక్క.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "cat", telugu: "పిల్లి", transliteration: "pilli", english: "Cat", imageName: "cat", audioFile: "పిల్లి.mp3", theme: "Animals"),
                options: ["Cat", "Dog", "Bird", "Fish"],
                correctAnswer: "Cat",
                audioFile: "పిల్లి.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "bird", telugu: "పక్షి", transliteration: "pakshi", english: "Bird", imageName: "bird", audioFile: "పక్షి.mp3", theme: "Animals"),
                options: ["Bird", "Cat", "Dog", "Fish"],
                correctAnswer: "Bird",
                audioFile: "పక్షి.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "milk", telugu: "పాలు", transliteration: "paalu", english: "Milk", imageName: "milk", audioFile: "పాలు.mp3", theme: "Food"),
                options: ["Milk", "Water", "Juice", "Tea"],
                correctAnswer: "Milk",
                audioFile: "పాలు.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "flower", telugu: "పువ్వు", transliteration: "puvvu", english: "Flower", imageName: "flower", audioFile: "పువ్వు.mp3", theme: "Nature"),
                options: ["Flower", "Fruit", "Leaf", "Tree"],
                correctAnswer: "Flower",
                audioFile: "పువ్వు.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "tree", telugu: "వృక్షం", transliteration: "vriksham", english: "Tree", imageName: "tree", audioFile: "వృక్షం.mp3", theme: "Nature"),
                options: ["Tree", "Flower", "Fruit", "Leaf"],
                correctAnswer: "Tree",
                audioFile: "వృక్షం.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "sun", telugu: "సూర్యుడు", transliteration: "sooryudu", english: "Sun", imageName: "sun", audioFile: "సూర్యుడు.mp3", theme: "Nature"),
                options: ["Sun", "Moon", "Star", "Sky"],
                correctAnswer: "Sun",
                audioFile: "సూర్యుడు.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "banana", telugu: "అరటి పండు", transliteration: "arati pandu", english: "Banana", imageName: "banana", audioFile: "అరటి పండు.mp3", theme: "Food"),
                options: ["Banana", "Apple", "Mango", "Grape"],
                correctAnswer: "Banana",
                audioFile: "అరటి పండు.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "cow", telugu: "ఆవు", transliteration: "aavu", english: "Cow", imageName: "cow", audioFile: "ఆవు.mp3", theme: "Animals"),
                options: ["Cow", "Buffalo", "Goat", "Sheep"],
                correctAnswer: "Cow",
                audioFile: "ఆవు.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "goat", telugu: "మేక", transliteration: "meka", english: "Goat", imageName: "goat", audioFile: "మేక.mp3", theme: "Animals"),
                options: ["Goat", "Cow", "Buffalo", "Sheep"],
                correctAnswer: "Goat",
                audioFile: "మేక.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "rice", telugu: "అన్నం", transliteration: "annam", english: "Rice", imageName: "rice", audioFile: "అన్నం.mp3", theme: "Food"),
                options: ["Rice", "Milk", "Water", "Soup"],
                correctAnswer: "Rice",
                audioFile: "అన్నం.mp3"
            ),
            ListeningQuestion(
                word: Word(id: "red", telugu: "ఎరుపు", transliteration: "erupu", english: "Red", imageName: "red", audioFile: "ఎరుపు.mp3", theme: "Colors"),
                options: ["Red", "Blue", "Green", "White"],
                correctAnswer: "Red",
                audioFile: "ఎరుపు.mp3"
            )
        ]
        questions = availableQuestions.shuffled()
        currentRound = 0
        score = 0
        streak = 0
        loadCurrentQuestion()
    }
    
    private func loadCurrentQuestion() {
        if currentRound < questions.count {
            currentQuestion = questions[currentRound]
        } else {
            showingGameOver = true
        }
    }
    
    private func playAudio(_ audioFile: String) {
        isPlaying = true
        session.audioService.play(name: audioFile, rate: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isPlaying = false
        }
    }
    
    private func selectAnswer(_ answer: String, correctAnswer: String) {
        selectedAnswer = answer
        isCorrect = answer == correctAnswer
        
        if isCorrect {
            FeedbackCenter.correct()
            session.audioService.play(name: "success.mp3", rate: 1.0)
            score += 10
            streak += 1
            feedbackMessage = "Correct! Well done!"
            xpEarned = 5
            session.gamificationService.awardXP(xpEarned, type: .quizCompleted, description: "Listening correct")
            session.gamificationService.onActivityCompleted()
        } else {
            FeedbackCenter.wrong()
            session.audioService.play(name: "tryagain.mp3", rate: 1.0)
            streak = 0
            feedbackMessage = "Not quite right, but keep trying!"
            xpEarned = 0
        }
        
        showingFeedback = true
        
        // Move to next question after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            nextQuestion()
        }
    }
    
    private func nextQuestion() {
        showingFeedback = false
        selectedAnswer = nil
        currentRound += 1
        loadCurrentQuestion()
    }
}
