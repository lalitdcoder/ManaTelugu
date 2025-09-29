import SwiftUI

struct ElegantHomeView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedLearningMode: String? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                ElegantGradient()
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ElegantDesign.Spacing.xl) {
                        // Hero Section
                        heroSection
                            .padding(.top, ElegantDesign.Spacing.xl)
                        
                        // Progress Overview
                        progressSection
                        
                        // Learning Modes
                        learningModesSection
                        
                        // Quick Actions
                        quickActionsSection
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
                }
            }
            .navigationTitle("Mana Telugu")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                    Text("Welcome back!")
                        .font(ElegantDesign.Typography.title2)
                        .foregroundColor(ElegantDesign.Colors.textPrimary)
                    
                    Text("Continue your Telugu journey")
                        .font(ElegantDesign.Typography.body)
                        .foregroundColor(ElegantDesign.Colors.textSecondary)
                }
                
                Spacer()
                
                // Streak indicator
                VStack(spacing: ElegantDesign.Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundColor(ElegantDesign.Colors.accent)
                    
                    Text("5")
                        .font(ElegantDesign.Typography.headline)
                        .foregroundColor(ElegantDesign.Colors.textPrimary)
                    
                    Text("day streak")
                        .font(ElegantDesign.Typography.caption)
                        .foregroundColor(ElegantDesign.Colors.textSecondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Your Progress")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            HStack(spacing: ElegantDesign.Spacing.md) {
                progressCard("Letters", "36/49", 0.73, ElegantDesign.Colors.primary)
                progressCard("Words", "124", 0.45, ElegantDesign.Colors.secondary)
                progressCard("XP", "1,250", 1.0, ElegantDesign.Colors.accent)
            }
        }
    }
    
    private func progressCard(_ title: String, _ value: String, _ progress: Double, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.sm) {
            Text(title)
                .font(ElegantDesign.Typography.caption)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
            
            Text(value)
                .font(ElegantDesign.Typography.title3)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            ProgressView(value: progress)
                .tint(color)
                .scaleEffect(y: 0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .elegantCard()
    }
    
    // MARK: - Learning Modes Section
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Learn")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ElegantDesign.Spacing.md), count: 2), spacing: ElegantDesign.Spacing.md) {
                learningModeCard("Alphabet", "textformat.abc", ElegantDesign.Colors.primary, 0.75)
                learningModeCard("Lessons", "book.fill", ElegantDesign.Colors.secondary, 0.25)
                learningModeCard("Stories", "text.book.closed.fill", ElegantDesign.Colors.accent, 0.30)
                learningModeCard("Games", "gamecontroller.fill", ElegantDesign.Colors.primary, 0.60)
            }
        }
    }
    
    private func learningModeCard(_ title: String, _ icon: String, _ color: Color, _ progress: Double) -> some View {
        NavigationLink(destination: destinationView(for: title)) {
            VStack(spacing: ElegantDesign.Spacing.md) {
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
                VStack(spacing: ElegantDesign.Spacing.xs) {
                    Text(title)
                        .font(ElegantDesign.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(ElegantDesign.Colors.textPrimary)
                    
                    Text("\(Int(progress * 100))% complete")
                        .font(ElegantDesign.Typography.caption)
                        .foregroundColor(ElegantDesign.Colors.textSecondary)
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
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Quick Actions")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            VStack(spacing: ElegantDesign.Spacing.sm) {
                quickActionRow("Continue Last Lesson", "play.circle.fill", ElegantDesign.Colors.primary)
                quickActionRow("Practice Weak Areas", "target", ElegantDesign.Colors.secondary)
                quickActionRow("Daily Challenge", "star.circle.fill", ElegantDesign.Colors.accent)
            }
        }
    }
    
    private func quickActionRow(_ title: String, _ icon: String, _ color: Color) -> some View {
        Button(action: {
            handleQuickAction(title)
        }) {
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
            .padding(.vertical, ElegantDesign.Spacing.sm)
            .padding(.horizontal, ElegantDesign.Spacing.md)
            .background(ElegantDesign.Colors.surfaceSecondary)
            .cornerRadius(ElegantDesign.CornerRadius.md)
        }
        .buttonStyle(PlainButtonStyle())
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
