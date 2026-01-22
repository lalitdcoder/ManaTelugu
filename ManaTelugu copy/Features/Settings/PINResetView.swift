import SwiftUI

struct PINResetView: View {
    @Binding var isPresented: Bool
    @Binding var isPinReset: Bool

    @State private var num1 = Int.random(in: 12...19)
    @State private var num2 = Int.random(in: 3...9)
    @State private var answer = ""
    @State private var errorMessage: String?

    var correctAnswer: Int {
        num1 * num2
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("To reset your PIN, please solve this problem:")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("\(num1) × \(num2) = ?")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Answer", text: $answer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 150)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button(
                "Submit",
                action: {
                    HapticsService.shared.importantAction()
                    checkAnswer()
                }
            )
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding(30)
    }

    private func checkAnswer() {
        if let userAnswer = Int(answer), userAnswer == correctAnswer {
            isPinReset = true
            isPresented = false
        } else {
            errorMessage = "Incorrect answer. Please try again."
            // Generate new numbers
            num1 = Int.random(in: 12...19)
            num2 = Int.random(in: 3...9)
            answer = ""
        }
    }
}
