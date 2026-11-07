import Foundation
import Combine

@MainActor
final class LearnerRepository: ObservableObject {
    static let shared = LearnerRepository()

    @Published var skillScores: [String: Double] = [
        "comprehension": 0.5,
        "vocabulary": 0.5,
        "reading": 0.3,
        "writing": 0.2,
        "sentence_construction": 0.4,
        "listening": 0.5,
        "speaking": 0.3
    ]

    @Published var activeMistakes: [LearnerMistake] = []
    @Published var cachedGeneratedLessons: [String: LessonResponse] = [:] // moduleId -> LessonResponse

    private init() {
        loadFromLocalStorage()
    }

    // MARK: - Update Skill Score
    func recordActivityAttempt(activityType: EngineActivityType, isCorrect: Bool, contentId: String? = nil) {
        let skillName: String
        switch activityType {
        case .reading: skillName = "reading"
        case .writing: skillName = "writing"
        case .listening: skillName = "listening"
        case .speaking: skillName = "speaking"
        case .sentenceBuilder: skillName = "sentence_construction"
        case .vocabulary: skillName = "vocabulary"
        default: skillName = "comprehension"
        }

        let current = skillScores[skillName] ?? 0.5
        let delta = isCorrect ? 0.05 : -0.05
        let newScore = min(1.0, max(0.1, current + delta))
        skillScores[skillName] = (newScore * 100).rounded() / 100

        if !isCorrect {
            let mistake = LearnerMistake(
                id: UUID().uuidString,
                userId: "local_user",
                mistakeType: activityType.rawValue,
                contentId: contentId,
                createdAt: ISO8601DateFormatter().string(from: Date())
            )
            activeMistakes.append(mistake)
        } else if let contentId = contentId {
            activeMistakes.removeAll { $0.contentId == contentId }
        }

        saveToLocalStorage()
    }

    // MARK: - Cache & Retrieve Generated Lessons
    func cacheGeneratedLesson(_ lesson: LessonResponse, forModuleId moduleId: String) {
        cachedGeneratedLessons[moduleId] = lesson
        saveToLocalStorage()
    }

    func getCachedLesson(forModuleId moduleId: String) -> LessonResponse? {
        return cachedGeneratedLessons[moduleId]
    }

    // MARK: - Local Storage Persistence
    private func saveToLocalStorage() {
        if let skillsData = try? JSONEncoder().encode(skillScores) {
            UserDefaults.standard.set(skillsData, forKey: "learner_skill_scores")
        }
        if let mistakesData = try? JSONEncoder().encode(activeMistakes) {
            UserDefaults.standard.set(mistakesData, forKey: "learner_active_mistakes")
        }
    }

    private func loadFromLocalStorage() {
        if let skillsData = UserDefaults.standard.data(forKey: "learner_skill_scores"),
           let loadedSkills = try? JSONDecoder().decode([String: Double].self, from: skillsData) {
            self.skillScores = loadedSkills
        }
        if let mistakesData = UserDefaults.standard.data(forKey: "learner_active_mistakes"),
           let loadedMistakes = try? JSONDecoder().decode([LearnerMistake].self, from: mistakesData) {
            self.activeMistakes = loadedMistakes
        }
    }
}
