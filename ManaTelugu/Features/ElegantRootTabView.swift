import SwiftUI

struct ElegantRootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home
            ElegantHomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            // Learn
            ElegantAlphabetView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "textformat.abc" : "textformat.abc")
                    Text("Learn")
                }
                .tag(1)
            
            // Practice
            ElegantGamesView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                    Text("Practice")
                }
                .tag(2)
            
            // More
            ElegantMoreView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "ellipsis.circle.fill" : "ellipsis.circle")
                    Text("More")
                }
                .tag(3)
        }
        .accentColor(ElegantDesign.Colors.primary)
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            appearance.shadowColor = UIColor.separator.withAlphaComponent(0.3)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - Elegant Alphabet View
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
                ElegantGradient()
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ElegantDesign.Spacing.xl) {
                        // Hero Header
                        heroHeaderSection
                            .padding(.top, ElegantDesign.Spacing.xl)
                        
                        // Alphabet Stats
                        alphabetStatsSection
                        
                        // Learning Modes
                        learningModesSection
                        
                        // Quick Access Letters
                        quickAccessSection
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
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
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.lg) {
            Text("Telugu Alphabet")
                .font(ElegantDesign.Typography.title1)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Text("Master the beautiful Telugu script with interactive learning")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
            
            HStack(spacing: ElegantDesign.Spacing.lg) {
                statCard("Vowels", "16", ElegantDesign.Colors.primary)
                statCard("Consonants", "36", ElegantDesign.Colors.secondary)
                statCard("Progress", "\(learnedCount)/\(letters.count)", ElegantDesign.Colors.accent)
            }
        }
        .elegantCard()
    }
    
    private var alphabetStatsSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Learning Progress")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            HStack(spacing: ElegantDesign.Spacing.md) {
                progressCard("Vowels Learned", vowelsLearnedCount, 16, ElegantDesign.Colors.primary)
                progressCard("Consonants Learned", consonantsLearnedCount, 36, ElegantDesign.Colors.secondary)
            }
        }
    }
    
    private func progressCard(_ title: String, _ learned: Int, _ total: Int, _ color: Color) -> some View {
        VStack(spacing: ElegantDesign.Spacing.sm) {
            Text("\(learned)/\(total)")
                .font(ElegantDesign.Typography.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(ElegantDesign.Typography.caption)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
            ProgressView(value: Double(learned) / Double(max(total, 1)))
                .tint(color)
                .scaleEffect(y: 0.8)
        }
        .frame(maxWidth: .infinity)
        .elegantCard()
    }
    
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Learning Modes")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            VStack(spacing: ElegantDesign.Spacing.sm) {
                NavigationLink(destination: VowelsView()) {
                    learningModeCardContent("Learn Vowels", "a.circle.fill", "Master all 16 Telugu vowels", ElegantDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture { hapticFeedback() }
                
                NavigationLink(destination: ConsonantsView()) {
                    learningModeCardContent("Learn Consonants", "textformat.abc", "Practice 36 Telugu consonants", ElegantDesign.Colors.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture { hapticFeedback() }
                
                NavigationLink(destination: TraceGameView()) {
                    learningModeCardContent("Practice Writing", "scribble.variable", "Trace letters to improve writing", ElegantDesign.Colors.accent)
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture { hapticFeedback() }
                
                Button(action: { hapticFeedback() }) {
                    learningModeCardContent("Letter Quiz", "questionmark.circle.fill", "Test your alphabet knowledge", ElegantDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func learningModeCardContent(_ title: String, _ icon: String, _ description: String, _ color: Color) -> some View {
        HStack(spacing: ElegantDesign.Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                Text(title)
                    .font(ElegantDesign.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                
                Text(description)
                    .font(ElegantDesign.Typography.body)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ElegantDesign.Colors.textTertiary)
        }
        .padding(ElegantDesign.Spacing.md)
        .elegantCard()
    }
    
    private func hapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Quick Access")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ElegantDesign.Spacing.sm), count: 6), spacing: ElegantDesign.Spacing.sm) {
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
            VStack(spacing: ElegantDesign.Spacing.xs) {
                Text(letter.character)
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .foregroundColor(ElegantDesign.Colors.primary)
                
                Circle()
                    .fill(letter.isLearned ? ElegantDesign.Colors.success : ElegantDesign.Colors.textTertiary.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .elegantCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: ElegantDesign.Spacing.xs) {
            Text(value)
                .font(ElegantDesign.Typography.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(ElegantDesign.Typography.caption)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .elegantCard()
    }
    
    private var learningModeSelector: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Choose Learning Mode")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            // Segmented Control Style Selector
            HStack(spacing: ElegantDesign.Spacing.xs) {
                ForEach(LearningMode.allCases, id: \.self) { mode in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedMode = mode
                        }
                        loadLetters()
                    }) {
                        HStack(spacing: ElegantDesign.Spacing.xs) {
                            Image(systemName: mode.icon)
                                .font(.caption)
                            
                            Text(mode.rawValue)
                                .font(ElegantDesign.Typography.callout)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(selectedMode == mode ? .white : ElegantDesign.Colors.primary)
                        .padding(.horizontal, ElegantDesign.Spacing.md)
                        .padding(.vertical, ElegantDesign.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                                .fill(selectedMode == mode ? ElegantDesign.Colors.primary : ElegantDesign.Colors.primary.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.md)
                                .stroke(ElegantDesign.Colors.primary.opacity(selectedMode == mode ? 0 : 0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var lettersGridSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ElegantDesign.Spacing.sm), count: 4), spacing: ElegantDesign.Spacing.sm) {
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
            VStack(spacing: ElegantDesign.Spacing.sm) {
                Text(letter.character)
                    .font(.system(size: 32, weight: .medium, design: .serif))
                    .foregroundColor(ElegantDesign.Colors.primary)
                
                // Progress indicator
                Circle()
                    .fill(letter.isLearned ? ElegantDesign.Colors.success : ElegantDesign.Colors.textTertiary.opacity(0.3))
                    .frame(width: 8, height: 8)
                
                Text(letter.romanization)
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
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
    TeluguLetter(character: "ఈ", romanization: "ee", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఉ", romanization: "u", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఊ", romanization: "oo", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఋ", romanization: "ru", type: .vowel, isLearned: false),
    TeluguLetter(character: "ౠ", romanization: "ruu", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఌ", romanization: "lu", type: .vowel, isLearned: false),
    TeluguLetter(character: "ౡ", romanization: "luu", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఎ", romanization: "e", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఏ", romanization: "ae", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఐ", romanization: "ai", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఒ", romanization: "o", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఓ", romanization: "oa", type: .vowel, isLearned: false),
    TeluguLetter(character: "ఔ", romanization: "au", type: .vowel, isLearned: false),
    
    // Consonants (first 8 for demo)
    TeluguLetter(character: "క", romanization: "ka", type: .consonant, isLearned: true),
    TeluguLetter(character: "ఖ", romanization: "kha", type: .consonant, isLearned: true),
    TeluguLetter(character: "గ", romanization: "ga", type: .consonant, isLearned: false),
    TeluguLetter(character: "ఘ", romanization: "gha", type: .consonant, isLearned: false),
    TeluguLetter(character: "ఙ", romanization: "nga", type: .consonant, isLearned: false),
    TeluguLetter(character: "చ", romanization: "cha", type: .consonant, isLearned: false),
    TeluguLetter(character: "ఛ", romanization: "chha", type: .consonant, isLearned: false),
    TeluguLetter(character: "జ", romanization: "ja", type: .consonant, isLearned: false)
]

// MARK: - Elegant Games View
struct ElegantGamesView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationView {
            ZStack {
                ElegantGradient()
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ElegantDesign.Spacing.xl) {
                        // Header Section
                        headerSection
                            .padding(.top, ElegantDesign.Spacing.xl)
                        
                        // Games Section
                        gamesSection
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
                }
            }
            .navigationTitle("Practice Games")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Practice Telugu through interactive games")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .elegantCard()
    }
    
    private var gamesSection: some View {
        VStack(spacing: ElegantDesign.Spacing.md) {
            gameCard("Sentence Builder", "text.bubble.fill", "Arrange words to create perfect Telugu sentences", ElegantDesign.Colors.primary, isCompleted: false, estimatedTime: "5 min")
            gameCard("Listening Challenge", "ear.fill", "Listen and choose the correct meaning", ElegantDesign.Colors.secondary, isCompleted: true, estimatedTime: "8 min")
            gameCard("Card Match", "arrow.left.arrow.right", "Match Telugu words with English meanings", ElegantDesign.Colors.accent, isCompleted: false, estimatedTime: "6 min")
            gameCard("Sound Match", "speaker.wave.2.fill", "Match sounds with their Telugu letters", ElegantDesign.Colors.primary, isCompleted: false, estimatedTime: "7 min")
            gameCard("Trace Game", "scribble.variable", "Practice writing Telugu letters", ElegantDesign.Colors.secondary, isCompleted: true, estimatedTime: "10 min")
        }
    }
    
    private func gameCard(_ title: String, _ icon: String, _ description: String, _ color: Color, isCompleted: Bool, estimatedTime: String) -> some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(ElegantDesign.Colors.success)
                }
            }
            
            VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                Text(title)
                    .font(ElegantDesign.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                
                Text(description)
                    .font(ElegantDesign.Typography.body)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
                
                Text("Estimated time: \(estimatedTime)")
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textTertiary)
            }
            
            Spacer()
        }
        .frame(height: 120)
        .padding(ElegantDesign.Spacing.md)
        .elegantCard()
    }
}

// MARK: - Elegant More View
struct ElegantMoreView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationView {
            ZStack {
                ElegantGradient()
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ElegantDesign.Spacing.xl) {
                        // Header Section
                        headerSection
                            .padding(.top, ElegantDesign.Spacing.xl)
                        
                        // Main Sections
                        mainSectionsGrid
                        
                        // Lessons Section
                        lessonsSection
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
                }
            }
            .navigationTitle("More Options")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Manage your profile, settings, and get support")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .elegantCard()
    }
    
    private var mainSectionsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ElegantDesign.Spacing.md), count: 2), spacing: ElegantDesign.Spacing.md) {
            // Settings
            NavigationLink(destination: SettingsView()) {
                mainSectionCard("Settings", "gear.circle.fill", "App preferences", ElegantDesign.Colors.primary)
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture { hapticFeedback() }
            
            // Progress
            NavigationLink(destination: ProgressDashboardView()) {
                mainSectionCard("Progress", "chart.bar.fill", "Learning stats", ElegantDesign.Colors.secondary)
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture { hapticFeedback() }
            
            // Parent Mode
            NavigationLink(destination: ParentModeView()) {
                mainSectionCard("Parent Mode", "person.2.fill", "Parental controls", ElegantDesign.Colors.accent)
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture { hapticFeedback() }
            
            // Lessons
            NavigationLink(destination: ElegantLessonsView()) {
                mainSectionCard("Lessons", "book.fill", "Structured learning", ElegantDesign.Colors.primary)
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture { hapticFeedback() }
        }
    }
    
    private func mainSectionCard(_ title: String, _ icon: String, _ description: String, _ color: Color) -> some View {
        VStack(spacing: ElegantDesign.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            VStack(spacing: ElegantDesign.Spacing.xs) {
                Text(title)
                    .font(ElegantDesign.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                
                Text(description)
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .elegantCard()
    }
    
    private var lessonsSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Quick Access")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            VStack(spacing: ElegantDesign.Spacing.sm) {
                NavigationLink(destination: HelpSupportView()) {
                    menuRowContent("Help & Support", "questionmark.circle.fill", ElegantDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture { hapticFeedback() }
                
                Button(action: { 
                    hapticFeedback()
                    rateApp() 
                }) {
                    menuRowContent("Rate App", "star.fill", ElegantDesign.Colors.accent)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { 
                    hapticFeedback()
                    shareApp() 
                }) {
                    menuRowContent("Share App", "square.and.arrow.up.fill", ElegantDesign.Colors.secondary)
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
            activityItems: ["Check out Mana Telugu - Learn Telugu easily! https://apps.apple.com/app/id123456789"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func hapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func sectionHeader(_ title: String, _ subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
            Text(title)
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Text(subtitle)
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
    }
    
    private func menuRow(_ title: String, _ icon: String, _ color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            menuRowContent(title, icon, color)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func menuRowContent(_ title: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: ElegantDesign.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ElegantDesign.Colors.textTertiary)
        }
        .padding(ElegantDesign.Spacing.md)
        .background(ElegantDesign.Colors.surfaceSecondary)
        .cornerRadius(ElegantDesign.CornerRadius.md)
    }
}
