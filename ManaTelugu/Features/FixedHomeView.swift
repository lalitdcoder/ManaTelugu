import SwiftUI

// MARK: - Fixed Home View with Proper Spacing and Glass Effects
struct FixedHomeView: View {
    @EnvironmentObject var session: AppSession
    @StateObject private var navigationService = NavigationService.shared
    @State private var scrollOffset: CGFloat = 0
    
    // Mock data for the new design
    private let streakCount = 5
    private let lettersProgress = (36, 49)
    private let wordsCount = 124
    private let xpCount = 1250
    
    private let learnModules = [
        LearnModule(title: "Alphabet", progress: 0.75, icon: "textformat.abc", color: .blue, isEnabled: true),
        LearnModule(title: "Lessons", progress: 0.25, icon: "book.fill", color: .green, isEnabled: true),
        LearnModule(title: "Stories", progress: 0.30, icon: "scroll.fill", color: .orange, isEnabled: true),
        LearnModule(title: "Games", progress: 0.60, icon: "gamecontroller.fill", color: .cyan, isEnabled: true)
    ]
    
    var body: some View {
        NavigationStack(path: $navigationService.navigationPath) {
            ZStack {
                // Subtle cool-toned background
                Color(red: 0.97, green: 0.97, blue: 0.98)
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Top Section with Fixed Glass Effects
                        fixedTopSection
                            .padding(.top, 20)
                        
                        // Progress Metrics Section
                        fixedProgressMetricsSection
                        
                        // Learn Section
                        fixedLearnSection
                        

                        
                        // Bottom padding for tab bar - reduced
                        Color.clear
                            .frame(height: 20)
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .navigationDestination(for: HomeNavigationDestination.self) { destination in
                destinationView(for: destination)
            }
        }
    }
    
    // MARK: - Fixed Top Section with Improved Glass Effects
    private var fixedTopSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // Mana Telugu title with improved glass effect
                    Text("Mana Telugu")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    // Welcome banner with improved glass effect
                    Text("Welcome back! Continue your Telugu journey.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Streak counter with improved styling
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.orange)
                    
                    Text("\(streakCount) day streak")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(ModernDesignSystem.Colors.surface)
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                )
            }
        }
        .padding(20)
        .background(
            FixedGlassBackground()
        )
    }
    
    // MARK: - Fixed Progress Metrics Section
    private var fixedProgressMetricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
            
            HStack(spacing: 12) {
                // Letters Progress Card
                FixedProgressCard(
                    title: "Letters",
                    value: "\(lettersProgress.0)/\(lettersProgress.1)",
                    progress: Double(lettersProgress.0) / Double(lettersProgress.1),
                    color: .blue
                )
                
                // Words Progress Card
                FixedProgressCard(
                    title: "Words",
                    value: "\(wordsCount)",
                    progress: 0.8,
                    color: .green
                )
                
                // XP Progress Card
                FixedProgressCard(
                    title: "XP",
                    value: "\(xpCount)",
                    progress: 0.6,
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Fixed Learn Section
    private var fixedLearnSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learn")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
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
            ModernAlphabetView()
        case .lesson(_):
            FixedElegantLessonsView()
        case .story(_):
            FavoritesView()
        case .games:
            GamesHubView()
        case .practice:
            GamesHubView()
        case .vocabulary:
            VocabularyThemesView()
        case .progress:
            ProgressDashboardView()
        default:
            EmptyView()
        }
    }
}

// MARK: - Fixed Glass Background Effect
struct FixedGlassBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.white.opacity(0.9))
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.5))
                    .blur(radius: 0.5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Fixed Progress Card
struct FixedProgressCard: View {
    let title: String
    let value: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            // Fixed progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: max(0, min(geometry.size.width * progress, geometry.size.width)), height: 6)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(height: 6)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ModernDesignSystem.Colors.surface)
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
    }
}

// MARK: - Fixed Learn Module Card
struct FixedLearnModuleCard: View {
    let module: LearnModule
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticsService.shared.lightImpact()
            action()
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: module.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(module.color)
                    
                    Spacer()
                    
                    Text("\(Int(module.progress * 100))%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Text(module.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text("complete")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                // Fixed progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(module.color)
                            .frame(width: max(0, min(geometry.size.width * module.progress, geometry.size.width)), height: 6)
                            .animation(.easeInOut(duration: 0.5), value: module.progress)
                    }
                }
                .frame(height: 6)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ModernDesignSystem.Colors.surface)
                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
            )
        }
.buttonStyle(HapticPlainButtonStyle())
    }
}

// MARK: - Fixed Quick Action Button
struct FixedQuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticsService.shared.mediumImpact()
            action()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ModernDesignSystem.Colors.surface)
                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    FixedHomeView()
        .environmentObject(AppSession())
}
