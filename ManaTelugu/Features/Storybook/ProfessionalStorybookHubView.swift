import SwiftUI

// MARK: - Professional Stories Hub View
// Clean, vertical layout with cultural richness

struct ProfessionalStorybookHubView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedCategory: StoryCategory? = nil
    @State private var searchText = ""
    @State private var showingSettings = false
    @State private var showingFavorites = false
    
    // Mock stories data for professional presentation
    private let stories: [ProfessionalStory] = [
        ProfessionalStory(
            id: UUID(),
            title: "The Cat and the Mouse",
            titleTelugu: "పిల్లి మరియు ఎలుక",
            description: "A timeless Telugu folktale filled with wit and wisdom",
            author: "Traditional",
            category: .folktales,
            difficulty: .beginner,
            readingTime: "5 min",
            isCompleted: false,
            isFavorite: false
        ),
        ProfessionalStory(
            id: UUID(),
            title: "The Wise Farmer",
            titleTelugu: "తెలివైన రైతు",
            description: "Learn about hard work and wisdom through this classic story",
            author: "Traditional",
            category: .moral,
            difficulty: .intermediate,
            readingTime: "8 min",
            isCompleted: true,
            isFavorite: true
        ),
        ProfessionalStory(
            id: UUID(),
            title: "The Magic Pot",
            titleTelugu: "మాయా కుండ",
            description: "A magical tale that teaches the value of sharing",
            author: "Traditional",
            category: .mythology,
            difficulty: .beginner,
            readingTime: "6 min",
            isCompleted: false,
            isFavorite: false
        ),
        ProfessionalStory(
            id: UUID(),
            title: "The King's Challenge",
            titleTelugu: "రాజు సవాలు",
            description: "An adventure story about courage and determination",
            author: "Traditional",
            category: .historical,
            difficulty: .advanced,
            readingTime: "12 min",
            isCompleted: false,
            isFavorite: false
        )
    ]
    
    var filteredStories: [ProfessionalStory] {
        var filtered = stories
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { story in
                story.title.localizedCaseInsensitiveContains(searchText) ||
                story.titleTelugu.localizedCaseInsensitiveContains(searchText) ||
                story.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Professional gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.4, blue: 0.9),
                        Color(red: 0.4, green: 0.2, blue: 0.8),
                        Color(red: 0.8, green: 0.3, blue: 0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                ScrollView {
                    LazyVStack(spacing: ProfessionalSpacing.large.value) {
                        // Hero Section
                        heroSection
                            .padding(.top, ProfessionalSpacing.extraLarge.value)
                        
                        // Search Bar
                        searchSection
                        
                        // Categories
                        categoriesSection
                        
                        // Stories List
                        storiesListSection
                        
                        // Bottom padding for tab bar
                        Color.clear
                            .frame(height: 120)
                    }
                    .padding(.horizontal, ProfessionalSpacing.medium.value)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        ProfessionalCard(type: .hero) {
            VStack(alignment: .leading, spacing: ProfessionalSpacing.large.value) {
                ProfessionalText(
                    "Telugu Stories",
                    style: .heroTitle,
                    color: .textPrimary
                )
                
                ProfessionalText(
                    "Discover the rich world of Telugu literature and folklore",
                    style: .bodyText,
                    color: .textSecondary
                )
                
                HStack(spacing: ProfessionalSpacing.large.value) {
                    ProfessionalStatCard(
                        icon: "book.fill",
                        value: "\(stories.count)",
                        label: "Stories",
                        color: .professionalBlue
                    )
                    
                    ProfessionalStatCard(
                        icon: "clock.fill",
                        value: "2h",
                        label: "Reading",
                        color: .professionalGreen
                    )
                }
            }
        }
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        ProfessionalCard(type: .secondary) {
            HStack(spacing: ProfessionalSpacing.medium.value) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textSecondary)
                
                TextField("Search stories...", text: $searchText)
                    .font(ProfessionalTypography.font(for: .bodyText))
                    .foregroundColor(.textPrimary)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Categories",
                subtitle: "Choose your story type"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ProfessionalSpacing.medium.value) {
                    // All Stories
                    ProfessionalCategoryChip(
                        title: "All",
                        isSelected: selectedCategory == nil,
                        action: { selectedCategory = nil }
                    )
                    
                    // Category Chips
                    ForEach(StoryCategory.allCases, id: \.self) { category in
                        ProfessionalCategoryChip(
                            title: category.displayName,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
                .padding(.horizontal, ProfessionalSpacing.medium.value)
            }
        }
    }
    
    // MARK: - Stories List Section
    private var storiesListSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Available Stories",
                subtitle: "\(filteredStories.count) stories found"
            )
            
            VStack(spacing: ProfessionalSpacing.medium.value) {
                ForEach(filteredStories, id: \.id) { story in
                    ProfessionalStoryCard(story: story)
                }
            }
        }
    }
}

// MARK: - Professional Story Model
struct ProfessionalStory {
    let id: UUID
    let title: String
    let titleTelugu: String
    let description: String
    let author: String
    let category: StoryCategory
    let difficulty: DifficultyLevel
    let readingTime: String
    let isCompleted: Bool
    let isFavorite: Bool
    
    enum DifficultyLevel {
        case beginner
        case intermediate
        case advanced
        
        var displayName: String {
            switch self {
            case .beginner: return "Beginner"
            case .intermediate: return "Intermediate"
            case .advanced: return "Advanced"
            }
        }
        
        var color: Color {
            switch self {
            case .beginner: return .professionalGreen
            case .intermediate: return .professionalOrange
            case .advanced: return .professionalPurple
            }
        }
    }
}

// MARK: - Story Category (using the one from StoryModels.swift)

// MARK: - Professional Category Chip
struct ProfessionalCategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ProfessionalText(
                title,
                style: .buttonText,
                color: isSelected ? .white : .textPrimary,
                alignment: .center
            )
            .padding(.horizontal, ProfessionalSpacing.medium.value)
            .padding(.vertical, ProfessionalSpacing.small.value)
            .background(
                Capsule()
                    .fill(isSelected ? Color.professionalBlue : Color.cardSecondary)
            )
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color.professionalBlue : .white.opacity(0.2),
                        lineWidth: 1
                    )
            )
        }
    }
}

// MARK: - Professional Story Card
struct ProfessionalStoryCard: View {
    let story: ProfessionalStory
    @State private var isPressed = false
    
    var body: some View {
        ProfessionalCard(type: .interactive, isInteractive: true) {
            VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: ProfessionalSpacing.small.value) {
                        ProfessionalText(
                            story.title,
                            style: .cardTitle,
                            color: .textPrimary
                        )
                        
                        ProfessionalText(
                            story.titleTelugu,
                            style: .teluguTitle,
                            color: .professionalBlue
                        )
                    }
                    
                    Spacer()
                    
                    // Favorite Button
                    Button(action: {}) {
                        Image(systemName: story.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(story.isFavorite ? .professionalOrange : .textSecondary)
                    }
                }
                
                // Description
                ProfessionalText(
                    story.description,
                    style: .bodyText,
                    color: .textSecondary
                )
                
                // Footer
                HStack {
                    // Author
                    ProfessionalText(
                        "by \(story.author)",
                        style: .caption,
                        color: .textSecondary
                    )
                    
                    Spacer()
                    
                    // Difficulty Badge
                    Text(story.difficulty.displayName)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(story.difficulty.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(story.difficulty.color.opacity(0.15))
                        )
                    
                    // Reading Time
                    ProfessionalText(
                        story.readingTime,
                        style: .caption,
                        color: .textSecondary
                    )
                }
                
                // Completion Status
                if story.isCompleted {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.professionalGreen)
                        
                        ProfessionalText(
                            "Completed",
                            style: .caption,
                            color: .professionalGreen
                        )
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Replace the original StorybookHubView
typealias StorybookHubView = ProfessionalStorybookHubView
