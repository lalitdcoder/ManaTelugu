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
                ElegantGradient()
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xl) {
                        // Header
                        headerSection
                            .padding(.top, ElegantDesign.Spacing.xl)
                        
                        // Theme Grid
                        themeGridSection
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
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
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
            Text("Explore different themes to expand your vocabulary")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
    }
    
    private var themeGridSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ElegantDesign.Spacing.md), count: 2), spacing: ElegantDesign.Spacing.md) {
            ForEach(themes, id: \.self) { theme in
                NavigationLink(destination: ElegantVocabularyCardsView(theme: theme)) {
                    themeCard(theme)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func themeCard(_ theme: String) -> some View {
        VStack(spacing: ElegantDesign.Spacing.md) {
            // Icon
            Image(systemName: iconForTheme(theme))
                .font(.system(size: 32))
                .foregroundColor(colorForTheme(theme))
            
            // Title
            Text(theme)
                .font(ElegantDesign.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
                .multilineTextAlignment(.center)
            
            // Progress indicator
            Text("\(wordsLearnedForTheme(theme))/\(totalWordsForTheme(theme))")
                .font(ElegantDesign.Typography.caption)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .elegantCard()
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
        let colors = [ElegantDesign.Colors.primary, ElegantDesign.Colors.secondary, ElegantDesign.Colors.accent]
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
            ElegantGradient()
                .ignoresSafeArea(.all, edges: .all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: ElegantDesign.Spacing.lg) {
                    // Progress header
                    progressHeader
                        .padding(.top, ElegantDesign.Spacing.xl)
                    
                    // Words list
                    wordsSection
                }
                .padding(.horizontal, ElegantDesign.Spacing.md)
                .padding(.bottom, ElegantDesign.Spacing.xl)
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
            VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                Text("Progress")
                    .font(ElegantDesign.Typography.headline)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                
                Text("\(learnedCount)/\(words.count) words learned")
                    .font(ElegantDesign.Typography.body)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
            }
            
            Spacer()
            
            // Progress ring using built-in SwiftUI components
            ZStack {
                Circle()
                    .stroke(ElegantDesign.Colors.textTertiary.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: Double(learnedCount) / Double(max(words.count, 1)))
                    .stroke(ElegantDesign.Colors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: learnedCount)
                
                Text("\(Int((Double(learnedCount) / Double(max(words.count, 1))) * 100))%")
                    .font(ElegantDesign.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
            }
        }
        .elegantCard()
    }
    
    private var wordsSection: some View {
        VStack(spacing: ElegantDesign.Spacing.md) {
            ForEach(words, id: \.telugu) { word in
                wordCard(word)
            }
        }
    }
    
    private func wordCard(_ word: VocabularyWord) -> some View {
        HStack(spacing: ElegantDesign.Spacing.md) {
            // Telugu word
            VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                Text(word.telugu)
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .foregroundColor(ElegantDesign.Colors.primary)
                
                Text(word.pronunciation)
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textTertiary)
            }
            
            Spacer()
            
            // English translation
            VStack(alignment: .trailing, spacing: ElegantDesign.Spacing.xs) {
                Text(word.english)
                    .font(ElegantDesign.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                
                Circle()
                    .fill(word.isLearned ? ElegantDesign.Colors.success : ElegantDesign.Colors.textTertiary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(ElegantDesign.Spacing.md)
        .elegantCard()
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
            case .folktales: return ElegantDesign.Colors.primary
            case .moral: return ElegantDesign.Colors.secondary
            case .mythology: return ElegantDesign.Colors.accent
            case .modern: return ElegantDesign.Colors.primary
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
                        
                        // Story Categories
                        categoriesSection
                        
                        // Featured Stories
                        featuredStoriesSection
                        
                        // All Stories
                        allStoriesSection
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
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
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.lg) {
            Text("Telugu Stories")
                .font(ElegantDesign.Typography.title1)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Text("Discover the rich heritage of Telugu literature through engaging stories")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
            
            HStack(spacing: ElegantDesign.Spacing.lg) {
                statCard("Stories", "\(stories.count)", ElegantDesign.Colors.primary)
                statCard("Completed", "\(completedCount)", ElegantDesign.Colors.secondary)
                statCard("Favorites", "\(favoritesCount)", ElegantDesign.Colors.accent)
            }
        }
        .elegantCard()
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Story Categories")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ElegantDesign.Spacing.md), count: 2), spacing: ElegantDesign.Spacing.md) {
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
            VStack(spacing: ElegantDesign.Spacing.md) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(category.color)
                
                Text(category.rawValue)
                    .font(ElegantDesign.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("\(storiesCount(for: category)) stories")
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .elegantCard()
            .overlay(
                RoundedRectangle(cornerRadius: ElegantDesign.CornerRadius.lg)
                    .stroke(selectedCategory == category ? category.color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var featuredStoriesSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Featured Stories")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            if let featuredStory = stories.first {
                featuredStoryCard(featuredStory)
            }
        }
    }
    
    private func featuredStoryCard(_ story: ElegantStory) -> some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                    Text(story.title)
                        .font(ElegantDesign.Typography.title3)
                        .foregroundColor(ElegantDesign.Colors.textPrimary)
                    
                    Text(story.titleTelugu)
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(ElegantDesign.Colors.primary)
                    
                    Text(story.description)
                        .font(ElegantDesign.Typography.body)
                        .foregroundColor(ElegantDesign.Colors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: story.category.icon)
                    .font(.title)
                    .foregroundColor(story.category.color)
            }
            
            HStack {
                Text("Reading time: \(story.readingTime)")
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textTertiary)
                
                Spacer()
                
                if story.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ElegantDesign.Colors.success)
                }
                
                if story.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(ElegantDesign.Colors.accent)
                }
            }
        }
        .padding(ElegantDesign.Spacing.md)
        .elegantCard()
    }
    
    private var allStoriesSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("All Stories")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            VStack(spacing: ElegantDesign.Spacing.sm) {
                ForEach(filteredStories, id: \.id) { story in
                    storyCard(story)
                }
            }
        }
    }
    
    private func storyCard(_ story: ElegantStory) -> some View {
        HStack(spacing: ElegantDesign.Spacing.md) {
            Image(systemName: story.category.icon)
                .font(.title2)
                .foregroundColor(story.category.color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                Text(story.title)
                    .font(ElegantDesign.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                
                Text(story.titleTelugu)
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .foregroundColor(ElegantDesign.Colors.primary)
                
                Text(story.description)
                    .font(ElegantDesign.Typography.body)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
                
                Text("Reading time: \(story.readingTime)")
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textTertiary)
            }
            
            Spacer()
            
            VStack(spacing: ElegantDesign.Spacing.xs) {
                if story.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ElegantDesign.Colors.success)
                }
                
                if story.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(ElegantDesign.Colors.accent)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(ElegantDesign.Colors.textTertiary)
            }
        }
        .padding(ElegantDesign.Spacing.md)
        .elegantCard()
    }
    
    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: ElegantDesign.Spacing.xs) {
            Text(value)
                .font(ElegantDesign.Typography.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(ElegantDesign.Typography.caption)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
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
