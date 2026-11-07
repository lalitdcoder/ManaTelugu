import Combine
import Foundation

struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    let name: String
    let rank: Int
    let score: Int
    let isCurrentUser: Bool
}

class LocalLeaderboardService: ObservableObject {
    @Published var leaderboard: [LeaderboardEntry] = []

    init() {
        generateLeaderboard(userScore: 0)
    }

    func generateLeaderboard(userScore: Int) {
        let fakeNames = [
            "Raju", "Anitha", "Krishna", "Priya", "Rahul",
            "Sneha", "Vikram", "Swathi", "Arjun", "Kavya",
        ]

        var entries: [LeaderboardEntry] = []

        // Add fake users
        for (_, name) in fakeNames.enumerated() {
            // Generate scores around the user's score to make it competitive
            let randomVariance = Int.random(in: -500...500)
            let score = max(0, userScore + randomVariance)

            entries.append(
                LeaderboardEntry(
                    id: UUID(),
                    name: name,
                    rank: 0,  // Will sort later
                    score: score,
                    isCurrentUser: false
                ))
        }

        // Add current user
        entries.append(
            LeaderboardEntry(
                id: UUID(),
                name: "You",
                rank: 0,
                score: userScore,
                isCurrentUser: true
            ))

        // Sort by score
        entries.sort { $0.score > $1.score }

        // Assign ranks
        for i in 0..<entries.count {
            let entry = entries[i]
            entries[i] = LeaderboardEntry(
                id: entry.id,
                name: entry.name,
                rank: i + 1,
                score: entry.score,
                isCurrentUser: entry.isCurrentUser
            )
        }

        self.leaderboard = entries
    }
}
