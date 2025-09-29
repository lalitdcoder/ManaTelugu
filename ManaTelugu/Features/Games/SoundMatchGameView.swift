import SwiftUI

// Helper struct for predefined sound match questions
struct SoundMatchQuestion {
    let audioText: String
    let audioFile: String
    let options: [(telugu: String, transliteration: String)]
    let correctAnswer: String
}

struct SoundMatchGameView: View {
    @EnvironmentObject var session: AppSession
    @State private var letters: [Letter] = []
    @State private var words: [Word] = []
    @State private var quizItems: [QuizItem] = []
    @State private var currentQuizIndex = 0
    @State private var questionData: [String: SoundMatchQuestion] = [:] // Store question data for display
    @State private var selectedOption: String?
    @State private var isPlaying = false
    @State private var showingFeedback = false
    @State private var isCorrect = false
    @State private var feedbackMessage = ""
    @State private var xpEarned = 0
    @State private var score = 0
    @State private var timeRemaining = 60
    
    var currentQuizItem: QuizItem? {
        guard currentQuizIndex < quizItems.count else { return nil }
        return quizItems[currentQuizIndex]
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Enhanced background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
            // Header with score and timer
            HStack {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(score)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.red)
                    Text("\(timeRemaining)s")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)
            
            if let quizItem = currentQuizItem {
                // Question area
                VStack(spacing: 16) {
                    Text("What sound did you hear?")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        isPlaying = true
                        session.audioService.play(name: quizItem.prompt, rate: 1.0)
                        
                        // Simulate playback completion
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isPlaying = false
                        }
                    }) {
                        Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                
                // Options
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(quizItem.options, id: \.self) { optionId in
                        let (displayText, isCorrect) = displayTextAndCorrectness(for: optionId, quizItem: quizItem)
                        
                        Button(action: {
                            handleOptionSelection(optionId: optionId, isCorrect: isCorrect)
                        }) {
                            Text(displayText)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    selectedOption == optionId ?
                                    (isCorrect ? Color.green : Color.orange) :
                                    Color.gray.opacity(0.1)
                                )
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                        .disabled(selectedOption != nil)
                        .opacity(selectedOption != nil && selectedOption != optionId && isCorrect ? 1.0 : 1.0)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("Loading quiz...")
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            // Standardized feedback
            if showingFeedback {
                GameFeedbackView(
                    isCorrect: isCorrect,
                    message: feedbackMessage,
                    xpEarned: xpEarned,
                    correctAnswer: isCorrect ? nil : currentQuizItem?.correctId,
                    explanation: isCorrect ? "Great job recognizing the Telugu sound!" : "Listen carefully to the pronunciation and try again.",
                    onContinue: moveToNextQuestion
                )
            }
            
            Spacer()
            }
        }
        .onAppear {
            Task {
                await loadData()
                startNewGame()
            }
        }
        .onReceive(timer) { _ in
            guard isPlaying else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Game over
                timer.upstream.connect().cancel()
            }
        }
        .navigationTitle("Sound Match")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func loadData() async {
        letters = await session.dataRepository.letters
        words = await session.dataRepository.words
        
        // Create sample quiz items
        createQuizItems()
    }
    
    private func createQuizItems() {
        var items: [QuizItem] = []
        
        // Predefined Telugu sound matching questions
        let soundMatchQuestions = [
            // Basic vowels
            SoundMatchQuestion(
                audioText: "అ",
                audioFile: "అ.mp3",
                options: [
                    ("అ", "a"),
                    ("ఆ", "aa"),
                    ("ఇ", "i"),
                    ("ఉ", "u")
                ],
                correctAnswer: "అ"
            ),
            SoundMatchQuestion(
                audioText: "ఇ",
                audioFile: "ఇ.mp3",
                options: [
                    ("ఇ", "i"),
                    ("ఈ", "ii"),
                    ("ఉ", "u"),
                    ("ఎ", "e")
                ],
                correctAnswer: "ఇ"
            ),
            
            // Basic consonants
            SoundMatchQuestion(
                audioText: "క",
                audioFile: "క.mp3",
                options: [
                    ("క", "ka"),
                    ("గ", "ga"),
                    ("ఖ", "kha"),
                    ("చ", "cha")
                ],
                correctAnswer: "క"
            ),
            SoundMatchQuestion(
                audioText: "ప",
                audioFile: "ప.mp3",
                options: [
                    ("ప", "pa"),
                    ("బ", "ba"),
                    ("ఫ", "pha"),
                    ("మ", "ma")
                ],
                correctAnswer: "ప"
            ),
            SoundMatchQuestion(
                audioText: "మ",
                audioFile: "మ.mp3",
                options: [
                    ("మ", "ma"),
                    ("న", "na"),
                    ("వ", "va"),
                    ("ల", "la")
                ],
                correctAnswer: "మ"
            ),
            
            // Names and common words
            SoundMatchQuestion(
                audioText: "రామ",
                audioFile: "రామ.mp3",
                options: [
                    ("రామ", "rāma"),
                    ("కృష్ణ", "kṛṣṇa"),
                    ("సీత", "sīta"),
                    ("హనుమాన్", "hanumān")
                ],
                correctAnswer: "రామ"
            ),
            SoundMatchQuestion(
                audioText: "అన్నం",
                audioFile: "అన్నం.mp3",
                options: [
                    ("అన్నం", "annaṁ - rice"),
                    ("పాలు", "pālu - milk"),
                    ("నీరు", "nīru - water"),
                    ("రసం", "rasam - soup")
                ],
                correctAnswer: "అన్నం"
            ),
            SoundMatchQuestion(
                audioText: "పాలు",
                audioFile: "పాలు.mp3",
                options: [
                    ("పాలు", "pālu - milk"),
                    ("కాఫీ", "kāphī - coffee"),
                    ("టీ", "ṭī - tea"),
                    ("నీరు", "nīru - water")
                ],
                correctAnswer: "పాలు"
            ),
            
            // Animals
            SoundMatchQuestion(
                audioText: "కుక్క",
                audioFile: "కుక్క.mp3",
                options: [
                    ("కుక్క", "kukka - dog"),
                    ("పిల్లి", "pilli - cat"),
                    ("కోడి", "kōḍi - hen"),
                    ("పక్షి", "pakṣi - bird")
                ],
                correctAnswer: "కుక్క"
            ),
            SoundMatchQuestion(
                audioText: "పక్షి",
                audioFile: "పక్షి.mp3",
                options: [
                    ("పక్షి", "pakṣi - bird"),
                    ("కుక్క", "kukka - dog"),
                    ("పిల్లి", "pilli - cat"),
                    ("కోడి", "kōḍi - hen")
                ],
                correctAnswer: "పక్షి"
            ),
            
            // Nature
            SoundMatchQuestion(
                audioText: "సూర్యుడు",
                audioFile: "సూర్యుడు.mp3",
                options: [
                    ("సూర్యుడు", "sūryuḍu - sun"),
                    ("చంద్రుడు", "candraḍu - moon"),
                    ("నక్షత్రం", "nakṣatraṁ - star"),
                    ("ఆకాశం", "ākāśaṁ - sky")
                ],
                correctAnswer: "సూర్యుడు"
            ),
            SoundMatchQuestion(
                audioText: "వృక్షం",
                audioFile: "వృక్షం.mp3",
                options: [
                    ("వృక్షం", "vr̥kṣaṁ - tree"),
                    ("పువ్వు", "puvvu - flower"),
                    ("పండు", "paṇḍu - fruit"),
                    ("గడ్డి", "gaḍḍi - grass")
                ],
                correctAnswer: "వృక్షం"
            ),
            SoundMatchQuestion(
                audioText: "పువ్వు",
                audioFile: "పువ్వు.mp3",
                options: [
                    ("పువ్వు", "puvvu - flower"),
                    ("పండు", "paṇḍu - fruit"),
                    ("వృక్షం", "vr̥kṣaṁ - tree"),
                    ("గడ్డి", "gaḍḍi - grass")
                ],
                correctAnswer: "పువ్వు"
            ),
            
            // Transportation and people
            SoundMatchQuestion(
                audioText: "బండి",
                audioFile: "బండి.mp3",
                options: [
                    ("బండి", "baṇḍi - cart"),
                    ("కారు", "kāru - car"),
                    ("బస్సు", "bassu - bus"),
                    ("రైలు", "railu - train")
                ],
                correctAnswer: "బండి"
            ),
            SoundMatchQuestion(
                audioText: "మనిషి",
                audioFile: "మనిషి.mp3",
                options: [
                    ("మనిషి", "maniṣi - man"),
                    ("పిల్లవాడు", "pillavāḍu - boy"),
                    ("అమ్మాయి", "ammāyi - girl"),
                    ("చిన్నపిల్ల", "cinna pilla - child")
                ],
                correctAnswer: "మనిషి"
            )
        ]
        
        // Convert to QuizItem format and store question data
        for (index, question) in soundMatchQuestions.enumerated() {
            let quizId = "sound_match_\(index)"
            let quizItem = QuizItem(
                id: quizId,
                prompt: question.audioFile,
                correctId: question.correctAnswer,
                options: question.options.map { $0.telugu }, // Telugu text
                kind: .soundMatch
            )
            items.append(quizItem)
            
            // Store question data for display purposes
            questionData[quizId] = question
        }
        
        quizItems = items.shuffled()
    }
    
    private func displayTextAndCorrectness(for optionId: String, quizItem: QuizItem) -> (String, Bool) {
        let isCorrect = (optionId == quizItem.correctId)
        
        // Use predefined question data if available
        if let question = questionData[quizItem.id] {
            // Find the matching option in the question data
            if let option = question.options.first(where: { $0.telugu == optionId }) {
                return ("\(option.telugu)\n(\(option.transliteration))", isCorrect)
            }
        }
        
        // Fallback to original logic for backward compatibility
        if let letter = letters.first(where: { $0.id == optionId }) {
            return ("\(letter.character)\n(\(letter.romanization))", isCorrect)
        } else if let word = words.first(where: { $0.id == optionId }) {
            return ("\(word.telugu)\n(\(word.english))", isCorrect)
        }
        
        return (optionId, isCorrect)
    }
    
    private func handleOptionSelection(optionId: String, isCorrect: Bool) {
        selectedOption = optionId
        self.isCorrect = isCorrect
        
        if isCorrect {
            score += 1
            feedbackMessage = "Correct! Well done!"
            xpEarned = 5
            session.hapticsService.success()
            session.gamificationService.awardXP(5, type: .quizCompleted, description: "Sound match correct answer")
        } else {
            feedbackMessage = "Not quite right, but keep trying!"
            xpEarned = 0
            session.hapticsService.warning()
        }
        
        showingFeedback = true
    }
    
    private func moveToNextQuestion() {
        selectedOption = nil
        showingFeedback = false
        feedbackMessage = ""
        xpEarned = 0
        
        if currentQuizIndex < quizItems.count - 1 {
            currentQuizIndex += 1
        } else {
            // Game completed
            currentQuizIndex = 0
            startNewGame()
        }
    }
    
    private func startNewGame() {
        score = 0
        timeRemaining = 60
        selectedOption = nil
        showingFeedback = false
        feedbackMessage = ""
        xpEarned = 0
        createQuizItems()
    }
}
