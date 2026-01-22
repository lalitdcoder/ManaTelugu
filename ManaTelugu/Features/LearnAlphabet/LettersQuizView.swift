import SwiftUI

enum LettersQuizScope: Hashable {
    case vowels
    case consonants
    case all
}

struct LettersQuizView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    let scope: LettersQuizScope

    @State private var questions: [Question] = []
    @State private var currentIndex = 0
    @State private var correctCount = 0
    @State private var quizStartTime = Date()
    @State private var showingCompletion = false
    @State private var selectedAnswer: String? = nil
    @State private var hasAnswered = false

    struct Question: Identifiable {
        let id = UUID()
        let glyph: String
        let correct: String
        let options: [String]
    }

    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.lg) {
            Text(title)
                .font(ModernDesignSystem.Typography.title1)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            if currentIndex < questions.count {
                let q = questions[currentIndex]
                Text(q.glyph)
                    .font(.system(size: 120))
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                VStack(spacing: ModernDesignSystem.Spacing.md) {
                    ForEach(q.options, id: \.self) { opt in
                        Button {
                            selectAnswer(opt, for: q)
                        } label: {
                            Text(opt)
                                .font(ModernDesignSystem.Typography.body)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(getOptionBackgroundColor(for: opt, correct: q.correct))
                                .foregroundColor(getOptionTextColor(for: opt, correct: q.correct))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            getOptionBorderColor(for: opt, correct: q.correct),
                                            lineWidth: 2)
                                )
                        }
                        .disabled(hasAnswered)
                    }

                    if hasAnswered {
                        Button {
                            nextQuestion()
                        } label: {
                            Text("Next Question")
                                .font(ModernDesignSystem.Typography.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(ModernDesignSystem.Colors.primary)
                                .cornerRadius(12)
                        }
                        .padding(.top, ModernDesignSystem.Spacing.md)
                    }
                }
                .padding(.horizontal)
            } else if showingCompletion {
                QuizCompletionView(
                    scope: scope,
                    correctCount: correctCount,
                    totalQuestions: questions.count,
                    timeSpent: Date().timeIntervalSince(quizStartTime)
                )
            }
            Spacer()
        }
        .padding()
        .onAppear {
            Task {
                await buildQuestions()
            }
            quizStartTime = Date()
            session.sessionTimer.start()
        }
        .onDisappear {
            let minutes = session.sessionTimer.stop()
            if minutes > 0 {
                session.addLearningTime(minutes: minutes)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
    }

    private var title: String {
        switch scope {
        case .vowels: return "Vowels Quiz"
        case .consonants: return "Consonants Quiz"
        case .all: return "All Letters Quiz"
        }
    }

    private func buildQuestions() async {
        let vowels = [
            "అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఋ", "ౠ", "ఎ", "ఏ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః",
        ]
        let consonants = [
            "క", "ఖ", "గ", "ఘ", "ఙ", "చ", "ఛ", "జ", "ఝ", "ఞ", "ట", "ఠ", "డ", "ఢ", "ణ", "త", "థ",
            "ద", "ధ", "న", "ప", "ఫ", "బ", "భ", "మ", "య", "ర", "ల", "వ", "శ", "ష", "స", "హ", "ళ",
            "క్ష", "ఱ",
        ]
        let all = session.dataRepository.letters
        let pool: [Letter]
        let questionCount: Int

        switch scope {
        case .vowels:
            pool = all.filter { vowels.contains($0.character) }
            questionCount = min(12, pool.count)  // Up to 12 vowel questions
        case .consonants:
            pool = all.filter { consonants.contains($0.character) }
            questionCount = 12  // Always 12 consonant questions
        case .all:
            pool = all
            questionCount = 12  // 12 mixed questions
        }

        let translits = Set(pool.map { $0.romanization })
        var qs: [Question] = []

        // Shuffle the pool and take questions, allowing repeats if needed for consonants
        let shuffledPool = pool.shuffled()
        for i in 0..<questionCount {
            let letter = shuffledPool[i % shuffledPool.count]  // Cycle through if needed
            let correct = letter.romanization
            let others = translits.subtracting([correct]).shuffled().prefix(3)
            let opts = ([correct] + others).shuffled()
            qs.append(Question(glyph: letter.character, correct: correct, options: opts))
        }

        // Final shuffle to randomize question order
        questions = qs.shuffled()
    }

    private func selectAnswer(_ answer: String, for q: Question) {
        guard !hasAnswered else { return }

        selectedAnswer = answer
        hasAnswered = true

        if answer == q.correct {
            correctCount += 1
            FeedbackCenter.correct()
        } else {
            FeedbackCenter.wrong()
        }
    }

    private func nextQuestion() {
        currentIndex += 1
        selectedAnswer = nil
        hasAnswered = false

        // Show completion screen when quiz is finished
        if currentIndex >= questions.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingCompletion = true
            }
        }
    }

    private func getOptionBackgroundColor(for option: String, correct: String) -> Color {
        guard hasAnswered else { return ModernDesignSystem.Colors.surfaceSecondary }

        if option == selectedAnswer {
            return option == correct ? .green.opacity(0.3) : .red.opacity(0.3)
        } else if option == correct {
            return .green.opacity(0.3)
        }
        return ModernDesignSystem.Colors.surfaceSecondary
    }

    private func getOptionTextColor(for option: String, correct: String) -> Color {
        guard hasAnswered else { return ModernDesignSystem.Colors.textPrimary }

        if option == selectedAnswer {
            return option == correct ? .green : .red
        } else if option == correct {
            return .green
        }
        return ModernDesignSystem.Colors.textPrimary
    }

    private func getOptionBorderColor(for option: String, correct: String) -> Color {
        // Show a subtle border even before answering so options are clearly visible
        guard hasAnswered else { return Color.adaptiveSeparator }

        if option == selectedAnswer {
            return option == correct ? .green : .red
        } else if option == correct {
            return .green
        }
        return Color.adaptiveSeparator
    }
}

struct QuizCompletionView: View {
    @EnvironmentObject var session: AppSession
    let scope: LettersQuizScope
    let correctCount: Int
    let totalQuestions: Int
    let timeSpent: TimeInterval

    @State private var showingXPAnimation = false
    @State private var showingStars = false
    @State private var animatedXP = 0

    private var accuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctCount) / Double(totalQuestions)
    }

    private var starRating: Int {
        switch accuracy {
        case 0.9...1.0: return 3
        case 0.7..<0.9: return 2
        case 0.5..<0.7: return 1
        default: return 0
        }
    }

    private var totalXP: Int {
        correctCount * 2  // 2 XP per correct answer
    }

    private var scopeTitle: String {
        switch scope {
        case .vowels: return "Vowels Quiz"
        case .consonants: return "Consonants Quiz"
        case .all: return "Letters Quiz"
        }
    }

    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.lg) {
            Spacer()

            // Success Animation
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                // Stars
                HStack(spacing: ModernDesignSystem.Spacing.sm) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: index < starRating ? "star.fill" : "star")
                            .font(.system(size: 30))
                            .foregroundColor(
                                index < starRating
                                    ? .yellow : ModernDesignSystem.Colors.textPrimary.opacity(0.3)
                            )
                            .scaleEffect(showingStars && index < starRating ? 1.3 : 1.0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8).delay(
                                    Double(index) * 0.1), value: showingStars)
                    }
                }

                Text("\(scopeTitle) Complete!")
                    .font(ModernDesignSystem.Typography.title1)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    .opacity(showingXPAnimation ? 1 : 0)
                    .animation(.easeIn(duration: 0.5), value: showingXPAnimation)
            }

            // Stats Grid
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 2),
                spacing: ModernDesignSystem.Spacing.md
            ) {
                QuizStatCard(
                    title: "XP Earned",
                    value: "\(animatedXP)",
                    icon: "star.fill",
                    color: .yellow
                )

                QuizStatCard(
                    title: "Accuracy",
                    value: "\(Int(accuracy * 100))%",
                    icon: "target",
                    color: .green
                )

                QuizStatCard(
                    title: "Score",
                    value: "\(correctCount)/\(totalQuestions)",
                    icon: "checkmark.circle.fill",
                    color: .blue
                )

                QuizStatCard(
                    title: "Time",
                    value: formatTime(timeSpent),
                    icon: "clock.fill",
                    color: .orange
                )
            }

            // Performance Message
            VStack(spacing: ModernDesignSystem.Spacing.sm) {
                Text(performanceMessage)
                    .font(ModernDesignSystem.Typography.headline)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(encouragementMessage)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(ModernDesignSystem.Colors.surfaceSecondary)
            .cornerRadius(12)

            Spacer()
        }
        .onAppear {
            // Award XP for quiz completion
            session.updateProgress(xp: totalXP)
            startAnimations()
        }
    }

    private var performanceMessage: String {
        switch starRating {
        case 3: return "Perfect! 🎉"
        case 2: return "Great job! 👏"
        case 1: return "Good effort! 👍"
        default: return "Keep practicing! 💪"
        }
    }

    private var encouragementMessage: String {
        switch starRating {
        case 3: return "You mastered the Telugu letters! Ready for more challenges?"
        case 2: return "You're making excellent progress! Keep practicing!"
        case 1: return "You're learning! Try the quiz again to improve your score."
        default: return "Practice makes perfect. Don't give up!"
        }
    }

    private func startAnimations() {
        // XP Animation
        withAnimation(.easeOut(duration: 1.0)) {
            showingXPAnimation = true
        }

        // Animate XP counter
        let _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if animatedXP < totalXP {
                animatedXP += max(1, totalXP / 20)
                if animatedXP >= totalXP {
                    animatedXP = totalXP
                    timer.invalidate()
                }
            }
        }

        // Stars Animation (delayed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                showingStars = true
            }
        }
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return minutes > 0 ? "\(minutes)m \(seconds)s" : "\(seconds)s"
    }
}

struct QuizStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @EnvironmentObject var session: AppSession

    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Text(title)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(ModernDesignSystem.Colors.surfaceSecondary)
        .cornerRadius(12)
    }
}
