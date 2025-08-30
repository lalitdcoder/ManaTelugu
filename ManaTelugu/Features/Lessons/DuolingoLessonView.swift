import SwiftUI
import AVFoundation

struct DuolingoLessonView: View {
    let lesson: Lesson
    let lessonsRepository: LessonsRepository
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentActivityIndex = 0
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer = ""
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showingFeedback = false
    @State private var isCorrect = false
    @State private var startTime = Date()
    @State private var questionStartTime = Date()
    @State private var responses: [ActivityResponse] = []
    @State private var showingCompletion = false
    @State private var xpEarned = 0
    @State private var showingLetterIntro = true
    @State private var showingTopicIntro = true
    
    private var currentActivity: LessonActivity? {
        guard currentActivityIndex < lesson.activities.count else { return nil }
        return lesson.activities[currentActivityIndex]
    }
    
    private var currentQuestion: ActivityQuestion? {
        guard let activity = currentActivity,
              currentQuestionIndex < activity.questions.count else { return nil }
        return activity.questions[currentQuestionIndex]
    }
    
    private var totalQuestions: Int {
        lesson.activities.reduce(0) { $0 + $1.questions.count }
    }
    
    private var completedQuestions: Int {
        var completed = 0
        for i in 0..<currentActivityIndex {
            completed += lesson.activities[i].questions.count
        }
        completed += currentQuestionIndex
        return completed
    }
    
    private var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(completedQuestions) / Double(totalQuestions)
    }
    
    var body: some View {
        GeometryReader { geometry in
            if showingTopicIntro {
                topicIntroductionView(geometry: geometry)
            } else if showingLetterIntro && isBeginnerLesson {
                letterIntroductionView(geometry: geometry)
            } else {
                VStack(spacing: 0) {
                    // Progress Bar
                    progressBar
                    
                    // Question Content
                    if let question = currentQuestion {
                        questionView(question: question, geometry: geometry)
                    } else {
                        completionView
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            questionStartTime = Date()
        }
        .sheet(isPresented: $showingCompletion) {
            DuolingoCompletionView(
                lesson: lesson,
                responses: responses,
                totalXP: xpEarned,
                timeSpent: Date().timeIntervalSince(startTime),
                onDismiss: {
                    saveProgress()
                    dismiss()
                }
            )
        }
    }
    
    private var isBeginnerLesson: Bool {
        lesson.levelId.contains("beginner") || lesson.difficulty == 1
    }
    
    private func topicIntroductionView(geometry: GeometryProxy) -> some View {
        VStack(spacing: MTSpacing.large) {
            // Header
            VStack(spacing: MTSpacing.small) {
                Text(lesson.title)
                    .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                    .multilineTextAlignment(.center)
                
                Text("Lesson Overview")
                    .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.primary)
                    .fontWeight(.medium)
            }
            .padding(.top, MTSpacing.large)
            
            Spacer()
            
            // Topic Explanation
            VStack(spacing: MTSpacing.medium) {
                Image(systemName: "book.open")
                    .font(.system(size: 60))
                    .foregroundColor(MTColors.primary)
                
                Text(lessonsRepository.getTopicExplanation(for: lesson))
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, MTSpacing.medium)
            }
            .padding()
            .background(MTColors.surfaceAlt)
            .cornerRadius(16)
            .padding(.horizontal)
            
            // Lesson Details
            VStack(spacing: MTSpacing.small) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(MTColors.text.opacity(0.7))
                    Text("\(lesson.estimatedMinutes) minutes")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                    
                    Spacer()
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(lesson.xpReward) XP")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
                
                HStack {
                    Image(systemName: "list.bullet")
                        .foregroundColor(MTColors.text.opacity(0.7))
                    Text("\(totalQuestions) questions")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                    
                    Spacer()
                    
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(MTColors.text.opacity(0.7))
                    Text("Level \(lesson.difficulty)")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
            }
            .padding()
            .background(MTColors.surface)
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                showingTopicIntro = false
            }) {
                Text("Start Learning")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(MTColors.primary)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, MTSpacing.large)
        }
        .background(MTColors.background)
    }
    
    private func letterIntroductionView(geometry: GeometryProxy) -> some View {
        VStack(spacing: MTSpacing.large) {
            // Header
            VStack(spacing: MTSpacing.small) {
                Text("New Letters")
                    .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                
                Text("Learn these letters in this lesson")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, MTSpacing.large)
            
            Spacer()
            
            // Letters Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.medium), count: 2), spacing: MTSpacing.large) {
                ForEach(getLettersForLesson(), id: \.self) { letter in
                    VStack(spacing: MTSpacing.small) {
                        Text(letter.glyph)
                            .font(.system(size: 64))
                            .foregroundColor(MTColors.text)
                        
                        Text(letter.transliteration)
                            .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.8))
                        
                        Button(action: {
                            session.audioService.play(name: letter.audioFile, rate: 1.0)
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.title2)
                                .foregroundColor(MTColors.primary)
                        }
                    }
                    .padding()
                    .background(MTColors.surfaceAlt)
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                showingLetterIntro = false
            }) {
                Text("Start Lesson")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(MTColors.primary)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, MTSpacing.large)
        }
        .background(MTColors.background)
    }
    
    private func getLettersForLesson() -> [Letter] {
        let allLetters = session.dataRepository.letters()
        
        // Proper sequence: All vowels first, then consonants, then syllables
        switch lesson.order {
        // Vowels - Lessons 1-4
        case 1:
            return allLetters.filter { ["అ", "ఆ", "ఇ", "ఈ"].contains($0.glyph) }
        case 2:
            return allLetters.filter { ["ఉ", "ఊ", "ఋ", "ౠ"].contains($0.glyph) }
        case 3:
            return allLetters.filter { ["ఎ", "ఏ", "ఐ", "ఒ"].contains($0.glyph) }
        case 4:
            return allLetters.filter { ["ఓ", "ఔ", "అం", "అః"].contains($0.glyph) }
        // Consonants - Lessons 5-10
        case 5:
            return allLetters.filter { ["క", "ఖ", "గ", "ఘ"].contains($0.glyph) }
        case 6:
            return allLetters.filter { ["చ", "ఛ", "జ", "ఝ"].contains($0.glyph) }
        case 7:
            return allLetters.filter { ["ట", "ఠ", "డ", "ఢ"].contains($0.glyph) }
        case 8:
            return allLetters.filter { ["త", "థ", "ద", "ధ"].contains($0.glyph) }
        case 9:
            return allLetters.filter { ["ప", "ఫ", "బ", "భ"].contains($0.glyph) }
        case 10:
            return allLetters.filter { ["మ", "య", "ర", "ల"].contains($0.glyph) }
        // Additional consonants and syllables for extended lessons
        case 11:
            return allLetters.filter { ["వ", "శ", "ష", "స"].contains($0.glyph) }
        case 12:
            return allLetters.filter { ["హ", "ళ", "క్ష", "జ్ఞ"].contains($0.glyph) }
        // Syllable formation starts only after consonants are complete
        case 13:
            return allLetters.filter { ["కా", "కి", "కీ", "కు"].contains($0.glyph) }
        case 14:
            return allLetters.filter { ["కూ", "కె", "కే", "కై"].contains($0.glyph) }
        case 15:
            return allLetters.filter { ["కో", "కౌ", "కం", "కః"].contains($0.glyph) }
        default:
            // For other lessons, show first 4 letters as fallback
            return Array(allLetters.prefix(4))
        }
    }
    
    private var progressBar: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(MTColors.text)
                }
                
                Spacer()
                
                Text("\(completedQuestions + 1)/\(totalQuestions)")
                    .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.7))
            }
            .padding(.horizontal)
            .padding(.top)
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: MTColors.primary))
                .scaleEffect(x: 1, y: 3, anchor: .center)
                .padding(.horizontal)
                .padding(.top, MTSpacing.small)
        }
        .background(MTColors.surface)
    }
    
    private func questionView(question: ActivityQuestion, geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Question Content Area
            ScrollView {
                VStack(spacing: MTSpacing.large) {
                    Spacer(minLength: 40)
                    
                    // Question Text
                    Text(question.question)
                        .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, MTSpacing.large)
                    
                    // Question Type Specific Content
                    questionContent(for: question)
                    
                    Spacer(minLength: 40)
                }
            }
            
            // Feedback Area
            if showingFeedback {
                feedbackView(for: question)
            }
            
            // Bottom Action Area
            bottomActionArea(for: question)
        }
    }
    
    private func questionContent(for question: ActivityQuestion) -> some View {
        VStack(spacing: MTSpacing.medium) {
            switch question.type {
            case .multipleChoice, .characterRecognition, .wordTranslation:
                multipleChoiceView(question: question)
            case .textInput:
                textInputView(question: question)
            case .tracing:
                tracingView(question: question)
            case .audioIdentification:
                audioView(question: question)
            case .speaking:
                speakingView(question: question)
            default:
                multipleChoiceView(question: question)
            }
        }
        .padding(.horizontal, MTSpacing.large)
    }
    
    private func multipleChoiceView(question: ActivityQuestion) -> some View {
        VStack(spacing: MTSpacing.medium) {
            if let options = question.options {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedAnswer = option
                    }) {
                        HStack {
                            Text(option)
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .foregroundColor(selectedAnswer == option ? .white : MTColors.text)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedAnswer == option ? MTColors.primary : MTColors.surfaceAlt)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedAnswer == option ? MTColors.primary : MTColors.text.opacity(0.2), lineWidth: 2)
                                )
                        )
                    }
                    .disabled(showingFeedback)
                }
            }
        }
    }
    
    private func textInputView(question: ActivityQuestion) -> some View {
        VStack(spacing: MTSpacing.medium) {
            TextField("Type your answer...", text: $selectedAnswer)
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .padding()
                .background(MTColors.surfaceAlt)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(MTColors.text.opacity(0.2), lineWidth: 1)
                )
                .disabled(showingFeedback)
        }
    }
    
    private func speakingView(question: ActivityQuestion) -> some View {
        VStack(spacing: MTSpacing.large) {
            Image(systemName: "mic.slash")
                .font(.system(size: 60))
                .foregroundColor(MTColors.text.opacity(0.4))
            
            Text("Speaking Practice")
                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            Text("Coming Soon!")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.primary)
                .fontWeight(.medium)
            
            Text("This feature will include voice recognition for pronunciation practice.")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(MTColors.surfaceAlt.opacity(0.5))
        .cornerRadius(12)
    }
    
    private func feedbackView(for question: ActivityQuestion) -> some View {
        VStack(spacing: MTSpacing.medium) {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(isCorrect ? .green : .red)
                
                Text(isCorrect ? "Correct!" : "Incorrect")
                    .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                    .foregroundColor(isCorrect ? .green : .red)
                
                Spacer()
                
                if isCorrect, let activity = currentActivity {
                    Text("+\(activity.xpValue / activity.questions.count) XP")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
            }
            
            if let explanation = question.explanation {
                Text(explanation)
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.8))
                    .multilineTextAlignment(.leading)
            }
            
            if !isCorrect {
                Text("Correct answer: \(question.correctAnswer)")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func bottomActionArea(for question: ActivityQuestion) -> some View {
        VStack(spacing: MTSpacing.medium) {
            if showingFeedback {
                Button(action: nextQuestion) {
                    Text(isLastQuestion() ? "Complete Lesson" : "Continue")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(MTColors.primary)
                        .cornerRadius(12)
                }
            } else {
                HStack(spacing: MTSpacing.medium) {
                    if question.type == .speaking {
                        Button(action: skipQuestion) {
                            Text("Skip")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text.opacity(0.7))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(MTColors.surfaceAlt)
                                .cornerRadius(12)
                        }
                    }
                    
                    Button(action: checkAnswer) {
                        Text("Check")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedAnswer.isEmpty ? MTColors.text.opacity(0.3) : MTColors.primary)
                            .cornerRadius(12)
                    }
                    .disabled(selectedAnswer.isEmpty && question.type != .speaking)
                }
            }
        }
        .padding()
        .background(MTColors.surface)
    }
    
    private var completionView: some View {
        VStack(spacing: MTSpacing.large) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Lesson Complete!")
                .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            Text("Great job! You've completed all questions.")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showingCompletion = true
            }
        }
    }
    
    // MARK: - Actions
    private func checkAnswer() {
        let timeSpent = Date().timeIntervalSince(questionStartTime)
        guard let question = currentQuestion else { return }
        
        isCorrect = selectedAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == 
                   question.correctAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        let questionXP = (currentActivity?.xpValue ?? 0) / (currentActivity?.questions.count ?? 1)
        
        let response = ActivityResponse(
            id: UUID().uuidString,
            activityId: currentActivity?.id ?? "",
            questionId: question.id,
            userAnswer: selectedAnswer,
            isCorrect: isCorrect,
            timeSpent: timeSpent,
            xpEarned: isCorrect ? questionXP : 0,
            timestamp: Date()
        )
        
        responses.append(response)
        
        if isCorrect {
            xpEarned += questionXP
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showingFeedback = true
        }
    }
    
    private func skipQuestion() {
        let timeSpent = Date().timeIntervalSince(questionStartTime)
        guard let question = currentQuestion else { return }
        
        let questionXP = (currentActivity?.xpValue ?? 0) / (currentActivity?.questions.count ?? 1)
        
        let response = ActivityResponse(
            id: UUID().uuidString,
            activityId: currentActivity?.id ?? "",
            questionId: question.id,
            userAnswer: "",
            isCorrect: false,
            timeSpent: timeSpent,
            xpEarned: questionXP / 2, // Half XP for skipping
            timestamp: Date()
        )
        
        responses.append(response)
        xpEarned += questionXP / 2
        
        nextQuestion()
    }
    
    private func nextQuestion() {
        selectedAnswer = ""
        showingFeedback = false
        questionStartTime = Date()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if let activity = currentActivity, currentQuestionIndex < activity.questions.count - 1 {
                // Move to next question in current activity
                currentQuestionIndex += 1
            } else if currentActivityIndex < lesson.activities.count - 1 {
                // Move to next activity
                currentActivityIndex += 1
                currentQuestionIndex = 0
            } else {
                // All activities completed
                currentQuestionIndex += 1
            }
        }
    }
    
    private func isLastQuestion() -> Bool {
        return currentActivityIndex == lesson.activities.count - 1 && 
               currentQuestionIndex == (currentActivity?.questions.count ?? 0) - 1
    }
    
    private func tracingView(question: ActivityQuestion) -> some View {
        VStack(spacing: MTSpacing.large) {
            Text("Writing Practice")
                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            // Character to trace
            Text(question.correctAnswer)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(MTColors.text.opacity(0.3))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(MTColors.surfaceAlt.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(MTColors.text.opacity(0.2), lineWidth: 2)
                        )
                )
            
            // Tracing Canvas
            TracingCanvasView(
                targetCharacter: question.correctAnswer,
                onTracingComplete: { isCorrect in
                    selectedAnswer = question.correctAnswer
                    self.isCorrect = isCorrect
                }
            )
            .frame(height: 200)
            .background(MTColors.surface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(MTColors.primary.opacity(0.3), lineWidth: 2)
            )
            
            if let strokeOrder = question.strokeOrder, !strokeOrder.isEmpty {
                VStack(alignment: .leading, spacing: MTSpacing.small) {
                    Text("Stroke Order:")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .fontWeight(.medium)
                        .foregroundColor(MTColors.text)
                    
                    ForEach(Array(strokeOrder.enumerated()), id: \.offset) { index, step in
                        HStack {
                            Text("\(index + 1)")
                                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Circle().fill(MTColors.primary))
                            
                            Text(step)
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text.opacity(0.8))
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(MTColors.surfaceAlt.opacity(0.5))
                .cornerRadius(12)
            }
            
            Text("Trace the character in the canvas above")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .onAppear {
            // Auto-select correct answer for tracing (since it's practice)
            selectedAnswer = question.correctAnswer
        }
    }
    
    private func audioView(question: ActivityQuestion) -> some View {
        VStack(spacing: MTSpacing.large) {
            Image(systemName: "speaker.wave.2")
                .font(.system(size: 60))
                .foregroundColor(MTColors.primary)
            
            Text("Listening Practice")
                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            Button(action: {
                playAudioForCharacter(question.correctAnswer)
            }) {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                    Text("Play Audio")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                }
                .foregroundColor(MTColors.primary)
                .padding()
                .background(MTColors.surfaceAlt)
                .cornerRadius(12)
            }
            
            Text("Listen and select the correct answer")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
                .multilineTextAlignment(.center)
            
            // Multiple choice options for listening
            if let options = question.options {
                VStack(spacing: MTSpacing.medium) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedAnswer = option
                        }) {
                            HStack {
                                Text(option)
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .foregroundColor(selectedAnswer == option ? .white : MTColors.text)
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedAnswer == option ? MTColors.primary : MTColors.surfaceAlt)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedAnswer == option ? MTColors.primary : MTColors.text.opacity(0.2), lineWidth: 2)
                                    )
                            )
                        }
                        .disabled(showingFeedback)
                    }
                }
                .padding(.top, MTSpacing.medium)
            }
        }
    }
    
    private func saveProgress() {
        let correctCount = responses.filter { $0.isCorrect }.count
        let totalTime = Date().timeIntervalSince(startTime)
        
        lessonsRepository.completeLesson(
            lesson,
            xpEarned: xpEarned,
            correctAnswers: correctCount,
            totalQuestions: responses.count,
            timeSpent: totalTime,
            responses: responses
        )
        
        session.userProfile.totalXP += xpEarned
        if correctCount > responses.count / 2 {
            session.userProfile.streakDays += 1
        }
    }
    
    // MARK: - Audio Playback
    private func playAudioForCharacter(_ character: String) {
        // Use text-to-speech for Telugu characters
        let utterance = AVSpeechUtterance(string: character)
        utterance.voice = AVSpeechSynthesisVoice(language: "te-IN") // Telugu voice
        utterance.rate = 0.4 // Slower rate for learning
        utterance.volume = 1.0
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
