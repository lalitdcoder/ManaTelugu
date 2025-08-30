import SwiftUI

struct TracingCanvasView: View {
    let targetCharacter: String
    let onTracingComplete: (Bool) -> Void
    
    @State private var currentPath = Path()
    @State private var completedPaths: [Path] = []
    @State private var isDrawing = false
    @State private var hasStartedTracing = false
    @State private var showClearButton = false
    
    var body: some View {
        ZStack {
            // Background character (faded)
            Text(targetCharacter)
                .font(.system(size: 120, weight: .ultraLight))
                .foregroundColor(MTColors.text.opacity(0.1))
                .allowsHitTesting(false)
            
            // Drawing canvas
            Canvas { context, size in
                // Draw completed paths
                for path in completedPaths {
                    context.stroke(
                        path,
                        with: .color(MTColors.primary),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
                    )
                }
                
                // Draw current path
                if !currentPath.isEmpty {
                    context.stroke(
                        currentPath,
                        with: .color(MTColors.primary),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
                    )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDrawing {
                            // Start new path
                            currentPath = Path()
                            currentPath.move(to: value.location)
                            isDrawing = true
                            hasStartedTracing = true
                            showClearButton = true
                        } else {
                            // Continue current path
                            currentPath.addLine(to: value.location)
                        }
                    }
                    .onEnded { _ in
                        // Finish current path
                        if !currentPath.isEmpty {
                            completedPaths.append(currentPath)
                            currentPath = Path()
                        }
                        isDrawing = false
                        
                        // Check if tracing is complete (simple heuristic)
                        checkTracingCompletion()
                    }
            )
            
            // Clear button
            if showClearButton {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: clearCanvas) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(MTColors.primary))
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
            
            // Instructions overlay (shown when no tracing has started)
            if !hasStartedTracing {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "hand.draw")
                            .font(.title2)
                            .foregroundColor(MTColors.primary)
                        Text("Trace the character with your finger")
                            .font(MTTypography.body(kidMode: false))
                            .foregroundColor(MTColors.text.opacity(0.7))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(MTColors.surface.opacity(0.9))
                            .shadow(radius: 4)
                    )
                    .padding()
                }
            }
        }
    }
    
    private func clearCanvas() {
        withAnimation(.easeInOut(duration: 0.3)) {
            completedPaths.removeAll()
            currentPath = Path()
            hasStartedTracing = false
            showClearButton = false
        }
    }
    
    private func checkTracingCompletion() {
        // Simple heuristic: if user has drawn enough paths, consider it complete
        // In a real implementation, you might use more sophisticated pattern matching
        let hasEnoughStrokes = completedPaths.count >= 2 || 
                              (completedPaths.count >= 1 && pathLength(completedPaths[0]) > 200)
        
        if hasEnoughStrokes {
            // Provide haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // Call completion with success (for now, always true for practice)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onTracingComplete(true)
            }
        }
    }
    
    private func pathLength(_ path: Path) -> Double {
        // Simple approximation of path length
        var length: Double = 0
        var previousPoint: CGPoint?
        
        path.forEach { element in
            switch element {
            case .move(to: let point):
                previousPoint = point
            case .line(to: let point):
                if let prev = previousPoint {
                    length += distance(from: prev, to: point)
                }
                previousPoint = point
            default:
                break
            }
        }
        
        return length
    }
    
    private func distance(from point1: CGPoint, to point2: CGPoint) -> Double {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(Double(dx * dx + dy * dy))
    }
}

#Preview {
    TracingCanvasView(
        targetCharacter: "అ",
        onTracingComplete: { isCorrect in
            print("Tracing complete: \(isCorrect)")
        }
    )
    .frame(height: 200)
    .padding()
}
