import SwiftUI

struct HeartDepletedView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) var dismiss

    var onRefill: () -> Void = {}
    var onWait: () -> Void = {}

    var body: some View {
        ZStack {
            // Darkened background
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: ModernDesignSystem.Spacing.xl) {
                // Heart Icon with "Broken" or "Empty" animation
                Image(systemName: "heart.slash.fill")
                    .font(.system(size: 80))
                    .foregroundColor(ModernDesignSystem.Colors.error)
                    .symbolEffect(.bounce, value: true)
                    .padding()
                    .background(
                        Circle()
                            .fill(ModernDesignSystem.Colors.error.opacity(0.2))
                            .frame(width: 140, height: 140)
                    )
                    .overlay(
                        Circle()
                            .stroke(ModernDesignSystem.Colors.error, lineWidth: 4)
                            .frame(width: 140, height: 140)
                    )

                VStack(spacing: ModernDesignSystem.Spacing.sm) {
                    Text("Out of Hearts!")
                        .font(ModernDesignSystem.Typography.largeTitle)
                        .foregroundColor(.white)

                    Text("You need hearts to play lessons.")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)

                    if let nextHeartTime = session.nextHeartRegenTime {
                        Text("Next heart in: \(timeString(from: nextHeartTime))")
                            .font(ModernDesignSystem.Typography.headline)
                            .foregroundColor(ModernDesignSystem.Colors.funYellow)
                            .monospacedDigit()
                            .padding(.top, 8)
                    }
                }

                VStack(spacing: ModernDesignSystem.Spacing.md) {
                    // Refill with Gems Button
                    Button(action: {
                        // Simulate spending gems
                        HapticsManager.shared.impact(.medium)
                        // In a real app, check gems balance
                        session.hearts = 5  // Instant refill
                        onRefill()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "diamond.fill")
                                .foregroundColor(.white)
                            Text("Refill with 350 Gems")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: Color.blue.opacity(0.4), radius: 8, x: 0, y: 4)
                    }

                    // Wait Button
                    Button(action: {
                        onWait()
                        dismiss()
                    }) {
                        Text("No Thanks, I'll Wait")
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal, ModernDesignSystem.Spacing.xl)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .shadow(radius: 20)
            )
            .padding(ModernDesignSystem.Spacing.lg)
        }
    }

    private func timeString(from date: Date) -> String {
        let remaining = date.timeIntervalSinceNow
        if remaining > 0 {
            let minutes = Int(remaining) / 60
            let seconds = Int(remaining) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return "00:00"
        }
    }
}

// Preview
struct HeartDepletedView_Previews: PreviewProvider {
    static var previews: some View {
        HeartDepletedView()
            .environmentObject(AppSession())
    }
}
