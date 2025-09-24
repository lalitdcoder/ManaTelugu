import SwiftUI

struct NavBarIcon: View {
    let systemName: String
    let selected: Bool
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(selected ? MTColors.funBlue : Color.gray.opacity(0.5))
            .shadow(color: selected ? MTColors.funBlue.opacity(0.18) : .clear, radius: 4, x: 0, y: 2)
            .background(
                Circle()
                    .fill(Color.white.opacity(selected ? 0.9 : 0.5))
                    .frame(width: 44, height: 44)
            )
    }
}
