import SwiftUI

struct LetterDetailView: View {
    @EnvironmentObject var session: AppSession
    let letter: Letter
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            // Gentle pastel background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.97, green: 0.98, blue: 1.0), MTColors.funBlue.opacity(0.10), MTColors.funYellow.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Letter glyph - Made even more prominent
                    Text(letter.glyph)
                        .font(.system(size: 140, weight: .bold, design: .rounded))
                        .foregroundColor(MTColors.text)
                        .padding(.top, 20)
                    
                    // Stroke order visualization
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Stroke Order")
                            .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        
                        StrokeOrderView(points: letter.strokePathPoints)
                            .frame(height: 200)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.95))
                            .shadow(color: MTColors.funBlue.opacity(0.15), radius: 12, x: 0, y: 6)
                    )
                    
                    // Letter info
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Pronunciation")
                                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text)
                            
                            Spacer()
                            
                            Button(action: {
                                isPlaying = true
                                session.hapticsService.lightImpact()
                                session.audioService.play(name: letter.audioFile, rate: 1.0)
                                
                                // Simulate playback completion
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    isPlaying = false
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                                        .font(.system(size: 18, weight: .medium))
                                    Text(isPlaying ? "Stop" : "Play Sound")
                                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(MTColors.funBlue)
                                )
                                .foregroundColor(.white)
                                .shadow(color: MTColors.funBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .buttonStyle(.plain)
                            .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                                .onEnded { _ in
                                    session.audioService.play(name: letter.audioFile, rate: 0.75)
                                }
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(letter.transliteration)
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(MTColors.funBlue.opacity(0.15))
                                )
                            
                            Text("Name: \(letter.name)")
                                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text.opacity(0.7))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(MTColors.funYellow.opacity(0.15))
                                )
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.95))
                            .shadow(color: MTColors.funBlue.opacity(0.15), radius: 12, x: 0, y: 6)
                    )
                    
                    // Quick quiz button - Updated styling
                    NavigationLink {
                        // Placeholder for quiz view
                        Text("Quiz View")
                            .navigationTitle("Quiz")
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 20, weight: .medium))
                            Text("Test Me")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(MTColors.funGreen)
                        )
                        .shadow(color: MTColors.funGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StrokeOrderView: View {
    let points: [[CGPointCodable]]
    @State private var progress: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                Path { path in
                    let gridSize: CGFloat = 20
                    for x in stride(from: 0, through: geometry.size.width, by: gridSize) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    }
                    for y in stride(from: 0, through: geometry.size.height, by: gridSize) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                }
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                
                // Draw stroke paths with proper scaling
                ForEach(Array(points.enumerated()), id: \.offset) { index, strokePoints in
                    Path { path in
                        guard !strokePoints.isEmpty else { return }
                        
                        // Scale normalized coordinates (0.0-1.0) to view size
                        let firstPoint = CGPoint(
                            x: strokePoints[0].x * geometry.size.width,
                            y: strokePoints[0].y * geometry.size.height
                        )
                        path.move(to: firstPoint)
                        
                        for point in strokePoints.dropFirst() {
                            let scaledPoint = CGPoint(
                                x: point.x * geometry.size.width,
                                y: point.y * geometry.size.height
                            )
                            path.addLine(to: scaledPoint)
                        }
                    }
                    .stroke(MTColors.funBlue, lineWidth: 3)
                    .opacity(index < Int(progress * CGFloat(points.count)) ? 1.0 : 0.0)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0)) {
                progress = 1.0
            }
        }
    }
}