import SwiftUI

// MARK: - Premium Lesson Card
struct ProfessionalLessonCard: View {
    let lesson: ProfessionalLesson

    var body: some View {
        ManaCard(style: lesson.isLocked ? .outlined : .elevated) {
            HStack(spacing: ManaTheme.Spacing.md) {
                // Lesson Status Icon Ring
                ZStack {
                    Circle()
                        .fill(
                            lesson.isLocked
                                ? ManaTheme.Colors.fill
                                : lesson.difficulty.color.opacity(0.15)
                        )
                        .frame(width: 48, height: 48)

                    if lesson.isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(ManaTheme.Colors.tertiaryLabel)
                    } else if lesson.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(ManaTheme.Colors.emeraldGreen)
                    } else {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(lesson.difficulty.color)
                    }
                }

                // Lesson Title & Details
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(lesson.title)
                            .font(ManaTheme.Typography.headline)
                            .foregroundColor(lesson.isLocked ? ManaTheme.Colors.secondaryLabel : ManaTheme.Colors.label)

                        Spacer()

                        // Difficulty Tag
                        Text(lesson.difficulty.displayName)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(lesson.difficulty.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(lesson.difficulty.color.opacity(0.15))
                            )
                    }

                    Text(lesson.description)
                        .font(ManaTheme.Typography.subheadline)
                        .foregroundColor(lesson.isLocked ? ManaTheme.Colors.tertiaryLabel : ManaTheme.Colors.secondaryLabel)
                        .lineLimit(2)

                    HStack(spacing: 8) {
                        Label(lesson.estimatedTime, systemImage: "clock")
                            .font(ManaTheme.Typography.caption1)
                            .foregroundColor(ManaTheme.Colors.tertiaryLabel)

                        Spacer()

                        if !lesson.isLocked && lesson.progress > 0 {
                            Text("\(Int(lesson.progress * 100))% Complete")
                                .font(ManaTheme.Typography.caption1.weight(.semibold))
                                .foregroundColor(lesson.difficulty.color)
                        }
                    }

                    // Progress Bar
                    if !lesson.isLocked && lesson.progress > 0 {
                        ManaProgressBar(progress: lesson.progress, color: lesson.difficulty.color, height: 4)
                            .padding(.top, 2)
                    }
                }

                // Navigation Chevron
                if !lesson.isLocked {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(ManaTheme.Colors.tertiaryLabel)
                }
            }
        }
    }
}

// MARK: - Premium Lessons Hub View
struct ProfessionalLessonsHubView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var animatedProgress: Double = 0
    @State private var displayedLessons: [ProfessionalLesson] = []

    var body: some View {
        ZStack {
            // Adaptive Grouped Background (Light/Dark aware)
            ManaTheme.Colors.groupedBackground
                .ignoresSafeArea()

            if isLoading {
                VStack(spacing: ManaTheme.Spacing.md) {
                    ProgressView()
                        .scaleEffect(1.3)
                        .tint(ManaTheme.Colors.primary)

                    Text("Loading Lessons...")
                        .font(ManaTheme.Typography.headline)
                        .foregroundColor(ManaTheme.Colors.secondaryLabel)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ManaTheme.Spacing.lg) {
                        // Dynamic Hero Progress Ring Section
                        heroProgressSection

                        // Dynamic Learning Stats
                        learningStatsSection

                        // Available Lessons List
                        lessonsListSection

                        // Bottom padding for tab bar
                        Color.clear.frame(height: 60)
                    }
                    .padding(.horizontal, ManaTheme.Spacing.screenMarginLarge)
                    .padding(.top, ManaTheme.Spacing.sm)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle("Lessons")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadUserLessons()
        }
    }

    // MARK: - Hero Progress Ring Section (Dynamic Data)
    private var heroProgressSection: some View {
        ManaCard(style: .elevated) {
            VStack(spacing: ManaTheme.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("YOUR LEARNING JOURNEY")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(1.0)
                            .foregroundColor(ManaTheme.Colors.secondaryLabel)

                        Text("Telugu Mastery")
                            .font(ManaTheme.Typography.title2)
                            .foregroundColor(ManaTheme.Colors.label)
                    }

                    Spacer()

                    Text("\(Int(calculatedCourseProgress * 100))%")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(ManaTheme.Colors.primary)
                }

                // Animated Circular Ring & Bar
                ZStack {
                    Circle()
                        .stroke(ManaTheme.Colors.secondaryFill, lineWidth: 10)
                        .frame(width: 100, height: 100)

                    Circle()
                        .trim(from: 0, to: animatedProgress)
                        .stroke(
                            LinearGradient(
                                colors: [ManaTheme.Colors.primary, ManaTheme.Colors.primaryLight],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                        .animation(ManaTheme.Animation.smooth, value: animatedProgress)

                    VStack(spacing: 0) {
                        Text("\(completedCount)/\(displayedLessons.count)")
                            .font(ManaTheme.Typography.headline)
                            .foregroundColor(ManaTheme.Colors.label)

                        Text("Lessons")
                            .font(ManaTheme.Typography.caption2)
                            .foregroundColor(ManaTheme.Colors.secondaryLabel)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, ManaTheme.Spacing.xs)

                Text(learningMessage)
                    .font(ManaTheme.Typography.subheadline)
                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            withAnimation(ManaTheme.Animation.smooth.delay(0.2)) {
                animatedProgress = calculatedCourseProgress
            }
        }
    }

    private var calculatedCourseProgress: Double {
        guard !displayedLessons.isEmpty else { return 0 }
        let completed = displayedLessons.filter { $0.isCompleted }.count
        return Double(completed) / Double(displayedLessons.count)
    }

    private var completedCount: Int {
        displayedLessons.filter { $0.isCompleted }.count
    }

    private var learningMessage: String {
        let percent = Int(calculatedCourseProgress * 100)
        if percent == 0 {
            return "Start your first lesson today! Every step counts."
        } else if percent < 50 {
            return "Great momentum! Keep learning new Telugu concepts."
        } else if percent < 100 {
            return "You're more than halfway to Telugu fluency!"
        } else {
            return "Outstanding! You have mastered all available lessons!"
        }
    }

    // MARK: - Dynamic Learning Stats Section
    private var learningStatsSection: some View {
        HStack(spacing: ManaTheme.Spacing.sm) {
            HubStatChip(
                icon: "book.fill",
                value: "\(completedCount)",
                label: "Completed",
                color: ManaTheme.Colors.vowelColor
            )

            HubStatChip(
                icon: "flame.fill",
                value: "\(session.currentStreak)",
                label: "Streak",
                color: ManaTheme.Colors.primary
            )

            HubStatChip(
                icon: "star.fill",
                value: "\(session.gamificationService.gamificationState.totalXP)",
                label: "Total XP",
                color: ManaTheme.Colors.consonantColor
            )
        }
    }

    // MARK: - Lessons List Section
    private var lessonsListSection: some View {
        VStack(alignment: .leading, spacing: ManaTheme.Spacing.sm) {
            Text("Available Lessons")
                .font(ManaTheme.Typography.title3)
                .foregroundColor(ManaTheme.Colors.label)

            VStack(spacing: ManaTheme.Spacing.sm) {
                ForEach(Array(displayedLessons.enumerated()), id: \.element.id) { index, lesson in
                    NavigationLink(
                        destination: LessonFlowView(lesson: convertToTeluguLesson(lesson, index: index))
                    ) {
                        ProfessionalLessonCard(lesson: lesson)
                    }
                    .buttonStyle(.plain)
                    .disabled(lesson.isLocked)
                }
            }
        }
    }

    private func loadUserLessons() {
        isLoading = true
        Task {
            let lessonsRepo = LessonsRepository()
            await lessonsRepo.loadLevels()

            let trackedLessons = session.progressTrackingService.lessonProgress

            let mapped = lessonsRepo.levels.flatMap { level in
                level.lessons.map { lesson -> ProfessionalLesson in
                    let isComp = trackedLessons.first(where: { $0.lessonId == lesson.id })?.isCompleted ?? false
                    let prog = trackedLessons.first(where: { $0.lessonId == lesson.id })?.accuracy ?? (isComp ? 1.0 : 0.0)
                    return ProfessionalLesson(lesson: lesson, isCompleted: isComp, progress: prog, isLocked: false)
                }
            }

            DispatchQueue.main.async {
                self.displayedLessons = mapped
                self.isLoading = false
                withAnimation(ManaTheme.Animation.smooth) {
                    self.animatedProgress = self.calculatedCourseProgress
                }
            }
        }
    }

    private func convertToTeluguLesson(_ professionalLesson: ProfessionalLesson, index: Int) -> TeluguLesson {
        if index < teluguLessons.count {
            return teluguLessons[index]
        }

        return TeluguLesson(
            id: index + 1,
            title: professionalLesson.title,
            letters: [],
            isUnlocked: !professionalLesson.isLocked,
            isCompleted: professionalLesson.isCompleted
        )
    }
}

// MARK: - Hub Stat Chip
struct HubStatChip: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        ManaCard(style: .elevated, padding: ManaTheme.Spacing.sm) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)

                Text(value)
                    .font(ManaTheme.Typography.headline)
                    .foregroundColor(ManaTheme.Colors.label)

                Text(label)
                    .font(ManaTheme.Typography.caption2)
                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Professional Lesson Model
struct ProfessionalLesson {
    let id: String
    let title: String
    let description: String
    let progress: Double
    let difficulty: DifficultyLevel
    let estimatedTime: String
    let isCompleted: Bool
    let isLocked: Bool

    init(lesson: Lesson, isCompleted: Bool = false, progress: Double = 0.0, isLocked: Bool = false) {
        self.id = lesson.id
        self.title = lesson.title
        self.description = lesson.description
        self.progress = progress
        self.difficulty = ProfessionalLesson.mapDifficulty(from: lesson.difficulty)
        self.estimatedTime = "\(lesson.estimatedMinutes) min"
        self.isCompleted = isCompleted
        self.isLocked = isLocked
    }

    enum DifficultyLevel {
        case beginner
        case intermediate
        case advanced

        var displayName: String {
            switch self {
            case .beginner: return "Beginner"
            case .intermediate: return "Intermediate"
            case .advanced: return "Advanced"
            }
        }

        var color: Color {
            switch self {
            case .beginner: return ManaTheme.Colors.emeraldGreen
            case .intermediate: return ManaTheme.Colors.primary
            case .advanced: return ManaTheme.Colors.royalIndigo
            }
        }
    }

    static func mapDifficulty(from intDifficulty: Int) -> DifficultyLevel {
        switch intDifficulty {
        case 1: return .beginner
        case 2: return .intermediate
        case 3: return .advanced
        default: return .beginner
        }
    }
}

typealias LessonsHubView = ProfessionalLessonsHubView
