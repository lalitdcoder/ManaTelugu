import SwiftUI

struct TraceGameView: View {
    @EnvironmentObject var session: AppSession
    @State private var letters: [Letter] = []
    @State private var currentLetterIndex = 0
    @State private var showingFeedback = false
    @State private var isCorrect = false
    @State private var xpEarned = 0
    
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
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
            onTracingComplete: { success in
                handleTracingComplete(success: success)
            }
        )
        .frame(height: 300)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button("Skip") {
                nextLetter()
            }
            .font(.callout)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
            )
            
            Button("Next") {
                nextLetter()
            }
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
        Task {
            letters = await session.dataRepository.letters.prefix(5).map { $0 }
        }
    }
    
    private func handleTracingComplete(success: Bool) {
        isCorrect = success
        xpEarned = success ? 10 : 5
        showingFeedback = true
        
        // Add XP to user progress
        session.gamificationService.awardXP(xpEarned, type: .quizCompleted, description: "Letter tracing completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showingFeedback = false
            nextLetter()
        }
    }
    
    private func nextLetter() {
        if currentLetterIndex < letters.count - 1 {
            currentLetterIndex += 1
        } else {
            // Game complete - could show completion screen
        }
    }
}
