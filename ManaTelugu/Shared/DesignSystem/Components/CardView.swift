import SwiftUI

struct CardView: View {
    let telugu: String
    let transliteration: String
    let english: String
    let onTap: () -> Void
    
    @State private var showTranslation = false
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text(telugu)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(transliteration)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
            if showTranslation {
                Text(english)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        .scaleEffect(animate ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: animate)
        .onTapGesture {
            showTranslation.toggle()
            animate = true
            onTap()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                animate = false
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("\(telugu), \(transliteration)")
        .accessibilityHint(showTranslation ? "Hide translation" : "Show translation")
    }
}