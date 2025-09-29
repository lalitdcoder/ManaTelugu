import SwiftUI

struct LetterDetailView: View {
    @EnvironmentObject var session: AppSession
    let letters: [Letter]
    let initialIndex: Int
    @State private var isPlaying = false
    @State private var isPressed = false
    @State private var isGlowing = false
    @Environment(\.dismiss) private var dismiss
    @State private var index: Int = 0
    @State private var didInit: Bool = false
    private var letter: Letter { letters[index] }
    private var hasNext: Bool { index + 1 < letters.count }
    
    var body: some View {
        ZStack {
            ElegantGradient()
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 0) {
                // Enhanced Liquid Glass Header
                VStack(spacing: 0) {
                    // Letter type indicator
                    HStack {
                        Text(letterTypeIndicator)
                            .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                            .foregroundColor(letterTypeColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(letterTypeColor.opacity(0.2))
                            )
                        
                        Spacer()
                        
                        // Letter counter
                        Text("\(index + 1) of \(letters.count)")
                            .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.secondaryText)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    // Main letter display with enhanced styling
                    ZStack {
                        // Glow effect behind letter
                        Text(letter.character)
                            .font(.system(size: 160, weight: .bold, design: .rounded))
                            .foregroundColor(letterTypeColor.opacity(0.3))
                            .blur(radius: 20)
                            .scaleEffect(1.1)
                        
                        // Main letter
                        Text(letter.character)
                            .font(.system(size: 140, weight: .bold, design: .rounded))
                            .foregroundColor(MTColors.text)
                            .scaleEffect(isGlowing ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: isGlowing)
                    }
                    .padding(.vertical, 20)
                }
                .background(
                    LinearGradient(
                        colors: [
                            letterTypeColor.opacity(0.15),
                            letterTypeColor.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .glassEffect(.prominent, shape: .rect(cornerRadius: 0))
                )
                
                // Main content
                EnhancedScrollView(bottomPadding: 100) {
                    VStack(spacing: 24) {
                        // Pronunciation Section
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "speaker.wave.2")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(letterTypeColor)
                                
                                Text("Pronunciation")
                                    .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                                    .foregroundColor(MTColors.text)
                                
                                Spacer()
                            }
                            
                            // Enhanced Play Button with Liquid Glass
                            Button(action: playAudio) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(letterTypeColor)
                                            .frame(width: 50, height: 50)
                                            .scaleEffect(isPlaying ? 1.1 : 1.0)
                                            .animation(.easeInOut(duration: 0.2), value: isPlaying)
                                        
                                        Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(isPlaying ? "Playing..." : "Tap to Play")
                                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                            .fontWeight(.semibold)
                                        
                                        Text(letter.romanization)
                                            .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                                            .foregroundColor(MTColors.secondaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    if isPlaying {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: letterTypeColor))
                                            .scaleEffect(0.8)
                                    }
                                }
                                .padding(20)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            letterTypeColor.opacity(0.15),
                                            letterTypeColor.opacity(0.08)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .glassEffect(.regular, shape: .rect(cornerRadius: 20))
                                )
                            }
                            .buttonStyle(.plain)
                            .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                                .onEnded { _ in
                                    session.audioService.play(name: letter.audioFileName ?? "default_audio", rate: 0.75)
                                }
                            )
                            
                            // Letter Information
                            VStack(spacing: 12) {
                                LetterInfoRow(title: "Transliteration", value: letter.romanization, color: letterTypeColor)
                                LetterInfoRow(title: "Name", value: letter.character, color: MTColors.funYellow)
                            }
                        }
                        .padding(24)
                        .background(
                            LinearGradient(
                                colors: [
                                    letterTypeColor.opacity(0.08),
                                    letterTypeColor.opacity(0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .glassEffect(.regular, shape: .rect(cornerRadius: 24))
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            
            // Fixed Bottom Navigation
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    // Previous button
                    if index > 0 {
                        Button(role: .none, action: previousLetter) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.system(size: 20, weight: .medium))
                                Text("Previous")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(MTColors.text)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                MTColors.secondaryText.opacity(0.1)
                                    .glassEffect(.subtle, shape: .rect(cornerRadius: 16))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Next/Done button
                    Button(role: .none, action: nextAction) {
                        HStack(spacing: 12) {
                            Text(hasNext ? "Next Letter" : "Done")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .fontWeight(.bold)
                            
                            Image(systemName: hasNext ? "arrow.right.circle.fill" : "checkmark.circle.fill")
                                .font(.system(size: 20, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [
                                    hasNext ? letterTypeColor : MTColors.funGreen,
                                    hasNext ? letterTypeColor.opacity(0.8) : MTColors.funGreen.opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .glassEffect(.regular, shape: .rect(cornerRadius: 20))
                        )
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    }
                    .buttonStyle(.plain)
                    .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isPressed = pressing
                        }
                    }, perform: {})
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .background(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.1),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .glassEffect(.prominent, shape: .rect(cornerRadius: 0))
                )
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !didInit {
                index = min(max(0, initialIndex), max(letters.count - 1, 0))
                didInit = true
            }
        }
    }
    
    // MARK: - Computed Properties
    private var letterTypeIndicator: String {
        let vowelGlyphs = ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః"]
        return vowelGlyphs.contains(letter.character) ? "Vowel (అచ్చు)" : "Consonant (హల్లు)"
    }
    
    private var letterTypeColor: Color {
        let vowelGlyphs = ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః"]
        return vowelGlyphs.contains(letter.character) ? MTColors.funBlue : MTColors.funGreen
    }
    
    // MARK: - Actions
    private func playAudio() {
        // Haptic feedback
        session.hapticsService.mediumImpact()
        
        // Glow effect
        withAnimation(.easeInOut(duration: 0.3)) {
            isGlowing = true
        }
        
        // Audio playback
        isPlaying = true
        session.audioService.play(name: letter.audioFileName ?? "", rate: 1.0)
        
        // Reset states
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isGlowing = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isPlaying = false
        }
    }
    
    private func nextAction() {
        session.hapticsService.lightImpact()
        if hasNext {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                index = min(index + 1, letters.count - 1)
            }
        } else {
            dismiss()
        }
    }
    
    private func previousLetter() {
        session.hapticsService.lightImpact()
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            index = max(index - 1, 0)
        }
    }
}

// MARK: - Letter Info Row Component
struct LetterInfoRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(MTTypography.caption(kidMode: false))
                .foregroundColor(MTColors.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(MTTypography.body(kidMode: false))
                .foregroundColor(MTColors.text)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(color.opacity(0.15))
                )
        }
    }
}
