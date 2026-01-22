import SwiftUI

struct GameFeedbackView: View {
    let isCorrect: Bool
    let message: String
    let xpEarned: Int
    let correctAnswer: String?
    let explanation: String?
    let onContinue: () -> Void
    
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        ZStack {
            (session.isDarkModeActive ? Color.adaptiveBackground.opacity(0.7) : Color(.systemBackground).opacity(0.7))
                .ignoresSafeArea()
                .zIndex(1)
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                HStack {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(isCorrect ? (session.isDarkModeActive ? Color.teluguAccent : .green) : (session.isDarkModeActive ? Color.teluguAccent : .red))
                    
                    Text(isCorrect ? "Correct!" : "Incorrect")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(isCorrect ? (session.isDarkModeActive ? Color.teluguAccent : .green) : (session.isDarkModeActive ? Color.teluguAccent : .red))
                    
                    Spacer()
                    
                    if isCorrect && xpEarned > 0 {
                        Text("+\(xpEarned) XP")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(session.isDarkModeActive ? Color.teluguAccent : .green)
                            .fontWeight(.medium)
                    }
                }
                
                // Custom message
                Text(message)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.8))
                    .multilineTextAlignment(.leading)
                
                // Explanation if provided
                if let explanation = explanation {
                    Text(explanation)
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                
                // Show correct answer if incorrect
                if !isCorrect, let correctAnswer = correctAnswer {
                    Text("Correct answer: \(correctAnswer)")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
                
                // Continue button
                Button(action: {
                    HapticsService.shared.importantAction()
                    onContinue()
                }) {
                    Text("Continue")
                        .font(ModernDesignSystem.Typography.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(ModernDesignSystem.Colors.primary)
                        .cornerRadius(12)
                }
            }
            .padding()
            .frame(maxWidth: 400)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 12)
            .zIndex(2)
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 20) {
        GameFeedbackView(
            isCorrect: true,
            message: "Great job! You matched the sound correctly!",
            xpEarned: 10,
            correctAnswer: nil,
            explanation: "You're getting better at recognizing Telugu sounds!",
            onContinue: {}
        )
        
        GameFeedbackView(
            isCorrect: false,
            message: "Not quite right, but keep trying!",
            xpEarned: 0,
            correctAnswer: "క",
            explanation: "Listen carefully to the pronunciation and try again.",
            onContinue: {}
        )
    }
    .environmentObject(AppSession())
}
