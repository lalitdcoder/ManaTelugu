import SwiftUI

struct BadgeUnlockedView: View {
    let badge: GamificationBadge
    let onDismiss: () -> Void

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: AppleHIGDesign.Spacing.lg) {
            Text("New Badge Unlocked!")
                .font(AppleHIGDesign.Typography.title1)
                .foregroundColor(AppleHIGDesign.Colors.label)

            VStack(spacing: AppleHIGDesign.Spacing.md) {
                Text(badge.emoji)
                    .font(.system(size: 80))
                Text(badge.name)
                    .font(AppleHIGDesign.Typography.title2)
                    .foregroundColor(AppleHIGDesign.Colors.label)
                Text(badge.description)
                    .font(AppleHIGDesign.Typography.body)
                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                    .multilineTextAlignment(.center)
            }
            .padding(AppleHIGDesign.Spacing.lg)
            .background(AppleHIGDesign.Colors.secondarySystemBackground)
            .cornerRadius(AppleHIGDesign.CornerRadius.xl)
            .scaleEffect(isAnimating ? 1.0 : 0.5)
            .opacity(isAnimating ? 1.0 : 0.0)

            Button("Awesome!") {
                HapticsManager.shared.notification(.success)
                onDismiss()
            }
            .buttonStyle(AppleHIGButtonStyle(style: .primary, size: .large))
            .padding(.top, AppleHIGDesign.Spacing.md)
        }
        .padding(AppleHIGDesign.Spacing.xl)
        .background(AppleHIGDesign.Colors.systemBackground)
        .onAppear {
            AppleHIGDesign.Haptics.success()
            withAnimation(AppleHIGDesign.Animation.bouncy) {
                isAnimating = true
            }
        }
    }
}
