import SwiftUI

struct ModernProgressBar: View {
    let progress: Double // 0.0 to 1.0
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.15))
                .frame(height: 18)
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [ModernDesignSystem.Colors.funBlue, ModernDesignSystem.Colors.funGreen, ModernDesignSystem.Colors.funPink]), startPoint: .leading, endPoint: .trailing))
                .frame(width: max(0, CGFloat(progress) * 80), height: 18) // Use frame width passed in
                .animation(.easeOut(duration: 1.0), value: progress)
            Text("Progress")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 12)
        }
        .padding(.vertical, 8)
    }
}
