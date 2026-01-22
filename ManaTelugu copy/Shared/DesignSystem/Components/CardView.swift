import SwiftUI

struct CardView: View {
    let telugu: String
    let transliteration: String
    let english: String
    let onTap: () -> Void
    
    @State private var showTranslation = false
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.regular) {
            Text(telugu)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(ModernDesignSystem.Colors.primary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            (Text(transliteration) as Text)
                .font(ModernDesignSystem.Typography.body)
                .fontWeight(.medium)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
            if showTranslation {
                Text(english)
                    .font(ModernDesignSystem.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.accent)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .padding(ModernDesignSystem.Spacing.lg)
        .frame(maxWidth: .infinity, minHeight: 120)
        .frame(minWidth: ModernDesignSystem.Spacing.comfortableTouchTarget, minHeight: ModernDesignSystem.Spacing.comfortableTouchTarget)
        .glassEffect(.regular, shape: .rect(cornerRadius: 24))
        .scaleEffect(animate ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: animate)
        .animation(.easeInOut(duration: 0.3), value: showTranslation)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showTranslation.toggle()
                animate = true
            }
            onTap()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeOut(duration: 0.2)) {
                    animate = false
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("Telugu word: \(telugu), \(transliteration)")
        .accessibilityHint(showTranslation ? "Hide English translation" : "Tap to show English translation")
        .accessibilityValue(showTranslation ? "Translation: \(english)" : "Translation not yet revealed")
    }
}