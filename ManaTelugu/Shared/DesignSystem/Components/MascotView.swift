import SwiftUI

struct MascotView: View {
    var message: String
    @State private var wave = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {
            ZStack {
                // Cartoon parrot mascot (simple shapes)
                Circle()
                    .fill(MTColors.mascot)
                    .frame(width: 64, height: 64)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                            .offset(x: 16, y: -16)
                    )
                Ellipse()
                    .fill(MTColors.funGreen)
                    .frame(width: 32, height: 16)
                    .offset(x: 0, y: 24)
                // Beak
                Triangle()
                    .fill(MTColors.funYellow)
                    .frame(width: 16, height: 16)
                    .rotationEffect(.degrees(30))
                    .offset(x: 24, y: 8)
                // Eye
                Circle()
                    .fill(Color.black)
                    .frame(width: 8, height: 8)
                    .offset(x: 20, y: -10)
            }
            .scaleEffect(wave ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: wave)
            .onAppear { wave = true }
            // Speech bubble
            Text(message)
                .font(MTTypography.body(kidMode: true))
                .foregroundColor(MTColors.text)
                .padding(12)
                .background(MTColors.funYellow.opacity(0.8))
                .cornerRadius(16)
                .shadow(radius: 2)
        }
        .padding(.vertical, 8)
    }
}

// Simple triangle shape for beak
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


