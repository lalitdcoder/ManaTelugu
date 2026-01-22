import SwiftUI

// MARK: - Elegant Vocabulary View (Minimalistic)
struct ElegantVocabularyView: View {
    @EnvironmentObject var session: AppSession
    @State private var themes: [String] = []
    
    let allThemes = [
        "Numbers", "Colors", "Animals", "Family", "Food", 
        "School Objects", "Greetings", "Daily Actions", "Body Parts", "Weather"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xl) {
                        // Header
                        headerSection
                            .padding(.top, ModernDesignSystem.Spacing.xl)
                        
                        // Theme Grid
                        themeGridSection
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.bottom, ModernDesignSystem.Spacing.xl)
                }
            }
            .navigationTitle("Vocabulary")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            themes = allThemes
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
            Text("Explore different themes to expand your vocabulary")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
    }
    
    private var themeGridSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.md), count: 2), spacing: ModernDesignSystem.Spacing.md) {
            ForEach(themes, id: \.self) { theme in
                NavigationLink(destination: ElegantVocabularyCardsView(theme: theme)) {
                    themeCard(theme)
                }
.buttonStyle(HapticPlainButtonStyle())
            }
        }
    }
    
    private func themeCard(_ theme: String) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            // Icon
            Image(systemName: iconForTheme(theme))
                .font(.system(size: 32))
                .foregroundColor(colorForTheme(theme))
            
            // Title
            Text(theme)
                .font(ModernDesignSystem.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)
            
            // Progress indicator
            Text("\(wordsLearnedForTheme(theme))/\(totalWordsForTheme(theme))")
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .modernCard()
    }
    
    private func iconForTheme(_ theme: String) -> String {
        switch theme {
        case "Numbers": return "number.circle.fill"
        case "Colors": return "paintpalette.fill"
        case "Animals": return "pawprint.fill"
        case "Family": return "person.3.fill"
        case "Food": return "fork.knife"
        case "School Objects": return "backpack.fill"
        case "Greetings": return "hand.wave.fill"
        case "Daily Actions": return "figure.walk"
        case "Body Parts": return "figure.arms.open"
        case "Weather": return "cloud.sun.fill"
        default: return "book.fill"
        }
    }
    
    private func colorForTheme(_ theme: String) -> Color {
        let colors = [ModernDesignSystem.Colors.primary, ModernDesignSystem.Colors.secondary, ModernDesignSystem.Colors.accent]
        return colors[abs(theme.hashValue) % colors.count]
    }
    
    private func wordsLearnedForTheme(_ theme: String) -> Int {
        // Mock data - in real app would come from session
        return Int.random(in: 3...8)
    }
    
    private func totalWordsForTheme(_ theme: String) -> Int {
        return 10 // Standard 10 words per theme
    }
}

// MARK: - Elegant Vocabulary Cards View
struct ElegantVocabularyCardsView: View {
    let theme: String
    @State private var words: [VocabularyWord] = []
    
    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: ModernDesignSystem.Spacing.lg) {
                    // Progress header
                    progressHeader
                        .padding(.top, ModernDesignSystem.Spacing.xl)
                    
                    // Words list
                    wordsSection
                }
                .padding(.horizontal, ModernDesignSystem.Spacing.md)
                .padding(.bottom, ModernDesignSystem.Spacing.xl)
            }
        }
        .navigationTitle(theme)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadWordsForTheme()
        }
    }
    
    private var progressHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                Text("Progress")
                    .font(ModernDesignSystem.Typography.headline)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                
                Text("\(learnedCount)/\(words.count) words learned")
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            // Progress ring using built-in SwiftUI components
            ZStack {
                Circle()
                    .stroke(ModernDesignSystem.Colors.textTertiary.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: Double(learnedCount) / Double(max(words.count, 1)))
                    .stroke(ModernDesignSystem.Colors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: learnedCount)
                
                Text("\(Int((Double(learnedCount) / Double(max(words.count, 1))) * 100))%")
                    .font(ModernDesignSystem.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            }
        }
        .modernCard()
    }
    
    private var wordsSection: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            ForEach(words, id: \.telugu) { word in
                wordCard(word)
            }
        }
    }
    
    private func wordCard(_ word: VocabularyWord) -> some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            // Telugu word
            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                Text(word.telugu)
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .foregroundColor(ModernDesignSystem.Colors.primary)
                
                Text(word.pronunciation)
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textTertiary)
            }
            
            Spacer()
            
            // English translation
            VStack(alignment: .trailing, spacing: ModernDesignSystem.Spacing.xs) {
                Text(word.english)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                
                Circle()
                    .fill(word.isLearned ? ModernDesignSystem.Colors.success : ModernDesignSystem.Colors.textTertiary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(ModernDesignSystem.Spacing.md)
        .modernCard()
    }
    
    private var learnedCount: Int {
        words.filter { $0.isLearned }.count
    }
    
    private func loadWordsForTheme() {
        // Mock data based on theme
        words = mockWordsForTheme(theme)
    }
    
    private func mockWordsForTheme(_ theme: String) -> [VocabularyWord] {
        switch theme {
        case "Numbers":
            return [
                VocabularyWord(telugu: "ఒకటి", english: "One", pronunciation: "okati", isLearned: true),
                VocabularyWord(telugu: "రెండు", english: "Two", pronunciation: "rendu", isLearned: true),
                VocabularyWord(telugu: "మూడు", english: "Three", pronunciation: "moodu", isLearned: false),
                VocabularyWord(telugu: "నాలుగు", english: "Four", pronunciation: "naalugu", isLearned: false)
            ]
        case "Colors":
            return [
                VocabularyWord(telugu: "ఎరుపు", english: "Red", pronunciation: "erupu", isLearned: true),
                VocabularyWord(telugu: "నీలం", english: "Blue", pronunciation: "neelam", isLearned: false),
                VocabularyWord(telugu: "పచ్చ", english: "Green", pronunciation: "paccha", isLearned: false),
                VocabularyWord(telugu: "పసుపు", english: "Yellow", pronunciation: "pasupu", isLearned: false)
            ]
        default:
            return [
                VocabularyWord(telugu: "నమస్కారం", english: "Hello", pronunciation: "namaskaram", isLearned: true),
                VocabularyWord(telugu: "ధన్యవాదాలు", english: "Thank you", pronunciation: "dhanyavadalu", isLearned: false)
            ]
        }
    }
}

// MARK: - Elegant Stories View (Original Structure)
struct ElegantStoriesView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedCategory: StoryCategory? = nil
    @State private var searchText = ""
    @State private var stories: [ElegantStory] = []
    
    enum StoryCategory: String, CaseIterable {
        case folktales = "Folktales"
        case moral = "Moral Stories"
        case mythology = "Mythology"
        case modern = "Modern Tales"
        
        var icon: String {
            switch self {
            case .folktales: return "book.fill"
            case .moral: return "heart.fill"
            case .mythology: return "star.fill"
            case .modern: return "sparkles"
            }
        }
        
        var color: Color {
            switch self {
            case .folktales: return ModernDesignSystem.Colors.primary
            case .moral: return ModernDesignSystem.Colors.secondary
            case .mythology: return ModernDesignSystem.Colors.accent
            case .modern: return ModernDesignSystem.Colors.primary
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
                        
                        // Story Categories
                        categoriesSection
                        
                        // Featured Stories
                        featuredStoriesSection
                        
                        // All Stories
                        allStoriesSection
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.bottom, ModernDesignSystem.Spacing.xl)
                }
            }
            .navigationTitle("Telugu Stories")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadStories()
        }
    }
    
    private var heroHeaderSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.lg) {
            Text("Telugu Stories")
                .font(ModernDesignSystem.Typography.title1)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            Text("Discover the rich heritage of Telugu literature through engaging stories")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            
            HStack(spacing: ModernDesignSystem.Spacing.lg) {
                statCard("Stories", "\(stories.count)", ModernDesignSystem.Colors.primary)
                statCard("Completed", "\(completedCount)", ModernDesignSystem.Colors.secondary)
                statCard("Favorites", "\(favoritesCount)", ModernDesignSystem.Colors.accent)
            }
        }
        .modernCard()
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Story Categories")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.md), count: 2), spacing: ModernDesignSystem.Spacing.md) {
                ForEach(StoryCategory.allCases, id: \.self) { category in
                    categoryCard(category)
                }
            }
        }
    }
    
    private func categoryCard(_ category: StoryCategory) -> some View {
        Button(action: {
            selectedCategory = selectedCategory == category ? nil : category
        }) {
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(category.color)
                
                Text(category.rawValue)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("\(storiesCount(for: category)) stories")
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .modernCard()
            .overlay(
                RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.lg)
                    .stroke(selectedCategory == category ? category.color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var featuredStoriesSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Featured Stories")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            if let featuredStory = stories.first {
                featuredStoryCard(featuredStory)
            }
        }
    }
    
    private func featuredStoryCard(_ story: ElegantStory) -> some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                    Text(story.title)
                        .font(ModernDesignSystem.Typography.title3)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    
                    Text(story.titleTelugu)
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(ModernDesignSystem.Colors.primary)
                    
                    Text(story.description)
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: story.category.icon)
                    .font(.title)
                    .foregroundColor(story.category.color)
            }
            
            HStack {
                Text("Reading time: \(story.readingTime)")
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textTertiary)
                
                Spacer()
                
                if story.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ModernDesignSystem.Colors.success)
                }
                
                if story.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(ModernDesignSystem.Colors.accent)
                }
            }
        }
        .padding(ModernDesignSystem.Spacing.md)
        .modernCard()
    }
    
    private var allStoriesSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("All Stories")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            VStack(spacing: ModernDesignSystem.Spacing.sm) {
                ForEach(filteredStories, id: \.id) { story in
                    storyCard(story)
                }
            }
        }
    }
    
    private func storyCard(_ story: ElegantStory) -> some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: story.category.icon)
                .font(.title2)
                .foregroundColor(story.category.color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                Text(story.title)
                    .font(ModernDesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                
                Text(story.titleTelugu)
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .foregroundColor(ModernDesignSystem.Colors.primary)
                
                Text(story.description)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                
                Text("Reading time: \(story.readingTime)")
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textTertiary)
            }
            
            Spacer()
            
            VStack(spacing: ModernDesignSystem.Spacing.xs) {
                if story.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ModernDesignSystem.Colors.success)
                }
                
                if story.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(ModernDesignSystem.Colors.accent)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textTertiary)
            }
        }
        .padding(ModernDesignSystem.Spacing.md)
        .modernCard()
    }
    
    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.xs) {
            Text(value)
                .font(ModernDesignSystem.Typography.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Data Management
    private var filteredStories: [ElegantStory] {
        if let category = selectedCategory {
            return stories.filter { $0.category == category }
        }
        return stories
    }
    
    private var completedCount: Int {
        stories.filter { $0.isCompleted }.count
    }
    
    private var favoritesCount: Int {
        stories.filter { $0.isFavorite }.count
    }
    
    private func storiesCount(for category: StoryCategory) -> Int {
        stories.filter { $0.category == category }.count
    }
    
    private func loadStories() {
        stories = [
            ElegantStory(id: UUID(), title: "The Cat and the Mouse", titleTelugu: "పిల్లి మరియు ఎలుక", description: "A timeless Telugu folktale filled with wit and wisdom", category: .folktales, readingTime: "5 min", isCompleted: false, isFavorite: false),
            ElegantStory(id: UUID(), title: "The Wise Farmer", titleTelugu: "తెలివైన రైతు", description: "Learn about hard work and wisdom through this classic story", category: .moral, readingTime: "8 min", isCompleted: true, isFavorite: true),
            ElegantStory(id: UUID(), title: "The Magic Pot", titleTelugu: "మాయా కుండ", description: "A magical tale that teaches the value of sharing", category: .mythology, readingTime: "6 min", isCompleted: false, isFavorite: false),
            ElegantStory(id: UUID(), title: "The Clever Rabbit", titleTelugu: "తెలివైన కుందేలు", description: "A story about using intelligence over strength", category: .folktales, readingTime: "7 min", isCompleted: true, isFavorite: false),
            ElegantStory(id: UUID(), title: "The Golden Bird", titleTelugu: "బంగారు పక్షి", description: "An adventure story about courage and determination", category: .mythology, readingTime: "10 min", isCompleted: false, isFavorite: true)
        ]
    }
}

struct ElegantStory {
    let id: UUID
    let title: String
    let titleTelugu: String
    let description: String
    let category: ElegantStoriesView.StoryCategory
    let readingTime: String
    let isCompleted: Bool
    let isFavorite: Bool
}

// MARK: - Supporting Models
struct VocabularyWord {
    let telugu: String
    let english: String
    let pronunciation: String
    let isLearned: Bool
}

struct Story {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isCompleted: Bool
}
