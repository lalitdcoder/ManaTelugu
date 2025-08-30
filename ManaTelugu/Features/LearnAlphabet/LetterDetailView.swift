import SwiftUI

struct LetterDetailView: View {
    @EnvironmentObject var session: AppSession
    let letter: Letter
    @State private var currentLetter: Letter
    @State private var isPlaying = false
    
    init(letter: Letter) {
        self.letter = letter
        _currentLetter = State(initialValue: letter)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: MTSpacing.large) {
                // Letter glyph
                Text(currentLetter.glyph)
                    .font(.system(size: 120))
                    .foregroundColor(MTColors.text)
                
                // Stroke order visualization with glyph-outline fallback
                LetterStrokeContainer(letter: currentLetter)
                    .frame(height: 220)
                    .padding()
                    .background(MTColors.surfaceAlt)
                    .cornerRadius(16)
                
                // Letter info
                VStack(alignment: .leading, spacing: MTSpacing.medium) {
                    HStack {
                        Text("Pronunciation")
                            .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        
                        Spacer()
                        
                        Button(action: {
                            isPlaying = true
                            session.audioService.play(name: currentLetter.audioFile, rate: 1.0)
                            
                            // Simulate playback completion
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isPlaying = false
                            }
                        }) {
                            HStack {
                                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                                Text(isPlaying ? "Stop" : "Play Sound")
                            }
                            .padding(.horizontal, MTSpacing.medium)
                            .padding(.vertical, MTSpacing.small)
                            .background(MTColors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                        .buttonStyle(.plain)
                        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                session.audioService.play(name: currentLetter.audioFile, rate: 0.75)
                            }
                        )
                    }
                    
                    Text(currentLetter.transliteration)
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    
                    Text("Name: \(currentLetter.name)")
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
                .padding()
                .background(MTColors.surfaceAlt)
                .cornerRadius(16)
                .onAppear {
                    session.awardLetterView(letterId: currentLetter.id)
                }
                
                // Next letter controls
                HStack {
                    Spacer()
                    Button {
                        goToNextLetter()
                    } label: {
                        HStack(spacing: 8) {
                            Text("Next Letter")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            Image(systemName: "chevron.right")
                        }
                        .padding(.horizontal, MTSpacing.large)
                        .padding(.vertical, MTSpacing.medium)
                        .background(MTColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(24)
                    }
                }
                
                // Removed per-letter quiz. Use hub quizzes instead.
            }
            .padding()
        }
        .navigationTitle("Letter Detail")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct StrokeOrderView: View {
    let points: [[CGPointCodable]]
    @State private var strokeProgress: [CGFloat]
    
    init(points: [[CGPointCodable]]) {
        self.points = points
        self._strokeProgress = State(initialValue: Array(repeating: 0, count: max(points.count, 1)))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Reference path (light gray)
                ForEach(0..<points.count, id: \.self) { index in
                    makePath(for: points[index], in: geometry.size)
                        .stroke(MTColors.text.opacity(0.15), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                }
                
                // Animated stroke paths
                ForEach(0..<points.count, id: \.self) { index in
                    makePath(for: points[index], in: geometry.size)
                        .trim(from: 0, to: strokeProgress[index])
                        .stroke(MTColors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .onAppear {
                            // Sequentially animate each stroke
                            let delay = Double(index) * 0.75
                            withAnimation(.linear(duration: 0.7).delay(delay)) {
                                strokeProgress[index] = 1.0
                            }
                        }
                }
            }
        }
    }
    
    private func makePath(for stroke: [CGPointCodable], in size: CGSize) -> Path {
        var path = Path()
        // Fallback: if not enough points provided, draw a smooth S-curve so it isn't a straight line
        if stroke.count <= 2 {
            let start = CGPoint(x: size.width * 0.2, y: size.height * 0.25)
            let mid = CGPoint(x: size.width * 0.75, y: size.height * 0.45)
            let end = CGPoint(x: size.width * 0.4, y: size.height * 0.8)
            path.move(to: start)
            let c1 = CGPoint(x: size.width * 0.35, y: size.height * 0.05)
            let c2 = CGPoint(x: size.width * 0.6, y: size.height * 0.65)
            path.addCurve(to: mid, control1: c1, control2: c2)
            let c3 = CGPoint(x: size.width * 0.9, y: size.height * 0.25)
            let c4 = CGPoint(x: size.width * 0.2, y: size.height * 0.95)
            path.addCurve(to: end, control1: c3, control2: c4)
            return path
        }
        
        // Map normalized [0,1] points into view space
        let points = stroke.map { CGPoint(x: $0.x * size.width, y: $0.y * size.height) }
        
        path.move(to: points[0])
        
        // Use simple Catmull-Rom to Bezier conversion for smoothing
        for i in 0..<(points.count - 1) {
            let current = points[i]
            let next = points[i + 1]
            let previous = i > 0 ? points[i - 1] : current
            let following = i + 2 < points.count ? points[i + 2] : next
            let control1 = CGPoint(x: current.x + (next.x - previous.x) / 6.0, y: current.y + (next.y - previous.y) / 6.0)
            let control2 = CGPoint(x: next.x - (following.x - current.x) / 6.0, y: next.y - (following.y - current.y) / 6.0)
            path.addCurve(to: next, control1: control1, control2: control2)
        }
        
        return path
    }
}

// MARK: - Next letter logic
private extension LetterDetailView {
    func goToNextLetter() {
        // Pull ordered letters from repository and advance to the next one within same category if possible
        let all = session.dataRepository.letters()
        // Prefer to move through the same category ordering if available
        let vowels = ["అ","ఆ","ఇ","ఈ","ఉ","ఊ","ఋ","ౠ","ఎ","ఏ","ఐ","ఒ","ఓ","ఔ","అం","అః"]
        let consonants = ["క","ఖ","గ","ఘ","ఙ","చ","ఛ","జ","ఝ","ఞ","ట","ఠ","డ","ఢ","ణ","త","థ","ద","ధ","న","ప","ఫ","బ","భ","మ","య","ర","ల","వ","శ","ష","స","హ","ళ","క్ష","ఱ"]
        let category = vowels.contains(currentLetter.glyph) ? vowels : consonants
        let ordered = all.filter { category.contains($0.glyph) }.sorted { a, b in
            guard let ia = category.firstIndex(of: a.glyph), let ib = category.firstIndex(of: b.glyph) else { return false }
            return ia < ib
        }
        guard let idx = ordered.firstIndex(where: { $0.id == currentLetter.id }) else { return }
        let next = ordered[(idx + 1) % ordered.count]
        currentLetter = next
        session.awardLetterView(letterId: next.id)
    }
}

// MARK: - Glyph outline fallback using CoreText
import CoreText

private struct LetterStrokeContainer: View {
    let letter: Letter
    
    var body: some View {
        if hasUsableStrokes(letter.strokePathPoints) {
            StrokeOrderView(points: letter.strokePathPoints)
        } else {
            GlyphOutlineView(glyph: letter.glyph)
        }
    }
    
    private func hasUsableStrokes(_ strokes: [[CGPointCodable]]) -> Bool {
        let total = strokes.reduce(0) { $0 + $1.count }
        return !strokes.isEmpty && total > 3
    }
}

private struct GlyphOutlineView: View {
    let glyph: String
    @State private var progress: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let path = glyphPath(glyph: glyph, in: geometry.size)
            ZStack {
                path
                    .stroke(MTColors.text.opacity(0.15), lineWidth: 3)
                path
                    .trim(from: 0, to: progress)
                    .stroke(MTColors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .onAppear {
                        withAnimation(.linear(duration: 1.6)) {
                            progress = 1
                        }
                    }
            }
            // CoreText builds paths in a Y-up coordinate space; flip vertically for SwiftUI's Y-down
            .scaleEffect(y: -1, anchor: .center)
        }
    }
    
    private func glyphPath(glyph: String, in size: CGSize) -> Path {
        // Build path from glyph using CoreText
        let fontSize: CGFloat = min(size.width, size.height) * 0.8
        let ctFont = CTFontCreateWithName("Telugu Sangam MN" as CFString, fontSize, nil)
        let attr = [NSAttributedString.Key.font: ctFont] as CFDictionary
        let attributed = NSAttributedString(string: glyph, attributes: attr as? [NSAttributedString.Key: Any])
        let line = CTLineCreateWithAttributedString(attributed)
        let runs = CTLineGetGlyphRuns(line) as! [CTRun]
        let mutablePath = CGMutablePath()
        for run in runs {
            let runGlyphCount = CTRunGetGlyphCount(run)
            guard runGlyphCount > 0 else { continue }
            var glyphs = Array(repeating: CGGlyph(), count: runGlyphCount)
            var positions = Array(repeating: CGPoint.zero, count: runGlyphCount)
            CTRunGetGlyphs(run, CFRange(location: 0, length: 0), &glyphs)
            CTRunGetPositions(run, CFRange(location: 0, length: 0), &positions)
            let runAttributes = CTRunGetAttributes(run) as NSDictionary
            let runFont = runAttributes[kCTFontAttributeName as String] as! CTFont
            for (glyph, pos) in zip(glyphs, positions) {
                if let gp = CTFontCreatePathForGlyph(runFont, glyph, nil) {
                    var transform = CGAffineTransform(translationX: pos.x, y: pos.y)
                    mutablePath.addPath(gp, transform: transform)
                }
            }
        }
        // Center & scale to fit
        let path = mutablePath.copy() ?? CGMutablePath()
        let bounds = path.boundingBox
        let scale = 0.9 * min(size.width / bounds.width, size.height / bounds.height)
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: (size.width - bounds.width * scale) / 2 - bounds.minX * scale,
                                           y: (size.height - bounds.height * scale) / 2 - bounds.minY * scale)
        transform = transform.scaledBy(x: scale, y: scale)
        let fitted = CGMutablePath()
        fitted.addPath(path, transform: transform)
        return Path(fitted)
    }
}