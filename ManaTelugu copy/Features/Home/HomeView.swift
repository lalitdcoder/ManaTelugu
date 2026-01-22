import SwiftUI

// MARK: - Modern Home View with Apple HIG
struct HomeView: View {
    @EnvironmentObject var session: AppSession
    @State private var learnModules: [LearnModule] = []
    @State private var animateCards = false
    @State private var animateStreak = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
            // Stronger gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Compact Header
                    headerSection
                        
                        // Progress Metrics
                        progressMetricsSection
                        
                        // Learn Section
                        learnSection
                        
                        // Bottom padding
                        Color.clear.frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
            }
            .onAppear {
                updateLearnModules()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                    animateCards = true
                }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3)) {
                    animateStreak = true
                }
            }
            .onReceive(session.objectWillChange) { _ in
                updateLearnModules()
            }
            .navigationDestination(for: String.self) { moduleTitle in
                destinationViewForTitle(moduleTitle)
            }
            .navigationTitle("Mana Telugu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Navigation
    private func navigateToModule(_ module: LearnModule) {
        navigationPath.append(module.title)
    }
    
    @ViewBuilder
    private func destinationViewForTitle(_ title: String) -> some View {
        switch title {
        case "Alphabet":
            AlphabetHubView()
        case "Lessons":
            ElegantLessonsView()
        case "Stories":
            ProfessionalStorybookHubView()
        case "Games":
            GamesHubView()
        case "Vocabulary":
            VocabularyThemesView()
        default:
            AlphabetHubView()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Mana Telugu")
                    .font(.title.bold())
                    .foregroundColor(.primary)
                
                Text("Welcome back! Continue your Telugu journey.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Streak Chip
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.orange)
                
                Text("\(session.currentStreak)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(.orange.opacity(0.15))
            )
            .scaleEffect(animateStreak ? 1.0 : 0.8)
            .opacity(animateStreak ? 1.0 : 0.0)
        }
        .padding(.vertical, 12)
    }
    
    // MARK: - Progress Metrics Section
    private var progressMetricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.headline.bold())
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                CompactProgressCard(
                    label: "Letters",
                    value: "\(session.learnedLetters)/\(session.totalLetters)",
                    progress: Double(session.learnedLetters) / Double(max(session.totalLetters, 1)),
                    color: .blue,
                    showProgress: true
                )
                
                CompactProgressCard(
                    label: "Words",
                    value: "\(session.masteredWords)",
                    progress: 0,
                    color: .green,
                    showProgress: false
                )
                
                CompactProgressCard(
                    label: "XP",
                    value: "\(session.gamificationService.gamificationState.totalXP)",
                    progress: 0,
                    color: .orange,
                    showProgress: false
                )
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
    }
    
    // MARK: - Learn Section
    private var learnSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learn")
                .font(.headline.bold())
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(Array(learnModules.enumerated()), id: \.element.id) { index, module in
                    Button {
                        HapticsService.shared.buttonTap()
                        navigateToModule(module)
                    } label: {
                        HeroModuleCard(
                            module: module,
                            isPrimary: false
                        )
                    }
                    .buttonStyle(HeroCardButtonStyle())
                    .scaleEffect(animateCards ? 1.0 : 0.9)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.05), value: animateCards)
                }
            }
        }
    }
    
    // MARK: - Navigation
    @ViewBuilder
    private func destinationView(for module: LearnModule) -> some View {
        switch module.title {
        case "Alphabet":
            AlphabetHubView()
        case "Lessons":
            ElegantLessonsView()
        case "Stories":
            ProfessionalStorybookHubView()
        case "Games":
            GamesHubView()
        case "Vocabulary":
            VocabularyThemesView()
        default:
            AlphabetHubView()
        }
    }
    
    private func updateLearnModules() {
        let alphabetLessonIds = ["lesson_1_1", "lesson_1_2", "lesson_1_3"]
        
        let completedAlphabetLessons = session.progressTrackingService.lessonProgress.filter { progress in
            alphabetLessonIds.contains(progress.lessonId) && progress.isCompleted
        }.count
        let totalAlphabetLessons = alphabetLessonIds.count
        let alphabetProgress = totalAlphabetLessons > 0 ? Double(completedAlphabetLessons) / Double(totalAlphabetLessons) : 0
        
        let completedOtherLessons = session.progressTrackingService.completedLessonsCount - completedAlphabetLessons
        let totalOtherLessons = session.progressTrackingService.totalLessonsCount - totalAlphabetLessons
        let lessonsProgress = totalOtherLessons > 0 ? Double(completedOtherLessons) / Double(totalOtherLessons) : 0
        
        let storiesProgress = session.storyService.stories.count > 0 ? Double(session.storyService.completedStoriesCount) / Double(session.storyService.stories.count) : 0
        
        let vocabularyProgress = session.dataRepository.words.count > 0 ? Double(session.gamificationService.getLearningStats().totalWords) / Double(session.dataRepository.words.count) : 0
        
        let gamesProgress = 0.0 // Removed badge-based progress calculation

        let newModules = [
            LearnModule(title: "Alphabet", progress: alphabetProgress, icon: "text.book.closed.fill", color: .blue, isEnabled: true),
            LearnModule(title: "Lessons", progress: lessonsProgress, icon: "graduationcap.fill", color: .green, isEnabled: true),
            LearnModule(title: "Stories", progress: storiesProgress, icon: "book.fill", color: .orange, isEnabled: true),
            LearnModule(title: "Games", progress: gamesProgress, icon: "gamecontroller.fill", color: .purple, isEnabled: true),
            LearnModule(title: "Vocabulary", progress: vocabularyProgress, icon: "character.book.closed.fill", color: .red, isEnabled: true)
        ]
        
        DispatchQueue.main.async {
            self.learnModules = newModules
        }
    }
}

// MARK: - Compact Progress Card
struct CompactProgressCard: View {
    let label: String
    let value: String
    let progress: Double
    let color: Color
    let showProgress: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption.bold())
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3.bold())
                .foregroundColor(.primary)
            
            if showProgress {
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.2))
                        .frame(height: 4)
                    
                    Capsule()
                        .fill(color)
                        .frame(width: 60 * progress, height: 4)
                }
                .frame(width: 60)
                
                Text("\(Int(progress * 100))%")
                    .font(.caption2.bold())
                    .foregroundColor(color)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Learn Module Card
struct LearnModuleCard: View {
    let module: LearnModule
    let isPrimary: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticsService.shared.buttonTap()
            action()
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: module.icon)
                        .font(.title2.bold())
                        .foregroundColor(module.color)
                    
                    Spacer()
                    
                    if module.progress > 0 {
                        Text("\(Int(module.progress * 100))%")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(module.title)
                    .font(.headline.bold())
                    .foregroundColor(.primary)
                
                if module.progress > 0 {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(module.color.opacity(0.2))
                            .frame(height: 4)
                        
                        GeometryReader { geometry in
                            Capsule()
                                .fill(module.color)
                                .frame(width: geometry.size.width * module.progress, height: 4)
                        }
                        .frame(height: 4)
                    }
                }
            }
            .padding(16)
            .background(
                Group {
                    if isPrimary {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(module.color.opacity(0.1))
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial)
                    }
                }
                .shadow(
                    color: isPrimary ? module.color.opacity(0.2) : .black.opacity(0.05),
                    radius: isPrimary ? 8 : 4,
                    x: 0,
                    y: isPrimary ? 4 : 2
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isPrimary ? module.color.opacity(0.3) : .clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Learn Module Model
struct LearnModule: Identifiable {
    let id = UUID()
    let title: String
    let progress: Double
    let icon: String
    let color: Color
    let isEnabled: Bool
}

struct LearnModuleCardView: View {
    let module: LearnModule
    let isPrimary: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: module.icon)
                    .font(.title2.bold())
                    .foregroundColor(module.color)
                
                Spacer()
                
                if module.progress > 0 {
                    Text("\(Int(module.progress * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                }
            }
            
            Text(module.title)
                .font(.headline.bold())
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            if module.progress > 0 {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.quaternary)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(module.color)
                            .frame(width: geometry.size.width * module.progress, height: 4)
                    }
                    .frame(height: 4)
                }
            }
        }
        .padding(16)
        .background(
            Group {
                if isPrimary {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(module.color.opacity(0.1))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                }
            }
            .shadow(
                color: isPrimary ? module.color.opacity(0.2) : .black.opacity(0.05),
                radius: isPrimary ? 8 : 4,
                x: 0,
                y: isPrimary ? 4 : 2
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isPrimary ? module.color.opacity(0.3) : .clear, lineWidth: 1)
        )
        .foregroundStyle(.primary)
        .contentShape(Rectangle())
    }
}

// MARK: - Hero Module Card (Best HIG Design)
struct HeroModuleCard: View {
    let module: LearnModule
    let isPrimary: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: module.icon)
                    .font(.title2.bold())
                    .foregroundColor(module.color)
                
                Spacer()
                
                if module.progress > 0 {
                    Text("\(Int(module.progress * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                }
            }
            
            Text(module.title)
                .font(.headline.bold())
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            if module.progress > 0 {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.quaternary)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(module.color)
                            .frame(width: geometry.size.width * module.progress, height: 4)
                    }
                    .frame(height: 4)
                }
            }
        }
        .padding(16)
        .background(
            Group {
                if isPrimary {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(module.color.opacity(0.1))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                }
            }
            .shadow(
                color: isPrimary ? module.color.opacity(0.2) : .black.opacity(0.05),
                radius: isPrimary ? 8 : 4,
                x: 0,
                y: isPrimary ? 4 : 2
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isPrimary ? module.color.opacity(0.3) : .clear, lineWidth: 1)
        )
    }
}

// MARK: - Hero Card Button Style (HIG Compliant)
struct HeroCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
        .environmentObject(AppSession())
}
