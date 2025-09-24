import SwiftUI

struct StickerView: View {
    let sticker: Sticker
    let isUnlocked: Bool
    
    var body: some View {
        VStack {
            Text(sticker.imageName) // Using emoji for now
                .font(.system(size: 60))
                .padding()
                .background(
                    Circle()
                        .fill(isUnlocked ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.2))
                )
                .grayscale(isUnlocked ? 0 : 1)
            
            Text(sticker.name)
                .font(.caption)
                .fontWeight(.bold)
        }
        .opacity(isUnlocked ? 1.0 : 0.5)
    }
}
