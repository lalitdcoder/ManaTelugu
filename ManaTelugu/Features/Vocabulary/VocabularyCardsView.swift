import SwiftUI

struct VocabularyCardsView: View {
    @EnvironmentObject var session: AppSession
    let theme: String
    @State private var words: [Word] = []
    @State private var currentIndex = 0
    @State private var showingTranslation = true
    @State private var isPlaying = false
    
    var currentWord: Word? {
        guard currentIndex < words.count else { return nil }
        return words[currentIndex]
    }
    
    var body: some View {
        VStack(spacing: MTSpacing.large) {
            // Theme header
            Text(theme)
                .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            if let word = currentWord {
                // Word card
                VStack(spacing: MTSpacing.large) {
                    // Telugu word
                    Text(word.telugu)
                        .font(.system(size: 48))
                        .foregroundColor(MTColors.text)
                        .multilineTextAlignment(.center)
                    
                    // Transliteration
                    Text(word.transliteration)
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    // English meaning (always shown)
                    Text(word.english)
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, MTSpacing.large)
                        .padding(.vertical, MTSpacing.small)
                        .background(MTColors.primary)
                        .clipShape(Capsule())
                    
                    // Audio button
                    Button(action: {
                        isPlaying = true
                        session.audioService.play(name: word.audioFile, rate: 1.0)
                        
                        // Simulate playback completion
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isPlaying = false
                        }
                    }) {
                        HStack {
                            Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                            Text(isPlaying ? "Stop" : "Play Sound")
                        }
                        .padding(.horizontal, MTSpacing.large)
                        .padding(.vertical, MTSpacing.medium)
                        .background(MTColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            session.audioService.play(name: word.audioFile, rate: 0.75)
                        }
                    )
                }
                .padding()
                .background(MTColors.surfaceAlt)
                .cornerRadius(20)
                .frame(maxWidth: .infinity)
                // English is always visible; tap advances to next card for convenience
                .onTapGesture {
                    moveToNextWord()
                }
                
                // Navigation buttons
                HStack(spacing: MTSpacing.large) {
                    Button(action: {
                        session.hapticsService.lightImpact()
                        moveToPreviousWord()
                    }) {
                        VStack {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                            Text("Back")
                                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(MTColors.surfaceAlt)
                        .foregroundColor(MTColors.text)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        session.hapticsService.lightImpact()
                        moveToNextWord()
                    }) {
                        VStack {
                            Image(systemName: "arrow.right")
                                .font(.title2)
                            Text("Next")
                                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(MTColors.surfaceAlt)
                        .foregroundColor(MTColors.text)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("No words available for this theme")
                    .font(MTTypography.body())
                    .foregroundColor(MTColors.text)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            words = session.dataRepository.words(theme: theme)
        }
        .navigationTitle(theme)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func moveToNextWord() {
        if currentIndex < words.count - 1 {
            currentIndex += 1
        } else {
            // Reset to first word if at end
            currentIndex = 0
        }
    }

    private func moveToPreviousWord() {
        if currentIndex > 0 {
            currentIndex -= 1
        } else {
            // Wrap to last word if at start
            currentIndex = max(words.count - 1, 0)
        }
    }
}
