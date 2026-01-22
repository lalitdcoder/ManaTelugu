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
    @State private var showingGameOver = false
    @State private var showingFeedback = false
    @State private var isCorrect = false
    @State private var feedbackMessage = ""
    @State private var xpEarned = 0

    enum GameState {
        case playing, paused, gameOver
    }

    struct Sentence: Identifiable {
        let id = UUID()
        let telugu: String
        let english: String
        let words: [String]
        let difficulty: Int  // 1-3: Simple, Medium, Complex
        let category: String
    }

    let sentences: [Sentence] = [
        // Level 1 - Simple sentences
        Sentence(
            telugu: "నేను బడికి వెళ్తున్నాను", english: "I am going to school", words: ["నేను", "బడికి", "వెళ్తున్నాను"],
            difficulty: 1, category: "Daily Activities"),
        Sentence(
            telugu: "మా ఇంట్లో పిల్లి ఉంది", english: "There is a cat in our house",
            words: ["మా", "ఇంట్లో", "పిల్లి", "ఉంది"], difficulty: 1, category: "Family & Home"),
        Sentence(
            telugu: "నాకు నీళ్లు కావాలి", english: "I want water", words: ["నాకు", "నీళ్లు", "కావాలి"], difficulty: 1,
            category: "Basic Needs"),
        Sentence(
            telugu: "అమ్మ వంట చేస్తుంది", english: "Mother is cooking", words: ["అమ్మ", "వంట", "చేస్తుంది"],
            difficulty: 1, category: "Family"),
        Sentence(
            telugu: "నాన్న పని చేస్తున్నాడు", english: "Father is working", words: ["నాన్న", "పని", "చేస్తున్నాడు"],
            difficulty: 1, category: "Family"),
        Sentence(
            telugu: "పిల్లలు ఆట ఆడుతున్నారు", english: "Children are playing", words: ["పిల్లలు", "ఆట", "ఆడుతున్నారు"],
            difficulty: 1, category: "Activities"),
        Sentence(
            telugu: "నేను పుస్తకం చదువుతున్నాను", english: "I am reading a book",
            words: ["నేను", "పుస్తకం", "చదువుతున్నాను"], difficulty: 1, category: "Education"),
        Sentence(
            telugu: "కుక్క మొరుగుతుంది", english: "The dog is barking", words: ["కుక్క", "మొరుగుతుంది"],
            difficulty: 1, category: "Animals"),
        Sentence(
            telugu: "సూర్యుడు ఉదయం ఉదిస్తాడు", english: "The sun rises in the morning",
            words: ["సూర్యుడు", "ఉదయం", "ఉదిస్తాడు"], difficulty: 1, category: "Nature"),
        Sentence(
            telugu: "నేను చెప్పులు ధరిస్తున్నాను", english: "I am wearing shoes", words: ["నేను", "చెప్పులు", "ధరిస్తున్నాను"],
            difficulty: 1, category: "Clothing"),
        Sentence(
            telugu: "ఆ చెట్టు చాలా పెద్దది", english: "That tree is very big",
            words: ["ఆ", "చెట్టు", "చాలా", "పెద్దది"], difficulty: 1, category: "Nature"),
        Sentence(
            telugu: "నేను ఆహారం తిన్నాను", english: "I ate food", words: ["నేను", "ఆహారం", "తిన్నాను"], difficulty: 1,
            category: "Food"),

        // Level 2 - Medium sentences
        Sentence(
            telugu: "రమేష్ మంచి విద్యార్థి", english: "Ramesh is a good student", words: ["రమేష్", "మంచి", "విద్యార్థి"],
            difficulty: 2, category: "Education"),
        Sentence(
            telugu: "మేము సినిమా చూస్తున్నాము", english: "We are watching a movie",
            words: ["మేము", "సినిమా", "చూస్తున్నాము"], difficulty: 2, category: "Entertainment"),
        Sentence(
            telugu: "ఈ పుస్తకం చాలా మంచిది", english: "This book is very good",
            words: ["ఈ", "పుస్తకం", "చాలా", "మంచిది"], difficulty: 2, category: "Objects"),
        Sentence(
            telugu: "నేను రోజూ యోగా చేస్తాను", english: "I do yoga every day",
            words: ["నేను", "రోజూ", "యోగా", "చేస్తాను"], difficulty: 2, category: "Health"),
        Sentence(
            telugu: "మా ఊరిలో పెద్ద ఆలయం ఉంది", english: "There is a big temple in our village",
            words: ["మా", "ఊరిలో", "పెద్ద", "ఆలయం", "ఉంది"], difficulty: 2, category: "Places"),
        Sentence(
            telugu: "అతను చాలా తెలివైన వాడు", english: "He is very intelligent",
            words: ["అతను", "చాలా", "తెలివైన", "వాడు"], difficulty: 2, category: "Personality"),
        Sentence(
            telugu: "నేను ఆసుపత్రికి వెళ్లాను", english: "I went to the hospital",
            words: ["నేను", "ఆసుపత్రికి", "వెళ్లాను"], difficulty: 2, category: "Places"),
        Sentence(
            telugu: "ఆమె ఎక్కువ సమయం నిద్రిస్తుంది", english: "She sleeps most of the time",
            words: ["ఆమె", "ఎక్కువ", "సమయం", "నిద్రిస్తుంది"], difficulty: 2, category: "Activities"),
        Sentence(
            telugu: "ఆ ఫ్లవర్ చాలా అందమైనది", english: "That flower is very beautiful",
            words: ["ఆ", "ఫ్లవర్", "చాలా", "అందమైనది"], difficulty: 2, category: "Nature"),
        Sentence(
            telugu: "నేను ఫుట్‌బాల్ ఆడటం ఇష్టపడతాను", english: "I like playing football",
            words: ["నేను", "ఫుట్‌బాల్", "ఆడటం", "ఇష్టపడతాను"], difficulty: 2, category: "Sports"),
        Sentence(
            telugu: "ఆ రెస్టారెంట్ చాలా రుచిగా ఉంది", english: "That restaurant is very tasty",
            words: ["ఆ", "రెస్టారెంట్", "చాలా", "రుచిగా", "ఉంది"], difficulty: 2, category: "Food"),
        Sentence(
            telugu: "నీ కుటుంబం ఎలా ఉంది?", english: "How is your family?",
            words: ["నీ", "కుటుంబం", "ఎలా", "ఉంది?"], difficulty: 2, category: "Family"),

        // Level 3 - Complex sentences
        Sentence(
            telugu: "నేను రేపు ఉదయం తొమ్మిది గంటలకు ఆఫీసుకు వెళ్తాను",
            english: "I will go to the office tomorrow morning at nine o'clock",
            words: ["నేను", "రేపు", "ఉదయం", "తొమ్మిది", "గంటలకు", "ఆఫీసుకు", "వెళ్తాను"], difficulty: 3,
            category: "Advanced"),
        Sentence(
            telugu: "మీరు ఎప్పుడు భారతదేశానికి వచ్చారు?", english: "When did you come to India?",
            words: ["మీరు", "ఎప్పుడు", "భారతదేశానికి", "వచ్చారు?"], difficulty: 3, category: "Questions"),
        Sentence(
            telugu: "నాకు తెలుగు భాష నేర్చుకోవడం చాలా ఇష్టం", english: "I really like learning the Telugu language",
            words: ["నాకు", "తెలుగు", "భాష", "నేర్చుకోవడం", "చాలా", "ఇష్టం"], difficulty: 3,
            category: "Language Learning"),
        Sentence(
            telugu: "మేము గత వారం హైదరాబాదుకు వెళ్లాము", english: "We went to Hyderabad last week",
            words: ["మేము", "గత", "వారం", "హైదరాబాదుకు", "వెళ్లాము"], difficulty: 3, category: "Travel"),
        Sentence(
            telugu: "ఈ సమస్యను పరిష్కరించడం కష్టం", english: "It is difficult to solve this problem",
            words: ["ఈ", "సమస్యను", "పరిష్కరించడం", "కష్టం"], difficulty: 3, category: "Abstract"),
        Sentence(
            telugu: "నేను ఈ సంవత్సరం ఆఫీసులో ప్రమోషన్ పొందాను", english: "I got promoted at the office this year",
            words: ["నేను", "ఈ", "సంవత్సరం", "ఆఫీసులో", "ప్రమోషన్", "పొందాను"], difficulty: 3, category: "Work"),
        Sentence(
            telugu: "ఆ సినిమా చాలా ఆసక్తికరమైనది కానీ చాలా పొడవుగా ఉంది",
            english: "That movie is very interesting but very long",
            words: ["ఆ", "సినిమా", "చాలా", "ఆసక్తికరమైనది", "కానీ", "చాలా", "పొడవుగా", "ఉంది"], difficulty: 3,
            category: "Entertainment"),
        Sentence(
            telugu: "నేను ఈ ఉద్యోగం ఆ కంపెనీలో చేసాను", english: "I did this job at that company",
            words: ["నేను", "ఈ", "ఉద్యోగం", "ఆ", "కంపెనీలో", "చేసాను"], difficulty: 3, category: "Work"),
        Sentence(
            telugu: "ఆ పుస్తకం చాలా ఆసక్తికరమైనది కాబట్టి నేను దానిని రెండుసార్లు చదివాను",
            english: "That book is so interesting that I read it twice",
            words: ["ఆ", "పుస్తకం", "చాలా", "ఆసక్తికరమైనది", "కాబట్టి", "నేను", "దానిని", "రెండుసార్లు", "చదివాను"],
            difficulty: 3, category: "Education"),
        Sentence(
            telugu: "నేను నా స్నేహితులతో పర్యటన చేయడానికి ఇష్టపడతాను", english: "I like traveling with my friends",
            words: ["నేను", "నా", "స్నేహితులతో", "పర్యటన", "చేయడానికి", "ఇష్టపడతాను"], difficulty: 3,
            category: "Travel"),
        Sentence(
            telugu: "ఈ ఆహారం చాలా రుచిగా ఉంది కానీ చాలా ఖరీదైనది",
            english: "This food is very tasty but very expensive",
            words: ["ఈ", "ఆహారం", "చాలా", "రుచిగా", "ఉంది", "కానీ", "చాలా", "ఖరీదైనది"], difficulty: 3,
            category: "Food"),
    ]

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
                        Text("Sentence Builder")
                            .font(ModernDesignSystem.Typography.title1)
                            .foregroundColor(ModernDesignSystem.Colors.primaryText)
                        Text("Level \(currentLevel)")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                    }
                    Spacer()

                    // Game controls
                    HStack(spacing: 16) {
                        // Hint button
                        EnhancedButton(
                            interaction: .light,
                            isLoading: false,
                            isEnabled: true,
                            action: { showingHint.toggle() },
                            content: {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(ModernDesignSystem.Colors.funYellow)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(ModernDesignSystem.Colors.surface.opacity(0.9))
                                    )
                            }
                        )

                        // Pause button
                        EnhancedButton(
                            interaction: .light,
                            isLoading: false,
                            isEnabled: true,
                            action: { gameState = .paused },
                            content: {
                                Image(systemName: "pause.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(ModernDesignSystem.Colors.funBlue)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(ModernDesignSystem.Colors.surface.opacity(0.9))
                                    )
                            }
                        )
                    }
                }
                .padding(.horizontal)

                // Game stats - focus on progress, not pressure
                HStack(spacing: 32) {
                    LiquidGlassStatsCard(
                        title: "Score", value: "\(score)", icon: "star.fill",
                        color: ModernDesignSystem.Colors.funGreen)
                    LiquidGlassStatsCard(
                        title: "Level", value: "\(currentLevel)", icon: "chart.bar.fill",
                        color: ModernDesignSystem.Colors.funBlue)
                }
                .padding(.horizontal)

                if let sentence = currentSentence {
                    // Target sentence display
                    VStack(spacing: 16) {
                        Text("Build this sentence:")
                            .font(ModernDesignSystem.Typography.headline)
                            .foregroundColor(ModernDesignSystem.Colors.primaryText)

                        // Display Telugu sentence as target
                        Text(sentence.telugu)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ModernDesignSystem.Colors.funBlue.opacity(0.15))
                            )

                        // English translation as hint
                        Text(sentence.english)
                            .font(.caption)
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)

                    // Current sentence being built
                    VStack(spacing: 16) {
                        Text("Your sentence:")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.primaryText)

                        if selectedWords.isEmpty {
                            Text("Tap words below to build your sentence")
                                .font(ModernDesignSystem.Typography.caption)
                                .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.5))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.1))
                                )
                        } else {
                            HStack(spacing: 8) {
                                ForEach(selectedWords, id: \.self) { word in
                                    Text(word)
                                        .font(ModernDesignSystem.Typography.body)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(
                                                    ModernDesignSystem.Colors.funGreen.opacity(0.2))
                                        )
                                        .onTapGesture {
                                            removeWord(word)
                                        }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ModernDesignSystem.Colors.surface)
                            )
                        }
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)

                    // Available words
                    VStack(spacing: 16) {
                        Text("Available words:")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.primaryText)

                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3),
                            spacing: 12
                        ) {
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
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)

                    // Action buttons
                    HStack(spacing: ModernDesignSystem.Spacing.lg) {
                        EnhancedButton(
                            interaction: .medium,
                            isLoading: false,
                            isEnabled: true,
                            action: {
                                selectedWords.removeAll()
                                HapticsManager.shared.impact(.light)
                            },
                            content: {
                                Text("Clear")
                            }
                        )
                        .buttonStyle(.bordered)
                        .tint(ModernDesignSystem.Colors.funPink)
                        .controlSize(.large)
                        .frame(
                            minWidth: ModernDesignSystem.Spacing.minimumTouchTarget,
                            minHeight: ModernDesignSystem.Spacing.minimumTouchTarget
                        )
                        .accessibilityLabel("Clear selected words")
                        .accessibilityHint("Remove all selected words from the sentence")
                        .accessibilityAddTraits(.isButton)

                        EnhancedButton(
                            interaction: .medium,
                            isLoading: false,
                            isEnabled: !selectedWords.isEmpty,
                            action: checkSentence,
                            content: {
                                Text("Check")
                            }
                        )
                        .buttonStyle(.borderedProminent)
                        .tint(ModernDesignSystem.Colors.funGreen)
                        .controlSize(.large)
                        .frame(
                            minWidth: ModernDesignSystem.Spacing.minimumTouchTarget,
                            minHeight: ModernDesignSystem.Spacing.minimumTouchTarget
                        )
                        .accessibilityLabel("Check sentence")
                        .accessibilityHint("Verify if the sentence is correct")
                        .accessibilityAddTraits(.isButton)
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                }

                // Standardized feedback
                if showingFeedback {
                    GameFeedbackView(
                        isCorrect: isCorrect,
                        message: feedbackMessage,
                        xpEarned: xpEarned,
                        correctAnswer: isCorrect ? nil : currentSentence?.telugu,
                        explanation: isCorrect
                            ? "Perfect sentence structure!"
                            : "Try arranging the words in the correct order.",
                        onContinue: {
                            showingFeedback = false
                            if isCorrect {
                                nextLevel()
                            } else {
                                selectedWords.removeAll()
                            }
                        }
                    )
                }

                Spacer()
            }
            .padding(.vertical, ModernDesignSystem.Spacing.lg)
        }
        .onAppear {
            HapticsManager.shared.impact(.light)  // game start
            setupGame()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Exit") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $showingHint) {
            HintView(sentence: currentSentence)
        }
        .sheet(isPresented: $showingGameOver) {
            LessonSummaryView(
                totalXP: score / 2,
                accuracy: Double(score) / Double(sentences.count * 10),
                streak: session.currentStreak,
                onContinue: {
                    showingGameOver = false
                    dismiss()
                }
            )
        }
    }

    private func setupGame() {
        currentLevel = 1
        score = 0
        selectedWords.removeAll()
        currentSentence = sentences.first { $0.difficulty == currentLevel }
        gameState = .playing
    }

    private func addWord(_ word: String) {
        selectedWords.append(word)
        HapticsManager.shared.impact(.light)
    }

    private func removeWord(_ word: String) {
        if let index = selectedWords.firstIndex(of: word) {
            selectedWords.remove(at: index)
            HapticsManager.shared.impact(.light)
        }
    }

    @State private var comboCount = 0
    @State private var showHeartDepleted = false

    private func checkSentence() {
        guard let sentence = currentSentence else { return }

        self.isCorrect = selectedWords == sentence.words

        if isCorrect {
            // Combo and Audio Logic
            comboCount += 1
            let pitchRate = min(1.0 + (Float(comboCount) * 0.1), 2.0)  // Increase pitch up to 2.0x

            if comboCount >= 3 {
                HapticsManager.shared.notification(.success)  // Stronger haptic for combos
            } else {
                HapticsService.shared.success()
            }

            session.audioService.play(name: "success.mp3", rate: pitchRate)

            // Score calc with combo bonus
            let comboBonus = comboCount >= 3 ? comboCount * 5 : 0
            score += (currentLevel * 10) + comboBonus

            feedbackMessage =
                comboCount >= 3
                ? "🔥 On Fire! \(comboCount) in a row!" : "Excellent! Perfect sentence!"
            xpEarned = (currentLevel * 5) + (comboCount * 2)

            session.gamificationService.awardXP(
                xpEarned, type: .quizCompleted, description: "Sentence builder correct")
            session.gamificationService.onActivityCompleted()

            // Award progress for each word in the sentence
            for word in sentence.words {
                let wordObj = Word(
                    id: word, telugu: word, transliteration: word, english: "", imageName: "",
                    audioFile: "", theme: "Sentence")
                session.gamificationService.onWordLearned(wordObj)
            }
        } else {
            // Reset Combo
            comboCount = 0

            HapticsManager.shared.notification(.error)
            session.audioService.play(name: "tryagain.mp3", rate: 1.0)
            feedbackMessage = "Not quite right, but keep trying!"
            xpEarned = 0

            // Heart System
            session.deductHeart()
            if session.hearts == 0 {
                showHeartDepleted = true
            }
        }

        showingFeedback = true
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

    private func endGame() {
        gameState = .gameOver
        showingGameOver = true

        // Award XP based on score
        let xpEarned = score / 2
        HapticsManager.shared.impact(.heavy)
        HapticsManager.shared.notification(.success)
        session.gamificationService.awardXP(
            xpEarned, type: .quizCompleted, description: "Sentence builder completed")
        session.gamificationService.onActivityCompleted()
    }

    private func restartGame() {
        if session.hearts > 0 {
            setupGame()
            showingGameOver = false
        } else {
            showHeartDepleted = true
        }
    }
}

// MARK: - Sentence Builder Stat Card
struct SentenceBuilderStatCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
            Text(value)
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(color)
                .fontWeight(.bold)
            (Text(title) as Text)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(
            LiquidGlassView(
                intensity: 0.12,
                cornerRadius: 22,
                padding: 0
            ) {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(color.opacity(0.02))
            }
        )
    }
}

// MARK: - Word Card View
struct WordCardView: View {
    let word: String
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            HapticsService.shared.optionSelect()
            onTap()
        }) {
            Text(word)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ModernDesignSystem.Colors.surface)
                        .shadow(
                            color: ModernDesignSystem.Colors.funBlue.opacity(0.15), radius: 4, x: 0,
                            y: 2)
                )
        }
        .buttonStyle(HapticPlainButtonStyle())
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
                .foregroundColor(ModernDesignSystem.Colors.funYellow)

            Text("Hint")
                .font(ModernDesignSystem.Typography.title1)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)

            if let sentence = sentence {
                VStack(spacing: 16) {
                    Text("The sentence has \(sentence.words.count) words")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)

                    Text("Category: \(sentence.category)")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                }
            }

            Button("Got it!") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(ModernDesignSystem.Colors.funGreen)
            .controlSize(.large)
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ModernDesignSystem.Colors.surface)
                .shadow(
                    color: ModernDesignSystem.Colors.funYellow.opacity(0.2), radius: 16, x: 0, y: 8)
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
                .foregroundColor(ModernDesignSystem.Colors.funYellow)

            Text("Game Complete!")
                .font(ModernDesignSystem.Typography.title1)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)

            VStack(spacing: 16) {
                Text("Final Score")
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                Text("\(score)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(ModernDesignSystem.Colors.funGreen)

                Text("Level reached: \(level)")
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.funBlue)
            }

            VStack(spacing: 16) {
                Button("Play Again") {
                    onPlayAgain()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(ModernDesignSystem.Colors.funGreen)
                .controlSize(.large)

                Button("Exit") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                .tint(ModernDesignSystem.Colors.funBlue)
                .controlSize(.large)
            }
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ModernDesignSystem.Colors.surface)
                .shadow(
                    color: ModernDesignSystem.Colors.funBlue.opacity(0.2), radius: 16, x: 0, y: 8)
        )
    }
}
