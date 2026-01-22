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
    @State private var validate = false  // <-- Added for TracingCanvasView
    @State private var startTime = Date()
    @State private var responses: [ActivityResponse] = []

    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)

            VStack(spacing: 0) {
                // Progress Bar
                progressBar

                // Scrollable Activity Content
                ScrollView {
                    if activities.isEmpty {
                        // Loading state while activities are being generated
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Loading lesson...")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(40)
                    } else if currentActivityIndex < activities.count {
                        activityContent(activities[currentActivityIndex])
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)))
                    } else {
                        // Show proper completion view with time and percentage
                        LessonCompletionView(
                            lesson: convertToLesson(lesson),
                            responses: responses,
                            totalXP: calculateTotalXP(),
                            timeSpent: Date().timeIntervalSince(startTime),
                            onDismiss: { dismiss() }
                        )
                    }
                }

                if showFeedback {
                    feedbackOverlay
                }

                // Continue Button (fixed at bottom)
                if currentActivityIndex < activities.count {
                    continueButton
                        .padding(.horizontal, ModernDesignSystem.Spacing.lg)
                        .padding(.bottom, ModernDesignSystem.Spacing.md)
                }
            }
        }  // Closing brace for ZStack
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
        .onAppear {
            generateActivities()
        }
    }  // Closing brace for body property

    private var progressBar: some View {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
            HStack {
                Button(action: {
                    HapticsService.shared.navigationTap()
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
                .buttonStyle(.plain)

                Spacer()

                Text("\(currentActivityIndex + 1)/\(activities.count)")
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }

            ProgressView(value: progress)
                .tint(ModernDesignSystem.Colors.primary)
                .scaleEffect(y: 2)
        }
        .padding(ModernDesignSystem.Spacing.md)
    }

    @ViewBuilder
    private func activityContent(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.xl) {
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
        }
        .padding(ModernDesignSystem.Spacing.lg)
    }

    private func introView(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.xl) {
            Text(activity.letter?.character ?? "")
                .font(.system(size: 180, weight: .medium, design: .serif))
                .foregroundColor(ModernDesignSystem.Colors.primary)

            Text(activity.question)
                .font(ModernDesignSystem.Typography.title2)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)

            // Audio button
            Button(action: {
                HapticsService.shared.audioPlay()
                playLetterSound(activity.letter?.character ?? "")
            }) {
                HStack {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title2)
                    Text("Listen")
                        .font(ModernDesignSystem.Typography.callout)
                }
                .foregroundColor(.white)
                .padding(ModernDesignSystem.Spacing.md)
                .background(ModernDesignSystem.Colors.primary)
                .cornerRadius(ModernDesignSystem.CornerRadius.md)
            }
            .buttonStyle(.plain)
        }
    }

    private func multipleChoiceView(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.xl) {
            if activity.type == .listening {
                // For listening, show audio button instead of question text
                VStack(spacing: ModernDesignSystem.Spacing.md) {
                    Text("Listen to the sound")
                        .font(ModernDesignSystem.Typography.title2)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                    Button(action: {
                        HapticsService.shared.audioPlay()
                        playLetterSound(activity.letter?.character ?? "")
                    }) {
                        Image(systemName: "speaker.wave.3.fill")
                            .font(.system(size: 60))
                            .foregroundColor(ModernDesignSystem.Colors.primary)
                            .padding(ModernDesignSystem.Spacing.lg)
                            .background(
                                Circle().fill(ModernDesignSystem.Colors.primary.opacity(0.1)))
                    }
                    .buttonStyle(.plain)
                }
            } else {
                // For reading, show the letter
                Text(activity.question)
                    .font(ModernDesignSystem.Typography.title2)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(activity.letter?.character ?? "")
                    .font(.system(size: 120, weight: .medium, design: .serif))
                    .foregroundColor(ModernDesignSystem.Colors.primary)
            }

            VStack(spacing: ModernDesignSystem.Spacing.md) {
                ForEach(activity.options, id: \.self) { option in
                    optionButton(option, activity: activity)
                }
            }
        }
    }

    private func optionButton(_ option: String, activity: TeluguLessonActivity) -> some View {
        Button(action: {
            let correct = option == activity.correctAnswer
            if correct {
                FeedbackCenter.correct()
            } else {
                FeedbackCenter.wrong()
            }
            selectedAnswer = option
            isCorrect = correct
            showFeedback = true
        }) {
            HStack {
                if activity.type == .listening {
                    Text(option)
                        .font(.system(size: 40, weight: .medium, design: .serif))
                        .foregroundColor(ModernDesignSystem.Colors.primary)
                } else {
                    Text(option)
                        .font(ModernDesignSystem.Typography.callout)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                }

                Spacer()

                if showFeedback && selectedAnswer == option {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                        .font(.title2)
                }
            }
            .padding(ModernDesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
                    .fill(
                        showFeedback && selectedAnswer == option
                            ? (isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                            : ModernDesignSystem.Colors.surfaceSecondary
                    )
                    .stroke(
                        showFeedback && selectedAnswer == option
                            ? (isCorrect ? Color.green : Color.red)
                            : ModernDesignSystem.Colors.primary.opacity(0.3), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .disabled(showFeedback)
    }

    private func writingView(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            Text("Trace the letter")
                .font(ModernDesignSystem.Typography.title3)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            TracingCanvasView(
                targetCharacter: activity.letter?.character ?? "",
                referenceStrokes: [],
                clearCanvas: .constant(false),
                validate: $validate,
                onTracingComplete: { success in
                    // For lessons without reference strokes, use basic validation
                    isCorrect = success  // Use the canvas's built-in validation
                    showFeedback = true
                    if isCorrect {
                        FeedbackCenter.correct()
                        // Award XP for successful tracing (no extra streak bonus)
                        session.gamificationService.awardXP(
                            10, type: .quizCompleted, description: "Letter tracing completed")
                    } else {
                        FeedbackCenter.wrong()
                    }
                },
                isLessonMode: true
            )
            .aspectRatio(1.0, contentMode: .fit)
            .frame(
                maxHeight: UIScreen.main.bounds.height < 700
                    ? 250 : (UIScreen.main.bounds.height < 900 ? 350 : 400))
        }
    }

    private func reviewView(_ activity: TeluguLessonActivity) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.xl) {
            Text("Review: \(activity.question)")
                .font(ModernDesignSystem.Typography.title2)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)

            Text(activity.letter?.character ?? "")
                .font(.system(size: 80, weight: .medium, design: .serif))
                .foregroundColor(ModernDesignSystem.Colors.primary)

            VStack(spacing: ModernDesignSystem.Spacing.md) {
                ForEach(activity.options, id: \.self) { option in
                    optionButton(option, activity: activity)
                }
            }
        }
    }

    private var continueButton: some View {
        Button(action: {
            HapticsService.shared.importantAction()
            if activities[currentActivityIndex].type == .writing && !showFeedback {
                validate = true
            } else {
                nextActivity()
            }
        }) {
            Text(buttonText)
                .font(ModernDesignSystem.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(ModernDesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
                        .fill(buttonColor)
                )
        }
        .buttonStyle(.plain)
    }

    private var buttonText: String {
        if showFeedback {
            return "Continue"
        } else if activities[currentActivityIndex].type == .intro {
            return "Got it!"
        } else if activities[currentActivityIndex].type == .writing {
            return "Check"
        } else {
            return "Skip"
        }
    }

    private var buttonColor: Color {
        if showFeedback || activities[currentActivityIndex].type == .intro
            || activities[currentActivityIndex].type == .writing
        {
            return ModernDesignSystem.Colors.primary
        } else {
            return ModernDesignSystem.Colors.textTertiary
        }
    }

    private var feedbackOverlay: some View {
        HStack {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title)
                .foregroundColor(isCorrect ? .green : .red)

            Text(isCorrect ? "Correct!" : "Incorrect")
                .font(ModernDesignSystem.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(isCorrect ? .green : .red)

            Spacer()
        }
        .padding(ModernDesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
                .fill(isCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                .stroke(isCorrect ? Color.green : Color.red, lineWidth: 2)
        )
        .padding(.horizontal, ModernDesignSystem.Spacing.md)
        .padding(.bottom, ModernDesignSystem.Spacing.xl)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: showFeedback)
    }

    private func playLetterSound(_ letter: String) {
        let fileName = "\(letter).mp3"
        session.audioService.play(name: fileName, rate: 1.0)
    }

    private var lessonCompleteView: some View {
        VStack(spacing: ModernDesignSystem.Spacing.xl) {
            Spacer()

            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundColor(ModernDesignSystem.Colors.accent)

            Text("Lesson Complete!")
                .font(ModernDesignSystem.Typography.title1)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Text("You learned \(lesson.letters.count) new letters")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)

            Spacer()

            Button(action: {
                HapticsService.shared.navigationTap()
                dismiss()
            }) {
                Text("Continue")
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(ModernDesignSystem.Spacing.md)
                    .background(ModernDesignSystem.Colors.primary)
                    .cornerRadius(ModernDesignSystem.CornerRadius.md)
            }
            .buttonStyle(.plain)
        }
        .padding(ModernDesignSystem.Spacing.lg)
    }

    private func nextActivity() {
        // Track the response
        if currentActivityIndex < activities.count {
            _ = activities[currentActivityIndex]
            let response = ActivityResponse(
                id: UUID().uuidString,
                activityId: "activity_\(currentActivityIndex)",
                questionId: "question_\(currentActivityIndex)",
                userAnswer: selectedAnswer,
                isCorrect: isCorrect,
                timeSpent: 2.0,
                xpEarned: isCorrect ? 10 : 0,
                timestamp: Date()
            )
            responses.append(response)
        }

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
            newActivities.append(
                TeluguLessonActivity(
                    type: .intro,
                    letter: letter,
                    question: letter.description,
                    options: [],
                    correctAnswer: ""
                ))

            // Reading Practice
            let readingOptions = generateOptions(for: letter, from: lesson.letters)
            newActivities.append(
                TeluguLessonActivity(
                    type: .reading,
                    letter: letter,
                    question: "Which letter is this?",
                    options: readingOptions,
                    correctAnswer: letter.romanization
                ))

            // Listening Practice
            newActivities.append(
                TeluguLessonActivity(
                    type: .listening,
                    letter: letter,
                    question: "Select \(letter.romanization)",
                    options: lesson.letters.map { $0.character },
                    correctAnswer: letter.character
                ))

            // Writing Practice
            newActivities.append(
                TeluguLessonActivity(
                    type: .writing,
                    letter: letter,
                    question: "Trace this letter",
                    options: [],
                    correctAnswer: ""
                ))
        }

        // Review Section
        for letter in lesson.letters {
            newActivities.append(
                TeluguLessonActivity(
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

    private func generateOptions(for letter: TeluguLetterData, from letters: [TeluguLetterData])
        -> [String]
    {
        var options = [letter.romanization]
        let otherOptions = letters.filter { $0.romanization != letter.romanization }.map {
            $0.romanization
        }
        options.append(contentsOf: Array(otherOptions.prefix(3)))
        return options.shuffled()
    }

    private func convertToLesson(_ teluguLesson: TeluguLesson) -> Lesson {
        return Lesson(
            id: String(teluguLesson.id),
            title: teluguLesson.title,
            description: "Learn \(teluguLesson.letters.count) Telugu letters",
            levelId: "beginner",
            order: teluguLesson.id,
            difficulty: 1,
            xpReward: calculateTotalXP(),
            estimatedMinutes: 5,
            activities: []
        )
    }

    private func calculateTotalXP() -> Int {
        return responses.filter { $0.isCorrect }.count * 10 + (lesson.letters.count * 5)
    }
}
