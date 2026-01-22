import Foundation

class ProgressTracker: ObservableObject {
    static let shared = ProgressTracker()
    
    @Published var streakDays: Int = 0
    @Published var totalXP: Int = 0
    @Published var lettersMastered: Set<String> = []
    @Published var wordsLearned: Set<String> = []
    
    private init() {
        loadProgress()
    }
    
    func loadProgress() {
        // In a real app, this would load from persistent storage
        // For now we'll use default values
    }
    
    func markLetterMastered(_ letterId: String) {
        lettersMastered.insert(letterId)
        awardXP(10)
    }
    
    func markWordLearned(_ wordId: String) {
        wordsLearned.insert(wordId)
        awardXP(5)
    }
    
    func awardXP(_ points: Int) {
        totalXP += points
    }
    
    func updateStreak() {
        streakDays += 1
    }
}