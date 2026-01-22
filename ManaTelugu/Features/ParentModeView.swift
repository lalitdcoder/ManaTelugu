import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

struct ParentModeView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var isAuthenticated = false
    @State private var mathAnswer = ""
    @State private var showingError = false
    @State private var currentMathProblem = MathProblem.random()
    @State private var storedPassword: String? = UserDefaults.standard.string(
        forKey: "parent_password")
    @State private var enteredPassword = ""
    @State private var showingPasswordSetup = false
    @State private var showingResetAlert = false
    @State private var showingResetSheet = false
    @State private var resetMathProblem = MathProblem.random()
    @State private var resetMathAnswer = ""

    var body: some View {
        ZStack {
            // Smooth gradient background
            ModernDesignSystem.Colors.backgroundGradient
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }
        }
    }

    private var passwordSetupView: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 60))
                    .foregroundColor(ModernDesignSystem.Colors.teluguBlue)

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
                        .fill(ModernDesignSystem.Colors.surface)
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
                                .fill(ModernDesignSystem.Colors.teluguBlue)
                        )
                }
                .disabled(mathAnswer.isEmpty || enteredPassword.isEmpty)
                .opacity(mathAnswer.isEmpty || enteredPassword.isEmpty ? 0.6 : 1.0)

                if showingError {
                    Text("Incorrect answer. Try again!")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.error)
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
                    .foregroundColor(ModernDesignSystem.Colors.teluguBlue)

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
                                    .fill(ModernDesignSystem.Colors.teluguBlue)
                            )
                    }
                    .disabled(mathAnswer.isEmpty)
                    .opacity(mathAnswer.isEmpty ? 0.6 : 1.0)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ModernDesignSystem.Colors.surface)
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
                                    .fill(ModernDesignSystem.Colors.success)
                            )
                    }
                    .disabled(enteredPassword.isEmpty)
                    .opacity(enteredPassword.isEmpty ? 0.6 : 1.0)
                }

                if showingError {
                    Text("Incorrect answer or password. Try again!")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.error)
                }

                Button(action: {
                    resetMathProblem = MathProblem.random()
                    resetMathAnswer = ""
                    showingResetSheet = true
                }) {
                    Text("Forgot Password? Reset it")
                        .font(.footnote)
                        .foregroundColor(ModernDesignSystem.Colors.teluguBlue)
                        .underline()
                }
            }
        }
        .padding(.horizontal, 24)
        .sheet(isPresented: $showingResetSheet) {
            resetPasswordSheet
        }
    }

    private var authenticatedView: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 50))
                            .foregroundColor(ModernDesignSystem.Colors.teluguBlue)

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
                        NavigationLink {
                            ContactUsView()
                        } label: {
                            ParentOptionCard(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                description: "Get in touch with our support team",
                                color: ModernDesignSystem.Colors.teluguBlue
                            )
                        }

                        NavigationLink {
                            AboutUsView()
                        } label: {
                            ParentOptionCard(
                                icon: "info.circle.fill",
                                title: "About Us",
                                description: "Learn more about Mana Telugu",
                                color: ModernDesignSystem.Colors.success
                            )
                        }

                        Button(action: {
                            showingResetAlert = true
                        }) {
                            ParentOptionCard(
                                icon: "trash.fill",
                                title: "Reset Progress",
                                description: "Clear all progress and start over",
                                color: ModernDesignSystem.Colors.error
                            )
                        }
                        .alert("Reset Progress?", isPresented: $showingResetAlert) {
                            Button("Cancel", role: .cancel) {}
                            Button("Reset", role: .destructive) {
                                session.gamificationService.resetProgress()
                                session.dataRepository.resetProgress()
                                dismiss()
                            }
                        } message: {
                            Text(
                                "This action cannot be undone. All badges, XP, and learned letters will be lost."
                            )
                        }
                    }

                    // Child's progress summary
                    progressSummary
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
        }
    }

    private var progressSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Child's Progress")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                ProgressRow(
                    title: "Experience Points",
                    value: "\(session.gamificationService.gamificationState.totalXP) XP",
                    color: ModernDesignSystem.Colors.teluguBlue)
                ProgressRow(
                    title: "Learning Streak",
                    value: "\(session.gamificationService.gamificationState.streakCount) days",
                    color: ModernDesignSystem.Colors.warning)
                ProgressRow(
                    title: "Badges Earned",
                    value:
                        "\(session.gamificationService.gamificationState.badges.filter { $0.isUnlocked }.count)",
                    color: ModernDesignSystem.Colors.success)
                ProgressRow(
                    title: "Level",
                    value:
                        "Level \(session.gamificationService.gamificationState.currentLevel.level)",
                    color: ModernDesignSystem.Colors.funPurple)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ModernDesignSystem.Colors.surface)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    private var resetPasswordSheet: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Image(systemName: "lock.rotation")
                    .font(.system(size: 60))
                    .foregroundColor(ModernDesignSystem.Colors.teluguBlue)

                Text("Reset Password")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("Solve this math problem to reset your password")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("What is \(resetMathProblem.question)?")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    TextField("Your answer", text: $resetMathAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .font(.body)
                        .multilineTextAlignment(.center)

                    Button(action: {
                        if Int(resetMathAnswer) == resetMathProblem.answer {
                            UserDefaults.standard.removeObject(forKey: "parent_password")
                            storedPassword = nil
                            showingResetSheet = false
                        } else {
                            resetMathAnswer = ""
                            resetMathProblem = MathProblem.random()
                        }
                    }) {
                        Text("Reset Password")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ModernDesignSystem.Colors.error)
                            )
                    }
                    .disabled(resetMathAnswer.isEmpty)
                    .opacity(resetMathAnswer.isEmpty ? 0.6 : 1.0)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ModernDesignSystem.Colors.surface)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )

                Button("Cancel") {
                    showingResetSheet = false
                }
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .preferredColorScheme(.light)  // Or stick to system theme
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

    struct MathProblem {
        let question: String
        let answer: Int

        static func random() -> MathProblem {
            let operations = ["+", "-", "×"]
            let operation = operations.randomElement() ?? "+"

            switch operation {
            case "+":
                let a = Int.random(in: 50...99)
                let b = Int.random(in: 50...99)
                return MathProblem(question: "\(a) + \(b)", answer: a + b)
            case "-":
                let a = Int.random(in: 100...200)
                let b = Int.random(in: 10...99)
                return MathProblem(question: "\(a) - \(b)", answer: a - b)
            case "×":
                let a = Int.random(in: 12...19)
                let b = Int.random(in: 3...9)
                return MathProblem(question: "\(a) × \(b)", answer: a * b)
            default:
                return MathProblem(question: "15 × 5", answer: 75)
            }
        }
    }

    struct ParentOptionCard: View {
        let icon: String
        let title: String
        let description: String
        let color: Color

        var body: some View {
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
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ModernDesignSystem.Colors.surface)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
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
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)

                Spacer()

                Text(value)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
        }
    }
}
