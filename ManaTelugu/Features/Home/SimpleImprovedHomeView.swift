import SwiftUI

struct SimpleImprovedHomeView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: MTSpacing.xLarge) {
                    // Welcome Section
                    welcomeSection
                    
                    // Quick Stats
                    quickStatsSection
                    
                    // Continue Learning
                    continueSection
                    
                    // Learning Modes
                    learningModesSection
                        
                        // Bottom padding for tab bar
                        Color.clear.frame(height: 100)
                    }
                    .padding(.horizontal, MTSpacing.medium)
                    .padding(.top, MTSpacing.medium)
                }
            }
            .applySoftGradient()
            .navigationTitle("మనతెలుగు")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: MTSpacing.medium) {
            Text("Welcome back!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(MTColors.primaryText)
            
            Text("Ready to continue your Telugu journey?")
                .font(.body)
                .foregroundColor(MTColors.secondaryText)
            
            HStack {
                VStack(alignment: .leading, spacing: MTSpacing.tiny) {
                    Text("Current Streak")
                        .font(.caption)
                        .foregroundColor(MTColors.secondaryText)
                    
                    Text("7 days")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(MTColors.teluguSaffron)
                }
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 32))
                    .foregroundColor(MTColors.teluguSaffron)
            }
        }
        .padding(MTSpacing.large)
        .background(MTColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
    
    private var quickStatsSection: some View {
        HStack(spacing: MTSpacing.medium) {
            statCard("XP", "1,250", MTColors.teluguBlue)
            statCard("Level", "5", MTColors.teluguGreen)
            statCard("Badges", "12", MTColors.teluguSaffron)
        }
    }
    
    private func statCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: MTSpacing.tiny) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(MTColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(MTSpacing.medium)
        .background(MTColors.cardBackground)
        .cornerRadius(12)
    }
    
    private var continueSection: some View {
        VStack(alignment: .leading, spacing: MTSpacing.medium) {
            HStack {
                Text("Continue Learning")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(MTColors.primaryText)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(MTColors.teluguBlue)
            }
            
            Text("Pick up where you left off")
                .font(.body)
                .foregroundColor(MTColors.secondaryText)
            
            Button(action: {
                // Navigation handled by NavigationLink
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Learning")
                }
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, MTSpacing.large)
                .padding(.vertical, MTSpacing.medium)
                .background(MTColors.teluguBlue)
                .cornerRadius(12)
            }
            .frame(minHeight: MTSpacing.minimumTouchTarget)
        }
        .padding(MTSpacing.large)
        .background(MTColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
    
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: MTSpacing.medium) {
            Text("Learning Modes")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(MTColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.medium), count: 2), spacing: MTSpacing.medium) {
                learningModeCard("Alphabet", "textformat.abc", MTColors.teluguBlue, 0.75)
                learningModeCard("Vocabulary", "book.fill", MTColors.teluguGreen, 0.45)
                learningModeCard("Stories", "books.vertical.fill", MTColors.teluguSaffron, 0.30)
                learningModeCard("Games", "gamecontroller.fill", MTColors.culturalRed, 0.60)
            }
        }
    }
    
    private func learningModeCard(_ title: String, _ icon: String, _ color: Color, _ progress: Double) -> some View {
        NavigationLink(destination: destinationView(for: title)) {
            VStack(alignment: .leading, spacing: MTSpacing.small) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(MTColors.secondaryText)
                }
                
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(MTColors.primaryText)
                
                ProgressView(value: progress)
                    .tint(color)
            }
            .padding(MTSpacing.medium)
            .background(MTColors.cardBackground)
            .cornerRadius(12)
            .frame(minHeight: 120)
        }
        .frame(minWidth: MTSpacing.minimumTouchTarget, minHeight: MTSpacing.minimumTouchTarget)
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
