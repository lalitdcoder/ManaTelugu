import SwiftUI

struct LessonSummaryView: View {
    let totalXP: Int
    let accuracy: Double
    let streak: Int
    let onContinue: () -> Void

    @State private var animateXP = false
    @State private var animateAccuracy = false
    @State private var animateStreak = false
    @State private var showButton = false

    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Lesson Complete!")
                    .font(ModernDesignSystem.Typography.title1)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                HStack(spacing: 20) {
                    // XP Counter
                    VStack {
                        Text("XP Earned")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("+\(totalXP)")
                            .font(ModernDesignSystem.Typography.title1)
                            .foregroundColor(ModernDesignSystem.Colors.funYellow)
                            .scaleEffect(animateXP ? 1.0 : 0.5)
                            .opacity(animateXP ? 1.0 : 0.0)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // Accuracy Circle
                    VStack {
                        Text("Accuracy")
                            .font(.caption)
                            .foregroundColor(.gray)
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                                .frame(width: 60, height: 60)
                            Circle()
                                .trim(from: 0, to: animateAccuracy ? accuracy : 0)
                                .stroke(
                                    ModernDesignSystem.Colors.funGreen,
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                )
                                .frame(width: 60, height: 60)
                                .rotationEffect(.degrees(-90))
                            Text("\(Int(accuracy * 100))%")
                                .font(.caption).bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // Streak Flame
                    VStack {
                        Text("Streak")
                            .font(.caption)
                            .foregroundColor(.gray)
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .scaleEffect(animateStreak ? 1.2 : 0.8)
                            Text("\(streak)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                .padding(.horizontal)

                if showButton {
                    Button(action: onContinue) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ModernDesignSystem.Colors.primary)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 40)
                    .transition(.scale.combined(with: .opacity))
                }

                Spacer()
            }
            .background(Color(.systemBackground))
            .cornerRadius(24)
            .padding(20)
            .shadow(radius: 20)
            .frame(maxHeight: 500)
        }
        .onAppear {
            // Sequence animations
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animateXP = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 1.0)) {
                    animateAccuracy = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
                    animateStreak = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showButton = true
                }
            }

            // Play sound
            // session.audioService.play(name: "lesson_complete", rate: 1.0) // Assuming this exists or can be added
        }
    }
}
