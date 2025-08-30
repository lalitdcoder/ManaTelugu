import SwiftUI

struct SoundMatchGameView: View {
    @EnvironmentObject var session: AppSession
    @State private var letters: [Letter] = []
    @State private var words: [Word] = []
    @State private var quizItems: [QuizItem] = []
    @State private var currentQuizIndex = 0
    @State private var selectedOption: String?
    @State private var isPlaying = false
    @State private var feedbackMessage: String?
    @State private var feedbackColor: Color = MTColors.text
    @State private var score = 0
    @State private var timeRemaining = 60
    
    var currentQuizItem: QuizItem? {
        guard currentQuizIndex < quizItems.count else { return nil }
        return quizItems[currentQuizIndex]
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: MTSpacing.large) {
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
                VStack(spacing: MTSpacing.medium) {
                    Text("What sound did you hear?")
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    
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
                            .foregroundColor(MTColors.primary)
                            .frame(width: 100, height: 100)
                            .background(MTColors.surfaceAlt)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                
                // Options
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: MTSpacing.medium) {
                    ForEach(quizItem.options, id: \.self) { optionId in
                        let (displayText, isCorrect) = displayTextAndCorrectness(for: optionId, quizItem: quizItem)
                        
                        Button(action: {
                            handleOptionSelection(optionId: optionId, isCorrect: isCorrect)
                        }) {
                            Text(displayText)
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    selectedOption == optionId ?
                                    (isCorrect ? MTColors.success : MTColors.warning) :
                                    MTColors.surfaceAlt
                                )
                                .foregroundColor(MTColors.text)
                                .cornerRadius(12)
                        }
                        .disabled(selectedOption != nil)
                        .opacity(selectedOption != nil && selectedOption != optionId && isCorrect ? 1.0 : 1.0)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("Loading quiz...")
                    .font(MTTypography.body())
                    .foregroundColor(MTColors.text)
            }
            
            // Feedback message
            if let message = feedbackMessage {
                Text(message)
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .fontWeight(.bold)
                    .foregroundColor(feedbackColor)
                    .padding()
                    .background(feedbackColor.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .onAppear {
            loadData()
            startNewGame()
        }
        .onReceive(timer) { _ in
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
    
    private func loadData() {
        letters = session.dataRepository.letters()
        words = session.dataRepository.words()
        
        // Create sample quiz items
        createQuizItems()
    }
    
    private func createQuizItems() {
        // Create sample quiz items mixing letters and words
        var items: [QuizItem] = []
        
        // Add letter-based questions
        for letter in letters.prefix(5) {
            let options = letters.prefix(4).map { $0.id }
            let quizItem = QuizItem(
                id: "quiz_\(letter.id)",
                prompt: letter.audioFile,
                correctId: letter.id,
                options: Array(options.shuffled().prefix(4)),
                kind: .soundMatch
            )
            items.append(quizItem)
        }
        
        // Add word-based questions
        for word in words.prefix(5) {
            let options = words.prefix(4).map { $0.id }
            let quizItem = QuizItem(
                id: "quiz_\(word.id)",
                prompt: word.audioFile,
                correctId: word.id,
                options: Array(options.shuffled().prefix(4)),
                kind: .soundMatch
            )
            items.append(quizItem)
        }
        
        quizItems = items.shuffled()
    }
    
    private func displayTextAndCorrectness(for optionId: String, quizItem: QuizItem) -> (String, Bool) {
        let isCorrect = (optionId == quizItem.correctId)
        
        // Find the corresponding letter or word
        if let letter = letters.first(where: { $0.id == optionId }) {
            return ("\(letter.glyph)\n\(letter.transliteration)", isCorrect)
        } else if let word = words.first(where: { $0.id == optionId }) {
            return ("\(word.telugu)\n\(word.english)", isCorrect)
        }
        
        return (optionId, isCorrect)
    }
    
    private func handleOptionSelection(optionId: String, isCorrect: Bool) {
        selectedOption = optionId
        
        if isCorrect {
            score += 1
            feedbackMessage = "Correct! Well done!"
            feedbackColor = MTColors.success
            session.hapticsService.success()
        } else {
            feedbackMessage = "Try again next time!"
            feedbackColor = MTColors.warning
            session.hapticsService.warning()
        }
        
        // Move to next question after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            moveToNextQuestion()
        }
    }
    
    private func moveToNextQuestion() {
        selectedOption = nil
        feedbackMessage = nil
        
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
        feedbackMessage = nil
        createQuizItems()
    }
}