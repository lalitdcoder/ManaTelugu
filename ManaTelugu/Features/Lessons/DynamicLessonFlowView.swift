import SwiftUI

// MARK: - Dynamic Lesson Flow View

struct DynamicLessonFlowView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss

    let node: LessonTierNode

    // MARK: - State

    @State private var gameQueue: [GameStep] = []
    @State private var currentIndex: Int = 0
    @State private var showCompletion: Bool = false
    @State private var isLoading: Bool = true
    @State private var xpEarned: Int = 0

    // MARK: - Computed Properties

    private var progressValue: Double {
        guard !gameQueue.isEmpty else { return 0 }
        return Double(currentIndex) / Double(gameQueue.count)
    }

    private var tierBadge: String {
        switch node.tier {
        case 1: return "Bronze"
        case 2: return "Silver"
        case 3: return "Gold"
        default: return "Level \(node.tier)"
        }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea()

            if isLoading {
                loadingView
            } else if showCompletion {
                lessonCompletionOverlay
            } else if gameQueue.isEmpty {
                noContentView
            } else {
                VStack(spacing: 0) {
                    progressHeader
                        .padding(.horizontal, ModernDesignSystem.Spacing.md)
                        .padding(.top, ModernDesignSystem.Spacing.sm)

                    gameContent
                }
            }
        }
        .navigationTitle(node.tierName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    HapticsManager.shared.impact(.light)
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
            }
        }
        .onAppear {
            generateLesson()
        }
    }

    // MARK: - Subviews

    private var loadingView: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(ModernDesignSystem.Colors.primary)
            Text("Preparing your lesson…")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
    }

    private var noContentView: some View {
        VStack(spacing: ModernDesignSystem.Spacing.lg) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(ModernDesignSystem.Colors.warning)
            Text("No content found for \"\(node.topic)\"")
                .font(ModernDesignSystem.Typography.title3)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)
            Button("Go Back") { dismiss() }
                .font(ModernDesignSystem.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(ModernDesignSystem.Colors.primary)
                .cornerRadius(ModernDesignSystem.CornerRadius.md)
        }
        .padding(ModernDesignSystem.Spacing.xl)
    }

    private var progressHeader: some View {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
            HStack {
                Text("Step \(min(currentIndex + 1, gameQueue.count)) of \(gameQueue.count)")
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                Spacer()
                Text(tierBadge)
                    .font(ModernDesignSystem.Typography.caption)
                    .fontWeight(.bold)
                    .foregroundColor(node.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(node.color.opacity(0.15))
                    .clipShape(Capsule())
            }

            ProgressView(value: progressValue)
                .tint(node.color)
                .scaleEffect(y: 2)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding(.bottom, ModernDesignSystem.Spacing.sm)
    }

    @ViewBuilder
    private var gameContent: some View {
        if currentIndex < gameQueue.count {
            let step = gameQueue[currentIndex]

            switch step {
            case .introduction(let word), .speaking(let word), .reading(let word), .listening(let word):
                IntroductionStepView(word: word) {
                    advanceStep()
                }
                .environmentObject(session)
                .id("intro_\(currentIndex)")

            case .vocabulary(let words), .matching(let words), .cardMatch(let words), .review(let words):
                EmbeddedCardMatchView(words: words) {
                    advanceStep()
                }
                .environmentObject(session)
                .id("vocab_\(currentIndex)")

            case .writing(let letter, let anchorWord), .tracing(let letter, let anchorWord):
                EmbeddedTracingView(letter: letter, anchorWord: anchorWord) {
                    advanceStep()
                }
                .environmentObject(session)
                .id("tracing_\(currentIndex)")

            case .multipleChoice, .fillBlank, .sentenceBuilder, .conversation, .translation:
                SentenceBuilderGameView()
                    .environmentObject(session)
                    .id("sentence_\(currentIndex)")
            }
        }
    }

    // MARK: - Lesson Completion Overlay

    private var lessonCompletionOverlay: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: ModernDesignSystem.Spacing.xl) {
                ZStack {
                    Circle()
                        .fill(ModernDesignSystem.Colors.primary.opacity(0.15))
                        .frame(width: 140, height: 140)

                    Image(systemName: "trophy.fill")
                        .font(.system(size: 64))
                        .foregroundColor(ModernDesignSystem.Colors.warning)
                }

                VStack(spacing: ModernDesignSystem.Spacing.xs) {
                    Text("Lesson Complete!")
                        .font(ModernDesignSystem.Typography.title1)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                    Text("You completed \(node.topic) (\(tierBadge))")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }

                HStack(spacing: ModernDesignSystem.Spacing.sm) {
                    Image(systemName: "sparkles")
                        .foregroundColor(ModernDesignSystem.Colors.warning)
                    Text("+\(xpEarned) XP")
                        .font(ModernDesignSystem.Typography.title3)
                        .fontWeight(.bold)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                }
                .padding(.horizontal, ModernDesignSystem.Spacing.xl)
                .padding(.vertical, ModernDesignSystem.Spacing.md)
                .background(
                    Capsule()
                        .fill(ModernDesignSystem.Colors.cardBackground)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                )

                Button {
                    HapticsManager.shared.impact(.medium)
                    dismiss()
                } label: {
                    Text("Continue")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ModernDesignSystem.Colors.primary)
                        .cornerRadius(ModernDesignSystem.CornerRadius.lg)
                }
                .padding(.horizontal, ModernDesignSystem.Spacing.xl)
            }
            .padding(ModernDesignSystem.Spacing.lg)
        }
    }

    // MARK: - Flow Control

    private func generateLesson() {
        let generator = LessonGenerator(repository: session.dataRepository)
        Task {
            let steps = await generator.generateLessonAsync(moduleId: node.id, topic: node.topic, tier: node.tier)
            await MainActor.run {
                self.gameQueue = steps
                self.currentIndex = 0
                self.isLoading = false
            }
        }
    }

    private func advanceStep() {
        if currentIndex + 1 < gameQueue.count {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentIndex += 1
            }
        } else {
            completeLesson()
        }
    }

    private func completeLesson() {
        self.xpEarned = node.xpReward
        session.gamificationService.awardXP(xpEarned, type: .quizCompleted, description: "Completed \(node.topic)")
        session.completedLessons += 1

        HapticsManager.shared.notification(.success)

        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            showCompletion = true
        }
    }
}

// MARK: - Helper Activity Step Views

struct IntroductionStepView: View {
    @EnvironmentObject var session: AppSession
    let word: Word
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.lg) {
            Spacer()

            VStack(spacing: 12) {
                Text(word.telugu)
                    .font(.system(size: 54, weight: .bold))
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                Text(word.transliteration)
                    .font(ModernDesignSystem.Typography.title3)
                    .foregroundColor(ModernDesignSystem.Colors.primary)

                Text(word.english)
                    .font(ModernDesignSystem.Typography.title2)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            .padding(ModernDesignSystem.Spacing.xl)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ModernDesignSystem.Colors.cardBackground)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
            )

            Button {
                session.audioService.play(name: word.audioFile, rate: 1.0)
                HapticsManager.shared.impact(.medium)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "speaker.wave.2.fill")
                    Text("Listen")
                }
                .font(.headline)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(ModernDesignSystem.Colors.primary.opacity(0.12))
                .foregroundColor(ModernDesignSystem.Colors.primary)
                .cornerRadius(20)
            }

            Spacer()

            Button(action: onContinue) {
                Text("Continue")
                    .font(ModernDesignSystem.Typography.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ModernDesignSystem.Colors.primary)
                    .cornerRadius(14)
            }
        }
        .padding(ModernDesignSystem.Spacing.lg)
    }
}

struct EmbeddedCardMatchView: View {
    @EnvironmentObject var session: AppSession
    let words: [Word]
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            CardMatchGameView()
                .environmentObject(session)

            Button(action: onComplete) {
                Text("Next Step")
                    .font(ModernDesignSystem.Typography.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(ModernDesignSystem.Colors.primary)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }
}

struct EmbeddedTracingView: View {
    @EnvironmentObject var session: AppSession
    let letter: Letter
    let anchorWord: Word
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            TraceGameView()
                .environmentObject(session)

            Button(action: onComplete) {
                Text("Next Step")
                    .font(ModernDesignSystem.Typography.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(ModernDesignSystem.Colors.primary)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }
}
