import SwiftUI

struct LessonFlowView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    let lesson: TeluguLesson
    @State private var currentActivityIndex = 0
    @State private var activities: [TeluguLessonActivity] = []
    @State private var selectedAnswer = ""
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var progress: Double = 0
    
    var body: some View {
        ZStack {
            ElegantGradient()
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 0) {
                // Progress Bar
                progressBar
                
                // Activity Content
                if currentActivityIndex < activities.count {
                    activityContent(activities[currentActivityIndex])
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else {
                    lessonCompleteView
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            generateActivities()
        }
    }
    
    private var progressBar: some View {
        VStack(spacing: ElegantDesign.Spacing.sm) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(ElegantDesign.Colors.textSecondary)
                }
                
                Spacer()
                
                Text("\(currentActivityIndex + 1)/\(activities.count)")
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
            }
            
            ProgressView(value: progress)
                .tint(ElegantDesign.Colors.primary)
                .scaleEffect(y: 2)
        }
        .padding(ElegantDesign.Spacing.md)
    }
    
    @ViewBuilder
    private func activityContent(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ElegantDesign.Spacing.xl) {
            Spacer()
            
            switch activity.type {
            case .intro:
                introView(activity)
            case .reading, .listening:
                multipleChoiceView(activity)
            case .writing:
                writingView(activity)
            case .review:
                reviewView(activity)
            }
            
            Spacer()
            
            // Continue Button
            continueButton
        }
        .padding(ElegantDesign.Spacing.lg)
        .overlay(
            // Feedback overlay - positioned over the content
            feedbackOverlay,
            alignment: .bottom
        )
    }
    
    private func introView(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ElegantDesign.Spacing.xl) {
            Text(activity.letter?.character ?? "")
                .font(.system(size: 180, weight: .medium, design: .serif))
                .foregroundColor(ElegantDesign.Colors.primary)
            
            Text(activity.question)
                .font(ElegantDesign.Typography.title2)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
                .multilineTextAlignment(.center)
            
            // Audio button
            Button(action: {
                // Play letter sound
                playLetterSound(activity.letter?.character ?? "")
            }) {
                HStack {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title2)
                    Text("Listen")
                        .font(ElegantDesign.Typography.callout)
                }
                .foregroundColor(.white)
                .padding(ElegantDesign.Spacing.md)
                .background(ElegantDesign.Colors.primary)
                .cornerRadius(ElegantDesign.CornerRadius.md)
            }
        }
    }
    
    private func multipleChoiceView(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ElegantDesign.Spacing.xl) {
            if activity.type == .listening {
                // For listening, show audio button instead of question text
                VStack(spacing: ElegantDesign.Spacing.md) {
                    Text("Listen to the sound")
                        .font(ElegantDesign.Typography.title2)
                        .foregroundColor(ElegantDesign.Colors.textPrimary)
                    
                    Button(action: {
                        playLetterSound(activity.letter?.character ?? "")
                    }) {
                        Image(systemName: "speaker.wave.3.fill")
                            .font(.system(size: 60))
                            .foregroundColor(ElegantDesign.Colors.primary)
                            .padding(ElegantDesign.Spacing.lg)
                            .background(Circle().fill(ElegantDesign.Colors.primary.opacity(0.1)))
                    }
                }
            } else {
                // For reading, show the letter
                Text(activity.question)
                    .font(ElegantDesign.Typography.title2)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(activity.letter?.character ?? "")
                    .font(.system(size: 120, weight: .medium, design: .serif))
                    .foregroundColor(ElegantDesign.Colors.primary)
            }
            
            VStack(spacing: ElegantDesign.Spacing.md) {
                ForEach(activity.options, id: \.self) { option in
                    optionButton(option, activity: activity)
                }
            }
        }
    }
    
    private func optionButton(_ option: String, activity: TeluguLessonActivity) -> some View {
        Button(action: {
            selectedAnswer = option
            isCorrect = option == activity.correctAnswer
            showFeedback = true
            
            if isCorrect {
                session.audioFeedback.playSuccess()
            } else {
                session.audioFeedback.playTryAgain()
            }
        }) {
            HStack {
                if activity.type == .listening {
                    Text(option)
                        .font(.system(size: 40, weight: .medium, design: .serif))
                        .foregroundColor(ElegantDesign.Colors.primary)
                } else {
                    Text(option)
                        .font(ElegantDesign.Typography.callout)
                        .foregroundColor(ElegantDesign.Colors.textPrimary)
                }
                
                Spacer()
                
                if showFeedback && selectedAnswer == option {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                        .font(.title2)
                }
            }
            .padding(ElegantDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                    .fill(showFeedback && selectedAnswer == option ? 
                          (isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1)) :
                          ElegantDesign.Colors.surfaceSecondary)
                    .stroke(showFeedback && selectedAnswer == option ?
                           (isCorrect ? Color.green : Color.red) :
                           ElegantDesign.Colors.primary.opacity(0.3), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(showFeedback)
    }
    
    private func writingView(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ElegantDesign.Spacing.xl) {
            Text("Trace the letter")
                .font(ElegantDesign.Typography.title2)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            TracingCanvasView(
                targetCharacter: activity.letter?.character ?? "",
                referenceStrokes: [], // Empty for now - can be populated later
                onTracingComplete: { success in
                    isCorrect = success
                    showFeedback = true
                    if success {
                        session.audioFeedback.playSuccess()
                    } else {
                        session.audioFeedback.playTryAgain()
                    }
                }
            )
            .frame(width: 200, height: 200)
        }
    }
    
    private func reviewView(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ElegantDesign.Spacing.xl) {
            Text("Review: \(activity.question)")
                .font(ElegantDesign.Typography.title2)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(activity.letter?.character ?? "")
                .font(.system(size: 80, weight: .medium, design: .serif))
                .foregroundColor(ElegantDesign.Colors.primary)
            
            VStack(spacing: ElegantDesign.Spacing.md) {
                ForEach(activity.options, id: \.self) { option in
                    optionButton(option, activity: activity)
                }
            }
        }
    }
    
    private var continueButton: some View {
        Button(action: nextActivity) {
            Text(showFeedback ? "Continue" : (activities[currentActivityIndex].type == .intro ? "Got it!" : "Skip"))
                .font(ElegantDesign.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(ElegantDesign.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                        .fill(showFeedback || activities[currentActivityIndex].type == .intro ? 
                              ElegantDesign.Colors.primary : ElegantDesign.Colors.textTertiary)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var feedbackOverlay: some View {
        Group {
            if showFeedback {
                HStack {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(isCorrect ? .green : .red)
                    
                    Text(isCorrect ? "Correct!" : "Incorrect")
                        .font(ElegantDesign.Typography.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(isCorrect ? .green : .red)
                    
                    Spacer()
                }
                .padding(ElegantDesign.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                        .fill(isCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                        .stroke(isCorrect ? Color.green : Color.red, lineWidth: 2)
                )
                .padding(.horizontal, ElegantDesign.Spacing.md)
                .padding(.bottom, ElegantDesign.Spacing.xl)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showFeedback)
            }
        }
    }
    
    private func playLetterSound(_ letter: String) {
        // The AudioService expects filename with extension since it uses withExtension: nil
        let fileName = "\(letter).mp3"
        session.audioService.play(name: fileName, rate: 1.0)
        print("Playing sound for: \(letter)")
    }
    
    private var lessonCompleteView: some View {
        VStack(spacing: ElegantDesign.Spacing.xl) {
            Spacer()
            
            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundColor(ElegantDesign.Colors.accent)
            
            Text("Lesson Complete!")
                .font(ElegantDesign.Typography.title1)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Text("You learned \(lesson.letters.count) new letters")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Text("Continue")
                    .font(ElegantDesign.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(ElegantDesign.Spacing.md)
                    .background(ElegantDesign.Colors.primary)
                    .cornerRadius(ElegantDesign.CornerRadius.md)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(ElegantDesign.Spacing.lg)
    }
    
    private func nextActivity() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if showFeedback || activities[currentActivityIndex].type == .intro {
                currentActivityIndex += 1
                progress = Double(currentActivityIndex) / Double(activities.count)
                showFeedback = false
                selectedAnswer = ""
            }
        }
    }
    
    private func generateActivities() {
        var newActivities: [TeluguLessonActivity] = []
        
        // Generate activities for each letter
        for letter in lesson.letters {
            // Intro
            newActivities.append(TeluguLessonActivity(
                type: .intro,
                letter: letter,
                question: letter.description,
                options: [],
                correctAnswer: ""
            ))
            
            // Reading Practice
            let readingOptions = generateOptions(for: letter, from: lesson.letters)
            newActivities.append(TeluguLessonActivity(
                type: .reading,
                letter: letter,
                question: "Which letter is this?",
                options: readingOptions,
                correctAnswer: letter.romanization
            ))
            
            // Listening Practice
            newActivities.append(TeluguLessonActivity(
                type: .listening,
                letter: letter,
                question: "Select \(letter.romanization)",
                options: lesson.letters.map { $0.character },
                correctAnswer: letter.character
            ))
            
            // Writing Practice
            newActivities.append(TeluguLessonActivity(
                type: .writing,
                letter: letter,
                question: "Trace this letter",
                options: [],
                correctAnswer: ""
            ))
        }
        
        // Review Section
        for letter in lesson.letters {
            newActivities.append(TeluguLessonActivity(
                type: .review,
                letter: letter,
                question: "Review: Which letter is this?",
                options: generateOptions(for: letter, from: lesson.letters),
                correctAnswer: letter.romanization
            ))
        }
        
        activities = newActivities
        progress = 0
    }
    
    private func generateOptions(for letter: TeluguLetterData, from letters: [TeluguLetterData]) -> [String] {
        var options = [letter.romanization]
        let otherOptions = letters.filter { $0.romanization != letter.romanization }.map { $0.romanization }
        options.append(contentsOf: Array(otherOptions.prefix(3)))
        return options.shuffled()
    }
}
