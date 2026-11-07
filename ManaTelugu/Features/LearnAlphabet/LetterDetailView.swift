import SwiftUI

struct LetterDetailView: View {
    @EnvironmentObject var session: AppSession
    let letters: [Letter]
    let initialIndex: Int
    @State private var isPlaying = false
    @State private var isGlowing = false
    @Environment(\.dismiss) private var dismiss
    @State private var index: Int = 0
    @State private var didInit: Bool = false

    private var currentLetter: Letter {
        guard index >= 0 && index < letters.count else { return letters[0] }
        return letters[index]
    }
    private var hasNext: Bool {
        index + 1 < letters.count
    }

    var body: some View {
        ZStack {
            ManaTheme.Colors.groupedBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header Display Card
                headerView

                // Main Content
                ScrollView(showsIndicators: false) {
                    mainContentView
                        .padding(.bottom, 100)
                }
            }

            // Fixed Bottom Navigation
            bottomNavigationView
        }
        .navigationTitle("Letter Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !didInit {
                index = min(max(0, initialIndex), max(letters.count - 1, 0))
                didInit = true
            }
        }
    }

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
            ? ManaTheme.Colors.peacockBlue : ManaTheme.Colors.emeraldGreen
    }

    // MARK: - Subviews
    private var headerView: some View {
        VStack(spacing: ManaTheme.Spacing.xs) {
            // Letter type & count header
            HStack {
                Text(letterTypeIndicator(for: currentLetter))
                    .font(ManaTheme.Typography.caption1.weight(.semibold))
                    .foregroundColor(letterTypeColor(for: currentLetter))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(letterTypeColor(for: currentLetter).opacity(0.15))
                    )

                Spacer()

                Text("\(index + 1) of \(letters.count)")
                    .font(ManaTheme.Typography.caption1.weight(.bold))
                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
            }
            .padding(.horizontal, ManaTheme.Spacing.screenMarginLarge)
            .padding(.top, ManaTheme.Spacing.sm)

            // Large Center Telugu Letter Display
            ZStack {
                Text(currentLetter.character)
                    .font(.system(size: 140, weight: .bold))
                    .foregroundColor(letterTypeColor(for: currentLetter).opacity(0.2))
                    .blur(radius: 20)
                    .scaleEffect(1.1)

                Text(currentLetter.character)
                    .font(.system(size: 120, weight: .bold))
                    .foregroundColor(ManaTheme.Colors.label)
                    .scaleEffect(isGlowing ? 1.06 : 1.0)
                    .animation(ManaTheme.Animation.smooth, value: isGlowing)
            }
            .padding(.vertical, ManaTheme.Spacing.md)
        }
        .background(ManaTheme.Colors.secondaryGroupedBackground)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(ManaTheme.Colors.separator),
            alignment: .bottom
        )
    }

    private var mainContentView: some View {
        VStack(spacing: ManaTheme.Spacing.lg) {
            // Pronunciation & Audio Section
            ManaCard(style: .elevated) {
                VStack(alignment: .leading, spacing: ManaTheme.Spacing.md) {
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(letterTypeColor(for: currentLetter))

                        Text("Pronunciation & Sound")
                            .font(ManaTheme.Typography.headline)
                            .foregroundColor(ManaTheme.Colors.label)

                        Spacer()
                    }

                    // Play Audio Button
                    Button(action: { playAudio(for: currentLetter) }) {
                        HStack(spacing: ManaTheme.Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(letterTypeColor(for: currentLetter))
                                    .frame(width: 48, height: 48)

                                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(isPlaying ? "Playing Sound..." : "Tap to Pronounce")
                                    .font(ManaTheme.Typography.bodyEmphasized)
                                    .foregroundColor(ManaTheme.Colors.label)

                                Text("Romanization: '\(currentLetter.romanization)'")
                                    .font(ManaTheme.Typography.caption1)
                                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
                            }

                            Spacer()

                            if isPlaying {
                                ProgressView()
                                    .tint(letterTypeColor(for: currentLetter))
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    Divider()

                    // Transliteration Row
                    HStack {
                        Text("English Transliteration")
                            .font(ManaTheme.Typography.subheadline)
                            .foregroundColor(ManaTheme.Colors.secondaryLabel)

                        Spacer()

                        Text(currentLetter.romanization)
                            .font(ManaTheme.Typography.bodyEmphasized)
                            .foregroundColor(letterTypeColor(for: currentLetter))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(letterTypeColor(for: currentLetter).opacity(0.12))
                            )
                    }

                    if !currentLetter.meaning.isEmpty {
                        HStack {
                            Text("Example Meaning")
                                .font(ManaTheme.Typography.subheadline)
                                .foregroundColor(ManaTheme.Colors.secondaryLabel)

                            Spacer()

                            Text(currentLetter.meaning)
                                .font(ManaTheme.Typography.body)
                                .foregroundColor(ManaTheme.Colors.label)
                        }
                    }
                }
            }

            // Learned Toggle Card
            ManaCard(style: .elevated) {
                Toggle(
                    isOn: Binding(
                        get: {
                            session.learnedLettersSet.contains(currentLetter.id)
                        },
                        set: { newValue in
                            if newValue {
                                session.dataRepository.markLetterAsLearned(currentLetter.id)
                                session.gamificationService.awardLetterLearned(currentLetter.character)
                                session.updateProgress(xp: 15, letters: 1)
                                session.gamificationService.onActivityCompleted()
                                ManaTheme.Haptics.success()
                            } else {
                                session.dataRepository.unmarkLetterAsLearned(currentLetter.id)
                                ManaTheme.Haptics.light()
                            }
                        }
                    )
                ) {
                    HStack(spacing: ManaTheme.Spacing.sm) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(ManaTheme.Colors.emeraldGreen)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Mark as Learned")
                                .font(ManaTheme.Typography.headline)
                                .foregroundColor(ManaTheme.Colors.label)

                            Text("Earn +15 XP and track script progress")
                                .font(ManaTheme.Typography.caption1)
                                .foregroundColor(ManaTheme.Colors.secondaryLabel)
                        }
                    }
                }
                .tint(ManaTheme.Colors.emeraldGreen)
            }
        }
        .padding(.horizontal, ManaTheme.Spacing.screenMarginLarge)
        .padding(.top, ManaTheme.Spacing.md)
    }

    private var bottomNavigationView: some View {
        VStack {
            Spacer()

            HStack(spacing: ManaTheme.Spacing.md) {
                if index > 0 {
                    Button(action: previousLetter) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Previous")
                        }
                        .font(ManaTheme.Typography.bodyEmphasized)
                        .foregroundColor(ManaTheme.Colors.label)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ManaTheme.Colors.secondaryGroupedBackground)
                        .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.button, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.button, style: .continuous)
                                .stroke(ManaTheme.Colors.separator.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }

                Button(action: nextAction) {
                    HStack(spacing: 6) {
                        Text(hasNext ? "Next Letter" : "Complete")
                        Image(systemName: hasNext ? "chevron.right" : "checkmark")
                    }
                    .font(ManaTheme.Typography.bodyEmphasized)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        hasNext ? letterTypeColor(for: currentLetter) : ManaTheme.Colors.emeraldGreen
                    )
                    .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.button, style: .continuous))
                    .shadow(
                        color: (hasNext ? letterTypeColor(for: currentLetter) : ManaTheme.Colors.emeraldGreen).opacity(0.3),
                        radius: 6, x: 0, y: 3
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, ManaTheme.Spacing.screenMarginLarge)
            .padding(.bottom, ManaTheme.Spacing.md)
        }
    }

    private func playAudio(for letter: Letter) {
        ManaTheme.Haptics.medium()

        withAnimation(ManaTheme.Animation.smooth) {
            isGlowing = true
        }

        isPlaying = true
        session.audioService.play(
            name: letter.audioFileName?.isEmpty == false ? letter.audioFileName! : "\(letter.character).mp3",
            rate: 1.0
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(ManaTheme.Animation.smooth) {
                isGlowing = false
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isPlaying = false
        }
    }

    private func nextAction() {
        ManaTheme.Haptics.light()
        if index + 1 < letters.count {
            withAnimation(ManaTheme.Animation.smooth) {
                index += 1
            }
        } else {
            dismiss()
        }
    }

    private func previousLetter() {
        ManaTheme.Haptics.light()
        withAnimation(ManaTheme.Animation.smooth) {
            index = max(index - 1, 0)
        }
    }
}
