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
        VStack(spacing: MTSpacing.medium) {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(isCorrect ? .green : .red)
                
                Text(isCorrect ? "Correct!" : "Incorrect")
                    .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                    .foregroundColor(isCorrect ? .green : .red)
                
                Spacer()
                
                if isCorrect && xpEarned > 0 {
                    Text("+\(xpEarned) XP")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
            }
            
            // Custom message
            Text(message)
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.8))
                .multilineTextAlignment(.leading)
            
            // Explanation if provided
            if let explanation = explanation {
                Text(explanation)
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.8))
                    .multilineTextAlignment(.leading)
            }
            
            // Show correct answer if incorrect
            if !isCorrect, let correctAnswer = correctAnswer {
                Text("Correct answer: \(correctAnswer)")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
            
            // Continue button
            Button(action: onContinue) {
                Text("Continue")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(MTColors.primary)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(
            LiquidGlassView(
                intensity: isCorrect ? 0.15 : 0.1,
                cornerRadius: 12,
                padding: 0
            ) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
            }
        )
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
