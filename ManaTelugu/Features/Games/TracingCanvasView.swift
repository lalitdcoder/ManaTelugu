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
        guard !completedPaths.isEmpty else { return }
        let minPathLength: Double = 300 // Even stricter
        let minArea: CGFloat = 20000 // Even stricter
        let minPoints: Int = 40 // Require at least 40 points in the trace
        let userBoundingBox = completedPaths.reduce(CGRect.null) { $0.union($1.boundingRect) }
        let hasLongEnoughPath = completedPaths.contains { pathLength($0) > minPathLength }
        let hasBigEnoughArea = userBoundingBox.width * userBoundingBox.height > minArea
        let userPoints: [CGPoint] = completedPaths.flatMap { path in
            var points: [CGPoint] = []
            path.forEach { element in
                switch element {
                case .move(to: let pt): points.append(pt)
                case .line(to: let pt): points.append(pt)
                default: break
                }
            }
            return points
        }
        let enoughPoints = userPoints.count >= minPoints
        // Require at least as many strokes as reference
        let enoughStrokes = completedPaths.count >= referenceStrokes.count
        // Require start and end points to be close to reference
        let refStart = referenceStrokes.first?.first.map { CGPoint(x: $0.x * 120, y: $0.y * 120) }
        let refEnd = referenceStrokes.last?.last.map { CGPoint(x: $0.x * 120, y: $0.y * 120) }
        let userStart = completedPaths.first.flatMap { path in
            var first: CGPoint? = nil
            path.forEach { element in
                if case .move(to: let pt) = element, first == nil { first = pt }
                else if case .line(to: let pt) = element, first == nil { first = pt }
            }
            return first
        }
        let userEnd = completedPaths.last.flatMap { path in
            var last: CGPoint? = nil
            path.forEach { element in
                if case .line(to: let pt) = element { last = pt }
                else if case .move(to: let pt) = element, last == nil { last = pt }
            }
            return last
        }
        let startClose = (refStart != nil && userStart != nil) ? distance(from: refStart!, to: userStart!) < 24 : true
        let endClose = (refEnd != nil && userEnd != nil) ? distance(from: refEnd!, to: userEnd!) < 24 : true
        if !(hasLongEnoughPath && hasBigEnoughArea && enoughPoints && enoughStrokes && startClose && endClose) {
            return
        }
        // --- Path similarity check ---
        let refPoints: [CGPoint] = referenceStrokes.flatMap { stroke in
            stroke.map { CGPoint(x: $0.x * 120, y: $0.y * 120) }
        }
        guard !userPoints.isEmpty, !refPoints.isEmpty else { return }
        // 3. Compute average min distance from user to ref
        var userToRefDistances: [Double] = []
        for userPt in userPoints {
            let minDist = refPoints.map { distance(from: $0, to: userPt) }.min() ?? 9999
            userToRefDistances.append(minDist)
        }
        let avgUserToRef = userToRefDistances.reduce(0, +) / Double(userToRefDistances.count)
        // 4. Compute average min distance from ref to user
        var refToUserDistances: [Double] = []
        for refPt in refPoints {
            let minDist = userPoints.map { distance(from: $0, to: refPt) }.min() ?? 9999
            refToUserDistances.append(minDist)
        }
        let avgRefToUser = refToUserDistances.reduce(0, +) / Double(refToUserDistances.count)
        // 5. Accept if both averages are less than 7% of canvas size (very strict)
        let threshold: Double = 120 * 0.07
        if avgUserToRef < threshold && avgRefToUser < threshold {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onTracingComplete(true)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onTracingComplete(false)
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
        referenceStrokes: [
            [CGPointCodable(x: 0.5, y: 0.5), CGPointCodable(x: 0.7, y: 0.7)],
            [CGPointCodable(x: 0.7, y: 0.7), CGPointCodable(x: 0.9, y: 0.9)]
        ],
        onTracingComplete: { isCorrect in
            print("Tracing complete: \(isCorrect)")
        }
    )
    .frame(height: 200)
    .padding()
}
