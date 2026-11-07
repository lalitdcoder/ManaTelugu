import SwiftUI

// MARK: - Onboarding Model Data
struct LearnerStoryOption: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let startingModuleNumber: Int
    let initialSkills: [String: Double]
}

struct LearningGoalOption: Identifiable {
    let id: String
    let title: String
    let icon: String
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss

    @State private var currentStep: Int = 1
    @State private var selectedStoryId: String? = nil
    @State private var selectedGoals: Set<String> = []

    private let storyOptions: [LearnerStoryOption] = [
        LearnerStoryOption(
            id: "understand_only",
            title: "I understand Telugu but struggle to speak",
            subtitle: "Focus on active sentence construction and speaking confidence.",
            icon: "bubble.left.and.bubble.right.fill",
            startingModuleNumber: 3,
            initialSkills: ["comprehension": 0.6, "listening": 0.7, "speaking": 0.3, "reading": 0.2, "sentence_construction": 0.3]
        ),
        LearnerStoryOption(
            id: "speak_some",
            title: "I speak some Telugu but want to improve",
            subtitle: "Expand vocabulary, refine grammar, and speak naturally.",
            icon: "sparkles",
            startingModuleNumber: 5,
            initialSkills: ["comprehension": 0.7, "listening": 0.7, "speaking": 0.5, "reading": 0.3, "sentence_construction": 0.5]
        ),
        LearnerStoryOption(
            id: "cannot_read",
            title: "I can speak but can't read Telugu script",
            subtitle: "Learn Telugu vowels, consonants, and reading systematically.",
            icon: "book.fill",
            startingModuleNumber: 9,
            initialSkills: ["comprehension": 0.8, "listening": 0.8, "speaking": 0.6, "reading": 0.1, "writing": 0.1]
        ),
        LearnerStoryOption(
            id: "know_little",
            title: "I know a little Telugu",
            subtitle: "Start with common phrases, numbers, and basic greetings.",
            icon: "hand.wave.fill",
            startingModuleNumber: 2,
            initialSkills: ["comprehension": 0.4, "listening": 0.4, "speaking": 0.2, "reading": 0.2]
        ),
        LearnerStoryOption(
            id: "completely_new",
            title: "I'm completely new to Telugu",
            subtitle: "Start from zero with friendly step-by-step guidance.",
            icon: "star.fill",
            startingModuleNumber: 1,
            initialSkills: ["comprehension": 0.1, "listening": 0.1, "speaking": 0.1, "reading": 0.1]
        )
    ]

    private let goalOptions: [LearningGoalOption] = [
        LearningGoalOption(id: "talk_family", title: "Talk with family & elders", icon: "heart.fill"),
        LearningGoalOption(id: "speak_confidently", title: "Speak more confidently", icon: "mic.fill"),
        LearningGoalOption(id: "learn_read", title: "Learn to read Telugu script", icon: "book.closed.fill"),
        LearningGoalOption(id: "learn_write", title: "Learn to write Telugu", icon: "pencil.tip"),
        LearningGoalOption(id: "connect_culture", title: "Connect with Telugu culture", icon: "sun.max.fill"),
        LearningGoalOption(id: "understand_better", title: "Understand family conversations", icon: "ear.fill")
    ]

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Top Progress Indicator
                HStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { step in
                        Capsule()
                            .fill(step <= currentStep ? Color.orange : Color.gray.opacity(0.3))
                            .frame(height: 6)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                if currentStep == 1 {
                    stepOneStoryView
                } else if currentStep == 2 {
                    stepTwoGoalsView
                } else {
                    stepThreeProfileSummaryView
                }

                Spacer()

                // Navigation Buttons
                HStack {
                    if currentStep > 1 {
                        Button("Back") {
                            withAnimation { currentStep -= 1 }
                        }
                        .font(.headline)
                        .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button {
                        handleNextStep()
                    } label: {
                        Text(currentStep == 3 ? "Start Learning" : "Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(isNextDisabled ? Color.gray : Color.orange)
                            .cornerRadius(14)
                    }
                    .disabled(isNextDisabled)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }

    private var isNextDisabled: Bool {
        if currentStep == 1 { return selectedStoryId == nil }
        if currentStep == 2 { return selectedGoals.isEmpty }
        return false
    }

    // MARK: - Step 1: Telugu Story
    private var stepOneStoryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What's your Telugu story?")
                .font(.title.bold())
                .foregroundColor(.primary)

            Text("Select the description that best fits your current level.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(storyOptions) { option in
                        let isSelected = selectedStoryId == option.id
                        Button {
                            withAnimation {
                                selectedStoryId = option.id
                                HapticsManager.shared.selection()
                            }
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: option.icon)
                                    .font(.title2)
                                    .foregroundColor(isSelected ? .orange : .secondary)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.title)
                                        .font(.body.bold())
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)

                                    Text(option.subtitle)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.leading)
                                }

                                Spacer()

                                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundColor(isSelected ? .orange : .gray.opacity(0.4))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isSelected ? Color.orange.opacity(0.1) : Color(uiColor: .secondarySystemGroupedBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Step 2: Learning Goals
    private var stepTwoGoalsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What are your main goals?")
                .font(.title.bold())
                .foregroundColor(.primary)

            Text("Select all that apply to personalize your learning path.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(goalOptions) { goal in
                        let isSelected = selectedGoals.contains(goal.id)
                        Button {
                            withAnimation {
                                if isSelected {
                                    selectedGoals.remove(goal.id)
                                } else {
                                    selectedGoals.insert(goal.id)
                                }
                                HapticsManager.shared.selection()
                            }
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: goal.icon)
                                    .font(.title2)
                                    .foregroundColor(isSelected ? .orange : .secondary)

                                Text(goal.title)
                                    .font(.body.bold())
                                    .foregroundColor(.primary)

                                Spacer()

                                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                    .font(.title2)
                                    .foregroundColor(isSelected ? .orange : .gray.opacity(0.4))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isSelected ? Color.orange.opacity(0.1) : Color(uiColor: .secondarySystemGroupedBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Step 3: Summary & Personalization
    private var stepThreeProfileSummaryView: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(.orange)

            Text("Your Customized Telugu Path")
                .font(.title.bold())
                .foregroundColor(.primary)

            Text("Based on your story and goals, we've set up a tailored progression for you.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let storyId = selectedStoryId, let selectedOption = storyOptions.first(where: { $0.id == storyId }) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Recommended Starting Point")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            Text("Module \(selectedOption.startingModuleNumber)")
                                .font(.title3.bold())
                                .foregroundColor(.orange)
                        }
                        Spacer()
                    }

                    Divider()

                    Text("Selected Goals (\(selectedGoals.count))")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    HStack(spacing: 8) {
                        ForEach(Array(selectedGoals.prefix(3)), id: \.self) { goalId in
                            if let goal = goalOptions.first(where: { $0.id == goalId }) {
                                Text(goal.title)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.15))
                                    .foregroundColor(.orange)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(uiColor: .secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
                )
                .padding(.horizontal)
            }
        }
    }

    private func handleNextStep() {
        HapticsManager.shared.impact(.light)
        if currentStep < 3 {
            withAnimation { currentStep += 1 }
        } else {
            completeOnboarding()
        }
    }

    private func completeOnboarding() {
        if let storyId = selectedStoryId, let selectedOption = storyOptions.first(where: { $0.id == storyId }) {
            session.completedLessons = max(0, selectedOption.startingModuleNumber - 1)
            session.userProfile.unlockedBadges.append("welcome_badge")
            UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
            UserDefaults.standard.set(selectedStoryId, forKey: "learnerStoryId")
            UserDefaults.standard.set(Array(selectedGoals), forKey: "learnerGoals")
        }
        HapticsManager.shared.notification(.success)
        dismiss()
    }
}
