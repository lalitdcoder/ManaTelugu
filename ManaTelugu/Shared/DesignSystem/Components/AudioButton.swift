import SwiftUI

struct AudioButton: View {
    @EnvironmentObject var session: AppSession
    let audioFile: String
    let word: String?
    let size: HIGButtonSize
    @State private var isPlaying = false
    @State private var showSlowPlayback = false
    @State private var isPressed = false
    
    init(
        audioFile: String,
        word: String? = nil,
        size: HIGButtonSize = .medium
    ) {
        self.audioFile = audioFile
        self.word = word
        self.size = size
    }
    
    var body: some View {
        Button(action: playAudio) {
            ZStack {
                Circle()
                    .fill(isPlaying ? MTColors.success : MTColors.primary)
                    .frame(width: size.frameSize, height: size.frameSize)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                    .foregroundColor(.white)
                    .font(.system(size: size.iconSize, weight: .medium))
                    .accessibilityHidden(true)
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(.easeInOut(duration: 0.2), value: isPlaying)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(isPlaying ? "Playing" : "Stopped")
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    playSlowAudio()
                }
        )
    }
    
    private var accessibilityLabel: String {
        if let word = word {
            return "Play audio for \(word)"
        } else {
            return "Play audio"
        }
    }
    
    private var accessibilityHint: String {
        "Double tap to hear pronunciation. Long press for slow playback."
    }
    
    private func playAudio() {
        guard !isPlaying else {
            stopAudio()
            return
        }
        
        isPlaying = true
        session.audioService.play(name: audioFile, rate: 1.0)
        session.hapticsService.lightImpact()
        
        // Announce for accessibility
        if let word = word {
            session.announceForAccessibility("Playing \(word)")
        }
        
        // Auto-stop after reasonable duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if isPlaying {
                stopAudio()
            }
        }
    }
    
    private func playSlowAudio() {
        guard !isPlaying else { return }
        
        showSlowPlayback = true
        session.audioService.play(name: audioFile, rate: 0.75)
        session.hapticsService.mediumImpact()
        
        // Announce for accessibility
        session.announceForAccessibility("Playing slowly")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            showSlowPlayback = false
        }
    }
    
    private func stopAudio() {
        isPlaying = false
        session.audioService.stop()
        session.announceForAccessibility("Audio stopped")
    }
}

// MARK: - Enhanced Audio Button with Visual Feedback
struct EnhancedAudioButton: View {
    @EnvironmentObject var session: AppSession
    let audioFile: String
    let word: String
    let showWaveform: Bool
    @State private var isPlaying = false
    @State private var waveformAnimation = false
    @State private var isPressed = false
    
    init(
        audioFile: String,
        word: String,
        showWaveform: Bool = true
    ) {
        self.audioFile = audioFile
        self.word = word
        self.showWaveform = showWaveform
    }
    
    var body: some View {
        HIGAccessibleButton(
            label: "Play audio for \(word)",
            hint: "Double tap to hear pronunciation. Long press for slow playback.",
            action: playAudio
        ) {
            HStack(spacing: MTSpacing.small) {
                ZStack {
                    Circle()
                        .fill(isPlaying ? MTColors.success : MTColors.primary)
                        .frame(width: MTSpacing.minimumTouchTarget, height: MTSpacing.minimumTouchTarget)
                    
                    Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                        .accessibilityHidden(true)
                }
                
                if showWaveform {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(MTColors.primary.opacity(0.6))
                                .frame(width: 3, height: waveformHeight(for: index))
                                .animation(
                                    .easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.1),
                                    value: waveformAnimation
                                )
                        }
                    }
                    .opacity(isPlaying ? 1 : 0.3)
                }
                
                HIGDynamicText(
                    word,
                    style: .body,
                    weight: .medium,
                    color: MTColors.primaryText
                )
            }
            .padding(.horizontal, MTSpacing.medium)
            .padding(.vertical, MTSpacing.small)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(MTColors.surface)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    playSlowAudio()
                }
        )
        .onAppear {
            waveformAnimation = true
        }
    }
    
    private func waveformHeight(for index: Int) -> CGFloat {
        let baseHeight: CGFloat = 8
        let maxHeight: CGFloat = 20
        let heights: [CGFloat] = [12, 20, 16, 18, 14]
        
        if isPlaying {
            return heights[index]
        } else {
            return baseHeight
        }
    }
    
    private func playAudio() {
        guard !isPlaying else {
            stopAudio()
            return
        }
        
        isPlaying = true
        session.audioService.play(name: audioFile, rate: 1.0)
        session.hapticsService.lightImpact()
        session.announceForAccessibility("Playing \(word)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if isPlaying {
                stopAudio()
            }
        }
    }
    
    private func playSlowAudio() {
        guard !isPlaying else { return }
        
        session.audioService.play(name: audioFile, rate: 0.75)
        session.hapticsService.mediumImpact()
        session.announceForAccessibility("Playing \(word) slowly")
    }
    
    private func stopAudio() {
        isPlaying = false
        session.audioService.stop()
        session.announceForAccessibility("Audio stopped")
    }
}
