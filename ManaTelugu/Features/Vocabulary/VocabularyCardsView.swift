import SwiftUI

struct VocabularyCardsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    let theme: String
    @State private var words: [Word] = []
    @State private var currentIndex = 0
    @State private var showingTranslation = true
    @State private var isPlaying = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var currentWord: Word? {
        guard currentIndex < words.count else { return nil }
        return words[currentIndex]
    }

    var body: some View {
        ZStack {
            // Stronger gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                // Theme header
                VStack(alignment: .leading, spacing: 8) {
                    Text(theme)
                        .font(ModernDesignSystem.Typography.title1)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    Text("\(currentIndex + 1) of \(words.count)")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.7))
                }
                .padding(.horizontal)

                if let word = currentWord {
                    // Word card - Made bigger and more prominent
                    VStack(spacing: 24) {
                        // Favorites Button
                        HStack {
                            Spacer()
                            Button(action: {
                                session.toggleFavorite(wordID: word.id)
                                HapticsService.shared.selection()
                            }) {
                                Image(
                                    systemName: session.isFavorite(wordID: word.id)
                                        ? "heart.fill" : "heart"
                                )
                                .font(.title2)
                                .foregroundColor(
                                    session.isFavorite(wordID: word.id)
                                        ? ModernDesignSystem.Colors.funPink : .gray
                                )
                                .padding(8)
                                .background(Material.thin)
                                .clipShape(Circle())
                            }
                            .padding(.top, -10)
                            .padding(.trailing, -10)
                        }

                        // Telugu word - Larger and more prominent
                        Text(word.telugu)
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 0)

                        // Transliteration
                        Text(word.transliteration)
                            .font(ModernDesignSystem.Typography.headline)
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary.opacity(0.8))
                            .multilineTextAlignment(.center)

                        // English meaning (conditionally shown)
                        if showingTranslation {
                            Text(word.english)
                                .font(ModernDesignSystem.Typography.body)
                                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ModernDesignSystem.Colors.funGreen.opacity(0.15))
                                )
                                .transition(.scale.combined(with: .opacity))
                        }

                        // Audio button - Updated to match new theme
                        // Audio button - Simplified
                        Text("🔊 Play Sound")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .onTapGesture {
                                HapticFeedback.medium()
                                alertMessage = "Audio button tapped! File: \(word.audioFile)"
                                showAlert = true
                                session.audioService.play(name: word.audioFile, rate: 1.0)
                            }
                            .frame(minWidth: 44, minHeight: 44)
                            .accessibilityLabel("Play audio for \(word.telugu)")
                            .accessibilityHint("Double tap to hear pronunciation")
                            .accessibilityAddTraits(.isButton)
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.5)
                                    .onEnded { _ in
                                        HapticFeedback.medium()
                                        session.audioService.play(name: word.audioFile, rate: 0.75)
                                    }
                            )
                    }
                    .padding(32)
                    .glassEffect(.regular, shape: .rect(cornerRadius: 24))
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        print("🖱️ Card tapped - toggling translation")
                        HapticFeedback.medium()
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showingTranslation.toggle()
                        }
                    }

                    // Navigation buttons - Simplified
                    HStack(spacing: 20) {
                        // Previous button
                        Text("⬅️ Previous")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(currentIndex > 0 ? Color.blue : Color.gray)
                            .cornerRadius(10)
                            .onTapGesture {
                                if currentIndex > 0 {
                                    moveToPreviousWord()
                                }
                            }

                        // Next button
                        Text("Next ➡️")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(currentIndex < words.count - 1 ? Color.green : Color.gray)
                            .cornerRadius(10)
                            .onTapGesture {
                                moveToNextWord()
                            }
                    }
                    .padding(.horizontal)
                } else {
                    Text("No words available for this theme")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                }

                if let word = currentWord {
                    Toggle(
                        isOn: Binding(
                            get: { return session.dataRepository.isWordLearned(word.telugu) },
                            set: { newValue in
                                if newValue {
                                    session.gamificationService.awardWordLearned(word.telugu)
                                    session.updateProgress(xp: 10, words: 1)
                                    HapticFeedback.success()
                                }
                            }
                        )
                    ) {
                        Text("Learned Word")
                            .font(.headline)
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: ModernDesignSystem.Colors.funGreen))
                    .padding()
                    .background(ModernDesignSystem.Colors.cardBackground.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }

                Spacer()
            }
            .padding(.vertical)
        }
        .alert("Audio Debug", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            print("🚀 VocabularyCardsView appeared for theme: \(theme)")
            Task {
                // Filter words by theme from the data repository
                words = session.dataRepository.words.filter { $0.theme == theme }
                print("Loading words for theme '\(theme)': found \(words.count) words")

                // Debug: Print all available themes
                let allThemes = Set(session.dataRepository.words.map { $0.theme })
                print("Available themes: \(allThemes)")

                if let firstWord = words.first {
                    print("First word: \(firstWord.telugu) - \(firstWord.audioFile)")
                }
            }
        }
        .navigationTitle(theme)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
    }

    private func moveToNextWord() {
        print("📱 moveToNextWord called - current: \(currentIndex), max: \(words.count - 1)")
        HapticFeedback.medium()

        // Award XP for the current word before moving
        if let word = currentWord {
            session.gamificationService.awardWordLearned(word.telugu)
            session.updateProgress(xp: 10, words: 1)
        }

        if currentIndex < words.count - 1 {
            currentIndex += 1
            showingTranslation = true
            print("✅ Moved to next word: \(currentIndex)")
        } else {
            // Reset to first word if at end
            currentIndex = 0
            showingTranslation = true
            print("🔄 Reset to first word")
        }
    }

    private func moveToPreviousWord() {
        print("📱 moveToPreviousWord called - current: \(currentIndex)")
        HapticFeedback.medium()
        if currentIndex > 0 {
            currentIndex -= 1
            showingTranslation = true
            print("✅ Moved to previous word: \(currentIndex)")
        }
    }
}
