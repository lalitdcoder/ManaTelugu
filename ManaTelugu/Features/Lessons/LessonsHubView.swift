import SwiftUI

struct LessonsHubView: View {
    @EnvironmentObject var session: AppSession
    private var lessonsRepository: LessonsRepository { session.lessonsRepository }
    @State private var showingLevelCompletionAlert = false
    @State private var completedLevelTitle = ""
    @State private var nextLevelTitle = ""
    @State private var showingAllLessons: [String: Bool] = [:]
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            // Gentle pastel background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.97, green: 0.98, blue: 1.0), MTColors.funBlue.opacity(0.10), MTColors.funGreen.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView("Loading Lessons...")
                    .progressViewStyle(CircularProgressViewStyle(tint: MTColors.funBlue))
                    .scaleEffect(1.5)
                    .foregroundColor(MTColors.text)
            } else if lessonsRepository.levels.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 48))
                        .foregroundColor(MTColors.funBlue.opacity(0.6))
                    Text("No Lessons Available")
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.8))
                    Text("Check back later for new content.")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.6))
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Lessons")
                                .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text)
                            Text("Structured beginner lessons")
                                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text.opacity(0.7))
                        }
                        .padding(.horizontal)
                        
                        // Level Cards
                        VStack(spacing: 28) {
                            ForEach(lessonsRepository.levels) { level in
                                let completedCount = lessonsRepository.getCompletedLessonCount(for: level.id)
                                let totalLessons = level.lessons.count
                                let progressPercentage = totalLessons > 0 ? Double(completedCount) / Double(totalLessons) : 0.0
                                LevelSectionCard(
                                    level: level,
                                    progress: progressPercentage,
                                    isUnlocked: true,
                                    lessonsRepository: lessonsRepository,
                                    showingAllLessons: $showingAllLessons
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .alert("Level Complete! 🎉", isPresented: $showingLevelCompletionAlert) {
                    Button("Continue") { }
                } message: {
                    Text("Great job completing \(completedLevelTitle)! Ready for the next level?")
                }
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBarIcon(systemName: "house.fill", selected: false)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavBarIcon(systemName: "star.fill", selected: false)
            }
        }
        .onAppear {
            Task {
                // Ensure we only load if the data isn't already available
                if lessonsRepository.levels.isEmpty {
                    await lessonsRepository.loadLevels()
                }
                isLoading = false
                checkForLevelCompletion()
            }
        }
    }
    
    private func checkForLevelCompletion() {
        for level in lessonsRepository.levels {
            let completedCount = lessonsRepository.getCompletedLessonCount(for: level.id)
            let totalLessons = level.lessons.count
            if completedCount == totalLessons {
                completedLevelTitle = level.title
                let currentIndex = lessonsRepository.levels.firstIndex { $0.id == level.id } ?? -1
                if currentIndex >= 0 && currentIndex < lessonsRepository.levels.count - 1 {
                    nextLevelTitle = lessonsRepository.levels[currentIndex + 1].title
                } else {
                    nextLevelTitle = "You've completed all levels!"
                }
                showingLevelCompletionAlert = true
                break
            }
        }
    }
}

// MARK: - Level Section Card
struct LevelSectionCard: View {
    let level: LearningLevel
    let progress: Double // 0.0 to 1.0
    let isUnlocked: Bool
    let lessonsRepository: LessonsRepository
    @Binding var showingAllLessons: [String: Bool]
    @EnvironmentObject var session: AppSession
    @State private var isPressed = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(MTColors.funBlue.opacity(0.12))
                        .frame(width: 56, height: 56)
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(MTColors.funBlue)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.title)
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    Text(level.description)
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(progress * 100))%")
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.6))
                    ModernProgressBar(progress: progress)
                        .frame(width: 80)
                }
            }
            .padding(.bottom, 4)
            // Lessons Grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 16) {
                let isExpanded = showingAllLessons[level.id] ?? false
                let lessonsToShow = isExpanded ? level.lessons : Array(level.lessons.prefix(2))
                ForEach(lessonsToShow) { lesson in
                    LessonSectionCard(lesson: lesson, lessonsRepository: lessonsRepository)
                }
            }
            if (showingAllLessons[level.id] ?? false) == false && !level.lessons.isEmpty {
                Button("View All Lessons") {
                    isPressed = true
                    showingAllLessons[level.id] = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { isPressed = false }
                }
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(MTColors.funBlue)
                .cornerRadius(12)
                .shadow(color: MTColors.funBlue.opacity(isPressed ? 0.15 : 0.08), radius: isPressed ? 8 : 4, x: 0, y: 2)
                .scaleEffect(isPressed ? 0.97 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isPressed)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.95))
                .shadow(color: MTColors.funBlue.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .padding(.vertical, 4)
    }
}

// MARK: - Lesson Section Card
struct LessonSectionCard: View {
    let lesson: Lesson
    let lessonsRepository: LessonsRepository
    @EnvironmentObject var session: AppSession
    @State private var animate = false
    private var isCompleted: Bool {
        lessonsRepository.isLessonCompleted(lesson.id)
    }
    var body: some View {
        NavigationLink(destination: DuolingoLessonView(lesson: lesson, lessonsRepository: lessonsRepository).environmentObject(session)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Lesson \(lesson.order)")
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.6))
                    Spacer()
                    if isCompleted {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(MTColors.funGreen)
                            .font(.caption)
                    }
                }
                Text(lesson.title)
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .fontWeight(.medium)
                    .foregroundColor(MTColors.text)
                    .multilineTextAlignment(.leading)
                HStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 18))
                        .foregroundColor(MTColors.funYellow)
                    Text("+\(lesson.xpReward) XP")
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.funYellow)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(lesson.estimatedMinutes) min")
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.6))
                }
            }
            .padding()
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCompleted ? MTColors.funGreen.opacity(0.08) : MTColors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isCompleted ? MTColors.funGreen.opacity(0.3) : MTColors.text.opacity(0.1), lineWidth: 1)
                    )
            )
            .scaleEffect(animate ? 1.04 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: animate)
        }
    }
}
// Reuse ModernProgressBar and NavBarIcon from HomeView
