import SwiftUI

struct TreasureChestView: View {
    let stickerReward: Sticker
    let xpReward: Int
    let onDismiss: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("You've unlocked a Treasure Chest!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            VStack {
                Text("💎") // Treasure chest emoji
                    .font(.system(size: 100))
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                
                Text("You found a new sticker!")
                    .font(.title2)
                
                StickerView(sticker: stickerReward, isUnlocked: true)
                
                Text("+\(xpReward) XP")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(30)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            
            Button(action: onDismiss) {
                Text("Collect")
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
            // Single animation instead of infinite loop to prevent crashes
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                    isAnimating = false
                }
            }
        }
    }
}
