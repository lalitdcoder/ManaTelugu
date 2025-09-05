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
        ZStack {
            // Gentle pastel background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.97, green: 0.98, blue: 1.0), MTColors.funGreen.opacity(0.10), MTColors.funPink.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Theme header
                VStack(alignment: .leading, spacing: 8) {
                    Text(theme)
                        .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    Text("\(currentIndex + 1) of \(words.count)")
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
                .padding(.horizontal)
                
                if let word = currentWord {
                    // Word card - Made bigger and more prominent
                    VStack(spacing: 24) {
                        // Telugu word - Larger and more prominent
                        Text(word.telugu)
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundColor(MTColors.text)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                        
                        // Transliteration
                        Text(word.transliteration)
                            .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        // English meaning (conditionally shown)
                        if showingTranslation {
                            Text(word.english)
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(MTColors.funGreen.opacity(0.15))
                                )
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Audio button - Updated to match new theme
                        Button(action: {
                            isPlaying = true
                            session.hapticsService.lightImpact()
                            session.audioService.play(name: word.audioFile, rate: 1.0)
                            
                            // Simulate playback completion
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isPlaying = false
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                                    .font(.system(size: 20, weight: .medium))
                                Text(isPlaying ? "Stop" : "Play Sound")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(MTColors.funGreen)
                            )
                            .foregroundColor(.white)
                            .shadow(color: MTColors.funGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                session.audioService.play(name: word.audioFile, rate: 0.75)
                            }
                        )
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.95))
                            .shadow(color: MTColors.funGreen.opacity(0.15), radius: 16, x: 0, y: 8)
                    )
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showingTranslation.toggle()
                        }
                    }
                    
                    // Navigation buttons - Next/Previous instead of Easy/Hard/Okay
                    HStack(spacing: 20) {
                        // Previous button
                        Button(action: {
                            session.hapticsService.lightImpact()
                            moveToPreviousWord()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Previous")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(MTColors.funBlue.opacity(0.15))
                            )
                            .foregroundColor(MTColors.funBlue)
                        }
                        .buttonStyle(.plain)
                        .disabled(currentIndex == 0)
                        .opacity(currentIndex == 0 ? 0.5 : 1.0)
                        
                        // Next button
                        Button(action: {
                            session.hapticsService.lightImpact()
                            moveToNextWord()
                        }) {
                            HStack(spacing: 8) {
                                Text("Next")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .fontWeight(.medium)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(MTColors.funGreen)
                            )
                            .foregroundColor(.white)
                            .shadow(color: MTColors.funGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                } else {
                    Text("No words available for this theme")
                        .font(MTTypography.body())
                        .foregroundColor(MTColors.text)
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .onAppear {
            Task {
                words = await session.dataRepository.words(theme: theme)
                print("DEBUG: Loaded \(words.count) words for theme: \(theme)")
                if words.isEmpty {
                    print("DEBUG: No words loaded - using fallback test words")
                    // Fallback test words if data loading fails
                    words = [
                        Word(id: "test_1", telugu: "కుందేలు", transliteration: "Kundelu", english: "Rabbit", imageName: "rabbit.png", audioFile: "కుందేలు.mp3", theme: theme),
                        Word(id: "test_2", telugu: "మేక", transliteration: "Meka", english: "Goat", imageName: "goat.png", audioFile: "మేక.mp3", theme: theme),
                        Word(id: "test_3", telugu: "చిలుక", transliteration: "Chiluka", english: "Parrot", imageName: "parrot.png", audioFile: "చిలుక.mp3", theme: theme)
                    ]
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func moveToNextWord() {
        if currentIndex < words.count - 1 {
            currentIndex += 1
            showingTranslation = true
            // Award XP for learning a new word
            session.awardXP(3)
        } else {
            // Reset to first word if at end
            currentIndex = 0
            showingTranslation = true
            // Award XP for completing the vocabulary set
            session.awardXP(20)
        }
    }
    
    private func moveToPreviousWord() {
        if currentIndex > 0 {
            currentIndex -= 1
            showingTranslation = true
        }
    }
}
