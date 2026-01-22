import SwiftUI

struct ElegantHomeView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedLearningMode: String? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ModernDesignSystem.Spacing.xl) {
                        // Hero Section
                        heroSection
                            .padding(.top, ModernDesignSystem.Spacing.xl)
                        
                        // Progress Overview
                        progressSection
                        
                        // Learning Modes
                        learningModesSection
                        

                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.bottom, ModernDesignSystem.Spacing.xl)
                }
            }
            .navigationTitle("Mana Telugu")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                    Text("Welcome back!")
                        .font(ModernDesignSystem.Typography.title2)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    
                    Text("Continue your Telugu journey")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
                
                Spacer()
                
                // Streak indicator
                VStack(spacing: ModernDesignSystem.Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundColor(ModernDesignSystem.Colors.accent)
                    
                    Text("5")
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    
                    Text("day streak")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Your Progress")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            HStack(spacing: ModernDesignSystem.Spacing.md) {
                progressCard("Letters", "36/49", 0.73, ModernDesignSystem.Colors.primary)
                progressCard("Words", "124", 0.45, ModernDesignSystem.Colors.secondary)
                progressCard("XP", "1,250", 1.0, ModernDesignSystem.Colors.accent)
            }
        }
    }
    
    private func progressCard(_ title: String, _ value: String, _ progress: Double, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.sm) {
            Text(title)
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            
            Text(value)
                .font(ModernDesignSystem.Typography.title3)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            ProgressView(value: progress)
                .tint(color)
                .scaleEffect(y: 0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .modernCard()
    }
    
    // MARK: - Learning Modes Section
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Learn")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.md), count: 2), spacing: ModernDesignSystem.Spacing.md) {
                learningModeCard("Alphabet", "textformat.abc", ModernDesignSystem.Colors.primary, 0.75)
                learningModeCard("Lessons", "book.fill", ModernDesignSystem.Colors.secondary, 0.25)
                learningModeCard("Stories", "text.book.closed.fill", ModernDesignSystem.Colors.accent, 0.30)
                learningModeCard("Games", "gamecontroller.fill", ModernDesignSystem.Colors.primary, 0.60)
            }
        }
    }
    
    private func learningModeCard(_ title: String, _ icon: String, _ color: Color, _ progress: Double) -> some View {
        NavigationLink(destination: destinationView(for: title)) {
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                // Content
                VStack(spacing: ModernDesignSystem.Spacing.xs) {
                    Text(title)
                        .font(ModernDesignSystem.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    
                    Text("\(Int(progress * 100))% complete")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
                
                // Progress
                ProgressView(value: progress)
                    .tint(color)
                    .scaleEffect(y: 0.6)
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
.buttonStyle(HapticPlainButtonStyle())
    }
    

    
    // MARK: - Navigation Destinations
    @ViewBuilder
    private func destinationView(for title: String) -> some View {
        switch title {
        case "Alphabet":
            ElegantAlphabetView()
        case "Lessons":
            ElegantLessonsView()
        case "Stories":
            ElegantStoriesView()
        case "Games":
            ElegantGamesView()
        default:
            ElegantAlphabetView()
        }
    }
    
    // MARK: - Action Handlers
    private func handleQuickAction(_ title: String) {
        switch title {
        case "Continue Last Lesson":
            // Navigate to last lesson or show lesson picker
            selectedLearningMode = "Continue"
        case "Practice Weak Areas":
            // Navigate to practice mode with weak areas
            selectedLearningMode = "Practice"
        case "Daily Challenge":
            // Navigate to daily challenge
            selectedLearningMode = "Challenge"
        default:
            break
        }
    }
}
