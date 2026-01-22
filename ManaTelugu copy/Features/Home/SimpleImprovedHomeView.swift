import SwiftUI

struct SimpleImprovedHomeView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: ModernDesignSystem.Spacing.xLarge) {
                    // Welcome Section
                    welcomeSection
                    
                    // Quick Stats
                    quickStatsSection
                    

                    
                    // Learning Modes
                    learningModesSection
                        
                        // Bottom padding for tab bar
                        Color.clear.frame(height: 100)
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.top, ModernDesignSystem.Spacing.md)
                }
            }
            .applySoftGradient()
            .navigationTitle("మనతెలుగు")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Welcome back!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)
            
            Text("Ready to continue your Telugu journey?")
                .font(.body)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)
            
            HStack {
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
                    Text("Current Streak")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                    
                    Text("7 days")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(ModernDesignSystem.Colors.teluguSaffron)
                }
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 32))
                    .foregroundColor(ModernDesignSystem.Colors.teluguSaffron)
            }
        }
        .padding(ModernDesignSystem.Spacing.lg)
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
    
    private var quickStatsSection: some View {
        HStack(spacing: ModernDesignSystem.Spacing.md) {
            statCard("XP", "1,250", ModernDesignSystem.Colors.teluguBlue)
            statCard("Level", "5", ModernDesignSystem.Colors.teluguGreen)
            statCard("Badges", "12", ModernDesignSystem.Colors.teluguSaffron)
        }
    }
    
    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: ModernDesignSystem.Spacing.tiny) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(ModernDesignSystem.Spacing.md)
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(12)
    }
    

    
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Learning Modes")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(ModernDesignSystem.Colors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ModernDesignSystem.Spacing.md), count: 2), spacing: ModernDesignSystem.Spacing.md) {
                learningModeCard("Alphabet", "textformat.abc", ModernDesignSystem.Colors.teluguBlue, 0.75)
                learningModeCard("Vocabulary", "book.fill", ModernDesignSystem.Colors.teluguGreen, 0.45)
                learningModeCard("Stories", "books.vertical.fill", ModernDesignSystem.Colors.teluguSaffron, 0.30)
                learningModeCard("Games", "gamecontroller.fill", ModernDesignSystem.Colors.culturalRed, 0.60)
            }
        }
    }
    
    private func learningModeCard(_ title: String, _ icon: String, _ color: Color, _ progress: Double) -> some View {
        NavigationLink(destination: destinationView(for: title)) {
            VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.sm) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                }
                
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(ModernDesignSystem.Colors.primaryText)
                
                ProgressView(value: progress)
                    .tint(color)
            }
            .padding(ModernDesignSystem.Spacing.md)
            .background(ModernDesignSystem.Colors.cardBackground)
            .cornerRadius(12)
            .frame(minHeight: 120)
        }
        .frame(minWidth: ModernDesignSystem.Spacing.minimumTouchTarget, minHeight: ModernDesignSystem.Spacing.minimumTouchTarget)
        .accessibilityLabel(title)
        .accessibilityHint("Start \(title.lowercased()) learning")
        .accessibilityAddTraits(.isButton)
    }
    
    @ViewBuilder
    private func destinationView(for title: String) -> some View {
        switch title {
        case "Alphabet":
            AlphabetHubView()
        case "Vocabulary":
            VocabularyThemesView()
        case "Stories":
            ProfessionalStorybookHubView()
        case "Games":
            GamesHubView()
        default:
            AlphabetHubView()
        }
    }
