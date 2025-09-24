import SwiftUI

struct AudioButton: View {
    @EnvironmentObject var session: AppSession
    let audioFile: String
    let size: CGFloat = 60 // Apple's recommended minimum touch target
    @State private var isPlaying = false
    @State private var showSlowPlayback = false
    
    var body: some View {
        EnhancedButton(
            interaction: .medium,
            isLoading: false,
            isEnabled: true,
            action: {
                isPlaying = true
                session.audioService.play(name: audioFile, rate: 1.0)
                session.hapticsService.success()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPlaying = false
                }
            },
            content: {
                ZStack {
                    Circle()
                        .fill(isPlaying ? .accentColor : Color(.systemBlue))
                        .frame(width: size, height: size)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                }
            }
        )
        .frame(minWidth: MTSpacing.comfortableTouchTarget, minHeight: MTSpacing.comfortableTouchTarget)
        .accessibilityLabel("Play audio")
        .accessibilityHint("Double tap to hear pronunciation. Long press for slow playback.")
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(isPlaying ? "Playing" : "Stopped")
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
    }
}
