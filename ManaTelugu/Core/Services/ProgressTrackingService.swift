import Foundation

class ProgressTrackingService: ObservableObject {
    @Published var lessonProgress: [LessonProgress] = []
    
    private let userDefaultsKey = "lessonProgress"
    
    init() {
        loadProgress()
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
    
    private func saveProgressToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(lessonProgress) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([LessonProgress].self, from: data) {
            lessonProgress = decoded
        }
    }
}
