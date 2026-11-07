import SwiftUI

// MARK: - Learn Module Model
struct LearnModule: Identifiable {
    let id = UUID()
    let title: String
    let progress: Double
    let icon: String
    let color: Color
    var gradientColors: [Color]
    let isEnabled: Bool

    init(title: String, progress: Double, icon: String, color: Color, gradientColors: [Color]? = nil, isEnabled: Bool = true) {
        self.title = title
        self.progress = progress
        self.icon = icon
        self.color = color
        self.gradientColors = gradientColors ?? [color, color.opacity(0.7)]
        self.isEnabled = isEnabled
    }
}

// MARK: - Premium Home View (iOS 17+ HIG Native)
struct HomeView: View {
    @EnvironmentObject var session: AppSession
    @StateObject private var curriculumRepo = CurriculumRepository()
    @State private var learnModules: [LearnModule] = []
    @State private var animateCards = false
    @State private var animateStreak = false
    @State private var animateHero = false
    @State private var streakPulse = false
    @State private var navigationPath = NavigationPath()
    @State private var heroSelectedModule: CurriculumModule? = nil

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                AppleHIGDesign.Colors.systemGroupedBackground
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppleHIGDesign.Spacing.lg) {
                        topHeaderSection
                            .padding(.top, AppleHIGDesign.Spacing.sm)

                        continueLearningHeroCard

                        dailyGoalCard

                        if let word = session.wordOfTheDay {
                            WordOfTheDayCard(word: word) {
                                session.audioService.play(name: word.audioFile, rate: 1.0)
                            }
                            .scaleEffect(animateCards ? 1.0 : 0.96)
                            .opacity(animateCards ? 1.0 : 0)
                        }

                        progressMetricsSection

                        learnSection

                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, AppleHIGDesign.Spacing.screenMargin)
                    .padding(.bottom, 60)
                }
                .scrollIndicators(.hidden)
            }
            .onAppear {
                session.checkWordOfTheDay()
                updateLearnModules()
                withAnimation(AppleHIGDesign.Animation.smooth) {
                    animateHero = true
                }
                withAnimation(AppleHIGDesign.Animation.smooth.delay(0.1)) {
                    animateCards = true
                }
                withAnimation(AppleHIGDesign.Animation.bouncy.delay(0.25)) {
                    animateStreak = true
                }
                withAnimation(Animation.easeInOut(duration: 1.2).delay(0.8).repeatForever(autoreverses: true)) {
                    streakPulse = true
                }
            }
            .onReceive(session.objectWillChange) { _ in
                updateLearnModules()
            }
            .navigationDestination(for: String.self) { moduleTitle in
                destinationViewForTitle(moduleTitle)
            }
            .navigationBarHidden(true)
            .fullScreenCover(item: $heroSelectedModule) { module in
                LessonEngineView(module: module)
                    .environmentObject(session)
            }
        }
    }

    // MARK: - Navigation Routing
    private func navigateToModule(_ module: LearnModule) {
        navigationPath.append(module.title)
    }

    @ViewBuilder
    private func destinationViewForTitle(_ title: String) -> some View {
        switch title {
        case "Alphabet":
            AlphabetHubView()
        case "Lessons":
            ProfessionalLessonsHubView()
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

    // MARK: - Top Header Section
    private var topHeaderSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(greetingSubtitle)
                    .font(AppleHIGDesign.Typography.caption1)
                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)

                HStack(spacing: 6) {
                    Text("మనా తెలుగు")
                        .font(AppleHIGDesign.Typography.teluguMedium)
                        .foregroundColor(AppleHIGDesign.Colors.label)

                    Text("• Mana Telugu")
                        .font(AppleHIGDesign.Typography.subheadline.weight(.semibold))
                        .foregroundColor(AppleHIGDesign.Colors.primary)
                }
            }

            Spacer()

            NavigationLink(destination: GamificationDashboardView()) {
                HStack(spacing: 5) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(session.currentStreak > 0 ? AppleHIGDesign.Colors.primary : AppleHIGDesign.Colors.tertiaryLabel)
                        .scaleEffect(streakPulse && session.currentStreak > 0 ? 1.15 : 1.0)

                    Text("\(session.currentStreak)")
                        .font(AppleHIGDesign.Typography.headline)
                        .foregroundColor(AppleHIGDesign.Colors.label)

                    Text("days")
                        .font(AppleHIGDesign.Typography.caption2.weight(.medium))
                        .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(AppleHIGDesign.Colors.secondarySystemGroupedBackground)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(AppleHIGDesign.Colors.separator.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: AppleHIGDesign.Shadow.subtle.color, radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            .scaleEffect(animateStreak ? 1.0 : 0.8)
            .opacity(animateStreak ? 1.0 : 0)
        }
    }

    private var greetingSubtitle: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default: return "Good Night"
        }
    }

    // MARK: - Continue Learning Hero Card ("What should I do next?")
    private var continueLearningHeroCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.xxl)
                .fill(AppleHIGDesign.TeluguPalette.heroGradient)
                .shadow(color: AppleHIGDesign.TeluguPalette.midnightIndigo.opacity(0.25), radius: 12, x: 0, y: 6)

            Text("తె")
                .font(.system(size: 140, weight: .bold))
                .foregroundColor(.white.opacity(0.06))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                .offset(x: 20, y: 15)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.md) {
                HStack {
                    Text("RECOMMENDED AI LESSON")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1.2)
                        .foregroundColor(.white.opacity(0.75))

                    Spacer()

                    Label("5 min", systemImage: "clock.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Capsule())
                }

                let currentModule = curriculumRepo.module(byNumber: session.completedLessons + 1) ?? curriculumRepo.modules.first

                VStack(alignment: .leading, spacing: 4) {
                    Text(currentModule != nil ? "Module \(currentModule!.moduleNumber): \(currentModule!.title)" : "Welcome to Telugu")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)

                    if let desc = currentModule?.description {
                        Text(desc)
                            .font(AppleHIGDesign.Typography.subheadline)
                            .foregroundColor(.white.opacity(0.80))
                            .lineLimit(2)
                    } else {
                        Text("Start learning Telugu step-by-step.")
                            .font(AppleHIGDesign.Typography.subheadline)
                            .foregroundColor(.white.opacity(0.80))
                    }
                }

                Spacer().frame(height: 2)

                if let targetModule = currentModule {
                    Button {
                        heroSelectedModule = targetModule
                        AppleHIGDesign.Haptics.selection()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text("Start Lesson")
                                .font(AppleHIGDesign.Typography.bodyEmphasized)
                        }
                        .foregroundColor(AppleHIGDesign.TeluguPalette.midnightIndigo)
                        .padding(.horizontal, AppleHIGDesign.Spacing.xl)
                        .padding(.vertical, AppleHIGDesign.Spacing.sm)
                        .background(AppleHIGDesign.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.button))
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(AppleHIGDesign.Spacing.xl)
        }
        .frame(height: 200)
        .scaleEffect(animateHero ? 1.0 : 0.95)
        .opacity(animateHero ? 1.0 : 0)
    }

    // MARK: - Daily Goal Card
    private var dailyGoalCard: some View {
        let goal = session.dailyGoal
        let todayXP = session.todayXP
        let ratio = min(Double(todayXP) / Double(goal > 0 ? goal : 100), 1.0)
        let isGoalReached = todayXP >= goal

        return HStack(spacing: AppleHIGDesign.Spacing.lg) {
            ZStack {
                Circle()
                    .stroke(AppleHIGDesign.Colors.tertiarySystemFill, lineWidth: 6)
                    .frame(width: 52, height: 52)

                Circle()
                    .trim(from: 0, to: CGFloat(ratio))
                    .stroke(
                        isGoalReached ? AppleHIGDesign.Colors.success : AppleHIGDesign.Colors.primary,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 52, height: 52)
                    .rotationEffect(.degrees(-90))

                Image(systemName: isGoalReached ? "checkmark" : "target")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isGoalReached ? AppleHIGDesign.Colors.success : AppleHIGDesign.Colors.primary)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text("Daily Learning Goal")
                        .font(AppleHIGDesign.Typography.headline)
                        .foregroundColor(AppleHIGDesign.Colors.label)

                    Spacer()

                    Text("\(todayXP) / \(goal) XP")
                        .font(AppleHIGDesign.Typography.subheadline.weight(.semibold))
                        .foregroundColor(isGoalReached ? AppleHIGDesign.Colors.success : AppleHIGDesign.Colors.primary)
                }

                Text(isGoalReached ? "Daily goal accomplished!" : "\(max(0, goal - todayXP)) XP remaining to complete your daily goal")
                    .font(AppleHIGDesign.Typography.caption1)
                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
            }
        }
        .padding(AppleHIGDesign.Spacing.lg)
        .background(AppleHIGDesign.Colors.secondarySystemGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.card))
        .shadow(color: AppleHIGDesign.Shadow.subtle.color, radius: AppleHIGDesign.Shadow.subtle.radius, x: 0, y: AppleHIGDesign.Shadow.subtle.y)
        .scaleEffect(animateCards ? 1.0 : 0.96)
        .opacity(animateCards ? 1.0 : 0)
    }

    // MARK: - Progress Metrics Section
    private var progressMetricsSection: some View {
        HStack(spacing: AppleHIGDesign.Spacing.md) {
            metricCard(
                title: "Letters",
                value: "\(session.learnedLetters)/\(session.totalLetters)",
                subtitle: "Alphabet Mastered",
                icon: "character.book.closed.fill",
                color: AppleHIGDesign.Colors.primary,
                action: { navigateToModule(LearnModule(title: "Alphabet", progress: 0.5, icon: "", color: .orange)) }
            )

            metricCard(
                title: "Words",
                value: "\(session.masteredWords)",
                subtitle: "Vocabulary Learnt",
                icon: "text.book.closed.fill",
                color: AppleHIGDesign.TeluguPalette.terracotta,
                action: { navigateToModule(LearnModule(title: "Vocabulary", progress: 0.5, icon: "", color: .orange)) }
            )

            metricCard(
                title: "Lessons",
                value: "\(session.completedLessons)/48",
                subtitle: "Modules Completed",
                icon: "checkmark.seal.fill",
                color: AppleHIGDesign.Colors.success,
                action: { navigateToModule(LearnModule(title: "Lessons", progress: 0.5, icon: "", color: .orange)) }
            )
        }
        .scaleEffect(animateCards ? 1.0 : 0.96)
        .opacity(animateCards ? 1.0 : 0)
    }

    private func metricCard(title: String, value: String, subtitle: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(color)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(value)
                        .font(AppleHIGDesign.Typography.title3)
                        .foregroundColor(AppleHIGDesign.Colors.label)

                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                        .lineLimit(1)
                }
            }
            .padding(AppleHIGDesign.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppleHIGDesign.Colors.secondarySystemGroupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.card))
            .shadow(color: AppleHIGDesign.Shadow.subtle.color, radius: AppleHIGDesign.Shadow.subtle.radius, x: 0, y: AppleHIGDesign.Shadow.subtle.y)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Learn Section
    private var learnSection: some View {
        VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.md) {
            HStack {
                Text("Explore Core Skills")
                    .font(AppleHIGDesign.Typography.title3)
                    .foregroundColor(AppleHIGDesign.Colors.label)
                Spacer()
            }

            VStack(spacing: AppleHIGDesign.Spacing.sm) {
                ForEach(learnModules) { module in
                    learnModuleCard(module: module)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.96)
        .opacity(animateCards ? 1.0 : 0)
    }

    private func learnModuleCard(module: LearnModule) -> some View {
        Button {
            if module.isEnabled {
                navigateToModule(module)
                AppleHIGDesign.Haptics.selection()
            }
        } label: {
            HStack(spacing: AppleHIGDesign.Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: module.gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: module.icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(module.title)
                            .font(AppleHIGDesign.Typography.headline)
                            .foregroundColor(AppleHIGDesign.Colors.label)

                        Spacer()

                        if !module.isEnabled {
                            Text("Coming Soon")
                                .font(AppleHIGDesign.Typography.caption2.weight(.bold))
                                .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(AppleHIGDesign.Colors.tertiarySystemFill)
                                .clipShape(Capsule())
                        } else {
                            Text("\(Int(module.progress * 100))%")
                                .font(AppleHIGDesign.Typography.caption1.weight(.semibold))
                                .foregroundColor(module.color)
                        }
                    }

                    ProgressView(value: module.isEnabled ? module.progress : 0)
                        .tint(module.color)
                        .scaleEffect(y: 1.2)
                }

                if module.isEnabled {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppleHIGDesign.Colors.tertiaryLabel)
                }
            }
            .padding(AppleHIGDesign.Spacing.lg)
            .background(AppleHIGDesign.Colors.secondarySystemGroupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.card))
            .shadow(color: AppleHIGDesign.Shadow.subtle.color, radius: AppleHIGDesign.Shadow.subtle.radius, x: 0, y: AppleHIGDesign.Shadow.subtle.y)
            .opacity(module.isEnabled ? 1.0 : 0.6)
        }
        .buttonStyle(.plain)
        .disabled(!module.isEnabled)
    }

    private func updateLearnModules() {
        let letterProgress = Double(session.learnedLetters) / Double(max(1, session.totalLetters))
        let lessonProgress = Double(session.completedLessons) / Double(max(1, session.totalLessons))
        let wordProgress = Double(session.masteredWords) / Double(max(1, session.totalWords))

        learnModules = [
            LearnModule(
                title: "Alphabet",
                progress: letterProgress,
                icon: "character.book.closed.fill",
                color: AppleHIGDesign.Colors.primary,
                gradientColors: [Color.orange, Color.red]
            ),
            LearnModule(
                title: "Lessons",
                progress: lessonProgress,
                icon: "book.fill",
                color: AppleHIGDesign.TeluguPalette.terracotta,
                gradientColors: [Color.orange, Color.brown]
            ),
            LearnModule(
                title: "Vocabulary",
                progress: wordProgress,
                icon: "text.book.closed.fill",
                color: AppleHIGDesign.Colors.success,
                gradientColors: [Color.green, Color.teal]
            ),
            LearnModule(
                title: "Stories",
                progress: 0.25,
                icon: "books.vertical.fill",
                color: Color.purple,
                gradientColors: [Color.purple, Color.indigo]
            ),
            LearnModule(
                title: "Games",
                progress: 0.60,
                icon: "gamecontroller.fill",
                color: Color.blue,
                gradientColors: [Color.blue, Color.cyan]
            )
        ]
    }
}
