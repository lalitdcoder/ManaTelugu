import SwiftUI

import SwiftUI

// MARK: - Professional Lesson Card
struct ProfessionalLessonCard: View {
    let lesson: ProfessionalLesson
    @State private var isPressed = false

    var body: some View {
        ProfessionalCard(
            type: lesson.isLocked ? .secondary : .interactive,
            isInteractive: !lesson.isLocked
        ) {
            HStack(spacing: ProfessionalSpacing.medium.value) {
                // Lesson Icon
                ZStack {
                    Circle()
                        .fill(lesson.isLocked ? Color.gray.opacity(0.3) : lesson.difficulty.color.opacity(0.15))
                        .frame(width: 50, height: 50)

                    if lesson.isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.gray)
                    } else if lesson.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.professionalGreen)
                    } else {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(lesson.difficulty.color)
                    }
                }

                // Lesson Content
                VStack(alignment: .leading, spacing: ProfessionalSpacing.small.value) {
                    HStack {
                        ProfessionalText(
                            lesson.title,
                            style: .cardTitle,
                            color: lesson.isLocked ? .textSecondary : .textPrimary
                        )

                        Spacer()

                        // Difficulty Badge
                        Text(lesson.difficulty.displayName)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(lesson.difficulty.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(lesson.difficulty.color.opacity(0.15))
                            )
                    }

                    ProfessionalText(
                        lesson.description,
                        style: .bodyText,
                        color: lesson.isLocked ? .textTertiary : .textSecondary
                    )

                    HStack {
                        ProfessionalText(
                            lesson.estimatedTime,
                            style: .caption,
                            color: .textSecondary
                        )

                        Spacer()

                        if !lesson.isLocked && lesson.progress > 0 {
                            ProfessionalText(
                                "\(Int(lesson.progress * 100))% Complete",
                                style: .caption,
                                color: lesson.difficulty.color
                            )
                        }
                    }

                    // Progress Bar
                    if !lesson.isLocked && lesson.progress > 0 {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.black.opacity(0.1))
                                    .frame(height: 4)

                                RoundedRectangle(cornerRadius: 2)
                                    .fill(lesson.difficulty.color)
                                    .frame(width: geometry.size.width * lesson.progress, height: 4)
                            }
                        }
                        .frame(height: 4)
                    }
                }

                // Arrow
                if !lesson.isLocked {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }
}

// MARK: - Professional Lessons Hub View
// Clean, vertical layout with inspiring progress visualization

struct ProfessionalLessonsHubView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var animatedProgress: Double = 0
    @State private var displayedLessons: [ProfessionalLesson] = []
    
    var body: some View {
        ZStack {
            // Subtle gradient background matching the rest of the app
            LinearGradient(
                colors: [
                    Color(red: 0.97, green: 0.98, blue: 1.0),
                    AppleHIGDesign.Colors.systemBackground
                ],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
                
                if isLoading {
                    ProfessionalCard(type: .hero) {
                        VStack(spacing: ProfessionalSpacing.large.value) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.professionalBlue)
                            
                            ProfessionalText(
                                "Loading Lessons...",
                                style: .cardTitle,
                                color: .textPrimary,
                                alignment: .center
                            )
                        }
                        .padding(ProfessionalSpacing.extraLarge.value)
                    }
                    .padding(.horizontal, ProfessionalSpacing.large.value)
                } else {
                    ScrollView {
                        LazyVStack(spacing: ProfessionalSpacing.large.value) {
                            // Hero Progress Section
                            heroProgressSection
                                .padding(.top, -20)
                            
                            // Learning Stats
                            learningStatsSection
                            
                            // Lessons List
                            lessonsListSection
                            
                            // Bottom padding for tab bar
                            Color.clear
                                .frame(height: 120)
                        }
                        .padding(.horizontal, ProfessionalSpacing.medium.value)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationBarHidden(false)
            .navigationTitle("Lessons")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .onAppear {
                // Simulate loading
                isLoading = true
                Task {
                    // Use the proper lessons repository with 10 lessons
                    let lessonsRepo = LessonsRepository()
                    await lessonsRepo.loadLevels()
                    
                    displayedLessons = lessonsRepo.levels.flatMap { level in
                        level.lessons.map { lesson in
                            ProfessionalLesson(lesson: lesson, isLocked: false)
                        }
                    }
                    
                    withAnimation(ProfessionalAnimation.pageTransition) {
                        isLoading = false
                    }
                }
            }
        }
    
    // MARK: - Hero Progress Section
    private var heroProgressSection: some View {
        ProfessionalCard(type: .hero) {
            VStack(alignment: .leading, spacing: ProfessionalSpacing.large.value) {
                // Title
                ProfessionalText(
                    "Your Learning Journey",
                    style: .heroTitle,
                    color: .textPrimary
                )
                
                // Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: animatedProgress)
                        .stroke(
                            LinearGradient(
                                colors: [.professionalBlue, .professionalGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(ProfessionalAnimation.progressUpdate, value: animatedProgress)
                    
                    VStack(spacing: ProfessionalSpacing.tiny.value) {
                        ProfessionalText(
                            "65%",
                            style: .statValue,
                            color: .textPrimary,
                            alignment: .center
                        )
                        
                        ProfessionalText(
                            "Complete",
                            style: .caption,
                            color: .textSecondary,
                            alignment: .center
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Progress Description
                ProfessionalText(
                    "You're doing great! Keep up the momentum.",
                    style: .bodyText,
                    color: .textSecondary,
                    alignment: .center
                )
            }
        }
        .onAppear {
            withAnimation(ProfessionalAnimation.progressUpdate) {
                animatedProgress = 0.65
            }
        }
    }
    
    // MARK: - Learning Stats Section
    private var learningStatsSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Learning Stats",
                subtitle: "Track your progress"
            )
            
            HStack(spacing: ProfessionalSpacing.medium.value) {
                ProfessionalStatCard(
                    icon: "book.fill",
                    value: "12",
                    label: "Lessons",
                    color: .professionalBlue
                )
                
                ProfessionalStatCard(
                    icon: "clock.fill",
                    value: "3h",
                    label: "Time",
                    color: .professionalGreen
                )
                
                ProfessionalStatCard(
                    icon: "star.fill",
                    value: "8",
                    label: "Streak",
                    color: .professionalOrange
                )
            }
        }
    }
    
    // MARK: - Lessons List Section
    private var lessonsListSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Available Lessons",
                subtitle: "Continue your learning"
            )
            
            VStack(spacing: ProfessionalSpacing.medium.value) {
                ForEach(displayedLessons, id: \.id) { lesson in
                    ProfessionalLessonCard(lesson: lesson)
                }
            }
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
    
    init(lesson: Lesson, isLocked: Bool = false) {
        self.id = lesson.id
        self.title = lesson.title
        self.description = lesson.description
        self.progress = 0.0 // Placeholder, actual progress needs to be fetched/calculated
        self.difficulty = ProfessionalLesson.mapDifficulty(from: lesson.difficulty)
        self.estimatedTime = "\(lesson.estimatedMinutes) min"
        self.isCompleted = false // Placeholder, actual completion needs to be fetched
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
            case .beginner: return .professionalGreen
            case .intermediate: return .professionalOrange
            case .advanced: return .professionalPurple
            }
        }
    }
    
    static func mapDifficulty(from intDifficulty: Int) -> DifficultyLevel {
        switch intDifficulty {
        case 1: return .beginner
        case 2: return .intermediate
        case 3: return .advanced
        default: return .beginner // Default to beginner if unknown
        }
    }
} // Closing brace for ProfessionalLesson struct

// MARK: - Replace the original LessonsHubView
typealias LessonsHubView = ProfessionalLessonsHubView
