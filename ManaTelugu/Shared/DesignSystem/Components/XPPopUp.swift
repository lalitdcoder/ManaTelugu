import SwiftUI

struct XPPopUp: View {
    let amount: Int

    var body: some View {
        Text("+\(amount) XP")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(ModernDesignSystem.Colors.funYellow)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(ModernDesignSystem.Colors.primary)
                    .shadow(
                        color: ModernDesignSystem.Colors.funYellow.opacity(0.5), radius: 10,
                        x: 0, y: 0)
            )
            .zIndex(100)
    }
}
