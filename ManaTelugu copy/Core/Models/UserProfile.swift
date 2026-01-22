import Foundation

struct LegacyXPEvent: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let points: Int
    let reason: String
}


struct UserProfile: Codable {
    var name: String
    var kidMode: Bool
    var unlockedBadges: [String] = []
    var streakDays: Int = 0
    var parentPin: String? = nil
    var currentStreak: Int = 0
    var totalXP: Int = 0
    var level: Int = 1
}