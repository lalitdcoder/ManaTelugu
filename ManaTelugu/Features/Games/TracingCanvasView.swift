import SwiftUI

struct TracingCanvasView: View {
    let targetCharacter: String
    let referenceStrokes: [[CGPointCodable]]
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
                .foregroundColor(ElegantDesign.Colors.textPrimary.opacity(0.1))
                .allowsHitTesting(false)
            
            // Drawing canvas
            Canvas { context, size in
                // Draw completed paths
                for path in completedPaths {
                    context.stroke(
                        path,
                        with: .color(ElegantDesign.Colors.primary),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
                    )
                }
                
                // Draw current path
                if !currentPath.isEmpty {
                    context.stroke(
                        currentPath,
                        with: .color(ElegantDesign.Colors.primary),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
                    )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDrawing {
                            isDrawing = true
                            hasStartedTracing = true
                            currentPath = Path()
                            currentPath.move(to: value.location)
                        } else {
                            currentPath.addLine(to: value.location)
                        }
                        showClearButton = true
                    }
                    .onEnded { _ in
                        isDrawing = false
                        completedPaths.append(currentPath)
                        currentPath = Path()
                        
                        // Simple completion check
                        if completedPaths.count >= 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                onTracingComplete(true)
                            }
                        }
                    }
            )
            
            // Clear button
            if showClearButton {
                VStack {
                    HStack {
                        Spacer()
                        Button("Clear") {
                            clearCanvas()
                        }
                        .font(ElegantDesign.Typography.callout)
                        .foregroundColor(ElegantDesign.Colors.primary)
                        .padding(ElegantDesign.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.sm)
                                .fill(ElegantDesign.Colors.surfaceSecondary)
                        )
                    }
                    Spacer()
                }
                .padding(ElegantDesign.Spacing.md)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                .fill(ElegantDesign.Colors.surfaceSecondary.opacity(0.3))
                .stroke(ElegantDesign.Colors.primary.opacity(0.3), lineWidth: 2)
        )
    }
    
    private func clearCanvas() {
        completedPaths.removeAll()
        currentPath = Path()
        showClearButton = false
        hasStartedTracing = false
    }
}
