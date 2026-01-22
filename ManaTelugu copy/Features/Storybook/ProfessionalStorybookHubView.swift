import SwiftUI

// MARK: - Professional Stories Hub View
// Clean, vertical layout with cultural richness

struct ProfessionalStorybookHubView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: StoryCategory? = nil
    @State private var searchText = ""
    @State private var showingSettings = false
    @State private var showingFavorites = false
    
    var filteredStories: [TeluguStory] {
        var filtered = session.storyService.stories
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { story in
                story.title.localizedCaseInsensitiveContains(searchText) ||
                story.titleEnglish.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.container, edges: .top)
            
            ScrollView {
                LazyVStack(spacing: ModernDesignSystem.Spacing.lg) {
                    // Hero Section
                    heroSection
                        .padding(.top, -20)
                    
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
                .padding(.horizontal, ModernDesignSystem.Spacing.md)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Stories")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.lg) {
            Text("Telugu Stories")
                .font(ModernDesignSystem.Typography.title1)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            Text("Discover the rich world of Telugu literature and folklore")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            
            HStack(spacing: ModernDesignSystem.Spacing.lg) {
                ModernStatCard(
                    icon: "book.fill",
                    value: "\(session.storyService.stories.count)",
                    label: "Stories",
                    color: ModernDesignSystem.Colors.alphabet
                )
                
                ModernStatCard(
                    icon: "clock.fill",
                    value: "2h",
                    label: "Reading",
                    color: ModernDesignSystem.Colors.lessons
                )
            }
        }
        .modernCard(hasLiquidGlass: true)
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            
            TextField("Search stories...", text: $searchText)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            if !searchText.isEmpty {
                Button(action: { 
                    HapticsService.shared.buttonTap()
                    searchText = "" 
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
            }
        }
        .modernCard()
    }
    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Categories")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ModernDesignSystem.Spacing.sm) {
                    ModernButton("All", style: selectedCategory == nil ? .primary : .secondary) {
                        selectedCategory = nil
                    }
                    
                    ForEach(StoryCategory.allCases, id: \.self) { category in
                        ModernButton(category.displayName, style: selectedCategory == category ? .primary : .secondary) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, ModernDesignSystem.Spacing.md)
            }
        }
    }
    
    // MARK: - Stories List Section
    private var storiesListSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Available Stories")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                ForEach(filteredStories, id: \.id) { story in
                    NavigationLink(destination: StoryReaderView(story: story)) {
                        ModernStoryCard(story: story)
                    }
.buttonStyle(HapticPlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Modern Stat Card
struct ModernStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(ModernDesignSystem.Typography.title2)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            Text(label)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .modernCard()
    }
}

// MARK: - Modern Story Card
struct ModernStoryCard: View {
    let story: TeluguStory
    
    var body: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                    Text(story.titleEnglish)
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    
                    Text(story.title)
                        .font(ModernDesignSystem.Typography.teluguHeading)
                        .foregroundColor(ModernDesignSystem.Colors.stories)
                }
                
                Spacer()
                
                // Favorite Button
                Button(action: {
                    HapticsService.shared.success()
                }) {
                    Image(systemName: story.isBookmarked ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(story.isBookmarked ? ModernDesignSystem.Colors.stories : ModernDesignSystem.Colors.textSecondary)
                }
            }
            
            // Description
            Text(story.culturalContext)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                .lineLimit(2)
            
            // Footer
            HStack {
                // Author
                Text("by \(story.author)")
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                
                Spacer()
                
                // Difficulty Badge
                Text(story.difficulty.displayName)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Color(story.difficulty.color))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color(story.difficulty.color).opacity(0.15))
                    )
                
                // Reading Time
                Text("\(story.estimatedReadingTime) min")
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            
            // Completion Status
            if story.isCompleted {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ModernDesignSystem.Colors.success)
                    
                    Text("Completed")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(ModernDesignSystem.Colors.success)
                    
                    Spacer()
                }
            }
        }
        .modernCard()
    }
}

// MARK: - Replace the original StorybookHubView
typealias StorybookHubView = ProfessionalStorybookHubView

