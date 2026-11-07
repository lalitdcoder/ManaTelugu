import SwiftUI

struct TraceGameView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var letters: [Letter] = []
    @State private var currentLetterIndex = 0
    @State private var showingFeedback = false
    @State private var isCorrect = false
    @State private var xpEarned = 0
    @State private var clearCanvas = false
    @State private var validate = false

    var currentLetter: Letter? {
        guard currentLetterIndex < letters.count else { return nil }
        return letters[currentLetterIndex]
    }

    var body: some View {
        ZStack {
            ManaTheme.Colors.groupedBackground
                .ignoresSafeArea()

            VStack(spacing: ManaTheme.Spacing.md) {
                if let letter = currentLetter {
                    header(for: letter)
                    tracingCanvas(for: letter)
                    actionButtons
                }
            }
            .padding(ManaTheme.Spacing.screenMarginLarge)

            // Feedback overlay modal
            if showingFeedback {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                VStack(spacing: ManaTheme.Spacing.md) {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(isCorrect ? ManaTheme.Colors.emeraldGreen : ManaTheme.Colors.error)

                    Text(isCorrect ? "Great Job!" : "Try Again!")
                        .font(ManaTheme.Typography.title2)
                        .foregroundColor(isCorrect ? ManaTheme.Colors.emeraldGreen : ManaTheme.Colors.error)

                    if isCorrect {
                        Text("Successfully traced! +\(xpEarned) XP")
                            .font(ManaTheme.Typography.body)
                            .foregroundColor(ManaTheme.Colors.secondaryLabel)
                    }
                }
                .padding(ManaTheme.Spacing.xl)
                .background(ManaTheme.Colors.secondaryGroupedBackground)
                .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous))
                .shadow(color: ManaTheme.Shadow.medium.color, radius: 12, x: 0, y: 4)
                .scaleEffect(showingFeedback ? 1.0 : 0.8)
                .animation(ManaTheme.Animation.smooth, value: showingFeedback)
            }
        }
        .navigationTitle("Letter Tracing")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            ManaTheme.Haptics.light()
            loadLetters()
        }
    }

    private func header(for letter: Letter) -> some View {
        ManaCard(style: .elevated) {
            HStack(spacing: ManaTheme.Spacing.md) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Trace '\(letter.character)' (\(letter.romanization))")
                        .font(ManaTheme.Typography.headline)
                        .foregroundColor(ManaTheme.Colors.label)

                    Text("Follow the guide line to form the stroke correctly")
                        .font(ManaTheme.Typography.caption1)
                        .foregroundColor(ManaTheme.Colors.secondaryLabel)
                }

                Spacer()

                Text("\(currentLetterIndex + 1)/\(max(letters.count, 1))")
                    .font(ManaTheme.Typography.caption1.weight(.bold))
                    .foregroundColor(ManaTheme.Colors.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(ManaTheme.Colors.primary.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
    }

    private func tracingCanvas(for letter: Letter) -> some View {
        TracingCanvasView(
            targetCharacter: letter.character,
            referenceStrokes: letter.strokePathPoints,
            clearCanvas: $clearCanvas,
            validate: $validate,
            onTracingComplete: { success in
                handleTracingComplete(success: success)
            },
            isLessonMode: false
        )
        .frame(maxHeight: 380)
        .background(ManaTheme.Colors.secondaryGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous)
                .stroke(ManaTheme.Colors.separator.opacity(0.3), lineWidth: 1)
        )
    }

    private var actionButtons: some View {
        HStack(spacing: ManaTheme.Spacing.sm) {
            Button("Clear") {
                clearCanvas = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    clearCanvas = false
                }
            }
            .buttonStyle(ManaButtonStyle(variant: .tertiary, size: .medium))

            Button("Check Trace") {
                validate = true
            }
            .buttonStyle(ManaButtonStyle(variant: .primary, size: .medium))

            Button("Next") {
                skipLetter()
            }
            .buttonStyle(ManaButtonStyle(variant: .secondary, size: .medium))
        }
    }

    private func loadLetters() {
        letters = Array(session.dataRepository.letters.prefix(10))
    }

    private func handleTracingComplete(success: Bool) {
        isCorrect = success
        xpEarned = success ? 10 : 0

        if success {
            session.audioService.play(name: "success.mp3", rate: 1.0)
            ManaTheme.Haptics.success()
            session.gamificationService.awardXP(
                xpEarned, type: .quizCompleted, description: "Letter tracing completed")
            session.gamificationService.onActivityCompleted()

            if let letter = currentLetter {
                session.dataRepository.markLetterAsLearned(letter.id)
            }
        } else {
            session.audioService.play(name: "tryagain.mp3", rate: 1.0)
            ManaTheme.Haptics.error()
        }

        showingFeedback = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            showingFeedback = false
            clearCanvas = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                clearCanvas = false
                if isCorrect {
                    nextLetter()
                }
            }
        }
    }

    private func nextLetter() {
        if currentLetterIndex < letters.count - 1 {
            currentLetterIndex += 1
        } else {
            ManaTheme.Haptics.heavy()
        }
    }

    private func skipLetter() {
        if currentLetterIndex < letters.count - 1 {
            currentLetterIndex += 1
        } else {
            ManaTheme.Haptics.heavy()
        }
    }
}
