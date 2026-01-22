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
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                if let letter = currentLetter {
                    header(for: letter)
                    referenceGlyph(for: letter)
                    tracingCanvas(for: letter)
                    actionButtons
                }
            }
            .padding(20)

            // Feedback overlay
            if showingFeedback {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(isCorrect ? .green : .red)

                    Text(isCorrect ? "Correct!" : "Try Again!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(isCorrect ? .green : .red)

                    if isCorrect {
                        Text("Great tracing! +\(xpEarned) XP")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                )
                .scaleEffect(showingFeedback ? 1.0 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showingFeedback)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Exit") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .onAppear {
            HapticsManager.shared.impact(.light)
            loadLetters()
        }
    }

    private func header(for letter: Letter) -> some View {
        VStack(spacing: 8) {
            Text("Trace the Letter")
                .font(.title2)
                .foregroundColor(.primary)

            Text("Follow the shape to write '\(letter.character)' (\(letter.romanization))")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }

    private func referenceGlyph(for letter: Letter) -> some View {
        VStack(spacing: 8) {
            Text(letter.character)
                .font(.system(size: 100, weight: .light, design: .serif))
                .foregroundColor(.blue)

            Text(letter.meaning)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
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
        .frame(
            height: UIScreen.main.bounds.height < 700
                ? 250 : (UIScreen.main.bounds.height < 900 ? 350 : 400))
    }

    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button("Skip") {
                skipLetter()
            }
            .buttonStyle(HapticButtonStyle(hapticType: .medium))
            .font(.callout)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
            )

            Button("Check") {
                validate = true
            }
            .buttonStyle(HapticButtonStyle(hapticType: .medium))
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green)
            )

            Button("Next") {
                skipLetter()
            }
            .buttonStyle(HapticButtonStyle(hapticType: .medium))
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
            )
        }
    }

    private func loadLetters() {
        letters = Array(session.dataRepository.letters.prefix(5))
    }

    private func handleTracingComplete(success: Bool) {
        isCorrect = success
        xpEarned = success ? 10 : 0

        // -- ADDED: Play correct/incorrect sound
        if success {
            session.audioService.play(name: "success.mp3", rate: 1.0)
        } else {
            session.audioService.play(name: "tryagain.mp3", rate: 1.0)
        }
        // -- END ADDED

        showingFeedback = true

        if success {
            FeedbackCenter.correct()
            session.gamificationService.awardXP(
                xpEarned, type: .quizCompleted, description: "Letter tracing completed")
            session.gamificationService.onActivityCompleted()

            // Mark letter as learned when successfully traced
            if let letter = currentLetter {
                session.dataRepository.markLetterAsLearned(letter.id)
            }
        } else {
            FeedbackCenter.wrong()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
            // Game complete - could show completion screen
            HapticsManager.shared.impact(.heavy)
            FeedbackCenter.correct()
        }
    }

    private func skipLetter() {
        if currentLetterIndex < letters.count - 1 {
            currentLetterIndex += 1
        } else {
            // Game complete - no sound for skip
            HapticsManager.shared.impact(.heavy)
        }
    }
}
