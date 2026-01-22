import SwiftUI

struct LetterCardView: View {
    let letter: Letter
    
    var body: some View {
        VStack(spacing: 4) {
            Text(letter.character)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(ModernDesignSystem.Colors.primary)
            
            Text(letter.romanization)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ModernDesignSystem.Colors.surface)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}
