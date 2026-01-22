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
    @Environment(\.dismiss) private var dismiss
    @State private var letters: [Letter] = []
    @State private var words: [Word] = []
    @State private var quizItems: [QuizItem] = []
    @State private var currentQuizIndex = 0
    @State private var questionData: [String: SoundMatchQuestion] = [:]  // Store question data for display
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
            Group {
                if session.isDarkModeActive {
                    Color.adaptiveBackground.ignoresSafeArea()
                } else {
                    LinearGradient(
                        colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ).ignoresSafeArea()
                }
            }

            VStack(spacing: 20) {
                // Header with score and timer
                HStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(
                                session.isDarkModeActive ? Color.teluguAccent : .yellow)
                        Text("\(score)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(
                                session.isDarkModeActive ? Color.teluguTextPrimary : .primary)
                    }

                    Spacer()

                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(session.isDarkModeActive ? Color.teluguAccent : .red)
                        Text("\(timeRemaining)s")
                            .foregroundColor(
                                session.isDarkModeActive ? Color.teluguTextPrimary : .primary)
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
                            HapticsService.shared.audioPlay()
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
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16
                    ) {
                        ForEach(quizItem.options, id: \.self) { optionId in
                            let (displayText, isCorrect) = displayTextAndCorrectness(
                                for: optionId, quizItem: quizItem)

                            Button(action: {
                                handleOptionSelection(optionId: optionId, isCorrect: isCorrect)
                            }) {
                                Text(displayText)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        selectedOption == optionId
                                            ? (isCorrect ? Color.green : Color.orange)
                                            : Color.gray.opacity(0.1)
                                    )
                                    .foregroundColor(.primary)
                                    .cornerRadius(12)
                            }
                            .disabled(selectedOption != nil)
                            .opacity(
                                selectedOption != nil && selectedOption != optionId && isCorrect
                                    ? 1.0 : 1.0
                            )
                            .buttonStyle(HapticButtonStyle())
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
                        explanation: isCorrect
                            ? "Great job recognizing the Telugu sound!"
                            : "Listen carefully to the pronunciation and try again.",
                        onContinue: moveToNextQuestion
                    )
                }

                Spacer()
            }
        }
        .onAppear {
            HapticsManager.shared.impact(.light)
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
                HapticsManager.shared.impact(.heavy)
                HapticsManager.shared.notification(.success)
                timer.upstream.connect().cancel()
            }
        }
        .navigationTitle("Sound Match")
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
    }

    private func loadData() async {
        letters = session.dataRepository.letters
        words = session.dataRepository.words

        // Create sample quiz items
        createQuizItems()
    }

    private func createQuizItems() {
        var items: [QuizItem] = []
        // Only use audio files that exist in Resources/Sounds
        let availableAudioFiles: Set<String> = [
            "అ.mp3", "ఆ.mp3", "ఇ.mp3", "ఉ.mp3", "ఊ.mp3", "ఋ.mp3", "ఎ.mp3", "ఏ .mp3", "ఐ.mp3",
            "ఒ.mp3", "ఓ.mp3", "ఔ.mp3",
            "క.mp3", "ఖ.mp3", "గ.mp3", "ఘ.mp3", "ఙ.mp3", "చ.mp3", "ఛ.mp3", "జ.mp3", "ఝ .mp3",
            "ఞ.mp3",
            "ట.mp3", "ఠ .mp3", "డ.mp3", "ఢ.mp3", "ణ.mp3", "త .mp3", "థ.mp3", "ద.mp3", "ధ.mp3",
            "న.mp3",
            "ప.mp3", "ఫ.mp3", "బ.mp3", "భ .mp3", "మ.mp3", "య.mp3", "ర.mp3", "ల.mp3", "వ.mp3",
            "శ.mp3", "ష.mp3", "స .mp3", "హ.mp3", "ళ.mp3",
            "అన్నం.mp3", "అమ్మ.mp3", "అక్క.mp3", "అత్త.mp3", "అత్తయ్య.mp3", "అరటి పండు.mp3", "ఆవు.mp3", "ఎద్దు.mp3",
            "ఎరుపు.mp3", "ఎలుకపులి.mp3",
            "ఏనుగు.mp3", "ఒకటి.mp3", "కుక్క.mp3", "కుందేలు.mp3", "కోడి మాంసం.mp3", "కోతి.mp3", "గాజర.mp3", "గుడ్లు.mp3",
            "గొర్రె.mp3",
            "చిలుక.mp3", "చేప.mp3", "టమాటా.mp3", "తాత.mp3", "తాతయ్య.mp3", "పక్షి.mp3", "పచ్చ.mp3", "పాలు.mp3",
            "పిల్లి.mp3", "పువ్వు.mp3",
            "బండి.mp3", "మనిషి.mp3", "మామ.mp3", "మామయ్య.mp3", "మామిడి పండు.mp3", "మేక.mp3", "నక్క.mp3", "నాన్న.mp3",
            "నారింజ.mp3",
            "నీలం.mp3", "పసుపు.mp3", "పండు.mp3", "పులి.mp3", "పుస్తకం.mp3", "పెరుగు.mp3", "పెద్దనాన్న.mp3", "పెద్దమ్మ.mp3",
            "రామ.mp3",
            "సూర్యుడు.mp3", "వృక్షం.mp3",
        ]
        let soundMatchQuestions: [SoundMatchQuestion] = [
            SoundMatchQuestion(
                audioText: "అ", audioFile: "అ.mp3",
                options: [("అ", "a"), ("ఆ", "aa"), ("ఇ", "i"), ("ఉ", "u")], correctAnswer: "అ"),
            SoundMatchQuestion(
                audioText: "ఆ", audioFile: "ఆ.mp3",
                options: [("ఆ", "aa"), ("అ", "a"), ("ఇ", "i"), ("ఉ", "u")], correctAnswer: "ఆ"),
            SoundMatchQuestion(
                audioText: "ఇ", audioFile: "ఇ.mp3",
                options: [("ఇ", "i"), ("ఈ", "ii"), ("ఉ", "u"), ("ఎ", "e")], correctAnswer: "ఇ"),
            SoundMatchQuestion(
                audioText: "ఉ", audioFile: "ఉ.mp3",
                options: [("ఉ", "u"), ("ఊ", "uu"), ("ఇ", "i"), ("ఆ", "aa")], correctAnswer: "ఉ"),
            SoundMatchQuestion(
                audioText: "ఒకటి", audioFile: "ఒకటి.mp3",
                options: [("ఒకటి", "one"), ("రెండు", "two"), ("మూడు", "three"), ("నాలుగు", "four")],
                correctAnswer: "ఒకటి"),
            SoundMatchQuestion(
                audioText: "క", audioFile: "క.mp3",
                options: [("క", "ka"), ("గ", "ga"), ("ఖ", "kha"), ("చ", "cha")], correctAnswer: "క"),
            SoundMatchQuestion(
                audioText: "ప", audioFile: "ప.mp3",
                options: [("ప", "pa"), ("బ", "ba"), ("ఫ", "pha"), ("మ", "ma")], correctAnswer: "ప"),
            SoundMatchQuestion(
                audioText: "మ", audioFile: "మ.mp3",
                options: [("మ", "ma"), ("న", "na"), ("వ", "va"), ("ల", "la")], correctAnswer: "మ"),
            SoundMatchQuestion(
                audioText: "అన్నం", audioFile: "అన్నం.mp3",
                options: [("అన్నం", "rice"), ("పాలు", "milk"), ("నీరు", "water"), ("రసం", "soup")],
                correctAnswer: "అన్నం"),
            SoundMatchQuestion(
                audioText: "పాలు", audioFile: "పాలు.mp3",
                options: [("పాలు", "milk"), ("కాఫీ", "coffee"), ("టీ", "tea"), ("నీరు", "water")],
                correctAnswer: "పాలు"),
            SoundMatchQuestion(
                audioText: "కుక్క", audioFile: "కుక్క.mp3",
                options: [("కుక్క", "dog"), ("పిల్లి", "cat"), ("కోడి", "hen"), ("పక్షి", "bird")],
                correctAnswer: "కుక్క"),
            SoundMatchQuestion(
                audioText: "పక్షి", audioFile: "పక్షి.mp3",
                options: [("పక్షి", "bird"), ("కుక్క", "dog"), ("పిల్లి", "cat"), ("కోడి", "hen")],
                correctAnswer: "పక్షి"),
            SoundMatchQuestion(
                audioText: "సూర్యుడు", audioFile: "సూర్యుడు.mp3",
                options: [("సూర్యుడు", "sun"), ("చంద్రుడు", "moon"), ("నక్షత్రం", "star"), ("ఆకాశం", "sky")],
                correctAnswer: "సూర్యుడు"),
            SoundMatchQuestion(
                audioText: "వృక్షం", audioFile: "వృక్షం.mp3",
                options: [("వృక్షం", "tree"), ("పువ్వు", "flower"), ("పండు", "fruit"), ("గడ్డి", "grass")],
                correctAnswer: "వృక్షం"),
            SoundMatchQuestion(
                audioText: "పువ్వు", audioFile: "పువ్వు.mp3",
                options: [("పువ్వు", "flower"), ("పండు", "fruit"), ("వృక్షం", "tree"), ("గడ్డి", "grass")],
                correctAnswer: "పువ్వు"),
            SoundMatchQuestion(
                audioText: "బండి", audioFile: "బండి.mp3",
                options: [("బండి", "cart"), ("కారు", "car"), ("బస్సు", "bus"), ("రైలు", "train")],
                correctAnswer: "బండి"),
            SoundMatchQuestion(
                audioText: "మనిషి", audioFile: "మనిషి.mp3",
                options: [("మనిషి", "man"), ("పిల్లవాడు", "boy"), ("అమ్మాయి", "girl"), ("చిన్నపిల్ల", "child")],
                correctAnswer: "మనిషి"),
            SoundMatchQuestion(
                audioText: "ఎరుపు", audioFile: "ఎరుపు.mp3",
                options: [("ఎరుపు", "red"), ("నీలం", "blue"), ("పచ్చ", "green"), ("తెలుపు", "white")],
                correctAnswer: "ఎరుపు"),
            SoundMatchQuestion(
                audioText: "నీలం", audioFile: "నీలం.mp3",
                options: [("నీలం", "blue"), ("ఎరుపు", "red"), ("పచ్చ", "green"), ("తెలుపు", "white")],
                correctAnswer: "నీలం"),
            SoundMatchQuestion(
                audioText: "పచ్చ", audioFile: "పచ్చ.mp3",
                options: [("పచ్చ", "green"), ("ఎరుపు", "red"), ("నీలం", "blue"), ("తెలుపు", "white")],
                correctAnswer: "పచ్చ"),
            SoundMatchQuestion(
                audioText: "అమ్మ", audioFile: "అమ్మ.mp3",
                options: [("అమ్మ", "mother"), ("అన్న", "brother"), ("అక్క", "sister"), ("అత్త", "aunt")],
                correctAnswer: "అమ్మ"),
            SoundMatchQuestion(
                audioText: "అక్క", audioFile: "అక్క.mp3",
                options: [("అక్క", "sister"), ("అన్న", "brother"), ("అమ్మ", "mother"), ("అత్త", "aunt")],
                correctAnswer: "అక్క"),
            SoundMatchQuestion(
                audioText: "అత్త", audioFile: "అత్త.mp3",
                options: [("అత్త", "aunt"), ("అక్క", "sister"), ("అన్న", "brother"), ("అమ్మ", "mother")],
                correctAnswer: "అత్త"),
            SoundMatchQuestion(
                audioText: "నాన్న", audioFile: "నాన్న.mp3",
                options: [("నాన్న", "father"), ("అమ్మ", "mother"), ("అక్క", "sister"), ("అత్త", "aunt")],
                correctAnswer: "నాన్న"),
            SoundMatchQuestion(
                audioText: "పిల్లి", audioFile: "పిల్లి.mp3",
                options: [("పిల్లి", "cat"), ("కుక్క", "dog"), ("కోడి", "hen"), ("పక్షి", "bird")],
                correctAnswer: "పిల్లి"),
            SoundMatchQuestion(
                audioText: "కోతి", audioFile: "కోతి.mp3",
                options: [("కోతి", "monkey"), ("కుక్క", "dog"), ("పిల్లి", "cat"), ("పక్షి", "bird")],
                correctAnswer: "కోతి"),
            SoundMatchQuestion(
                audioText: "మేక", audioFile: "మేక.mp3",
                options: [("మేక", "goat"), ("కుక్క", "dog"), ("పిల్లి", "cat"), ("పక్షి", "bird")],
                correctAnswer: "మేక"),
        ]
        // Filter questions to only those with audio files present
        let filteredQuestions = soundMatchQuestions.filter {
            availableAudioFiles.contains($0.audioFile)
        }
        for (index, question) in filteredQuestions.enumerated() {
            let quizId = "sound_match_\(index)"
            let quizItem = QuizItem(
                id: quizId,
                prompt: question.audioFile,
                correctId: question.correctAnswer,
                options: question.options.map { $0.telugu },
                kind: .soundMatch
            )
            items.append(quizItem)
            questionData[quizId] = question
        }
        quizItems = items.shuffled()
    }

    private func displayTextAndCorrectness(for optionId: String, quizItem: QuizItem) -> (
        String, Bool
    ) {
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

    @State private var comboCount = 0
    @State private var showHeartDepleted = false

    private func handleOptionSelection(optionId: String, isCorrect: Bool) {
        selectedOption = optionId
        self.isCorrect = isCorrect

        if isCorrect {
            score += 1
            comboCount += 1

            let pitchRate = min(1.0 + (Float(comboCount) * 0.1), 2.0)
            if comboCount >= 3 {
                HapticsManager.shared.notification(.success)
            } else {
                HapticsService.shared.correctAnswer()
            }

            feedbackMessage = comboCount >= 3 ? "🔥 \(comboCount) in a row!" : "Correct! Well done!"
            let comboBonus = comboCount >= 3 ? comboCount * 2 : 0
            xpEarned = 5 + comboBonus

            session.audioService.play(name: "success.mp3", rate: pitchRate)
            session.gamificationService.awardXP(
                xpEarned, type: .quizCompleted, description: "Sound match correct answer")
            session.gamificationService.onActivityCompleted()
        } else {
            comboCount = 0
            feedbackMessage = "Not quite right, but keep trying!"
            xpEarned = 0
            HapticsService.shared.wrongAnswer()
            session.audioService.play(name: "tryagain.mp3", rate: 1.0)
            session.deductHeart()
            if session.hearts == 0 {
                showHeartDepleted = true
            }
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
            HapticsManager.shared.impact(.heavy)
            HapticsManager.shared.notification(.success)
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
