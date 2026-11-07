import SwiftUI

// MARK: - Lesson Engine View Container
struct LessonEngineView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss

    let module: CurriculumModule

    @State private var lessonResponse: LessonResponse? = nil
    @State private var currentIndex: Int = 0
    @State private var selectedOption: String? = nil
    @State private var isAnswerChecked: Bool = false
    @State private var isAnswerCorrect: Bool = false
    @State private var builtSentence: [String] = []
    @State private var showCompletion: Bool = false
    @State private var xpEarned: Int = 50

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            if let lesson = lessonResponse {
                if showCompletion {
                    completionOverlay(lesson: lesson)
                } else {
                    VStack(spacing: 0) {
                        // Top Navigation & Progress Header
                        headerBar(totalActivities: lesson.activities.count)
                            .padding(.horizontal)
                            .padding(.top, 12)

                        // Main Activity Canvas
                        ScrollView {
                            VStack(spacing: 20) {
                                if currentIndex < lesson.activities.count {
                                    let currentActivity = lesson.activities[currentIndex]
                                    LessonActivityRendererView(
                                        activity: currentActivity,
                                        selectedOption: $selectedOption,
                                        isAnswerChecked: $isAnswerChecked,
                                        isAnswerCorrect: $isAnswerCorrect,
                                        builtSentence: $builtSentence
                                    )
                                }
                            }
                            .padding()
                        }

                        // Bottom Action Footer Bar
                        footerActionBar(totalActivities: lesson.activities.count)
                            .padding()
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                    }
                }
            } else {
                ProgressView("Loading lesson...")
                    .scaleEffect(1.2)
                    .tint(.orange)
            }
        }
        .navigationBarHidden(true)
        .task {
            self.lessonResponse = await LessonGenerator.shared.fetchOrGenerateLesson(forModule: module)
        }
    }

    // MARK: - Header Bar
    private func headerBar(totalActivities: Int) -> some View {
        VStack(spacing: 8) {
            HStack {
                Button {
                    HapticsManager.shared.impact(.light)
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("Step \(currentIndex + 1) of \(totalActivities)")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)

                Spacer()

                Image(systemName: "sparkles")
                    .foregroundColor(.orange)
            }

            ProgressView(value: Double(currentIndex + 1), total: Double(max(1, totalActivities)))
                .tint(.orange)
                .scaleEffect(y: 1.5)
                .clipShape(Capsule())
        }
    }

    // MARK: - Footer Action Bar
    private func footerActionBar(totalActivities: Int) -> some View {
        VStack(spacing: 12) {
            if let lesson = lessonResponse, currentIndex < lesson.activities.count {
                let currentActivity = lesson.activities[currentIndex]

                // Show feedback banner if answer was checked for quiz types
                if isAnswerChecked {
                    HStack(spacing: 10) {
                        Image(systemName: isAnswerCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(isAnswerCorrect ? .green : .red)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(isAnswerCorrect ? "Excellent!" : "Not quite right")
                                .font(.headline)
                                .foregroundColor(isAnswerCorrect ? .green : .red)

                            if let explanation = currentActivity.explanation {
                                Text(explanation)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(isAnswerCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(12)
                }

                // Action Button
                Button {
                    handleActionTap(activity: currentActivity, totalActivities: totalActivities)
                } label: {
                    Text(actionButtonTitle(activity: currentActivity))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.orange)
                        .cornerRadius(14)
                }
            }
        }
    }

    private func actionButtonTitle(activity: EngineLessonActivity) -> String {
        let requiresChecking = activity.type == .multipleChoice || activity.type == .fillBlank || activity.type == .listening || activity.type == .translation
        if requiresChecking && !isAnswerChecked {
            return "Check Answer"
        }
        return currentIndex + 1 == lessonResponse?.activities.count ? "Finish Lesson" : "Continue"
    }

    private func handleActionTap(activity: EngineLessonActivity, totalActivities: Int) {
        let requiresChecking = activity.type == .multipleChoice || activity.type == .fillBlank || activity.type == .listening || activity.type == .translation

        if requiresChecking && !isAnswerChecked {
            // Validate answer
            if let expectedAnswer = activity.answer {
                if activity.type == .sentenceBuilder {
                    let fullSentence = builtSentence.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                    let target = expectedAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
                    isAnswerCorrect = fullSentence == target
                } else {
                    isAnswerCorrect = selectedOption?.contains(expectedAnswer) == true || selectedOption == expectedAnswer
                }
            } else {
                isAnswerCorrect = true
            }
            isAnswerChecked = true

            // Record learner activity attempt & skill score adjustment locally
            LearnerRepository.shared.recordActivityAttempt(activityType: activity.type, isCorrect: isAnswerCorrect, contentId: activity.id)

            HapticsManager.shared.notification(isAnswerCorrect ? .success : .warning)
            return
        }

        // Advance to next step
        if currentIndex + 1 < totalActivities {
            withAnimation(.easeInOut) {
                currentIndex += 1
                selectedOption = nil
                isAnswerChecked = false
                isAnswerCorrect = false
                builtSentence = []
            }
        } else {
            // Complete Lesson
            session.completedLessons += 1
            session.gamificationService.awardXP(xpEarned, type: .quizCompleted, description: "Completed \(module.title)")

            HapticsManager.shared.notification(.success)
            withAnimation {
                showCompletion = true
            }
        }
    }

    // MARK: - Completion Screen
    private func completionOverlay(lesson: LessonResponse) -> some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 120, height: 120)

                Image(systemName: "trophy.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.orange)
            }

            VStack(spacing: 6) {
                Text("Lesson Complete!")
                    .font(.title.bold())
                    .foregroundColor(.primary)

                Text(lesson.title)
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text(lesson.objective)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundColor(.orange)
                Text("+\(xpEarned) XP Earned")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Capsule().fill(Color(uiColor: .secondarySystemGroupedBackground)))
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Continue to Learn")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.orange)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - Activity Renderer View Router
struct LessonActivityRendererView: View {
    @EnvironmentObject var session: AppSession
    let activity: EngineLessonActivity
    @Binding var selectedOption: String?
    @Binding var isAnswerChecked: Bool
    @Binding var isAnswerCorrect: Bool
    @Binding var builtSentence: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Activity Type Tag Badge
            HStack(spacing: 6) {
                Image(systemName: activityIcon(for: activity.type))
                    .font(.caption.bold())
                Text(activity.type.displayName.uppercased())
                    .font(.caption2.bold())
            }
            .foregroundColor(.orange)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.orange.opacity(0.12))
            .clipShape(Capsule())

            // Main Instruction / Title
            Text(activity.instruction ?? activity.title)
                .font(.title3.bold())
                .foregroundColor(.primary)

            // Dynamic Step Content
            switch activity.type {
            case .introduction, .reading, .writing:
                introductionCard(activity: activity)
            case .vocabulary, .matching:
                vocabularyCard(activity: activity)
            case .multipleChoice, .listening, .fillBlank, .translation:
                quizCard(activity: activity)
            case .sentenceBuilder:
                sentenceBuilderCard(activity: activity)
            case .conversation, .speaking:
                conversationCard(activity: activity)
            case .review:
                reviewCard(activity: activity)
            }
        }
    }

    private func activityIcon(for type: EngineActivityType) -> String {
        switch type {
        case .introduction: return "lightbulb.fill"
        case .vocabulary: return "book.fill"
        case .multipleChoice: return "questionmark.circle.fill"
        case .matching: return "square.grid.2x2.fill"
        case .sentenceBuilder: return "text.badge.plus"
        case .fillBlank: return "pencil.line"
        case .listening: return "speaker.wave.3.fill"
        case .reading: return "eye.fill"
        case .writing: return "pencil.tip"
        case .speaking: return "mic.fill"
        case .translation: return "globe"
        case .conversation: return "bubble.left.and.bubble.right.fill"
        case .review: return "star.fill"
        }
    }

    // MARK: - Activity Sub-Cards
    private func introductionCard(activity: EngineLessonActivity) -> some View {
        VStack(spacing: 16) {
            if let telugu = activity.teluguText {
                Text(telugu)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.primary)
            }

            if let trans = activity.transliteration {
                Text(trans)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

            if let english = activity.englishTranslation {
                Text(english)
                    .font(.headline)
                    .foregroundColor(.orange)
            }

            if !activity.prompt.isEmpty {
                Text(activity.prompt)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(18)
    }

    private func vocabularyCard(activity: EngineLessonActivity) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            if !activity.prompt.isEmpty {
                Text(activity.prompt)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            if let telugu = activity.teluguText {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(telugu)
                            .font(.title.bold())
                            .foregroundColor(.primary)

                        if let trans = activity.transliteration {
                            Text(trans)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    if let english = activity.englishTranslation {
                        Text(english)
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemGroupedBackground))
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(18)
    }

    private func quizCard(activity: EngineLessonActivity) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if !activity.prompt.isEmpty {
                Text(activity.prompt)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            if let options = activity.options {
                VStack(spacing: 10) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            guard !isAnswerChecked else { return }
                            selectedOption = option
                            HapticsManager.shared.impact(.light)
                        } label: {
                            HStack {
                                Text(option)
                                    .font(.body.weight(.medium))
                                    .foregroundColor(selectedOption == option ? .white : .primary)
                                Spacer()
                                if selectedOption == option {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(selectedOption == option ? Color.orange : Color(uiColor: .tertiarySystemGroupedBackground))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                        .disabled(isAnswerChecked)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(18)
    }

    private func sentenceBuilderCard(activity: EngineLessonActivity) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if !activity.prompt.isEmpty {
                Text(activity.prompt)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Word drop/assembled canvas
            HStack(spacing: 8) {
                if builtSentence.isEmpty {
                    Text("Tap words below in order...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                } else {
                    ForEach(Array(builtSentence.enumerated()), id: \.offset) { index, word in
                        Button {
                            guard !isAnswerChecked else { return }
                            builtSentence.remove(at: index)
                        } label: {
                            Text(word)
                                .font(.body.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.orange)
                                .clipShape(Capsule())
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .frame(minHeight: 54)
            .background(Color(uiColor: .tertiarySystemGroupedBackground))
            .cornerRadius(12)

            // Available word chips
            if let options = activity.options {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        let isUsed = builtSentence.contains(option)
                        Button {
                            guard !isAnswerChecked else { return }
                            if !isUsed {
                                builtSentence.append(option)
                                HapticsManager.shared.impact(.light)
                            }
                        } label: {
                            Text(option)
                                .font(.body)
                                .foregroundColor(isUsed ? .secondary : .primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color(uiColor: .tertiarySystemGroupedBackground).opacity(isUsed ? 0.4 : 1.0))
                                .cornerRadius(10)
                        }
                        .disabled(isUsed || isAnswerChecked)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(18)
    }

    private func conversationCard(activity: EngineLessonActivity) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            if !activity.prompt.isEmpty {
                Text(activity.prompt)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            if let telugu = activity.teluguText {
                Text(telugu)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.08))
                    .cornerRadius(12)
            }

            if let english = activity.englishTranslation {
                Text(english)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(18)
    }

    private func reviewCard(activity: EngineLessonActivity) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Key Takeaways")
                .font(.headline)
                .foregroundColor(.orange)

            if !activity.prompt.isEmpty {
                Text(activity.prompt)
                    .font(.body)
                    .foregroundColor(.primary)
            }

            if let explanation = activity.explanation {
                Text(explanation)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(18)
    }
}
