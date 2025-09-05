import Foundation

struct XPEvent: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let points: Int
    let reason: String
}

struct UserProfile: Codable {
    var kidMode: Bool
    var streakDays: Int
    var lastOpened: Date?
    var totalXP: Int
    var dailyLearningMinutes: Int
    var lastLearningDate: Date?
    var dailyGoalMinutes: Int
    var unlockedBadges: Set<String> = []
    var lettersMastered: Int = 0
    var lessonsCompleted: Int = 0
    var wordsMastered: Int = 0
}