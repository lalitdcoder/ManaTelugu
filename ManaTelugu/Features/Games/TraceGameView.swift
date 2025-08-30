import SwiftUI

struct TraceGameView: View {
    @EnvironmentObject var session: AppSession
    @State private var letters: [Letter] = []
    @State private var currentLetterIndex = 0
    @State private var path = Path()
    @State private var drawingPoints: [CGPoint] = []
    @State private var feedbackMessage: String?
    @State private var showSuccess = false
    
    var currentLetter: Letter? {
        guard currentLetterIndex < letters.count else { return nil }
        return letters[currentLetterIndex]
    }
    
    var body: some View {
        VStack(spacing: MTSpacing.large) {
            if let letter = currentLetter {
                header(for: letter)
                referenceGlyph(for: letter)
                drawingCanvas(for: letter)
                feedbackView
                controlBar
            } else {
                loadingView
            }
            Spacer()
        }
        .onAppear {
            loadData()
        }
        .navigationTitle("Trace Letters")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func loadData() {
        letters = session.dataRepository.letters().prefix(5).map { $0 }
    }
    
    private func updatePath() {
        path = Path { p in
            guard let firstPoint = drawingPoints.first else { return }
            p.move(to: firstPoint)
            
            for point in drawingPoints.dropFirst() {
                p.addLine(to: point)
            }
        }
    }
    
    private func checkDrawingAccuracy() {
        // Simple accuracy check - in a real app, this would use more sophisticated algorithms
        let accuracy = min(Double(drawingPoints.count) / 50.0, 1.0) // Simple proxy for accuracy
        
        if accuracy > 0.8 {
            feedbackMessage = "Great job! That looks like \(currentLetter?.glyph ?? "it")"
            showSuccess = true
            session.hapticsService.success()
        } else {
            feedbackMessage = "Keep practicing! Try to follow the lines more closely."
            showSuccess = false
            session.hapticsService.warning()
        }
    }
    
    private func clearDrawing() {
        path = Path()
        drawingPoints = []
        feedbackMessage = nil
    }
    
    private func moveToNextLetter() {
        if currentLetterIndex < letters.count - 1 {
            currentLetterIndex += 1
        } else {
            currentLetterIndex = 0
        }
        
        clearDrawing()
        feedbackMessage = nil
    }
}

// MARK: - Subviews split to help the type-checker
private extension TraceGameView {
    var loadingView: some View {
        Text("Loading...")
            .font(MTTypography.body())
            .foregroundColor(MTColors.text)
    }
    func header(for letter: Letter) -> some View {
        Text("Trace the letter: \(letter.glyph)")
            .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
            .foregroundColor(MTColors.text)
            .padding(.horizontal)
    }
    
    func referenceGlyph(for letter: Letter) -> some View {
        Text(letter.glyph)
            .font(.system(size: 60))
            .foregroundColor(MTColors.text.opacity(0.3))
    }
    
    var feedbackView: some View {
        Group {
            if let message = feedbackMessage {
                Text(message)
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .fontWeight(.bold)
                    .foregroundColor(showSuccess ? MTColors.success : MTColors.warning)
                    .padding()
                    .background(showSuccess ? MTColors.success.opacity(0.1) : MTColors.warning.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
    }
    
    var controlBar: some View {
        HStack {
            Button(action: clearDrawing) {
                Text("Clear")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(.white)
                    .padding(.horizontal, MTSpacing.large)
                    .padding(.vertical, MTSpacing.medium)
                    .background(MTColors.warning)
                    .cornerRadius(30)
            }
            Spacer()
            Button(action: moveToNextLetter) {
                Text("Next")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(.white)
                    .padding(.horizontal, MTSpacing.large)
                    .padding(.vertical, MTSpacing.medium)
                    .background(MTColors.primary)
                    .cornerRadius(30)
            }
        }
        .padding(.horizontal)
    }
    
    func drawingCanvas(for letter: Letter) -> some View {
        GeometryReader { geometry in
            ZStack {
                // Show the actual Telugu letter as a light background guide
                Text(letter.glyph)
                    .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.8))
                    .foregroundColor(MTColors.text.opacity(0.1))
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                path
                    .stroke(MTColors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                ColoredCanvas()
                    .gesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged { value in
                                drawingPoints.append(value.location)
                                updatePath()
                            }
                            .onEnded { _ in
                                checkDrawingAccuracy()
                            }
                    )
            }
        }
        .frame(height: 300)
        .background(MTColors.surfaceAlt)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Extracted reference strokes view
private struct TraceReferenceStrokes: View {
    let letter: Letter
    let size: CGSize
    
    var body: some View {
        Group {
            if !letter.strokePathPoints.isEmpty {
                ForEach(0..<letter.strokePathPoints.count, id: \.self) { index in
                    Path { path in
                        let pathPoints = letter.strokePathPoints[index]
                        guard let first = pathPoints.first else { return }
                        let startPoint = CGPoint(
                            x: first.x * size.width,
                            y: first.y * size.height
                        )
                        path.move(to: startPoint)
                        for pointCodable in pathPoints.dropFirst() {
                            let point = CGPoint(
                                x: pointCodable.x * size.width,
                                y: pointCodable.y * size.height
                            )
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.black.opacity(0.3), lineWidth: 2)
                }
            }
        }
    }
}

struct ColoredCanvas: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
