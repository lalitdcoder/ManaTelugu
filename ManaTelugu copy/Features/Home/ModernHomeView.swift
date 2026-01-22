import SwiftUI

// MARK: - Modern Home View
struct ModernHomeView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedQuickAction: QuickAction?
    @State private var showingProfile = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: AppleHIGDesign.Spacing.lg) {
                    // Header Section
                    headerSection

                    // Quick Actions
                    quickActionsSection

                    // Learning Progress
                    progressSection

                    // Continue Learning
                    continueLearningSectionn

                    // Featured Content
                    featuredSection

                    // Achievements
                    achievementsSection
                }
                .padding(.horizontal, AppleHIGDesign.Spacing.screenMargin)
                .padding(.bottom, AppleHIGDesign.Spacing.xxxl)
            }
            .background(AppleHIGDesign.Colors.systemBackground)
            .navigationTitle("Mana Telugu")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingProfile = true }) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppleHIGDesign.Colors.primary)
                    }
                    .appleHIGAccessibility(
                        label: "Profile",
                        hint: "View your profile and settings",
                        traits: [.isButton]
                    )
                }
            }
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        AppleHIGCard(style: .elevated) {
            VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.xs) {
                        Text("Welcome back!")
                            .font(AppleHIGDesign.Typography.headline)
                            .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)

                        Text("Ready to learn Telugu?")
                            .font(AppleHIGDesign.Typography.title2)
                            .foregroundColor(AppleHIGDesign.Colors.label)
                    }

                    Spacer()

                    TeluguStreakBadge(streakCount: session.currentStreak, size: .large)
                }

                // Daily goal progress
                VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.xs) {
                    HStack {
                        Text("Today's Goal")
                            .font(AppleHIGDesign.Typography.subheadline.weight(.medium))
                            .foregroundColor(AppleHIGDesign.Colors.label)

                        Spacer()

                        Text("\(session.todayXP)/\(session.dailyGoal) XP")
                            .font(AppleHIGDesign.Typography.caption1.weight(.medium))
                            .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                    }

                    SwiftUI.ProgressView(
                        value: Double(session.todayXP), total: Double(session.dailyGoal)
                    )
                    .tint(AppleHIGDesign.Colors.primary)
                    .scaleEffect(y: 2)
                }
            }
        }
    }

    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.md) {
            Text("Quick Start")
                .font(AppleHIGDesign.Typography.title3)
                .foregroundColor(AppleHIGDesign.Colors.label)

            let columns =
                horizontalSizeClass == .regular
                ? Array(repeating: GridItem(.flexible()), count: 4)
                : Array(repeating: GridItem(.flexible()), count: 2)

            LazyVGrid(columns: columns, spacing: AppleHIGDesign.Spacing.md) {
                ForEach(QuickAction.allCases, id: \.self) { action in
                    QuickActionCard(action: action) {
                        selectedQuickAction = action
                        HapticsManager.shared.impact(.medium)
                    }
                }
            }
        }
    }

    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.md) {
            Text("Your Progress")
                .font(AppleHIGDesign.Typography.title3)
                .foregroundColor(AppleHIGDesign.Colors.label)

            let columns =
                horizontalSizeClass == .regular
                ? Array(repeating: GridItem(.flexible()), count: 3)
                : Array(repeating: GridItem(.flexible()), count: 2)

            LazyVGrid(columns: columns, spacing: AppleHIGDesign.Spacing.md) {
                AppleHIGProgressCard(
                    title: "Letters Learned",
                    progress: Double(session.learnedLetters) / Double(session.totalLetters),
                    value: "\(session.learnedLetters)/\(session.totalLetters)",
                    color: AppleHIGDesign.Colors.vowelColor
                )

                AppleHIGProgressCard(
                    title: "Words Mastered",
                    progress: Double(session.masteredWords) / Double(session.totalWords),
                    value: "\(session.masteredWords)/\(session.totalWords)",
                    color: AppleHIGDesign.Colors.wordColor
                )

                AppleHIGProgressCard(
                    title: "Lessons Completed",
                    progress: Double(session.completedLessons) / Double(session.totalLessons),
                    value: "\(session.completedLessons)/\(session.totalLessons)",
                    color: AppleHIGDesign.Colors.primary
                )
            }
        }
    }

    // MARK: - Continue Learning Section
    private var continueLearningSectionn: some View {
        VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.md) {
            Text("Continue Learning")
                .font(AppleHIGDesign.Typography.title3)
                .foregroundColor(AppleHIGDesign.Colors.label)

            if let currentLesson = session.currentLesson {
                ModernContinueLearningCard(lesson: currentLesson)
            } else {
                StartLearningCard()
            }
        }
    }

    // MARK: - Featured Section
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.md) {
            Text("Featured")
                .font(AppleHIGDesign.Typography.title3)
                .foregroundColor(AppleHIGDesign.Colors.label)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppleHIGDesign.Spacing.md) {
                    ForEach(FeaturedContent.samples, id: \.id) { content in
                        FeaturedContentCard(content: content)
                    }
                }
                .padding(.horizontal, AppleHIGDesign.Spacing.screenMargin)
            }
            .padding(.horizontal, -AppleHIGDesign.Spacing.screenMargin)
        }
    }

    // MARK: - Achievements Section
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.md) {
            HStack {
                Text("Recent Achievements")
                    .font(AppleHIGDesign.Typography.title3)
                    .foregroundColor(AppleHIGDesign.Colors.label)

                Spacer()

                Button("View All") {
                    // Navigate to achievements
                }
                .font(AppleHIGDesign.Typography.subheadline)
                .foregroundColor(AppleHIGDesign.Colors.primary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppleHIGDesign.Spacing.md) {
                    ForEach(session.recentAchievements, id: \.id) { achievement in
                        TeluguAchievementBadge(achievement: achievement, isUnlocked: true)
                            .frame(width: 120)
                    }
                }
                .padding(.horizontal, AppleHIGDesign.Spacing.screenMargin)
            }
            .padding(.horizontal, -AppleHIGDesign.Spacing.screenMargin)
        }
    }
}

// MARK: - Quick Action
enum QuickAction: String, CaseIterable {
    case learnLetters = "Learn Letters"
    case practiceWords = "Practice Words"
    case playGames = "Play Games"
    case takeQuiz = "Take Quiz"

    var icon: String {
        switch self {
        case .learnLetters: return "textformat.abc"
        case .practiceWords: return "book.fill"
        case .playGames: return "gamecontroller.fill"
        case .takeQuiz: return "questionmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .learnLetters: return AppleHIGDesign.Colors.vowelColor
        case .practiceWords: return AppleHIGDesign.Colors.wordColor
        case .playGames: return AppleHIGDesign.Colors.systemPink
        case .takeQuiz: return AppleHIGDesign.Colors.systemPurple
        }
    }
}

// MARK: - Quick Action Card
struct QuickActionCard: View {
    let action: QuickAction
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            AppleHIGCard(style: .elevated) {
                VStack(spacing: AppleHIGDesign.Spacing.sm) {
                    ZStack {
                        Circle()
                            .fill(action.color.opacity(0.1))
                            .frame(width: 50, height: 50)

                        Image(systemName: action.icon)
                            .font(.title2)
                            .foregroundColor(action.color)
                    }

                    Text(action.rawValue)
                        .font(AppleHIGDesign.Typography.subheadline.weight(.medium))
                        .foregroundColor(AppleHIGDesign.Colors.label)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(AppleHIGDesign.Spacing.sm)
            }
        }
        .buttonStyle(AppleHIGButtonStyle(style: .tertiary, size: .medium))
        .appleHIGAccessibility(
            label: action.rawValue,
            hint: "Double tap to start \(action.rawValue.lowercased())",
            traits: [.isButton]
        )
    }
}

// MARK: - Apple HIG Progress Card
struct AppleHIGProgressCard: View {
    let title: String
    let progress: Double
    let value: String
    let color: Color

    var body: some View {
        AppleHIGCard(style: .elevated) {
            VStack(spacing: AppleHIGDesign.Spacing.sm) {
                HStack {
                    Text(title)
                        .font(AppleHIGDesign.Typography.subheadline.weight(.medium))
                        .foregroundColor(AppleHIGDesign.Colors.label)
                        .lineLimit(1)

                    Spacer()
                }

                HStack {
                    TeluguProgressRing(progress: progress, size: 40, color: color)

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text(value)
                            .font(AppleHIGDesign.Typography.headline)
                            .foregroundColor(AppleHIGDesign.Colors.label)

                        Text("\(Int(progress * 100))%")
                            .font(AppleHIGDesign.Typography.caption1)
                            .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                    }
                }
            }
        }
        .appleHIGAccessibility(
            label: "\(title): \(value), \(Int(progress * 100)) percent complete",
            traits: [.isStaticText]
        )
    }
}

// MARK: - Modern Continue Learning Card
struct ModernContinueLearningCard: View {
    let lesson: Lesson

    var body: some View {
        AppleHIGCard(style: .elevated) {
            HStack(spacing: AppleHIGDesign.Spacing.md) {
                // Lesson icon
                ZStack {
                    RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.md)
                        .fill(AppleHIGDesign.Colors.primary.opacity(0.1))
                        .frame(width: 60, height: 60)

                    Image(systemName: "book.fill")
                        .font(.title2)
                        .foregroundColor(AppleHIGDesign.Colors.primary)
                }

                // Lesson info
                VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.xs) {
                    Text(lesson.title)
                        .font(AppleHIGDesign.Typography.headline)
                        .foregroundColor(AppleHIGDesign.Colors.label)

                    Text(lesson.description)
                        .font(AppleHIGDesign.Typography.subheadline)
                        .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                        .lineLimit(2)

                    SwiftUI.ProgressView(value: 0.6)
                        .tint(AppleHIGDesign.Colors.primary)
                        .scaleEffect(y: 1.5)
                }

                Spacer()

                // Continue button
                Button("Continue") {
                    // Navigate to lesson
                }
                .buttonStyle(AppleHIGButtonStyle(style: .primary, size: .medium))
            }
        }
    }
}

// MARK: - Start Learning Card
struct StartLearningCard: View {
    var body: some View {
        AppleHIGCard(style: .filled) {
            VStack(spacing: AppleHIGDesign.Spacing.md) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppleHIGDesign.Colors.primary)

                Text("Start Your Telugu Journey")
                    .font(AppleHIGDesign.Typography.headline)
                    .foregroundColor(AppleHIGDesign.Colors.label)

                Text("Begin with the basics and learn Telugu letters, words, and pronunciation.")
                    .font(AppleHIGDesign.Typography.subheadline)
                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                    .multilineTextAlignment(.center)

                Button("Get Started") {
                    // Navigate to first lesson
                }
                .buttonStyle(AppleHIGButtonStyle(style: .primary, size: .large))
            }
            .padding(AppleHIGDesign.Spacing.lg)
        }
    }
}

// MARK: - Featured Content
struct FeaturedContent {
    let id = UUID()
    let title: String
    let description: String
    let image: String
    let color: Color

    static let samples = [
        FeaturedContent(
            title: "Telugu Festivals",
            description: "Learn about traditional Telugu festivals and celebrations",
            image: "party.popper.fill",
            color: AppleHIGDesign.Colors.systemOrange
        ),
        FeaturedContent(
            title: "Telugu Poetry",
            description: "Discover beautiful Telugu poems and their meanings",
            image: "book.pages.fill",
            color: AppleHIGDesign.Colors.systemPurple
        ),
        FeaturedContent(
            title: "Telugu Songs",
            description: "Learn Telugu through popular songs and music",
            image: "music.note",
            color: AppleHIGDesign.Colors.systemPink
        ),
    ]
}

// MARK: - Featured Content Card
struct FeaturedContentCard: View {
    let content: FeaturedContent

    var body: some View {
        AppleHIGCard(style: .elevated) {
            VStack(alignment: .leading, spacing: AppleHIGDesign.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.md)
                        .fill(content.color.opacity(0.1))
                        .frame(height: 80)

                    Image(systemName: content.image)
                        .font(.system(size: 30))
                        .foregroundColor(content.color)
                }

                Text(content.title)
                    .font(AppleHIGDesign.Typography.headline)
                    .foregroundColor(AppleHIGDesign.Colors.label)

                Text(content.description)
                    .font(AppleHIGDesign.Typography.caption1)
                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                    .lineLimit(3)
            }
        }
        .frame(width: 200)
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Text("Profile View")
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
