import SwiftUI

enum LettersQuizScope {
    case vowels
    case consonants
    case all
}

struct LettersQuizView: View {
    @EnvironmentObject var session: AppSession
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
        VStack(spacing: MTSpacing.large) {
            Text(title)
                .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            if currentIndex < questions.count {
                let q = questions[currentIndex]
                Text(q.glyph)
                    .font(.system(size: 120))
                    .foregroundColor(MTColors.text)
                
                VStack(spacing: MTSpacing.medium) {
                    ForEach(q.options, id: \.self) { opt in
                        Button {
                            selectAnswer(opt, for: q)
                        } label: {
                            Text(opt)
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(getOptionBackgroundColor(for: opt, correct: q.correct))
                                .foregroundColor(getOptionTextColor(for: opt, correct: q.correct))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(getOptionBorderColor(for: opt, correct: q.correct), lineWidth: 2)
                                )
                        }
                        .disabled(hasAnswered)
                    }
                    
                    if hasAnswered {
                        Button {
                            nextQuestion()
                        } label: {
                            Text("Next Question")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(MTColors.primary)
                                .cornerRadius(12)
                        }
                        .padding(.top, MTSpacing.medium)
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
            buildQuestions()
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
    }
    
    private var title: String {
        switch scope {
        case .vowels: return "Vowels Quiz"
        case .consonants: return "Consonants Quiz"
        case .all: return "All Letters Quiz"
        }
    }
    
    private func buildQuestions() {
        let vowels = ["అ","ఆ","ఇ","ఈ","ఉ","ఊ","ఋ","ౠ","ఎ","ఏ","ఐ","ఒ","ఓ","ఔ","అం","అః"]
        let consonants = ["క","ఖ","గ","ఘ","ఙ","చ","ఛ","జ","ఝ","ఞ","ట","ఠ","డ","ఢ","ణ","త","థ","ద","ధ","న","ప","ఫ","బ","భ","మ","య","ర","ల","వ","శ","ష","స","హ","ళ","క్ష","ఱ"]
        let all = session.dataRepository.letters()
        let pool: [Letter]
        let questionCount: Int
        
        switch scope {
        case .vowels:
            pool = all.filter { vowels.contains($0.glyph) }
            questionCount = min(12, pool.count) // Up to 12 vowel questions
        case .consonants:
            pool = all.filter { consonants.contains($0.glyph) }
            questionCount = 12 // Always 12 consonant questions
        case .all:
            pool = all
            questionCount = 12 // 12 mixed questions
        }
        
        let translits = Set(pool.map { $0.transliteration })
        var qs: [Question] = []
        
        // Shuffle the pool and take questions, allowing repeats if needed for consonants
        let shuffledPool = pool.shuffled()
        for i in 0..<questionCount {
            let letter = shuffledPool[i % shuffledPool.count] // Cycle through if needed
            let correct = letter.transliteration
            let others = translits.subtracting([correct]).shuffled().prefix(3)
            let opts = ([correct] + others).shuffled()
            qs.append(Question(glyph: letter.glyph, correct: correct, options: opts))
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
            session.hapticsService.success()
            session.awardXP(2)
        } else {
            session.hapticsService.warning()
        }
        session.touchStreak()
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
        guard hasAnswered else { return MTColors.surfaceAlt }
        
        if option == selectedAnswer {
            return option == correct ? .green.opacity(0.3) : .red.opacity(0.3)
        } else if option == correct {
            return .green.opacity(0.3)
        }
        return MTColors.surfaceAlt
    }
    
    private func getOptionTextColor(for option: String, correct: String) -> Color {
        guard hasAnswered else { return MTColors.text }
        
        if option == selectedAnswer {
            return option == correct ? .green : .red
        } else if option == correct {
            return .green
        }
        return MTColors.text
    }
    
    private func getOptionBorderColor(for option: String, correct: String) -> Color {
        guard hasAnswered else { return Color.clear }
        
        if option == selectedAnswer {
            return option == correct ? .green : .red
        } else if option == correct {
            return .green
        }
        return Color.clear
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
        correctCount * 2 // 2 XP per correct answer
    }
    
    private var scopeTitle: String {
        switch scope {
        case .vowels: return "Vowels Quiz"
        case .consonants: return "Consonants Quiz"
        case .all: return "Letters Quiz"
        }
    }
    
    var body: some View {
        VStack(spacing: MTSpacing.large) {
            Spacer()
            
            // Success Animation
            VStack(spacing: MTSpacing.medium) {
                // Stars
                HStack(spacing: MTSpacing.small) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: index < starRating ? "star.fill" : "star")
                            .font(.system(size: 30))
                            .foregroundColor(index < starRating ? .yellow : MTColors.text.opacity(0.3))
                            .scaleEffect(showingStars && index < starRating ? 1.3 : 1.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: showingStars)
                    }
                }
                
                Text("\(scopeTitle) Complete!")
                    .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                    .opacity(showingXPAnimation ? 1 : 0)
                    .animation(.easeIn(duration: 0.5), value: showingXPAnimation)
            }
            
            // Stats Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: MTSpacing.medium) {
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
            VStack(spacing: MTSpacing.small) {
                Text(performanceMessage)
                    .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                    .multilineTextAlignment(.center)
                
                Text(encouragementMessage)
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(MTColors.surfaceAlt)
            .cornerRadius(12)
            
            Spacer()
        }
        .onAppear {
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
        VStack(spacing: MTSpacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            Text(title)
                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(MTColors.surfaceAlt)
        .cornerRadius(12)
    }
}
