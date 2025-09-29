import SwiftUI

struct SimplifiedParentModeView: View {
    @State private var isAuthenticated = false
    @State private var mathAnswer = ""
    @State private var showingError = false
    @State private var currentMathProblem = MathProblem.random()
    @State private var storedPassword: String? = UserDefaults.standard.string(forKey: "parent_password")
    @State private var enteredPassword = ""
    @State private var showingPasswordSetup = false
    
    var body: some View {
        ZStack {
            // Smooth gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.92, green: 0.95, blue: 0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            if isAuthenticated {
                authenticatedView
            } else if storedPassword == nil {
                passwordSetupView
            } else {
                authenticationView
            }
        }
        .navigationTitle("Parent Mode")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var passwordSetupView: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Set Up Parent Mode")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("First, solve this math problem to create your password")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 24) {
                // Math problem
                VStack(spacing: 16) {
                    Text("What is \(currentMathProblem.question)?")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    TextField("Your answer", text: $mathAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                
                // Password setup
                VStack(spacing: 12) {
                    Text("Create a password for future access:")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    SecureField("Create password", text: $enteredPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                }
                
                Button(action: setupPassword) {
                    Text("Set Up Parent Mode")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                }
                .disabled(mathAnswer.isEmpty || enteredPassword.isEmpty)
                .opacity(mathAnswer.isEmpty || enteredPassword.isEmpty ? 0.6 : 1.0)
                
                if showingError {
                    Text("Incorrect answer. Try again!")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var authenticationView: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Parent Mode")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Solve the math problem or enter your password")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 24) {
                // Math problem option
                VStack(spacing: 16) {
                    Text("What is \(currentMathProblem.question)?")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    TextField("Your answer", text: $mathAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .font(.body)
                        .multilineTextAlignment(.center)
                    
                    Button(action: verifyMathAnswer) {
                        Text("Solve Math Problem")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                            )
                    }
                    .disabled(mathAnswer.isEmpty)
                    .opacity(mathAnswer.isEmpty ? 0.6 : 1.0)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                
                // Divider
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("OR")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                
                // Password option
                VStack(spacing: 16) {
                    SecureField("Enter password", text: $enteredPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                    
                    Button(action: verifyPassword) {
                        Text("Enter with Password")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.green)
                            )
                    }
                    .disabled(enteredPassword.isEmpty)
                    .opacity(enteredPassword.isEmpty ? 0.6 : 1.0)
                }
                
                if showingError {
                    Text("Incorrect answer or password. Try again!")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var authenticatedView: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Parent Dashboard")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Monitor your child's learning progress")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Main options
                VStack(spacing: 16) {
                    ParentOptionCard(
                        icon: "envelope.fill",
                        title: "Contact Us",
                        description: "Get in touch with our support team",
                        color: .blue
                    ) {
                        // Navigate to contact us
                    }
                    
                    ParentOptionCard(
                        icon: "info.circle.fill",
                        title: "About Us",
                        description: "Learn more about Mana Telugu",
                        color: .green
                    ) {
                        // Navigate to about us
                    }
                }
                
                // Child's progress summary
                progressSummary
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
    }
    
    private var progressSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Child's Progress")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ProgressRow(title: "Letters Learned", value: "24/36", color: .blue)
                ProgressRow(title: "Games Completed", value: "12", color: .green)
                ProgressRow(title: "Study Streak", value: "5 days", color: .orange)
                ProgressRow(title: "Total Time", value: "2h 30m", color: .purple)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
    
    private func setupPassword() {
        guard Int(mathAnswer) == currentMathProblem.answer else {
            showingError = true
            mathAnswer = ""
            currentMathProblem = MathProblem.random()
            return
        }
        
        UserDefaults.standard.set(enteredPassword, forKey: "parent_password")
        storedPassword = enteredPassword
        isAuthenticated = true
        showingError = false
    }
    
    private func verifyMathAnswer() {
        guard Int(mathAnswer) == currentMathProblem.answer else {
            showingError = true
            mathAnswer = ""
            currentMathProblem = MathProblem.random()
            return
        }
        
        isAuthenticated = true
        showingError = false
    }
    
    private func verifyPassword() {
        guard enteredPassword == storedPassword else {
            showingError = true
            enteredPassword = ""
            return
        }
        
        isAuthenticated = true
        showingError = false
    }
}

struct MathProblem {
    let question: String
    let answer: Int
    
    static func random() -> MathProblem {
        let operations = ["+", "-", "×"]
        let operation = operations.randomElement()!
        
        switch operation {
        case "+":
            let a = Int.random(in: 5...15)
            let b = Int.random(in: 5...15)
            return MathProblem(question: "\(a) + \(b)", answer: a + b)
        case "-":
            let a = Int.random(in: 10...25)
            let b = Int.random(in: 5...a-1)
            return MathProblem(question: "\(a) - \(b)", answer: a - b)
        case "×":
            let a = Int.random(in: 2...8)
            let b = Int.random(in: 2...8)
            return MathProblem(question: "\(a) × \(b)", answer: a * b)
        default:
            return MathProblem(question: "5 + 5", answer: 10)
        }
    }
}

struct ParentOptionCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct ProgressRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}
