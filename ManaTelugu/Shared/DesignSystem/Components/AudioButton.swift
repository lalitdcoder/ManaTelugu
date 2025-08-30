import SwiftUI

struct AudioButton: View {
    @EnvironmentObject var session: AppSession
    let audioFile: String
    let size: CGFloat = 50
    @State private var isPlaying = false
    @State private var showSlowPlayback = false
    
    var body: some View {
        Button(action: {
            isPlaying = true
            session.audioService.play(name: audioFile, rate: 1.0)
            
            // Simulate playback completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isPlaying = false
            }
        }) {
            ZStack {
                Circle()
                    .fill(MTColors.primary)
                    .frame(width: size, height: size)
                
                Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                    .foregroundColor(.white)
                    .font(.system(size: size * 0.4))
            }
        }
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
            .onEnded { _ in
                showSlowPlayback = true
                session.audioService.play(name: audioFile, rate: 0.75)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showSlowPlayback = false
                }
            }
        )
        .overlay(
            Group {
                if showSlowPlayback {
                    Text("Slow")
                        .font(.caption)
                        .foregroundColor(MTColors.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(MTColors.surface)
                        .cornerRadius(8)
                        .offset(y: size * 0.8)
                }
            }
        )
    }
}