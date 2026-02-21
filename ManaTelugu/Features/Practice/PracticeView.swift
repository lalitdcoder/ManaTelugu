import SwiftUI

struct PracticeView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var practiceItems: [PracticeItem] = []

    struct PracticeItem: Identifiable {
        let id = UUID()
        let telugu: String
        let transliteration: String
        let english: String
        let audioFile: String
        var difficulty: Difficulty = .unknown
    }

    enum Difficulty {
        case easy, medium, hard, unknown
    }

    var body: some View {
        NavigationStack {
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

                EnhancedScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Header - Apple-style with proper spacing
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Practice")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .accessibilityAddTraits(.isHeader)
                            Text("Sharpen your Telugu skills with targeted practice")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .accessibilityElement(children: .combine)

                        // Games Section - Apple-style section header
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: "gamecontroller.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                                Text("Interactive Games")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, ModernDesignSystem.Spacing.lg)

                            VStack(spacing: 12) {
                                PracticeSectionCard(
                                    title: "Vocabulary Match",
                                    icon: "rectangle.stack.fill",
                                    accent: ModernDesignSystem.Colors.funBlue,
                                    action: {},
                                    content: {
                                        Text("Match Telugu words with their English meanings.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(
                                        VocabularyCardsView(theme: "Animals").environmentObject(
                                            session))
                                )

                                PracticeSectionCard(
                                    title: "Sentence Builder",
                                    icon: "text.bubble.fill",
                                    accent: ModernDesignSystem.Colors.funGreen,
                                    action: {},
                                    content: {
                                        Text("Build Telugu sentences by arranging words correctly.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(
                                        SentenceBuilderGameView().environmentObject(session))
                                )

                                PracticeSectionCard(
                                    title: "Listening Challenge",
                                    icon: "ear.fill",
                                    accent: ModernDesignSystem.Colors.funPink,
                                    action: {},
                                    content: {
                                        Text("Listen to Telugu words and choose the right meaning.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(
                                        ListeningChallengeGameView().environmentObject(session))
                                )

                                PracticeSectionCard(
                                    title: "Sound Match",
                                    icon: "speaker.wave.2.fill",
                                    accent: ModernDesignSystem.Colors.funYellow,
                                    action: {},
                                    content: {
                                        Text(
                                            "Listen to the sound and pick the right letter or word."
                                        )
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(
                                        SoundMatchGameView().environmentObject(session))
                                )

                                PracticeSectionCard(
                                    title: "Card Match",
                                    icon: "arrow.left.arrow.right",
                                    accent: ModernDesignSystem.Colors.funBlue,
                                    action: {},
                                    content: {
                                        Text("Memory match game with Telugu letters.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(
                                        CardMatchGameView().environmentObject(session))
                                )

                                PracticeSectionCard(
                                    title: "Trace Letters",
                                    icon: "pencil.tip",
                                    accent: ModernDesignSystem.Colors.funGreen,
                                    action: {},
                                    content: {
                                        Text("Practice writing letters by tracing them.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(TraceGameView().environmentObject(session))
                                )

                            }
                            .padding(.horizontal, ModernDesignSystem.Spacing.lg)
                        }

                        // Quizzes Section - Apple-style section header
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                                Text("Knowledge Quizzes")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, ModernDesignSystem.Spacing.lg)

                            VStack(spacing: 12) {
                                PracticeSectionCard(
                                    title: "Vowels Quiz",
                                    icon: "textformat",
                                    accent: ModernDesignSystem.Colors.funYellow,
                                    action: {},
                                    content: {
                                        Text("Test your knowledge of Telugu vowels: అ ఆ ఇ ఈ...")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(
                                        LettersQuizView(scope: .vowels).environmentObject(session))
                                )

                                PracticeSectionCard(
                                    title: "Consonants Quiz",
                                    icon: "textformat.abc",
                                    accent: ModernDesignSystem.Colors.funBlue,
                                    action: {},
                                    content: {
                                        Text("Challenge yourself with consonants: క నుండి క్ష వరకు")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(
                                        LettersQuizView(scope: .consonants).environmentObject(
                                            session))
                                )

                                PracticeSectionCard(
                                    title: "Complete Letters Quiz",
                                    icon: "square.grid.2x2",
                                    accent: ModernDesignSystem.Colors.funGreen,
                                    action: {},
                                    content: {
                                        Text("Mixed practice with all Telugu letters.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(
                                        LettersQuizView(scope: .all).environmentObject(session))
                                )
                            }
                            .padding(.horizontal, ModernDesignSystem.Spacing.lg)
                        }

                    }
                    .padding(.vertical, ModernDesignSystem.Spacing.lg)
                }
            }
            .navigationTitle("Practice")
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
        .onAppear {
            loadPracticeItems()
        }
        .tabItem {
            Image(systemName: "book")
            Text("Practice")
        }
    }

    private func loadPracticeItems() {
        // Load a mix of letters and words for practice
        let letters = session.dataRepository.letters.prefix(5)
        let words = session.dataRepository.words.prefix(5)

        var items: [PracticeItem] = []

        for letter in letters {
            items.append(
                PracticeItem(
                    telugu: letter.character,
                    transliteration: letter.romanization,
                    english: letter.meaning,
                    audioFile: letter.audioFileName ?? ""
                ))
        }

        for word in words {
            items.append(
                PracticeItem(
                    telugu: word.telugu,
                    transliteration: word.transliteration,
                    english: word.english,
                    audioFile: word.audioFile
                ))
        }

        practiceItems = items
    }
}

// MARK: - Practice Section Card
struct PracticeSectionCard<Content: View>: View {
    let title: String
    let icon: String
    let accent: Color
    let action: () -> Void
    let content: () -> Content
    let destination: AnyView
    @EnvironmentObject var session: AppSession
    @State private var isPressed = false

    var body: some View {
        NavigationButton(
            destination: destination,
            hapticStyle: .medium,
            loadingMessage: "Loading practice..."
        ) {
            HStack(spacing: ModernDesignSystem.Spacing.md) {
                // Apple-style icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accent.opacity(0.1))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(accent)
                        .accessibilityHidden(true)  // Icon is decorative
                }

                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
                    (Text(title) as Text)
                        .font(ModernDesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)
                        .multilineTextAlignment(.leading)
                    content()
                }

                Spacer()

                // Apple-style chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ModernDesignSystem.Colors.tertiaryText)
                    .accessibilityHidden(true)  // Decorative indicator
            }
            .padding(.horizontal, ModernDesignSystem.Spacing.md)
            .padding(.vertical, ModernDesignSystem.Spacing.regular)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ModernDesignSystem.Colors.surfaceSecondary)
                    .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to start this practice activity")
    }
}

struct PracticeItemView: View {
    @EnvironmentObject var session: AppSession
    let item: PracticeView.PracticeItem
    @State private var showingOptions = false

    var body: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.sm) {
            (Text(item.telugu) as Text)
                .font(ModernDesignSystem.Typography.title1)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)

            Text(item.transliteration)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)

            if showingOptions {
                Text(item.english)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.primaryText)
                    .padding(.bottom, ModernDesignSystem.Spacing.sm)

                HStack(spacing: ModernDesignSystem.Spacing.md) {
                    EnhancedButton(
                        interaction: .medium,
                        isLoading: false,
                        isEnabled: true,
                        action: {
                            // Mark as hard
                            HapticsManager.shared.notification(.warning)
                        },
                        content: {
                            Text("Hard")
                                .font(ModernDesignSystem.Typography.caption)
                                .padding(.horizontal, ModernDesignSystem.Spacing.lg)
                                .padding(.vertical, ModernDesignSystem.Spacing.sm)
                                .background(ModernDesignSystem.Colors.warning)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    )
                    .frame(
                        minWidth: ModernDesignSystem.Spacing.minimumTouchTarget,
                        minHeight: ModernDesignSystem.Spacing.minimumTouchTarget
                    )
                    .accessibilityLabel("Mark as hard")
                    .accessibilityHint("This practice item was difficult")
                    .accessibilityAddTraits(.isButton)

                    EnhancedButton(
                        interaction: .medium,
                        isLoading: false,
                        isEnabled: true,
                        action: {
                            // Mark as medium
                            HapticsManager.shared.impact(.light)
                        },
                        content: {
                            Text("Okay")
                                .font(ModernDesignSystem.Typography.caption)
                                .padding(.horizontal, ModernDesignSystem.Spacing.lg)
                                .padding(.vertical, ModernDesignSystem.Spacing.sm)
                                .background(ModernDesignSystem.Colors.primary)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    )
                    .frame(
                        minWidth: ModernDesignSystem.Spacing.minimumTouchTarget,
                        minHeight: ModernDesignSystem.Spacing.minimumTouchTarget
                    )
                    .accessibilityLabel("Mark as okay")
                    .accessibilityHint("This practice item was moderately difficult")
                    .accessibilityAddTraits(.isButton)

                    EnhancedButton(
                        interaction: .medium,
                        isLoading: false,
                        isEnabled: true,
                        action: {
                            // Mark as easy
                            HapticsManager.shared.notification(.success)
                        },
                        content: {
                            Text("Easy")
                                .font(ModernDesignSystem.Typography.caption)
                                .padding(.horizontal, ModernDesignSystem.Spacing.lg)
                                .padding(.vertical, ModernDesignSystem.Spacing.sm)
                                .background(ModernDesignSystem.Colors.success)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    )
                    .frame(
                        minWidth: ModernDesignSystem.Spacing.minimumTouchTarget,
                        minHeight: ModernDesignSystem.Spacing.minimumTouchTarget
                    )
                    .accessibilityLabel("Mark as easy")
                    .accessibilityHint("This practice item was easy")
                    .accessibilityAddTraits(.isButton)
                }
            }
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(ModernDesignSystem.Colors.surfaceSecondary)
        .cornerRadius(12)
        .onTapGesture {
            withAnimation {
                showingOptions.toggle()
            }
        }
    }
}
