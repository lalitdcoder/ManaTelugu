import SwiftUI

struct LessonsHubView: View {
    @EnvironmentObject var session: AppSession
    @StateObject private var lessonsRepository = LessonsRepository()
    @State private var showingLevelCompletionAlert = false
    @State private var completedLevelTitle = ""
    @State private var nextLevelTitle = ""
    @State private var showingAllLessons: [String: Bool] = [:]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: MTSpacing.large) {
                    headerSection
                    
                    ForEach(lessonsRepository.levels) { level in
                        LevelCardView(
                            level: level,
                            progress: lessonsRepository.getLevelProgress(level.id),
                            isUnlocked: lessonsRepository.isLevelUnlocked(level, userXP: session.userProfile.totalXP),
                            lessonsRepository: lessonsRepository,
                            showingAllLessons: $showingAllLessons
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
        }
        .alert("Level Complete! 🎉", isPresented: $showingLevelCompletionAlert) {
            Button("Continue") { }
        } message: {
            Text("Great job completing \(completedLevelTitle)! Ready for the next level?")
        }
        .onReceive(lessonsRepository.$levelProgress) { _ in
            checkForLevelCompletion()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: MTSpacing.small) {
            Text("Learn Telugu")
                .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            Text("Structured lessons from beginner to advanced")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
        }
    }
    
    private func checkForLevelCompletion() {
        for level in lessonsRepository.levels {
            if let progress = lessonsRepository.getLevelProgress(level.id),
               progress.isCompleted,
               let completionDate = progress.completionDate,
               Date().timeIntervalSince(completionDate) < 5 { // Show alert for recently completed levels
                
                completedLevelTitle = level.title
                if let nextLevel = lessonsRepository.getNextLevel(after: level.id) {
                    nextLevelTitle = nextLevel.title
                } else {
                    nextLevelTitle = "You've completed all levels!"
                }
                showingLevelCompletionAlert = true
                break
            }
        }
    }
}

struct LevelCardView: View {
    let level: LearningLevel
    let progress: LevelProgress?
    let isUnlocked: Bool
    let lessonsRepository: LessonsRepository
    @Binding var showingAllLessons: [String: Bool]
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        let isExpanded = showingAllLessons[level.id] ?? false
        let lessonsToShow = isExpanded ? level.lessons : Array(level.lessons.prefix(2))
        // Show button whenever there are lessons and the view is not expanded yet
        let shouldShowButton = !isExpanded && !level.lessons.isEmpty
        
        VStack(alignment: .leading, spacing: MTSpacing.medium) {
            // Level Header
            HStack {
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
                    difficultyStars
                    
                    if let progress = progress {
                        Text("\(Int(progress.completionPercentage))%")
                            .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.primary)
                    }
                }
            }
            
            // Progress Bar
            if let progress = progress {
                ProgressView(value: progress.completionPercentage / 100.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: level.color)))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            
            // Lessons Grid - Show preview (first 2) or all lessons
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.small), count: 2), spacing: MTSpacing.small) {
                ForEach(lessonsToShow) { lesson in
                    NavigationLink {
                        DuolingoLessonView(lesson: lesson, lessonsRepository: lessonsRepository)
                    } label: {
                        LessonCardView(lesson: lesson, lessonsRepository: lessonsRepository)
                    }
                }
            }
            
            // Show button outside grid when not expanded
            if shouldShowButton {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingAllLessons[level.id] = true
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        // If there are more than the preview count, show remaining; otherwise show generic label
                        let remainingCount = max(level.lessons.count - lessonsToShow.count, 0)
                        Text(remainingCount > 0 ? "View \(remainingCount) More Lessons" : "View Lessons")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(MTColors.surfaceAlt)
        )
    }
    
    private var difficultyStars: some View {
        HStack(spacing: 2) {
            ForEach(1...4, id: \.self) { star in
                Image(systemName: star <= level.difficulty ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundColor(star <= level.difficulty ? Color(hex: level.color) : MTColors.text.opacity(0.3))
            }
        }
    }
    
    private var lockedLevelView: some View {
        VStack(spacing: MTSpacing.medium) {
            Image(systemName: "lock.fill")
                .font(.title)
                .foregroundColor(MTColors.text.opacity(0.4))
            
            Text("Requires \(level.requiredXP) XP")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.6))
            
            Text("Current XP: \(session.userProfile.totalXP)")
                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.5))
        }
        .frame(height: 120)
    }
}

struct LessonCardView: View {
    let lesson: Lesson
    let lessonsRepository: LessonsRepository
    @EnvironmentObject var session: AppSession
    
    private var isCompleted: Bool {
        lessonsRepository.isLessonCompleted(lesson.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: MTSpacing.small) {
            HStack {
                Text("Lesson \(lesson.order)")
                    .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.6))
                
                Spacer()
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            
            Text(lesson.title)
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .fontWeight(.medium)
                .foregroundColor(MTColors.text)
                .multilineTextAlignment(.leading)
            
            HStack {
                difficultyStars
                Spacer()
                Text("\(lesson.estimatedMinutes) min")
                    .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.6))
            }
            
            Text("+\(lesson.xpReward) XP")
                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.primary)
                .fontWeight(.medium)
        }
        .padding()
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCompleted ? MTColors.primary.opacity(0.1) : MTColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isCompleted ? MTColors.primary.opacity(0.3) : MTColors.text.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var difficultyStars: some View {
        HStack(spacing: 1) {
            ForEach(1...4, id: \.self) { star in
                Image(systemName: star <= lesson.difficulty ? "star.fill" : "star")
                    .font(.caption2)
                    .foregroundColor(star <= lesson.difficulty ? MTColors.primary : MTColors.text.opacity(0.3))
            }
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
