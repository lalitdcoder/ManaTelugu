import SwiftUI

// MARK: - Native Alphabet Hub View (iOS HIG Compliant)
struct ProfessionalAlphabetHubView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var letters: [Letter] = []
    @State private var isLoading = true
    @State private var animateStats = false
    @State private var animateProgress = false
    @State private var heroLetterIndex = 0

    private let heroLetters = ["అ", "ఆ", "క", "గ", "చ", "జ", "ట", "డ", "ణ", "త", "ద", "న", "ప", "మ", "ర", "ల", "వ", "స"]

    var vowels: [Letter] { letters.filter { $0.category == .vowel } }
    var consonants: [Letter] { letters.filter { $0.category == .consonant } }
    var learnedCount: Int { session.learnedLetters }
    var progressPercentage: Double {
        letters.isEmpty ? 0 : Double(learnedCount) / Double(max(letters.count, 1))
    }

    var body: some View {
        ZStack {
            // Adaptive system background (Light and Dark mode)
            ManaTheme.Colors.groupedBackground
                .ignoresSafeArea()

            if isLoading {
                VStack(spacing: ManaTheme.Spacing.md) {
                    ProgressView()
                        .scaleEffect(1.3)
                        .tint(ManaTheme.Colors.primary)
                    Text("Loading Telugu script...")
                        .font(ManaTheme.Typography.subheadline)
                        .foregroundColor(ManaTheme.Colors.secondaryLabel)
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ManaTheme.Spacing.lg) {
                        // Hero Header Banner
                        alphabetHeroBanner

                        // Stats Row
                        statsRow

                        // Learning Progress Card
                        progressCard

                        // Learning Modes Grid
                        learningModesSection

                        Spacer().frame(height: 60)
                    }
                    .padding(.horizontal, ManaTheme.Spacing.screenMarginLarge)
                    .padding(.top, ManaTheme.Spacing.sm)
                }
                .scrollIndicators(.hidden)
            }
        }
        .onAppear {
            loadLetters()
            withAnimation(ManaTheme.Animation.smooth.delay(0.1)) {
                animateStats = true
            }
            withAnimation(ManaTheme.Animation.smooth.delay(0.2)) {
                animateProgress = true
            }
            startHeroLetterRotation()
        }
        .navigationTitle("Telugu Script")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero Banner
    private var alphabetHeroBanner: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card, style: .continuous)
                .fill(ManaTheme.Colors.peacockGradient)
                .shadow(color: ManaTheme.Colors.peacockBlue.opacity(0.25), radius: 10, x: 0, y: 5)

            // Large rotating letter watermark
            Text(heroLetters[heroLetterIndex % heroLetters.count])
                .font(.system(size: 150, weight: .bold))
                .foregroundColor(.white.opacity(0.12))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                .offset(x: 15, y: 20)
                .animation(ManaTheme.Animation.smooth, value: heroLetterIndex)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: ManaTheme.Spacing.sm) {
                Text("TELUGU ALPHABET • అక్షరమాల")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.2)
                    .foregroundColor(.white.opacity(0.80))

                Text("Master the Sounds of Telugu")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                HStack(spacing: ManaTheme.Spacing.md) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(vowels.count) Vowels")
                            .font(ManaTheme.Typography.subheadline.weight(.semibold))
                            .foregroundColor(.white)

                        Text("అచ్చులు (Achulu)")
                            .font(ManaTheme.Typography.caption2)
                            .foregroundColor(.white.opacity(0.75))
                    }

                    Divider()
                        .frame(height: 24)
                        .background(Color.white.opacity(0.3))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(consonants.count) Consonants")
                            .font(ManaTheme.Typography.subheadline.weight(.semibold))
                            .foregroundColor(.white)

                        Text("హల్లులు (Hallulu)")
                            .font(ManaTheme.Typography.caption2)
                            .foregroundColor(.white.opacity(0.75))
                    }
                }
            }
            .padding(ManaTheme.Spacing.xl)
        }
        .frame(minHeight: 170)
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: ManaTheme.Spacing.sm) {
            AlphabetStatChip(
                icon: "character.book.closed.fill",
                value: "\(letters.count)",
                label: "Total Letters",
                color: ManaTheme.Colors.peacockBlue
            )

            AlphabetStatChip(
                icon: "checkmark.seal.fill",
                value: "\(learnedCount)",
                label: "Learned",
                color: ManaTheme.Colors.emeraldGreen
            )

            AlphabetStatChip(
                icon: "sparkles",
                value: "\(Int(progressPercentage * 100))%",
                label: "Mastered",
                color: ManaTheme.Colors.primary
            )
        }
        .scaleEffect(animateStats ? 1.0 : 0.95)
        .opacity(animateStats ? 1.0 : 0)
    }

    // MARK: - Progress Card
    private var progressCard: some View {
        ManaCard(style: .elevated) {
            VStack(spacing: ManaTheme.Spacing.sm) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(ManaTheme.Colors.primary)

                        Text("Overall Script Mastery")
                            .font(ManaTheme.Typography.headline)
                            .foregroundColor(ManaTheme.Colors.label)
                    }

                    Spacer()

                    Text("\(learnedCount) / \(letters.count) Letters")
                        .font(ManaTheme.Typography.subheadline.weight(.bold))
                        .foregroundColor(ManaTheme.Colors.primary)
                }

                ManaProgressBar(progress: progressPercentage, color: ManaTheme.Colors.primary, height: 8)
            }
        }
        .scaleEffect(animateProgress ? 1.0 : 0.96)
        .opacity(animateProgress ? 1.0 : 0)
    }

    // MARK: - Learning Modes Section (Native NavigationLinks)
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ManaTheme.Spacing.md) {
            Text("Learning Modes")
                .font(ManaTheme.Typography.title3)
                .foregroundColor(ManaTheme.Colors.label)

            VStack(spacing: ManaTheme.Spacing.sm) {
                NavigationLink(destination: VowelsView()) {
                    AlphabetModeCard(
                        title: "Vowels • అచ్చులు",
                        subtitle: "Learn basic vowel sounds (16 letters)",
                        icon: "mouth.fill",
                        color: ManaTheme.Colors.peacockBlue,
                        badgeText: "Foundational"
                    )
                }
                .buttonStyle(NativeCardButtonStyle())

                NavigationLink(destination: ConsonantsView()) {
                    AlphabetModeCard(
                        title: "Consonants • హల్లులు",
                        subtitle: "Master consonant letters & sounds (36 letters)",
                        icon: "character.text.justify.left",
                        color: ManaTheme.Colors.emeraldGreen,
                        badgeText: "Core"
                    )
                }
                .buttonStyle(NativeCardButtonStyle())

                NavigationLink(destination: GudinthaluView()) {
                    AlphabetModeCard(
                        title: "Gudinthalu • గుణింతాలు",
                        subtitle: "Vowel-consonant combination signs",
                        icon: "text.line.first.and.arrow.triangle.forward",
                        color: ManaTheme.Colors.royalIndigo,
                        badgeText: "Intermediate"
                    )
                }
                .buttonStyle(NativeCardButtonStyle())

                NavigationLink(destination: TraceGameView()) {
                    AlphabetModeCard(
                        title: "Letter Tracing",
                        subtitle: "Practice writing Telugu character strokes",
                        icon: "pencil.and.outline",
                        color: ManaTheme.Colors.primary,
                        badgeText: "Interactive"
                    )
                }
                .buttonStyle(NativeCardButtonStyle())

                NavigationLink(destination: LettersQuizView(scope: .all)) {
                    AlphabetModeCard(
                        title: "Script Quiz",
                        subtitle: "Test your recognition of Telugu characters",
                        icon: "checkmark.bubble.fill",
                        color: ManaTheme.Colors.terracotta,
                        badgeText: "Practice"
                    )
                }
                .buttonStyle(NativeCardButtonStyle())
            }
        }
    }

    private func loadLetters() {
        letters = session.dataRepository.letters
        isLoading = false
    }

    private func startHeroLetterRotation() {
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            withAnimation(ManaTheme.Animation.smooth) {
                heroLetterIndex = (heroLetterIndex + 1) % heroLetters.count
            }
        }
    }
}

// MARK: - Alphabet Mode Card
struct AlphabetModeCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let badgeText: String

    var body: some View {
        ManaCard(style: .elevated) {
            HStack(spacing: ManaTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 48, height: 48)
                    .background(color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.md, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(title)
                            .font(ManaTheme.Typography.headline)
                            .foregroundColor(ManaTheme.Colors.label)

                        Spacer()

                        Text(badgeText)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(color.opacity(0.14))
                            .clipShape(Capsule())
                    }

                    Text(subtitle)
                        .font(ManaTheme.Typography.subheadline)
                        .foregroundColor(ManaTheme.Colors.secondaryLabel)
                        .lineLimit(2)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(ManaTheme.Colors.tertiaryLabel)
            }
        }
    }
}

// MARK: - Alphabet Stat Chip
struct AlphabetStatChip: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        ManaCard(style: .elevated, padding: ManaTheme.Spacing.sm) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)

                Text(value)
                    .font(ManaTheme.Typography.headline)
                    .foregroundColor(ManaTheme.Colors.label)

                Text(label)
                    .font(ManaTheme.Typography.caption2)
                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

typealias AlphabetHubView = ProfessionalAlphabetHubView
