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
    @State private var lessonLetters: [Letter] = []
    @State private var teachingMomentAnimation = false
    
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
    
    private struct AudioToLetterMatchState {
        var matched: [Int: String] = [:] // audioIndex: letter
        var currentAudioIndex: Int? = nil
    }

    @State private var audioToLetterMatchState = AudioToLetterMatchState()
    
    var body: some View {
        GeometryReader { geometry in
            if !isBeginnerLesson {
                VStack {
                    Spacer()
                    Image(systemName: "hammer")
                        .font(.system(size: 48))
                        .foregroundColor(MTColors.primary)
                        .padding(.bottom, 16)
                    Text("These lessons are in development. Come back later.")
                        .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
            } else if showingTopicIntro {
                topicIntroductionView(geometry: geometry)
            } else if showingLetterIntro && !isBeginnerLesson {
                // Only show letter intro for non-beginner lessons
                // Beginner lessons teach letters just-in-time
                letterIntroductionView(geometry: geometry)
            } else {
                VStack(spacing: 0) {
                    // Progress Bar
                    progressBar
                    
                    // Question Content
                    if let question = currentQuestion {
                        questionView(question: question, geometry: geometry)
                    } else if lesson.activities.isEmpty {
                        // Debug: Show if no activities
                        VStack(spacing: MTSpacing.large) {
                            Text("Debug: No Activities Found")
                                .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.primary)
                            
                            Text("Lesson: \(lesson.title)")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            
                            Text("Activities count: \(lesson.activities.count)")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            
                            Text("Level ID: \(lesson.levelId)")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            
                            Text("Lesson ID: \(lesson.id)")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            
                            Text("Difficulty: \(lesson.difficulty)")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            
                            Text("Is Beginner: \(isBeginnerLesson ? "Yes" : "No")")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .foregroundColor(isBeginnerLesson ? .green : .red)
                            
                            Button("Reload Lesson") {
                                // Force reload
                                Task {
                                    lessonLetters = await getLettersForLessonSync()
                                }
                            }
                            .padding()
                            .background(MTColors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding()
                    } else {
                        completionView
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            questionStartTime = Date()
            Task {
                lessonLetters = await getLettersForLessonSync()
            }
            
            // For beginner lessons: show topic intro but skip bulk letter intro
            // (letters will be taught just-in-time)
            if isBeginnerLesson {
                showingTopicIntro = true
                showingLetterIntro = false // Skip bulk intro, teach just-in-time
            } else {
                showingTopicIntro = false
                showingLetterIntro = false
            }
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
                
                Text("Learn about \(lesson.title)")
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
            
            // Letters Grid - Show all 4 letters in a single row
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.medium), count: 4), spacing: MTSpacing.large) {
                ForEach(lessonLetters, id: \.self) { letter in
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
    
    private func getLettersForLesson() async -> [Letter] {
        return await getLettersForLessonSync()
    }
    
    private func getLettersForLessonSync() async -> [Letter] {
        let allLetters = await session.dataRepository.letters()
        switch lesson.order {
        case 1:
            return allLetters.filter { ["అ", "ఆ", "ఇ", "ఈ"].contains($0.glyph) }
        case 2:
            return allLetters.filter { ["ఉ", "ఊ", "ఋ", "ఎ", "ఏ"].contains($0.glyph) }
        case 3:
            return allLetters.filter { ["ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః"].contains($0.glyph) }
        case 4:
            return allLetters.filter { ["క", "ఖ", "గ", "ఘ", "ఙ"].contains($0.glyph) }
        case 5:
            return allLetters.filter { ["చ", "ఛ", "జ", "ఝ", "ఞ"].contains($0.glyph) }
        case 6:
            return allLetters.filter { ["ట", "ఠ", "డ", "ఢ", "ణ"].contains($0.glyph) }
        case 7:
            return allLetters.filter { ["త", "థ", "ద", "ధ", "న"].contains($0.glyph) }
        case 8:
            return allLetters.filter { ["ప", "ఫ", "బ", "భ", "మ"].contains($0.glyph) }
        case 9:
            return allLetters.filter { ["య", "ర", "ల", "వ", "శ", "ష", "స", "హ", "ళ", "క్ష", "ఱ"].contains($0.glyph) }
        case 10:
            return allLetters.filter { ["అ","ఆ","ఇ","ఈ","ఉ","ఊ","క","గ","చ","జ","త","ద"].contains($0.glyph) }
        default:
            return []
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
            if question.question == "interactive_audio_match" {
                audioToLetterMatchView(question: question)
            } else if question.question == "teaching_moment" {
                teachingMomentView(question: question)
            } else {
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
        }
        .padding(.horizontal, MTSpacing.large)
    }
    
    private func audioToLetterMatchView(question: ActivityQuestion) -> some View {
        let audioFiles = (question.audioFile ?? "").split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let options = question.options ?? []
        return VStack(spacing: MTSpacing.large) {
            Text("Match each sound to its letter")
                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.primary)
            // Audio buttons
            HStack(spacing: MTSpacing.medium) {
                ForEach(audioFiles.indices, id: \.self) { idx in
                    VStack {
                        Button(action: {
                            playAudioFile(audioFiles[idx])
                            audioToLetterMatchState.currentAudioIndex = idx
                        }) {
                            Image(systemName: audioToLetterMatchState.matched[idx] != nil ? "checkmark.circle.fill" : "play.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(audioToLetterMatchState.matched[idx] != nil ? MTColors.success : MTColors.primary)
                        }
                        Text("Sound \(idx + 1)")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    }
                }
            }
            // Option letter cards
            Text("Tap a sound, then tap the matching letter")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60), spacing: 16)], spacing: 16) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        if let idx = audioToLetterMatchState.currentAudioIndex, audioToLetterMatchState.matched[idx] == nil {
                            let correctLetter = String(audioFiles[idx].replacingOccurrences(of: ".mp3", with: ""))
                            if option == correctLetter {
                                audioToLetterMatchState.matched[idx] = option
                                session.audioService.play(name: "success.mp3", rate: 1.0)
                                #if os(iOS)
                                session.hapticsService.success()
                                #endif
                            } else {
                                session.audioService.play(name: "tryagain.mp3", rate: 1.0)
                            }
                            audioToLetterMatchState.currentAudioIndex = nil
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(MTColors.surfaceAlt)
                                .frame(height: 60)
                            Text(option)
                                .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text)
                        }
                    }
                    .disabled(audioToLetterMatchState.matched.values.contains(option))
                }
            }
            // Continue button
            if audioToLetterMatchState.matched.count == audioFiles.count {
                Button(action: nextQuestion) {
                    Text("Continue")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .padding()
                        .background(MTColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, MTSpacing.large)
            }
        }
        .onAppear {
            audioToLetterMatchState = AudioToLetterMatchState()
        }
    }

    private func playAudioFile(_ name: String) {
        session.audioService.play(name: name, rate: 1.0)
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
            if question.question == "teaching_moment" {
                // Teaching moment - just continue button
                Button(action: nextQuestion) {
                    Text("Got it!")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(MTColors.primary)
                        .cornerRadius(12)
                }
            } else if showingFeedback {
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
            session.audioService.play(name: "success.mp3", rate: 1.0)
            #if os(iOS)
            session.hapticsService.success()
            #endif
        } else {
            session.audioService.play(name: "tryagain.mp3", rate: 1.0)
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
        let referenceStrokes = lessonLetters.first(where: { $0.glyph == question.correctAnswer })?.strokePathPoints ?? []
        return VStack(spacing: MTSpacing.large) {
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
                referenceStrokes: referenceStrokes,
                onTracingComplete: { isCorrect in
                    selectedAnswer = question.correctAnswer
                    self.isCorrect = isCorrect
                    if isCorrect {
                        session.audioService.play(name: "success.mp3", rate: 1.0)
                        #if os(iOS)
                        session.hapticsService.success()
                        #endif
                    } else {
                        session.audioService.play(name: "tryagain.mp3", rate: 1.0)
                    }
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
                playQuestionAudio(question)
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
        
        lessonsRepository.markLessonComplete(lessonId: lesson.id, levelId: lesson.levelId)
        
        session.userProfile.totalXP += xpEarned
        if correctCount > responses.count / 2 {
            session.userProfile.streakDays += 1
        }
    }
    
    // MARK: - Audio Playback
    private func playQuestionAudio(_ question: ActivityQuestion) {
        // 0) Special mapping for first four vowels
        let vowelAudioMap: [String: String] = [
            "అ": "letter_a.mp3",
            "ఆ": "letter_aa.mp3",
            "ఇ": "letter_i.mp3",
            "ఈ": "letter_ii.mp3"
        ]
        if let mapped = vowelAudioMap[question.correctAnswer] {
            session.audioService.play(name: mapped, rate: 1.0)
            return
        }
        // 1) If the question specifies an audio file, use it
        if let file = question.audioFile {
            session.audioService.play(name: file, rate: 1.0)
            return
        }
        // 2) If we have a matching letter in the lesson letters, use its audio file
        if let letter = lessonLetters.first(where: { $0.glyph == question.correctAnswer }) {
            session.audioService.play(name: letter.audioFile, rate: 1.0)
            return
        }
        // 3) Try a file named directly after the glyph (e.g., "అ.mp3")
        let directName = "\(question.correctAnswer).mp3"
        session.audioService.play(name: directName, rate: 1.0)
        if session.audioService.isPlaying() { return }
        // 4) Fallback to iOS Telugu TTS
        let utterance = AVSpeechUtterance(string: question.correctAnswer)
        utterance.voice = AVSpeechSynthesisVoice(language: "te-IN")
        utterance.rate = 0.5
        AVSpeechSynthesizer().speak(utterance)
    }
    
    private func teachingMomentView(question: ActivityQuestion) -> some View {
        VStack(spacing: MTSpacing.large) {
            Text("New Letter!")
                .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.primary)
                .fontWeight(.bold)
            
            // Large letter display with animation
            Text(question.correctAnswer)
                .font(.system(size: 120, weight: .light))
                .foregroundColor(MTColors.text)
                .padding()
                .background(
                    Circle()
                        .fill(MTColors.surfaceAlt)
                        .overlay(
                            Circle()
                                .stroke(MTColors.primary.opacity(0.3), lineWidth: 3)
                        )
                )
                .scaleEffect(teachingMomentAnimation ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: teachingMomentAnimation)
            
            // Audio play button
            Button(action: {
                playQuestionAudio(question)
            }) {
                HStack {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title2)
                    Text("Listen")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding()
                .background(MTColors.primary)
                .cornerRadius(25)
            }
            
            // Explanation
            if let explanation = question.explanation {
                Text(explanation)
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Text("Listen carefully and get ready for questions about this letter!")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .onAppear {
            // Auto-play audio when teaching moment appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                playQuestionAudio(question)
            }
            // Start subtle animation
            teachingMomentAnimation = true
        }
    }
}
