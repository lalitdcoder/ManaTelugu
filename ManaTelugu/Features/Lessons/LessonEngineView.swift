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
                ProgressView("Loading adaptive lesson...")
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

            // Record learner activity attempt & skill score adjustment
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

            Task {
                await SupabaseManager.shared.recordLessonAttempt(moduleId: module.id, score: 1.0, xpEarned: xpEarned)
            }

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
                Image(systemName: activity.type.iconName)
                    .font(.caption.bold())
                Text(activity.type.displayName.uppercased())
                    .font(.caption2.bold())
            }
            .foregroundColor(.orange)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.orange.opacity(0.12))
            .clipShape(Capsule())

            Text(activity.title)
                .font(.title2.bold())
                .foregroundColor(.primary)

            if let instruction = activity.instruction {
                Text(instruction)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Divider()

            // Route activity type
            switch activity.type {
            case .introduction:
                introductionView

            case .vocabulary:
                vocabularyView

            case .multipleChoice, .listening, .reading, .translation:
                multipleChoiceView

            case .matching:
                matchingView

            case .sentenceBuilder:
                sentenceBuilderView

            case .fillBlank:
                fillBlankView

            case .conversation:
                conversationView

            case .review:
                reviewView

            case .writing, .speaking:
                unsupportedActivityBadgeView
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }

    // MARK: - Subviews for Activity Types

    private var introductionView: some View {
        VStack(spacing: 16) {
            if let telugu = activity.teluguText {
                VStack(spacing: 8) {
                    Text(telugu)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)

                    if let translit = activity.transliteration {
                        Text(translit)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.orange)
                    }

                    if let english = activity.englishTranslation {
                        Text(english)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.orange.opacity(0.08)))

                Button {
                    session.audioService.play(name: "greeting.mp3", rate: 1.0)
                    HapticsManager.shared.impact(.medium)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "speaker.wave.2.fill")
                        Text("Listen Pronunciation")
                    }
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.orange.opacity(0.15))
                    .foregroundColor(.orange)
                    .cornerRadius(12)
                }
            }

            Text(activity.prompt)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
        }
    }

    private var vocabularyView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(activity.prompt)
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let items = activity.options {
                VStack(spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Text(item)
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                            Spacer()
                            Button {
                                let parts = item.components(separatedBy: " • ")
                                if let teluguWord = parts.first {
                                    session.audioService.play(name: teluguWord, rate: 1.0)
                                }
                                HapticsManager.shared.impact(.light)
                            } label: {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(uiColor: .systemGroupedBackground)))
                    }
                }
            }
        }
    }

    private var multipleChoiceView: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let telugu = activity.teluguText {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(telugu)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                        if let translit = activity.transliteration {
                            Text(translit)
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                    }
                    Spacer()
                    Button {
                        session.audioService.play(name: telugu, rate: 1.0)
                        HapticsManager.shared.impact(.medium)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.orange.opacity(0.08)))
            }

            Text(activity.prompt)
                .font(.body.weight(.medium))
                .foregroundColor(.primary)

            if let options = activity.options {
                VStack(spacing: 10) {
                    ForEach(options, id: \.self) { option in
                        let isSelected = selectedOption == option
                        Button {
                            guard !isAnswerChecked else { return }
                            selectedOption = option
                            HapticsManager.shared.selection()
                        } label: {
                            HStack {
                                Text(option)
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(isSelected ? .orange : .primary)
                                Spacer()
                                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(isSelected ? .orange : .secondary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isSelected ? Color.orange.opacity(0.12) : Color(uiColor: .systemGroupedBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var matchingView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(activity.prompt)
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let options = activity.options {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(options, id: \.self) { item in
                        let isSelected = selectedOption == item
                        Button {
                            selectedOption = item
                            HapticsManager.shared.selection()
                        } label: {
                            Text(item)
                                .font(.body.weight(.semibold))
                                .foregroundColor(isSelected ? .white : .primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(isSelected ? Color.orange : Color(uiColor: .systemGroupedBackground))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var sentenceBuilderView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(activity.prompt)
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Selected tokens container
            HStack {
                if builtSentence.isEmpty {
                    Text("Tap words below to construct sentence...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(builtSentence, id: \.self) { word in
                        Text(word)
                            .font(.headline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                builtSentence.removeAll { $0 == word }
                            }
                    }
                }
                Spacer()
            }
            .padding()
            .frame(minHeight: 60)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(uiColor: .systemGroupedBackground)))

            // Word choices bank
            if let words = activity.options {
                HStack(spacing: 8) {
                    ForEach(words, id: \.self) { word in
                        let isUsed = builtSentence.contains(word)
                        Button {
                            if !isUsed {
                                builtSentence.append(word)
                                HapticsManager.shared.selection()
                            }
                        } label: {
                            Text(word)
                                .font(.headline)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(isUsed ? Color.gray.opacity(0.2) : Color.orange.opacity(0.12))
                                .foregroundColor(isUsed ? .gray : .orange)
                                .cornerRadius(10)
                        }
                        .disabled(isUsed)
                    }
                }
            }
        }
    }

    private var fillBlankView: some View {
        multipleChoiceView
    }

    private var conversationView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(activity.prompt)
                .font(.body)
                .foregroundColor(.primary)

            if let telugu = activity.teluguText {
                VStack(alignment: .leading, spacing: 8) {
                    Text(telugu)
                        .font(.title3.bold())
                        .foregroundColor(.primary)

                    if let english = activity.englishTranslation {
                        Text(english)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.orange.opacity(0.08)))
            }
        }
    }

    private var reviewView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 44))
                .foregroundColor(.orange)

            Text(activity.prompt)
                .font(.body)
                .foregroundColor(.primary)
        }
    }

    private var unsupportedActivityBadgeView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Activity Type '\(activity.type.rawValue)' Guided Mode")
                    .font(.caption.bold())
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)

            Text(activity.prompt)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}
