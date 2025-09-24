import SwiftUI

struct BadgeUnlockedView: View {
    let badge: GamificationBadge
    let onDismiss: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("New Badge Unlocked!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack {
                Text(badge.icon)
                    .font(.system(size: 80))
                Text(badge.name)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(badge.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .scaleEffect(isAnimating ? 1.0 : 0.5)
            .opacity(isAnimating ? 1.0 : 0.0)
            
            Button(action: onDismiss) {
                Text("Awesome!")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(30)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                isAnimating = true
            }
        }
    }
}
