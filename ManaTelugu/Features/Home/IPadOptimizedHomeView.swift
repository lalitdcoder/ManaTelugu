import SwiftUI

// MARK: - iPad-Optimized Home View
/// Adapts layout for iPad with:
/// - Wider content area with better spacing
/// - Multi-column grid for learn modules (3 columns on iPad vs 2 on iPhone)
/// - Larger cards and buttons optimized for touch
/// - Horizontal progress cards layout on iPad
struct IPadOptimizedHomeView: View {
    @EnvironmentObject var session: AppSession
    @StateObject private var navigationService = NavigationService.shared
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var scrollOffset: CGFloat = 0
    
    // Mock data
    private let streakCount = 5
    private let lettersProgress = (36, 49)
    private let wordsCount = 124
    private let xpCount = 1250
    
    private let learnModules = [
        LearnModule(title: "Alphabet", progress: 0.75, icon: "textformat.abc", color: .blue, isEnabled: true),
        LearnModule(title: "Lessons", progress: 0.25, icon: "book.fill", color: .green, isEnabled: true),
        LearnModule(title: "Stories", progress: 0.30, icon: "scroll.fill", color: .orange, isEnabled: true),
        LearnModule(title: "Games", progress: 0.60, icon: "gamecontroller.fill", color: .cyan, isEnabled: true),
        LearnModule(title: "Vocabulary", progress: 0.45, icon: "character.book.closed.fill", color: .red, isEnabled: true)
    ]
    
    var body: some View {
        NavigationStack(path: $navigationService.navigationPath) {
            ZStack {
                // Subtle cool-toned background
                Color(red: 0.97, green: 0.97, blue: 0.98)
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    LazyVStack(spacing: horizontalSizeClass == .regular ? 32 : 24) {
                        // Top Section with Fixed Glass Effects
                        topSection
                            .padding(.top, horizontalSizeClass == .regular ? 32 : 20)
                        
                        // Progress Metrics Section
                        progressMetricsSection
                        
                        // Learn Section
                        learnSection
                        
                        // Bottom padding for tab bar
                        Color.clear
                            .frame(height: 20)
                    }
                    .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 20)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .navigationDestination(for: HomeNavigationDestination.self) { destination in
                destinationView(for: destination)
            }
        }
    }
    
    // MARK: - Top Section with Improved Glass Effects
    private var topSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    // Mana Telugu title
                    Text("Mana Telugu")
                        .font(.system(size: horizontalSizeClass == .regular ? 32 : 28, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    // Welcome banner
                    Text("Welcome back! Continue your Telugu journey.")
                        .font(.system(size: horizontalSizeClass == .regular ? 18 : 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Streak counter with improved styling
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: horizontalSizeClass == .regular ? 24 : 20, weight: .bold))
                        .foregroundColor(.orange)
                    
                    Text("\(streakCount) day streak")
                        .font(.system(size: horizontalSizeClass == .regular ? 18 : 16, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(ModernDesignSystem.Colors.surface)
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                )
            }
        }
        .padding(horizontalSizeClass == .regular ? 24 : 20)
        .background(
            FixedGlassBackground()
        )
    }
    
    // MARK: - Progress Metrics Section
    private var progressMetricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.system(size: horizontalSizeClass == .regular ? 26 : 22, weight: .bold))
                .foregroundColor(.black)
            
            if horizontalSizeClass == .regular {
                // iPad: Horizontal layout with larger cards
                HStack(spacing: 16) {
                    FixedProgressCard(
                        title: "Letters",
                        value: "\(lettersProgress.0)/\(lettersProgress.1)",
                        progress: Double(lettersProgress.0) / Double(lettersProgress.1),
                        color: .blue
                    )
                    
                    FixedProgressCard(
                        title: "Words",
                        value: "\(wordsCount)",
                        progress: 0.8,
                        color: .green
                    )
                    
                    FixedProgressCard(
                        title: "XP",
                        value: "\(xpCount)",
                        progress: 0.6,
                        color: .orange
                    )
                }
            } else {
                // iPhone: 3-column grid
                HStack(spacing: 12) {
                    FixedProgressCard(
                        title: "Letters",
                        value: "\(lettersProgress.0)/\(lettersProgress.1)",
                        progress: Double(lettersProgress.0) / Double(lettersProgress.1),
                        color: .blue
                    )
                    
                    FixedProgressCard(
                        title: "Words",
                        value: "\(wordsCount)",
                        progress: 0.8,
                        color: .green
                    )
                    
                    FixedProgressCard(
                        title: "XP",
                        value: "\(xpCount)",
                        progress: 0.6,
                        color: .orange
                    )
                }
            }
        }
    }
    
    // MARK: - Learn Section with Adaptive Grid
    private var learnSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learn")
                .font(.system(size: horizontalSizeClass == .regular ? 26 : 22, weight: .bold))
                .foregroundColor(.black)
            
            // iPad: 3-column grid, iPhone: 2-column grid
            let columns = horizontalSizeClass == .regular ?
                Array(repeating: GridItem(.flexible(), spacing: 16), count: 3) :
                Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
            
            LazyVGrid(columns: columns, spacing: horizontalSizeClass == .regular ? 16 : 12) {
                ForEach(Array(learnModules), id: \.id) { module in
                    FixedLearnModuleCard(module: module) {
                        switch module.title {
                        case "Alphabet":
                            navigationService.navigate(to: HomeNavigationDestination.alphabet)
                        case "Lessons":
                            navigationService.navigate(to: HomeNavigationDestination.lesson(id: "lessons_hub"))
                        case "Stories":
                            navigationService.navigate(to: HomeNavigationDestination.story(id: UUID()))
                        case "Games":
                            navigationService.navigate(to: HomeNavigationDestination.games)
                        case "Vocabulary":
                            navigationService.navigate(to: HomeNavigationDestination.vocabulary)
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation Destination
    @ViewBuilder
    private func destinationView(for destination: HomeNavigationDestination) -> some View {
        switch destination {
        case .alphabet:
            IPadOptimizedAlphabetView()
        case .lesson(_):
            IPadOptimizedLessonsView()
        case .story(_):
            FavoritesView()
        case .games:
            IPadOptimizedGamesView()
        case .practice:
            IPadOptimizedGamesView()
        case .vocabulary:
            VocabularyThemesView()
        case .progress:
            ProgressDashboardView()
        default:
            EmptyView()
        }
    }
}

// MARK: - Preview
#Preview {
    IPadOptimizedHomeView()
        .environmentObject(AppSession())
}
