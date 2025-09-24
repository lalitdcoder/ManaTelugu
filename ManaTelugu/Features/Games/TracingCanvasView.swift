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
    
    // MARK: - Path Similarity Calculation
    private func calculatePathSimilarity(userPoints: [CGPoint], refPoints: [CGPoint]) -> Double {
        guard !userPoints.isEmpty && !refPoints.isEmpty else { return 0.0 }
        
        // Normalize points to same scale
        let userNormalized = normalizePoints(userPoints)
        let refNormalized = normalizePoints(refPoints)
        
        // Calculate distance between corresponding points
        let minCount = min(userNormalized.count, refNormalized.count)
        var totalDistance: Double = 0
        
        for i in 0..<minCount {
            let distance = sqrt(pow(userNormalized[i].x - refNormalized[i].x, 2) + pow(userNormalized[i].y - refNormalized[i].y, 2))
            totalDistance += distance
        }
        
        let averageDistance = totalDistance / Double(minCount)
        
        // Convert distance to similarity score (0-1, where 1 is perfect match)
        let maxExpectedDistance: Double = 0.3 // Adjust based on your needs
        let similarity = max(0, 1.0 - (averageDistance / maxExpectedDistance))
        
        return min(1.0, similarity)
    }
    
    // MARK: - Stroke Order Score Calculation
    private func calculateStrokeOrderScore() -> Double {
        guard completedPaths.count > 1 && referenceStrokes.count > 1 else { return 1.0 }
        
        // Simple stroke order validation
        // This is a basic implementation - you can make it more sophisticated
        let userStrokeCount = completedPaths.count
        let refStrokeCount = referenceStrokes.count
        
        // Allow some flexibility in stroke count
        let strokeCountSimilarity = 1.0 - abs(Double(userStrokeCount - refStrokeCount)) / Double(max(userStrokeCount, refStrokeCount))
        
        return max(0.0, strokeCountSimilarity)
    }
    
    // MARK: - Helper Functions
    private func normalizePoints(_ points: [CGPoint]) -> [CGPoint] {
        guard !points.isEmpty else { return [] }
        
        let minX = points.map { $0.x }.min() ?? 0
        let maxX = points.map { $0.x }.max() ?? 1
        let minY = points.map { $0.y }.min() ?? 0
        let maxY = points.map { $0.y }.max() ?? 1
        
        let width = maxX - minX
        let height = maxY - minY
        let scale = max(width, height)
        
        guard scale > 0 else { return points }
        
        return points.map { point in
            CGPoint(
                x: (point.x - minX) / scale,
                y: (point.y - minY) / scale
            )
        }
    }
    
    private func checkTracingCompletion() {
        guard !completedPaths.isEmpty else { return }
        
        // More balanced validation parameters - not too strict, not too lenient
        let minPathLength: Double = 200 // Reasonable minimum path length
        let minArea: CGFloat = 15000 // Reasonable minimum area
        let minPoints: Int = 30 // Reasonable minimum points
        let maxStrokes: Int = referenceStrokes.count + 3 // Allow some flexibility in stroke count
        
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
        let notTooManyStrokes = completedPaths.count <= maxStrokes
        let enoughStrokes = completedPaths.count >= max(1, referenceStrokes.count - 1) // More flexible stroke count
        
        // More flexible stroke order validation
        let _ = validateStrokeOrder()
        
        // Get reference points for comparison
        let refPoints: [CGPoint] = referenceStrokes.flatMap { stroke in
            stroke.map { CGPoint(x: $0.x * 120, y: $0.y * 120) }
        }
        
        guard !userPoints.isEmpty, !refPoints.isEmpty else { 
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onTracingComplete(false)
            }
            return 
        }
        
        // Basic requirements check
        guard hasLongEnoughPath && hasBigEnoughArea && enoughPoints && enoughStrokes && notTooManyStrokes else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onTracingComplete(false)
            }
            return
        }
        
        // Improved path similarity calculation
        let pathSimilarity = calculatePathSimilarity(userPoints: userPoints, refPoints: refPoints)
        let shapeSimilarity = calculateShapeSimilarity(userPoints: userPoints, refPoints: refPoints)
        let strokeOrderScore = calculateStrokeOrderScore()
        
        // More balanced scoring system
        let overallScore = (pathSimilarity * 0.5) + (shapeSimilarity * 0.3) + (strokeOrderScore * 0.2)
        
        // More reasonable threshold - 60% similarity required
        if overallScore > 0.6 {
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
    
    private func validateStrokeOrder() -> Bool {
        // Ensure user drew strokes in roughly the same order as reference
        guard completedPaths.count >= referenceStrokes.count else { return false }
        
        for i in 0..<min(completedPaths.count, referenceStrokes.count) {
            let userPath = completedPaths[i]
            let refStroke = referenceStrokes[i]
            
            // Get start and end points of user path
            var userStart: CGPoint?
            var userEnd: CGPoint?
            
            userPath.forEach { element in
                switch element {
                case .move(to: let pt):
                    if userStart == nil { userStart = pt }
                case .line(to: let pt):
                    userEnd = pt
                default: break
                }
            }
            
            // Get start and end points of reference stroke
            guard let refStart = refStroke.first, let refEnd = refStroke.last else { continue }
            let refStartPt = CGPoint(x: refStart.x * 120, y: refStart.y * 120)
            let refEndPt = CGPoint(x: refEnd.x * 120, y: refEnd.y * 120)
            
            // Check if user stroke starts and ends near reference stroke
            if let start = userStart, let end = userEnd {
                let startDist = distance(from: start, to: refStartPt)
                let endDist = distance(from: end, to: refEndPt)
                
                // Allow some flexibility but not too much
                if startDist > 25 || endDist > 25 {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func calculateShapeSimilarity(userPoints: [CGPoint], refPoints: [CGPoint]) -> Double {
        // Calculate how similar the overall shape is using bounding box and center of mass
        let userBounds = userPoints.reduce(CGRect.null) { $0.union(CGRect(origin: $1, size: .zero)) }
        let refBounds = refPoints.reduce(CGRect.null) { $0.union(CGRect(origin: $1, size: .zero)) }
        
        // Check aspect ratio similarity
        let userAspect = userBounds.width / userBounds.height
        let refAspect = refBounds.width / refBounds.height
        let aspectSimilarity = 1.0 - abs(userAspect - refAspect) / max(userAspect, refAspect)
        
        // Check center of mass similarity
        let userCenter = CGPoint(
            x: userPoints.map { $0.x }.reduce(0, +) / Double(userPoints.count),
            y: userPoints.map { $0.y }.reduce(0, +) / Double(userPoints.count)
        )
        let refCenter = CGPoint(
            x: refPoints.map { $0.x }.reduce(0, +) / Double(refPoints.count),
            y: refPoints.map { $0.y }.reduce(0, +) / Double(refPoints.count)
        )
        let centerDist = distance(from: userCenter, to: refCenter)
        let centerSimilarity = max(0, 1.0 - centerDist / 60) // Normalize by half canvas size
        
        return (aspectSimilarity + centerSimilarity) / 2.0
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
