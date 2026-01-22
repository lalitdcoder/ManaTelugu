import SwiftUI

/// Provides an interactive tracing canvas for users to practice Telugu character formation.
/// Shows a faint background character, records user strokes, and validates the drawing.
struct TracingCanvasView: View {
    // The Telugu character to display behind the tracing canvas.
    let targetCharacter: String
    // Reference strokes for validation (as arrays of points).
    let referenceStrokes: [[CGPointCodable]]
    // Signals to clear the canvas from parent view.
    @Binding var clearCanvas: Bool
    // Signals to validate the current tracing.
    @Binding var validate: Bool
    // Called when validation occurs, passing if tracing was correct.
    let onTracingComplete: (Bool) -> Void
    // Whether this is used in lessons (more lenient validation)
    let isLessonMode: Bool

    // Internal state: the path user is currently drawing.
    @State private var currentPath = Path()
    // All completed strokes for this attempt.
    @State private var completedPaths: [Path] = []
    // Tracks if user is currently tracing.
    @State private var isDrawing = false
    // Show/hide the clear button based on whether any drawing has occurred.
    @State private var showClearButton = false
    // Capture raw points for each stroke to enable validation without relying on Path internals.
    @State private var currentStrokePoints: [CGPoint] = []
    @State private var completedStrokePoints: [[CGPoint]] = []
    // Keep track of the canvas size for scaling reference points (which are normalized 0..1).
    @State private var canvasSize: CGSize = .zero

    // Get the current accessibility contrast from the environment.
    #if os(iOS) || os(macOS)
        private var accessibilityContrast: Bool { false }  // Placeholder: environment key unavailable on current SDK
    #else
        private var accessibilityContrast: AccessibilityContrast { .normal }
    #endif

    var body: some View {
        ZStack {
            // Faint, scalable Telugu character as tracing template with halo.
            Text(targetCharacter)
                .font(.system(size: 300, weight: .bold))
                .minimumScaleFactor(0.2)
                .foregroundColor(.blue.opacity(0.3))
                .background(
                    Text(targetCharacter)
                        .font(.system(size: 300, weight: .bold))
                        .minimumScaleFactor(0.2)
                        .foregroundColor(.blue.opacity(0.1))
                        .blur(radius: 12)
                )
                .allowsHitTesting(false)
                .accessibilityLabel("Tracing target: \(targetCharacter)")

            // Drawing area: renders completed and in-progress strokes.
            Canvas { context, size in
                let strokeColor: Color
                #if os(iOS) || os(macOS)
                    if #available(iOS 15.0, macOS 12.0, *) {
                        // Use accessibilityContrast from environment property
                        strokeColor = accessibilityContrast ? .black : .blue
                    } else {
                        strokeColor = .blue
                    }
                #else
                    strokeColor = .blue
                #endif

                for path in completedPaths {
                    context.stroke(
                        path,
                        with: .color(strokeColor),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round)
                    )
                }
                if !currentPath.isEmpty {
                    context.stroke(
                        currentPath,
                        with: .color(strokeColor),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round)
                    )
                }
                // Keep an updated canvas size for validation scaling.
                DispatchQueue.main.async {
                    if self.canvasSize != size { self.canvasSize = size }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDrawing {
                            isDrawing = true
                            currentPath = Path()
                            currentPath.move(to: value.location)
                            currentStrokePoints = [value.location]
                        } else {
                            currentPath.addLine(to: value.location)
                            currentStrokePoints.append(value.location)
                        }
                        showClearButton = true
                    }
                    .onEnded { _ in
                        isDrawing = false
                        completedPaths.append(currentPath)
                        currentPath = Path()
                        if !currentStrokePoints.isEmpty {
                            completedStrokePoints.append(currentStrokePoints)
                            currentStrokePoints.removeAll(keepingCapacity: false)
                        }
                    }
            )
            .accessibilityLabel("Tracing canvas for \(targetCharacter).")

            // Clear button appears after the user starts drawing.
            if showClearButton {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: resetCanvas) {
                            Label("Clear", systemImage: "gobackward")
                                .padding()
                        }
                        .accessibilityLabel("Clear tracing")
                    }
                    Spacer()
                }
                .padding()
            }
        }
        // Capture size using GeometryReader as a fallback (in case Canvas doesn't update size quickly).
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear { self.canvasSize = proxy.size }
                    .onChange(of: proxy.size) { _, newSize in
                        self.canvasSize = newSize
                    }
            }
        )
        // Validate and clear actions from parent.
        .onChange(of: clearCanvas) { _, shouldClear in
            if shouldClear { resetCanvas() }
        }
        .onChange(of: validate) { _, shouldValidate in
            if shouldValidate {
                validateTracing()
                validate = false
            }
        }
    }

    // Clears all strokes and resets the canvas.
    private func resetCanvas() {
        completedPaths.removeAll()
        currentPath = Path()
        showClearButton = false
        completedStrokePoints.removeAll()
        currentStrokePoints.removeAll()
    }

    // Compares the user's strokes to reference and calls the result callback.
    private func validateTracing() {
        guard !completedStrokePoints.isEmpty else {
            onTracingComplete(false)
            return
        }
        let size = canvasSize
        guard size.width > 0 && size.height > 0 else {
            onTracingComplete(false)
            return
        }

        // If no reference strokes (lessons mode), use basic validation
        if referenceStrokes.isEmpty {
            let success = validateBasicTracing()
            onTracingComplete(success)
            return
        }

        // Scale normalized reference strokes to canvas coordinates
        let refStrokesPixels: [[CGPoint]] = referenceStrokes.map { stroke in
            stroke.map { CGPoint(x: CGFloat($0.x) * size.width, y: CGFloat($0.y) * size.height) }
        }

        // Check for "one-corner cheating" - prevent scribbling in one spot
        if isOneCornerCheating(userStrokes: completedStrokePoints) {
            onTracingComplete(false)
            return
        }

        // Calculate validation scores
        let coverageScore = calculateCoverageScore(
            refStrokes: refStrokesPixels, userStrokes: completedStrokePoints, canvasSize: size)
        let similarityScore = calculateSimilarityScore(
            refStrokes: refStrokesPixels, userStrokes: completedStrokePoints)
        let completenessScore = calculateCompletenessScore(
            refStrokes: refStrokesPixels, userStrokes: completedStrokePoints, canvasSize: size)

        // Pass ONLY if ALL conditions are met
        // coverageScore: Precision (user stays within lines) - Low requirement
        // similarityScore: Shape matching - Low requirement
        // completenessScore: Recall (user covers enough of the letter) - High requirement to prevent incomplete traces
        let success = coverageScore >= 0.35 && similarityScore >= 0.35 && completenessScore >= 0.55
        onTracingComplete(success)
    }

    // Basic validation for lessons without reference strokes
    private func validateBasicTracing() -> Bool {
        // Check if user drew something reasonable
        guard !completedStrokePoints.isEmpty else { return false }

        // Check total stroke length - should be reasonable
        var totalLength: CGFloat = 0
        for stroke in completedStrokePoints {
            for i in 1..<stroke.count {
                let distance = hypot(stroke[i].x - stroke[i - 1].x, stroke[i].y - stroke[i - 1].y)
                totalLength += distance
            }
        }

        // Should have drawn at least 50 pixels worth of strokes
        guard totalLength >= 50 else { return false }

        // Check for scribbling in one spot
        if isOneCornerCheating(userStrokes: completedStrokePoints) {
            return false
        }

        // Check if strokes cover reasonable area
        let allPoints = completedStrokePoints.flatMap { $0 }
        guard !allPoints.isEmpty else { return false }

        let minX = allPoints.map { $0.x }.min() ?? 0
        let maxX = allPoints.map { $0.x }.max() ?? 0
        let minY = allPoints.map { $0.y }.min() ?? 0
        let maxY = allPoints.map { $0.y }.max() ?? 0

        let width = maxX - minX
        let height = maxY - minY

        // Should cover at least 30x30 pixel area
        return width >= 30 && height >= 30
    }

    // 1. Coverage Score: Check if user trace falls within stroke corridor
    private func calculateCoverageScore(
        refStrokes: [[CGPoint]], userStrokes: [[CGPoint]], canvasSize: CGSize
    ) -> Double {
        let haloWidth: CGFloat = 50  // Consistent large halo
        let corridorWidth: CGFloat = haloWidth * 1.0
        var totalUserPoints = 0
        var pointsInCorridor = 0

        for userStroke in userStrokes {
            for userPoint in userStroke {
                totalUserPoints += 1

                // Check if point is within corridor of any reference stroke
                var inCorridor = false
                for refStroke in refStrokes {
                    if isPointInStrokeCorridor(
                        point: userPoint, stroke: refStroke, corridorWidth: corridorWidth)
                    {
                        inCorridor = true
                        break
                    }
                }
                if inCorridor { pointsInCorridor += 1 }
            }
        }

        // Require 70% of points in corridor (was 55%)
        return totalUserPoints > 0 ? Double(pointsInCorridor) / Double(totalUserPoints) : 0.0
    }

    // 2. Similarity Score: Compare downsampled paths
    private func calculateSimilarityScore(refStrokes: [[CGPoint]], userStrokes: [[CGPoint]])
        -> Double
    {
        let sampleCount = 15  // Exact same downsample count for both modes
        let threshold: CGFloat = 35

        // Downsample both paths
        let refSampled = refStrokes.map { downsampleStroke($0, to: sampleCount) }
        let userSampled = userStrokes.map { downsampleStroke($0, to: sampleCount) }

        // Calculate average point-to-path distance
        var totalDistance: CGFloat = 0
        var pointCount = 0

        for userStroke in userSampled {
            for userPoint in userStroke {
                let minDistance =
                    refSampled.map { refStroke in
                        minDistanceToStroke(point: userPoint, stroke: refStroke)
                    }.min() ?? CGFloat.greatestFiniteMagnitude

                totalDistance += minDistance
                pointCount += 1
            }
        }

        let avgDistance =
            pointCount > 0 ? totalDistance / CGFloat(pointCount) : CGFloat.greatestFiniteMagnitude

        // Exact same similarity calculation for both modes
        if avgDistance <= threshold {
            return 1.0 - Double(avgDistance / threshold) * 0.6
        } else {
            return max(0.0, 0.4 - Double((avgDistance - threshold) / threshold) * 0.2)
        }
    }

    // 3. Completeness Score: Check how much of the reference shape is covered by user
    private func calculateCompletenessScore(
        refStrokes: [[CGPoint]], userStrokes: [[CGPoint]], canvasSize: CGSize
    ) -> Double {
        let haloWidth: CGFloat = 50  // Increased to 50 to match coverage score
        var totalRefSamples = 0
        var coveredRefSamples = 0

        // Sample reference strokes every 15 pixels
        let sampleStep: CGFloat = 15

        for refStroke in refStrokes {
            guard refStroke.count > 1 else { continue }

            // Walk along the stroke
            for i in 0..<refStroke.count - 1 {
                let start = refStroke[i]
                let end = refStroke[i + 1]
                let segmentLen = hypot(end.x - start.x, end.y - start.y)

                var currentPos: CGFloat = 0
                while currentPos < segmentLen {
                    let t = currentPos / segmentLen
                    let samplePoint = CGPoint(
                        x: start.x + (end.x - start.x) * t,
                        y: start.y + (end.y - start.y) * t
                    )

                    totalRefSamples += 1

                    // Check if this sample point is close to ANY user stroke
                    if isPointCoveredByUser(
                        point: samplePoint, userStrokes: userStrokes, threshold: haloWidth)
                    {
                        coveredRefSamples += 1
                    }

                    currentPos += sampleStep
                }
            }
            // Ensure we count the last point
            totalRefSamples += 1
            if let last = refStroke.last,
                isPointCoveredByUser(point: last, userStrokes: userStrokes, threshold: haloWidth)
            {
                coveredRefSamples += 1
            }
        }

        return totalRefSamples > 0 ? Double(coveredRefSamples) / Double(totalRefSamples) : 0.0
    }

    // Helper: Check if a reference point is covered by any user stroke
    private func isPointCoveredByUser(point: CGPoint, userStrokes: [[CGPoint]], threshold: CGFloat)
        -> Bool
    {
        for userStroke in userStrokes {
            if minDistanceToStroke(point: point, stroke: userStroke) <= threshold {
                return true
            }
        }
        return false
    }

    // 4. Prevent "one-corner cheating" - detect scribbling in one spot
    private func isOneCornerCheating(userStrokes: [[CGPoint]]) -> Bool {
        var allPoints: [CGPoint] = []
        for stroke in userStrokes {
            allPoints.append(contentsOf: stroke)
        }

        guard allPoints.count > 0 else { return false }

        let squareSize: CGFloat = 60
        let threshold = 0.3  // 30% of points

        // Check if 40% or more points fall in any 60x60 square
        for centerPoint in allPoints {
            let minX = centerPoint.x - squareSize / 2
            let maxX = centerPoint.x + squareSize / 2
            let minY = centerPoint.y - squareSize / 2
            let maxY = centerPoint.y + squareSize / 2

            let pointsInSquare = allPoints.filter { point in
                point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
            }.count

            if Double(pointsInSquare) / Double(allPoints.count) >= threshold {
                return true
            }
        }

        return false
    }

    // Helper: Check if point is within corridor of stroke
    private func isPointInStrokeCorridor(point: CGPoint, stroke: [CGPoint], corridorWidth: CGFloat)
        -> Bool
    {
        guard stroke.count > 1 else { return false }

        for i in 0..<stroke.count - 1 {
            let segmentStart = stroke[i]
            let segmentEnd = stroke[i + 1]
            let distance = distanceFromPointToLineSegment(
                point: point, lineStart: segmentStart, lineEnd: segmentEnd)
            if distance <= corridorWidth { return true }
        }
        return false
    }

    // Helper: Distance from point to line segment
    private func distanceFromPointToLineSegment(
        point: CGPoint, lineStart: CGPoint, lineEnd: CGPoint
    ) -> CGFloat {
        let A = point.x - lineStart.x
        let B = point.y - lineStart.y
        let C = lineEnd.x - lineStart.x
        let D = lineEnd.y - lineStart.y

        let dot = A * C + B * D
        let lenSq = C * C + D * D

        if lenSq == 0 { return hypot(A, B) }

        let param = dot / lenSq
        let clampedParam = max(0, min(1, param))

        let xx = lineStart.x + clampedParam * C
        let yy = lineStart.y + clampedParam * D

        return hypot(point.x - xx, point.y - yy)
    }

    // Helper: Downsample stroke to fixed number of points
    private func downsampleStroke(_ points: [CGPoint], to count: Int) -> [CGPoint] {
        guard points.count > 1, count > 1 else { return points }

        var result: [CGPoint] = []
        let step = Double(points.count - 1) / Double(count - 1)

        for i in 0..<count {
            let index = Int(Double(i) * step)
            let clampedIndex = min(index, points.count - 1)
            result.append(points[clampedIndex])
        }

        return result
    }

    // Helper: Minimum distance from point to stroke
    private func minDistanceToStroke(point: CGPoint, stroke: [CGPoint]) -> CGFloat {
        guard !stroke.isEmpty else { return CGFloat.greatestFiniteMagnitude }

        if stroke.count == 1 {
            let p = stroke[0]
            return hypot(point.x - p.x, point.y - p.y)
        }

        var minDist = CGFloat.greatestFiniteMagnitude
        for i in 0..<stroke.count - 1 {
            let dist = distanceFromPointToLineSegment(
                point: point, lineStart: stroke[i], lineEnd: stroke[i + 1])
            minDist = min(minDist, dist)
        }

        return minDist
    }
}
