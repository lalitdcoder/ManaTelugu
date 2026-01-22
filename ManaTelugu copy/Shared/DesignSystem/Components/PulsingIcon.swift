import SwiftUI

struct PulsingIcon: View {
    let iconName: String
    let color: Color
    let size: CGFloat
    
    @State private var isPulsing = false
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: size, weight: .semibold))
            .foregroundColor(color)
            .scaleEffect(isPulsing ? 1.1 : 1.0)
            .animation(
                .easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}






