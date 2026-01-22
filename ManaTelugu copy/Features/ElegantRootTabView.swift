import SwiftUI

struct ElegantRootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            // Modern background gradient
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)

            TabView(selection: $selectedTab) {
                // Home
                HomeView()
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        Text("Home")
                    }
                    .tag(0)

                // Learn
                NavigationStack {
                    ModernAlphabetView()
                }
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "textformat.abc" : "textformat.abc")
                    Text("Learn")
                }
                .tag(1)

                // Practice
                ModernGamesView()
                    .tabItem {
                        Image(
                            systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                        Text("Practice")
                    }
                    .tag(2)

                // More
                ModernMoreView()
                    .tabItem {
                        Image(
                            systemName: selectedTab == 3
                                ? "ellipsis.circle.fill" : "ellipsis.circle")
                        Text("More")
                    }
                    .tag(3)
            }
            .accentColor(ModernDesignSystem.Colors.primary)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color(.systemBackground), for: .tabBar)
            .toolbarColorScheme(nil, for: .tabBar)
            .onChange(of: selectedTab) {
                HapticFeedback.light()
            }
        }
    }
}

// MARK: - Modern Alphabet View
struct ModernAlphabetView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedMode: LearningMode = .vowels
    @State private var letters: [TeluguLetter] = []

    enum LearningMode: String, CaseIterable {
        case vowels = "Vowels"
        case consonants = "Consonants"
        case all = "All Letters"

        var icon: String {
            switch self {
            case .vowels: return "a.circle.fill"
            case .consonants: return "textformat.abc"
            case .all: return "character.book.closed.fill"
            }
        }

        var color: Color {
            switch self {
            case .vowels: return ModernDesignSystem.Colors.alphabet
            case .consonants: return ModernDesignSystem.Colors.lessons
            case .all: return ModernDesignSystem.Colors.games
            }
        }
    }

    var body: some View {
        ZStack {
            // Modern background gradient
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)

            ScrollView(showsIndicators: false) {
                VStack(spacing: ModernDesignSystem.Spacing.xl) {
                    // Hero Header with Liquid Glass
                    heroHeaderSection
                        .padding(.top, ModernDesignSystem.Spacing.xl)

                    // Alphabet Stats
                    alphabetStatsSection

                    // Learning Modes
                    learningModesSection

                }
                .padding(.horizontal, ModernDesignSystem.Spacing.md)
                .padding(.bottom, ModernDesignSystem.Spacing.xl)
            }
        }
        .navigationTitle("Telugu Alphabet")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadLetters()
        }
    }

    private var heroHeaderSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.lg) {
            Text("Telugu Alphabet")
                .font(ModernDesignSystem.Typography.title1)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Text("Master the beautiful Telugu script with interactive learning")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)

            HStack(spacing: ModernDesignSystem.Spacing.lg) {
                statCard("Vowels", "16", ModernDesignSystem.Colors.alphabet)
                statCard("Consonants", "36", ModernDesignSystem.Colors.lessons)
                statCard(
                    "Progress", "\(learnedCount)/\(letters.count)", ModernDesignSystem.Colors.games)
            }
        }
        .modernCard(hasLiquidGlass: true)
    }

    private var alphabetStatsSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Learning Progress")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            HStack(spacing: ModernDesignSystem.Spacing.md) {
                progressCard(
                    "Vowels Learned", vowelsLearnedCount, 16, ModernDesignSystem.Colors.alphabet)
                progressCard(
                    "Consonants Learned", consonantsLearnedCount, 36,
                    ModernDesignSystem.Colors.lessons)
            }
        }
    }

    private func progressCard(_ title: String, _ learned: Int, _ total: Int, _ color: Color)
        -> some View
    {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
            Text("\(learned)/\(total)")
                .font(ModernDesignSystem.Typography.title2)
                .foregroundColor(color)

            Text(title)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)

            ModernProgressBar(progress: Double(learned) / Double(max(total, 1)))
                .frame(height: 8)
        }
        .frame(maxWidth: .infinity)
        .modernCard()
    }

    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Learning Modes")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            VStack(spacing: ModernDesignSystem.Spacing.sm) {
                NavigationLink(destination: VowelsView()) {
                    learningModeCardContent(
                        "Learn Vowels", "a.circle.fill", "Master all 16 Telugu vowels",
                        ModernDesignSystem.Colors.alphabet)
                }
                .buttonStyle(HapticPlainButtonStyle())

                NavigationLink(destination: ConsonantsView()) {
                    learningModeCardContent(
                        "Learn Consonants", "textformat.abc", "Practice 36 Telugu consonants",
                        ModernDesignSystem.Colors.lessons)
                }
                .buttonStyle(HapticPlainButtonStyle())
                .disabled(false)
                .opacity(1.0)

                NavigationLink(destination: TraceGameView()) {
                    learningModeCardContent(
                        "Practice Writing", "scribble.variable", "Trace letters to improve writing",
                        ModernDesignSystem.Colors.games)
                }
                .buttonStyle(HapticPlainButtonStyle())
                .disabled(false)
                .opacity(1.0)

                NavigationLink(destination: LettersQuizView(scope: .all)) {
                    learningModeCardContent(
                        "Letter Quiz", "questionmark.circle.fill", "Test your alphabet knowledge",
                        ModernDesignSystem.Colors.alphabet)
                }
                .buttonStyle(HapticPlainButtonStyle())
                .disabled(false)
                .opacity(1.0)

            }
        }
    }

    private func learningModeCardContent(
        _ title: String, _ icon: String, _ description: String, _ color: Color
    ) -> some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                Text(title)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                Text(description)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.textTertiary)
        }
        .padding(ModernDesignSystem.Spacing.md)
        .modernCard()
    }

    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.xs) {
            Text(value)
                .font(ModernDesignSystem.Typography.title2)
                .foregroundColor(color)

            Text(title)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .modernCard()
    }

    // MARK: - Data Management
    private var filteredLetters: [TeluguLetter] {
        switch selectedMode {
        case .vowels:
            return letters.filter { $0.type == .vowel }
        case .consonants:
            return letters.filter { $0.type == .consonant }
        case .all:
            return letters
        }
    }

    private var learnedCount: Int {
        letters.filter { $0.isLearned }.count
    }

    private var vowelsLearnedCount: Int {
        letters.filter { $0.type == .vowel && $0.isLearned }.count
    }

    private var consonantsLearnedCount: Int {
        letters.filter { $0.type == .consonant && $0.isLearned }.count
    }

    private func loadLetters() {
        // Mock data - in real app this would come from the data service
        letters = mockTeluguLetters
    }

    // MARK: - Action Handlers
    private func handleLetterTap(_ letter: TeluguLetter) {
        // Navigate to letter detail view - implement navigation logic here
        print("Tapped letter: \(letter.character)")
    }
}

// MARK: - Legacy Elegant Alphabet View (for compatibility)
struct ElegantAlphabetView: View {
    @State private var selectedMode: LearningMode = .vowels
    @State private var letters: [TeluguLetter] = []

    enum LearningMode: String, CaseIterable {
        case vowels = "Vowels"
        case consonants = "Consonants"
        case all = "All Letters"

        var icon: String {
            switch self {
            case .vowels: return "a.circle.fill"
            case .consonants: return "textformat.abc"
            case .all: return "character.book.closed.fill"
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient
                    .ignoresSafeArea(.all, edges: .all)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ModernDesignSystem.Spacing.xl) {
                        // Hero Header
                        heroHeaderSection
                            .padding(.top, ModernDesignSystem.Spacing.xl)

                        // Alphabet Stats
                        alphabetStatsSection

                        // Learning Modes
                        learningModesSection

                        // Quick Access Letters
                        quickAccessSection
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.bottom, ModernDesignSystem.Spacing.xl)
                }
            }
            .navigationTitle("Telugu Alphabet")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadLetters()
        }
    }

    private var heroHeaderSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.lg) {
            Text("Telugu Alphabet")
                .font(ModernDesignSystem.Typography.title1)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Text("Master the beautiful Telugu script with interactive learning")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)

            HStack(spacing: ModernDesignSystem.Spacing.lg) {
                statCard("Vowels", "16", ModernDesignSystem.Colors.primary)
                statCard("Consonants", "36", ModernDesignSystem.Colors.secondary)
                statCard(
                    "Progress", "\(learnedCount)/\(letters.count)", ModernDesignSystem.Colors.accent
                )
            }
        }
        .elegantCard()
    }

    private var alphabetStatsSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Learning Progress")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            HStack(spacing: ModernDesignSystem.Spacing.md) {
                progressCard(
                    "Vowels Learned", vowelsLearnedCount, 16, ModernDesignSystem.Colors.primary)
                progressCard(
                    "Consonants Learned", consonantsLearnedCount, 36,
                    ModernDesignSystem.Colors.secondary)
            }
        }
    }

    private func progressCard(_ title: String, _ learned: Int, _ total: Int, _ color: Color)
        -> some View
    {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
            Text("\(learned)/\(total)")
                .font(ModernDesignSystem.Typography.title2)
                .foregroundColor(color)

            Text(title)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)

            ProgressView(value: Double(learned) / Double(max(total, 1)))
                .tint(color)
                .scaleEffect(y: 0.8)
        }
        .frame(maxWidth: .infinity)
        .elegantCard()
    }

    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Learning Modes")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            VStack(spacing: ModernDesignSystem.Spacing.sm) {
                NavigationLink(destination: VowelsView()) {
                    learningModeCardContent(
                        "Learn Vowels", "a.circle.fill", "Master all 16 Telugu vowels",
                        ModernDesignSystem.Colors.primary)
                }
                .buttonStyle(HapticPlainButtonStyle())

                NavigationLink(destination: ConsonantsView()) {
                    learningModeCardContent(
                        "Learn Consonants", "textformat.abc", "Practice 36 Telugu consonants",
                        ModernDesignSystem.Colors.secondary)
                }
                .buttonStyle(HapticPlainButtonStyle())

                NavigationLink(destination: TraceGameView()) {
                    learningModeCardContent(
                        "Practice Writing", "scribble.variable", "Trace letters to improve writing",
                        ModernDesignSystem.Colors.accent)
                }
                .buttonStyle(HapticPlainButtonStyle())

                Button(action: { hapticFeedback() }) {
                    learningModeCardContent(
                        "Letter Quiz", "questionmark.circle.fill", "Test your alphabet knowledge",
                        ModernDesignSystem.Colors.primary)
                }
                .buttonStyle(HapticPlainButtonStyle())
            }
        }
    }

    private func learningModeCardContent(
        _ title: String, _ icon: String, _ description: String, _ color: Color
    ) -> some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                Text(title)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                Text(description)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.textTertiary)
        }
        .padding(ModernDesignSystem.Spacing.md)
        .elegantCard()
    }

    private func hapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }

    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Quick Access")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.sm),
                    count: 6), spacing: ModernDesignSystem.Spacing.sm
            ) {
                ForEach(letters.prefix(12), id: \.character) { letter in
                    quickLetterCard(letter)
                }
            }
        }
    }

    private func quickLetterCard(_ letter: TeluguLetter) -> some View {
        Button(action: {
            // Navigate to letter detail view
            handleLetterTap(letter)
        }) {
            VStack(spacing: ModernDesignSystem.Spacing.xs) {
                Text(letter.character)
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .foregroundColor(ModernDesignSystem.Colors.primary)

                Circle()
                    .fill(
                        letter.isLearned
                            ? ModernDesignSystem.Colors.success
                            : ModernDesignSystem.Colors.textTertiary.opacity(0.3)
                    )
                    .frame(width: 6, height: 6)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .elegantCard()
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.xs) {
            Text(value)
                .font(ModernDesignSystem.Typography.title2)
                .foregroundColor(color)

            Text(title)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .elegantCard()
    }

    private var learningModeSelector: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Choose Learning Mode")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            // Segmented Control Style Selector
            HStack(spacing: ModernDesignSystem.Spacing.xs) {
                ForEach(LearningMode.allCases, id: \.self) { mode in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedMode = mode
                        }
                        loadLetters()
                    }) {
                        HStack(spacing: ModernDesignSystem.Spacing.xs) {
                            Image(systemName: mode.icon)
                                .font(.caption)

                            Text(mode.rawValue)
                                .font(ModernDesignSystem.Typography.callout)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(
                            selectedMode == mode ? .white : ModernDesignSystem.Colors.primary
                        )
                        .padding(.horizontal, ModernDesignSystem.Spacing.md)
                        .padding(.vertical, ModernDesignSystem.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
                                .fill(
                                    selectedMode == mode
                                        ? ModernDesignSystem.Colors.primary
                                        : ModernDesignSystem.Colors.primary.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.md)
                                .stroke(
                                    ModernDesignSystem.Colors.primary.opacity(
                                        selectedMode == mode ? 0 : 0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private var lettersGridSection: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.sm), count: 4),
            spacing: ModernDesignSystem.Spacing.sm
        ) {
            ForEach(filteredLetters, id: \.character) { letter in
                letterCard(letter)
            }
        }
    }

    private func letterCard(_ letter: TeluguLetter) -> some View {
        Button(action: {
            // Navigate to letter detail view
            handleLetterTap(letter)
        }) {
            VStack(spacing: ModernDesignSystem.Spacing.sm) {
                Text(letter.character)
                    .font(.system(size: 32, weight: .medium, design: .serif))
                    .foregroundColor(ModernDesignSystem.Colors.primary)

                // Progress indicator
                Circle()
                    .fill(
                        letter.isLearned
                            ? ModernDesignSystem.Colors.success
                            : ModernDesignSystem.Colors.textTertiary.opacity(0.3)
                    )
                    .frame(width: 8, height: 8)

                Text(letter.romanization)
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .elegantCard()
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Data Management
    private var filteredLetters: [TeluguLetter] {
        switch selectedMode {
        case .vowels:
            return letters.filter { $0.type == .vowel }
        case .consonants:
            return letters.filter { $0.type == .consonant }
        case .all:
            return letters
        }
    }

    private var learnedCount: Int {
        letters.filter { $0.isLearned }.count
    }

    private var vowelsLearnedCount: Int {
        letters.filter { $0.type == .vowel && $0.isLearned }.count
    }

    private var consonantsLearnedCount: Int {
        letters.filter { $0.type == .consonant && $0.isLearned }.count
    }

    private func loadLetters() {
        // Mock data - in real app this would come from the data service
        letters = mockTeluguLetters
    }

    // MARK: - Action Handlers
    private func handleLetterTap(_ letter: TeluguLetter) {
        hapticFeedback()
        // Navigate to letter detail view - implement navigation logic here
        print("Tapped letter: \(letter.character)")
    }
}

// MARK: - Telugu Letter Model
struct TeluguLetter {
    let character: String
    let romanization: String
    let type: LetterType
    let isLearned: Bool

    enum LetterType {
        case vowel, consonant
    }
}

// MARK: - Mock Data
private let mockTeluguLetters: [TeluguLetter] = [
    // Vowels
    TeluguLetter(character: "అ", romanization: "a", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఆ", romanization: "aa", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఇ", romanization: "i", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఈ", romanization: "ee", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఉ", romanization: "u", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఊ", romanization: "oo", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఋ", romanization: "ru", type: .vowel, isLearned: true),
    TeluguLetter(character: "ౠ", romanization: "ruu", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఌ", romanization: "lu", type: .vowel, isLearned: true),
    TeluguLetter(character: "ౡ", romanization: "luu", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఎ", romanization: "e", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఏ", romanization: "ae", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఐ", romanization: "ai", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఒ", romanization: "o", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఓ", romanization: "oa", type: .vowel, isLearned: true),
    TeluguLetter(character: "ఔ", romanization: "au", type: .vowel, isLearned: true),

    // Consonants (first 8 for demo)
    TeluguLetter(character: "క", romanization: "ka", type: .consonant, isLearned: true),
    TeluguLetter(character: "ఖ", romanization: "kha", type: .consonant, isLearned: true),
    TeluguLetter(character: "గ", romanization: "ga", type: .consonant, isLearned: true),
    TeluguLetter(character: "ఘ", romanization: "gha", type: .consonant, isLearned: true),
    TeluguLetter(character: "ఙ", romanization: "nga", type: .consonant, isLearned: true),
    TeluguLetter(character: "చ", romanization: "cha", type: .consonant, isLearned: true),
    TeluguLetter(character: "ఛ", romanization: "chha", type: .consonant, isLearned: true),
    TeluguLetter(character: "జ", romanization: "ja", type: .consonant, isLearned: true),
]

// MARK: - Modern Games View
struct ModernGamesView: View {
    @EnvironmentObject var session: AppSession

    var body: some View {
        NavigationStack {
            ZStack {
                // Modern background gradient
                ModernDesignSystem.Colors.backgroundGradient
                    .ignoresSafeArea(.all, edges: .all)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ModernDesignSystem.Spacing.xl) {
                        // Header Section with Liquid Glass
                        headerSection
                            .padding(.top, ModernDesignSystem.Spacing.xl)

                        // Games Section
                        gamesSection
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.bottom, ModernDesignSystem.Spacing.xl)
                }
            }
            .navigationTitle("Practice Games")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Practice Telugu through interactive games")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .modernCard(hasLiquidGlass: true)
    }

    private var gamesSection: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            NavigationLink(destination: SentenceBuilderGameView()) {
                gameCardContent(
                    "Sentence Builder", "text.bubble.fill",
                    "Arrange words to create perfect Telugu sentences",
                    ModernDesignSystem.Colors.alphabet, isCompleted: false, estimatedTime: "5 min")
            }

            NavigationLink(destination: ListeningChallengeGameView()) {
                gameCardContent(
                    "Listening Challenge", "ear.fill", "Listen and choose the correct meaning",
                    ModernDesignSystem.Colors.lessons, isCompleted: true, estimatedTime: "8 min")
            }

            NavigationLink(destination: CardMatchGameView()) {
                gameCardContent(
                    "Card Match", "arrow.left.arrow.right",
                    "Match Telugu words with English meanings", ModernDesignSystem.Colors.games,
                    isCompleted: false, estimatedTime: "6 min")
            }

            NavigationLink(destination: SoundMatchGameView()) {
                gameCardContent(
                    "Sound Match", "speaker.wave.2.fill", "Match sounds with their Telugu letters",
                    ModernDesignSystem.Colors.alphabet, isCompleted: false, estimatedTime: "7 min")
            }

            NavigationLink(destination: TraceGameView()) {
                gameCardContent(
                    "Trace Game", "scribble.variable", "Practice writing Telugu letters",
                    ModernDesignSystem.Colors.lessons, isCompleted: true, estimatedTime: "10 min")
            }
        }
    }

    private func gameCardContent(
        _ title: String, _ icon: String, _ description: String, _ color: Color, isCompleted: Bool,
        estimatedTime: String
    ) -> some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Spacer()

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(ModernDesignSystem.Colors.success)
                }
            }

            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                Text(title)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                Text(description)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)

                Text("Estimated time: \(estimatedTime)")
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textTertiary)
            }

            Spacer()
        }
        .frame(height: 120)
        .padding(ModernDesignSystem.Spacing.md)
        .modernCard()
    }
}

// MARK: - Legacy Elegant Games View (for compatibility)
struct ElegantGamesView: View {
    @EnvironmentObject var session: AppSession

    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient
                    .ignoresSafeArea(.all, edges: .all)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ModernDesignSystem.Spacing.xl) {
                        // Header Section
                        headerSection
                            .padding(.top, ModernDesignSystem.Spacing.xl)

                        // Games Section
                        gamesSection
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.bottom, ModernDesignSystem.Spacing.xl)
                }
            }
            .navigationTitle("Practice Games")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Practice Telugu through interactive games")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .elegantCard()
    }

    private var gamesSection: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            gameCard(
                "Sentence Builder", "text.bubble.fill",
                "Arrange words to create perfect Telugu sentences",
                ModernDesignSystem.Colors.primary, isCompleted: false, estimatedTime: "5 min")
            gameCard(
                "Listening Challenge", "ear.fill", "Listen and choose the correct meaning",
                ModernDesignSystem.Colors.secondary, isCompleted: true, estimatedTime: "8 min")
            gameCard(
                "Card Match", "arrow.left.arrow.right", "Match Telugu words with English meanings",
                ModernDesignSystem.Colors.accent, isCompleted: false, estimatedTime: "6 min")
            gameCard(
                "Sound Match", "speaker.wave.2.fill", "Match sounds with their Telugu letters",
                ModernDesignSystem.Colors.primary, isCompleted: false, estimatedTime: "7 min")
            gameCard(
                "Trace Game", "scribble.variable", "Practice writing Telugu letters",
                ModernDesignSystem.Colors.secondary, isCompleted: true, estimatedTime: "10 min")
        }
    }

    private func gameCard(
        _ title: String, _ icon: String, _ description: String, _ color: Color, isCompleted: Bool,
        estimatedTime: String
    ) -> some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Spacer()

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(ModernDesignSystem.Colors.success)
                }
            }

            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                Text(title)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                Text(description)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)

                Text("Estimated time: \(estimatedTime)")
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textTertiary)
            }

            Spacer()
        }
        .frame(height: 120)
        .padding(ModernDesignSystem.Spacing.md)
        .elegantCard()
    }
}

// MARK: - Modern More View
struct ModernMoreView: View {
    @EnvironmentObject var session: AppSession

    var body: some View {
        NavigationView {
            ZStack {
                // Modern background gradient
                ModernDesignSystem.Colors.backgroundGradient
                    .ignoresSafeArea(.all, edges: .all)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ModernDesignSystem.Spacing.xl) {
                        // Header Section with Liquid Glass
                        headerSection
                            .padding(.top, ModernDesignSystem.Spacing.xl)

                        // Main Sections
                        mainSectionsGrid

                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.bottom, ModernDesignSystem.Spacing.xl)
                }
            }
            .navigationTitle("More Options")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Manage your profile, settings, and get support")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .modernCard(hasLiquidGlass: true)
    }

    private var mainSectionsGrid: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.md), count: 2),
            spacing: ModernDesignSystem.Spacing.md
        ) {
            // Settings
            NavigationLink(destination: SettingsView()) {
                mainSectionCard(
                    "Settings", "gear.circle.fill", "App preferences",
                    ModernDesignSystem.Colors.alphabet)
            }
            .buttonStyle(PlainButtonStyle())
            .hapticOnTap(.light) {}

            // Progress
            NavigationLink(destination: ProgressDashboardView()) {
                mainSectionCard(
                    "Progress", "chart.bar.fill", "Learning stats",
                    ModernDesignSystem.Colors.lessons)
            }
            .buttonStyle(PlainButtonStyle())
            .hapticOnTap(.light) {}

            // Parent Mode
            NavigationLink(destination: ParentModeView()) {
                mainSectionCard(
                    "Parent Mode", "person.2.fill", "Parental controls",
                    ModernDesignSystem.Colors.games)
            }
            .buttonStyle(PlainButtonStyle())
            .hapticOnTap(.light) {}

            // Lessons
            NavigationLink(destination: ElegantLessonsView()) {
                mainSectionCard(
                    "Lessons", "book.fill", "Structured learning",
                    ModernDesignSystem.Colors.alphabet)
            }
            .buttonStyle(PlainButtonStyle())
            .hapticOnTap(.light) {}
        }
    }

    private func mainSectionCard(
        _ title: String, _ icon: String, _ description: String, _ color: Color
    ) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)

            VStack(spacing: ModernDesignSystem.Spacing.xs) {
                Text(title)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                Text(description)
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .modernCard()
    }

    private func menuRowContent(_ title: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)

            Text(title)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.textTertiary)
        }
        .padding(ModernDesignSystem.Spacing.md)
        .modernCard()
    }
}

// MARK: - Legacy Elegant More View (for compatibility)
struct ElegantMoreView: View {
    @EnvironmentObject var session: AppSession

    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient
                    .ignoresSafeArea(.all, edges: .all)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ModernDesignSystem.Spacing.xl) {
                        // Header Section
                        headerSection
                            .padding(.top, ModernDesignSystem.Spacing.xl)

                        // Main Sections
                        mainSectionsGrid

                        // Lessons Section
                        lessonsSection
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.bottom, ModernDesignSystem.Spacing.xl)
                }
            }
            .navigationTitle("More Options")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Manage your profile, settings, and get support")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .elegantCard()
    }

    private var mainSectionsGrid: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.md), count: 2),
            spacing: ModernDesignSystem.Spacing.md
        ) {
            // Settings
            NavigationLink(destination: SettingsView()) {
                mainSectionCard(
                    "Settings", "gear.circle.fill", "App preferences",
                    ModernDesignSystem.Colors.primary)
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture { hapticFeedback() }

            // Progress
            NavigationLink(destination: ProgressDashboardView()) {
                mainSectionCard(
                    "Progress", "chart.bar.fill", "Learning stats",
                    ModernDesignSystem.Colors.secondary)
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture { hapticFeedback() }

            // Parent Mode
            NavigationLink(destination: ParentModeView()) {
                mainSectionCard(
                    "Parent Mode", "person.2.fill", "Parental controls",
                    ModernDesignSystem.Colors.accent)
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture { hapticFeedback() }

            // Lessons
            NavigationLink(destination: ElegantLessonsView()) {
                mainSectionCard(
                    "Lessons", "book.fill", "Structured learning", ModernDesignSystem.Colors.primary
                )
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture { hapticFeedback() }
        }
    }

    private func mainSectionCard(
        _ title: String, _ icon: String, _ description: String, _ color: Color
    ) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)

            VStack(spacing: ModernDesignSystem.Spacing.xs) {
                Text(title)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)

                Text(description)
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .elegantCard()
    }

    private var lessonsSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Quick Access")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            VStack(spacing: ModernDesignSystem.Spacing.sm) {
                NavigationLink(destination: HelpSupportView()) {
                    menuRowContent(
                        "Help & Support", "questionmark.circle.fill",
                        ModernDesignSystem.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture { hapticFeedback() }

                Button(action: {
                    hapticFeedback()
                    rateApp()
                }) {
                    menuRowContent("Rate App", "star.fill", ModernDesignSystem.Colors.accent)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    hapticFeedback()
                    shareApp()
                }) {
                    menuRowContent(
                        "Share App", "square.and.arrow.up.fill", ModernDesignSystem.Colors.secondary
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private func rateApp() {
        if let url = URL(string: "https://apps.apple.com/app/id123456789") {
            UIApplication.shared.open(url)
        }
    }

    private func shareApp() {
        let activityVC = UIActivityViewController(
            activityItems: [
                "Check out Mana Telugu - Learn Telugu easily! https://apps.apple.com/app/id123456789"
            ],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }

    private func hapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }

    private func sectionHeader(_ title: String, _ subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
            Text(title)
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Text(subtitle)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
    }

    private func menuRow(
        _ title: String, _ icon: String, _ color: Color, action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            menuRowContent(title, icon, color)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func menuRowContent(_ title: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)

            Text(title)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.textTertiary)
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(ModernDesignSystem.Colors.surfaceSecondary)
        .cornerRadius(ModernDesignSystem.CornerRadius.md)
    }
}
