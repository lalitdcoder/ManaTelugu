import SwiftUI

struct NavBarIcon: View {
    let systemName: String
    let selected: Bool
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(selected ? ModernDesignSystem.Colors.funBlue : ModernDesignSystem.Colors.textSecondary)
            .shadow(color: selected ? ModernDesignSystem.Colors.funBlue.opacity(0.18) : .clear, radius: 4, x: 0, y: 2)
            .background(
                Circle()
                    .fill(ModernDesignSystem.Colors.surface.opacity(selected ? 0.9 : 0.5))
                    .frame(width: 44, height: 44)
            )
    }
}
