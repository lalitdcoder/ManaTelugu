import SwiftUI

struct AudioButton: View {
    @EnvironmentObject var session: AppSession
    let audioFile: String
    let size: CGFloat = 60 // Apple's recommended minimum touch target
    @State private var isPlaying = false
    @State private var showSlowPlayback = false
    @State private var animate = false
    
    var body: some View {
        Button(action: {
            isPlaying = true
            animate = true
            session.audioService.play(name: audioFile, rate: 1.0)
            session.hapticsService.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isPlaying = false
                animate = false
            }
        }) {
            ZStack {
                Circle()
                    .fill(isPlaying ? .accentColor : Color(.systemBlue))
                    .frame(width: size, height: size)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .scaleEffect(animate ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: animate)
                Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .medium))
            }
        }
        .frame(minWidth: 44, minHeight: 44) // Apple's minimum touch target
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
            .onEnded { _ in
                showSlowPlayback = true
                session.audioService.play(name: audioFile, rate: 0.75)
                session.hapticsService.lightImpact()
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
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray))
                        .cornerRadius(6)
                        .offset(y: size * 0.7)
                }
            }
        )
        .accessibilityLabel("Play audio")
        .accessibilityHint("Double tap to play, long press for slow playback")
    }
}