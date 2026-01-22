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

    // Moved from body to properties
    private var currentLetter: Letter {
        letters[index]
    }
    private var hasNext: Bool {
        index + 1 < letters.count
    }

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 0) {
                // Enhanced Liquid Glass Header
                headerView

                // Main content
                EnhancedScrollView(bottomPadding: 100) {
                    mainContentView
                }
            }

            // Fixed Bottom Navigation
            bottomNavigationView
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
        .onAppear {
            if !didInit {
                index = min(max(0, initialIndex), max(letters.count - 1, 0))
                didInit = true
            }
        }
    }

    // MARK: - Computed Properties
    private func letterTypeIndicator(for letter: Letter) -> String {
        let vowelGlyphs = [
            "అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః",
        ]
        return vowelGlyphs.contains(letter.character) ? "Vowel (అచ్చు)" : "Consonant (హల్లు)"
    }

    private func letterTypeColor(for letter: Letter) -> Color {
        let vowelGlyphs = [
            "అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః",
        ]
        return vowelGlyphs.contains(letter.character)
            ? ModernDesignSystem.Colors.funBlue : ModernDesignSystem.Colors.funGreen
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var headerBackgroundGradient: some View {
        LinearGradient(
            colors: [
                letterTypeColor(for: currentLetter).opacity(0.15),
                letterTypeColor(for: currentLetter).opacity(0.08),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .background(
            ModernDesignSystem.Colors.cardBackground.opacity(0.3)
        )
    }

    private var playButtonBackgroundGradient: some View {
        LinearGradient(
            colors: [
                letterTypeColor(for: currentLetter).opacity(0.15),
                letterTypeColor(for: currentLetter).opacity(0.08),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .background(
            ModernDesignSystem.Colors.cardBackground.opacity(0.2)
        )
        .cornerRadius(20)
    }

    // MARK: - Subviews
    private var headerView: some View {
        VStack(spacing: 0) {
            // Letter type indicator
            HStack {
                Text(letterTypeIndicator(for: currentLetter))
                    .font(AppleHIGDesign.Typography.caption1)
                    .foregroundColor(letterTypeColor(for: currentLetter))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(letterTypeColor(for: currentLetter).opacity(0.2))
                    )

                Spacer()

                // Letter counter
                Text("\(index + 1) of \(letters.count)")
                    .font(AppleHIGDesign.Typography.caption1)
                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            // Main letter display with enhanced styling
            ZStack {
                // Glow effect behind letter
                Text(currentLetter.character)
                    .font(AppleHIGDesign.Typography.teluguLarge)
                    .foregroundColor(letterTypeColor(for: currentLetter).opacity(0.3))
                    .blur(radius: 20)
                    .scaleEffect(1.1)

                // Main letter
                Text(currentLetter.character)
                    .font(.system(size: 140, weight: .bold, design: .rounded))
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    .scaleEffect(isGlowing ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isGlowing)
            }
            .padding(.vertical, 20)
        }
        .background(headerBackgroundGradient)
    }

    private var mainContentView: some View {
        VStack(spacing: 24) {
            // Pronunciation Section
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "speaker.wave.2")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(letterTypeColor(for: currentLetter))

                    Text("Pronunciation")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                    Spacer()
                }

                // Enhanced Play Button with Liquid Glass
                Button(action: { playAudio(for: currentLetter) }) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(letterTypeColor(for: currentLetter))
                                .frame(width: 50, height: 50)
                                .scaleEffect(isPlaying ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: isPlaying)

                            Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(isPlaying ? "Playing..." : "Tap to Play")
                                .font(ModernDesignSystem.Typography.body)
                                .fontWeight(.semibold)

                            Text(currentLetter.romanization)
                                .font(ModernDesignSystem.Typography.caption)
                                .foregroundColor(
                                    ModernDesignSystem.Colors.secondaryText)
                        }

                        Spacer()

                        if isPlaying {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(
                                        tint: letterTypeColor(for: currentLetter))
                                )
                                .scaleEffect(0.8)
                        }
                    }
                    .padding(20)
                    .background(playButtonBackgroundGradient)
                }
                .buttonStyle(.plain)
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            session.audioService.play(
                                name: currentLetter.audioFileName?.isEmpty == false
                                    ? currentLetter.audioFileName!
                                    : "default_audio.mp3",
                                rate: 0.75)
                        }
                )

                // Letter Information
                VStack(spacing: 12) {
                    LetterInfoRow(
                        title: "Transliteration",
                        value: currentLetter.romanization,
                        color: letterTypeColor(for: currentLetter)
                    )
                }

                // Mark as Learned Toggle
                Toggle(
                    isOn: Binding(
                        get: {
                            session.dataRepository.getLetter(by: currentLetter.id)?
                                .isLearned
                                ?? currentLetter.isLearned
                        },
                        set: { newValue in
                            if newValue {
                                // Mark as learned and award XP
                                session.dataRepository.markLetterAsLearned(
                                    currentLetter.id)
                                session.gamificationService.awardLetterLearned(
                                    currentLetter.character)
                                session.updateProgress(xp: 15, letters: 1)
                                session.gamificationService.onActivityCompleted()
                                HapticsManager.shared.notification(.success)
                            } else {
                                // Handle unlearning
                                session.dataRepository.unmarkLetterAsLearned(
                                    currentLetter.id)
                                HapticsManager.shared.impact(.light)
                            }
                        }
                    )
                ) {
                    Text("Learned Letter")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                }
                .toggleStyle(
                    SwitchToggleStyle(tint: ModernDesignSystem.Colors.funGreen)
                )
                .padding()
                .background(
                    ModernDesignSystem.Colors.cardBackground.opacity(0.2)
                )
                .cornerRadius(16)
            }
            .padding(24)
            .background(
                LinearGradient(
                    colors: [
                        letterTypeColor(for: currentLetter).opacity(0.08),
                        letterTypeColor(for: currentLetter).opacity(0.03),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .background(
                    ModernDesignSystem.Colors.cardBackground.opacity(0.2)
                )
                .cornerRadius(24)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var bottomNavigationView: some View {
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
                                .font(ModernDesignSystem.Typography.body)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            ModernDesignSystem.Colors.cardBackground.opacity(0.1)
                        )
                        .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                }

                // Next/Done button
                Button(role: .none, action: nextAction) {
                    HStack(spacing: 12) {
                        Text(hasNext ? "Next Letter" : "Done")
                            .font(ModernDesignSystem.Typography.body)
                            .fontWeight(.bold)

                        Image(
                            systemName: hasNext
                                ? "arrow.right.circle.fill" : "checkmark.circle.fill"
                        )
                        .font(.system(size: 20, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [
                                hasNext
                                    ? letterTypeColor(for: currentLetter)
                                    : ModernDesignSystem.Colors.funGreen,
                                hasNext
                                    ? letterTypeColor(for: currentLetter).opacity(0.8)
                                    : ModernDesignSystem.Colors.funGreen.opacity(0.8),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .background(
                            ModernDesignSystem.Colors.cardBackground.opacity(0.2)
                        )
                        .cornerRadius(20)
                    )
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                }
                .buttonStyle(.plain)
                .onLongPressGesture(
                    minimumDuration: 0, maximumDistance: .infinity,
                    pressing: { pressing in
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
                        Color.clear,
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .background(
                    ModernDesignSystem.Colors.cardBackground.opacity(0.3)
                )
            )
        }
    }

    // MARK: - Actions
    private func playAudio(for letter: Letter) {
        // Haptic feedback
        HapticsManager.shared.impact(.medium)

        // Glow effect
        withAnimation(.easeInOut(duration: 0.3)) {
            isGlowing = true
        }

        // Audio playback
        isPlaying = true
        session.audioService.play(
            name: letter.audioFileName?.isEmpty == false
                ? letter.audioFileName! : "default_audio.mp3", rate: 1.0)

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
        HapticsManager.shared.impact(.light)
        if index + 1 < letters.count {
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
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)

            Spacer()

            Text(value)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(color.opacity(0.15))
                )
        }
    }
}
