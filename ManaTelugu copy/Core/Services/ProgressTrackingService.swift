import Foundation

class ProgressTrackingService: ObservableObject {
    @Published var lessonProgress: [LessonProgress] = []
    
    private let userDefaultsKey = "lessonProgress"
    private let lessonsRepository: LessonsRepository // Add LessonsRepository dependency
    
    init(lessonsRepository: LessonsRepository) { // Update initializer
        self.lessonsRepository = lessonsRepository
        loadProgress()
    }
    
    var completedLessonsCount: Int {
        lessonProgress.filter { $0.isCompleted }.count
    }
    
    var totalLessonsCount: Int {
        lessonsRepository.levels.reduce(0) { $0 + $1.lessons.count }
    }
    
    /// Computes the overall accuracy across all completed lessons.
    var overallAccuracy: Double {
        let totalCorrect = lessonProgress.reduce(0) { $0 + $1.correctAnswers }
        let totalQuestions = lessonProgress.reduce(0) { $0 + $1.totalQuestions }
        return totalQuestions > 0 ? Double(totalCorrect) / Double(totalQuestions) : 0
    }
    
    func saveProgress(for lesson: Lesson, with responses: [ActivityResponse], timeSpent: TimeInterval) {
        let correctAnswers = responses.filter { $0.isCorrect }.count
        
        let progress = LessonProgress(
            id: UUID().uuidString,
            lessonId: lesson.id,
            userId: "defaultUser", // In a real app, this would be the actual user ID
            isCompleted: true,
            completionDate: Date(),
            xpEarned: responses.map { $0.xpEarned }.reduce(0, +),
            correctAnswers: correctAnswers,
            totalQuestions: responses.count,
            timeSpent: timeSpent,
            attempts: 1, // Simple implementation for now
            activityResponses: responses
        )
        
        lessonProgress.append(progress)
        saveProgressToUserDefaults()
    }
    
    func saveProgressToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(lessonProgress) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
        objectWillChange.send()
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([LessonProgress].self, from: data) {
            lessonProgress = decoded
        }
    }
}
