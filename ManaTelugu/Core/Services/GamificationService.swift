import Combine  // Added for Combine
import Foundation
import SwiftUI

// MARK: - Gamification Service
class GamificationService: ObservableObject {
    @Published var gamificationState = GamificationState()
    @Published var newlyUnlockedBadges: [GamificationBadge] = []
    @Published var treasureChestReward: (sticker: Sticker, xp: Int)? = nil
    @Published var lastXPChange: Int? = nil

    private let treasureChestWordGoal = 10  // Every 10 words, a treasure chest is awarded

    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard
    private let appGroupDefaults = UserDefaults(suiteName: "group.com.LalitDusanapudi.ManaTelugu")
    private let stateKey = "gamification_state"

    init() {
        loadState()
        gamificationState.objectWillChange.sink { [weak self] _ in
            guard let self = self else { return }
            self.objectWillChange.send()
            self.saveGamificationState()
            self.syncWidgetSnapshot()

            // Check for newly unlocked badges on the next run loop to ensure state has changed
            DispatchQueue.main.async {
                self.checkForNewBadges()
            }
        }.store(in: &cancellables)
    }

    private func checkForNewBadges() {
        let unlockedAndUnseen = gamificationState.badges.filter { badge in
            badge.isUnlocked
                && !newlyUnlockedBadges.contains(where: { $0.name == badge.name })
                && !wasBadgeSeen(badge)
        }

        if !unlockedAndUnseen.isEmpty {
            // Cap to at most 2 badges in the queue to show popups for
            let currentCount = newlyUnlockedBadges.count
            let availableSlots = max(0, 2 - currentCount)
            if availableSlots > 0 {
                newlyUnlockedBadges.append(contentsOf: unlockedAndUnseen.prefix(availableSlots))
            }
        }
    }

    func dismissNewlyUnlockedBadge() {
        if !newlyUnlockedBadges.isEmpty {
            let seenBadge = newlyUnlockedBadges.removeFirst()
            markBadgeAsSeen(seenBadge)
        }
    }

    private func wasBadgeSeen(_ badge: GamificationBadge) -> Bool {
        return badge.hasSeenPopup
    }

    private func markBadgeAsSeen(_ badge: GamificationBadge) {
        if let index = gamificationState.badges.firstIndex(where: { $0.name == badge.name }) {
            let current = gamificationState.badges[index]
            gamificationState.badges[index] = GamificationBadge(
                name: current.name,
                teluguName: current.teluguName,
                description: current.description,
                emoji: current.emoji,
                color: current.color,
                xpReward: current.xpReward,
                requirement: current.requirement,
                isUnlocked: current.isUnlocked,
                unlockedAt: current.unlockedAt,
                rarity: current.rarity,
                hasSeenPopup: true
            )
            saveGamificationState()
        }
    }

    // MARK: - Parent Dashboard Stats
    struct WeeklyStats {
        let wordsLearned: Int
        let xpGained: Int
        let badgesEarned: Int
    }

    func getWeeklyStats() -> WeeklyStats {
        let calendar = Calendar.current
        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else {
            return WeeklyStats(wordsLearned: 0, xpGained: 0, badgesEarned: 0)
        }

        let recentHistory = gamificationState.xpHistory.filter { $0.timestamp >= oneWeekAgo }

        let words = recentHistory.filter { $0.type == .wordLearned }.count
        let xp = recentHistory.map { $0.amount }.reduce(0, +)

        let badges = gamificationState.badges.filter { badge in
            guard badge.isUnlocked, let unlockedDate = badge.unlockedAt else { return false }
            return unlockedDate >= oneWeekAgo
        }.count

        return WeeklyStats(wordsLearned: words, xpGained: xp, badgesEarned: badges)
    }

    func awardTreasureChestIfNeeded() {
        if gamificationState.treasureChestProgress >= treasureChestWordGoal {
            // Award a treasure chest
            let xpReward = 100
            let stickerReward =
                StickerService().allStickers.randomElement() ?? StickerService().allStickers.first!

            treasureChestReward = (sticker: stickerReward, xp: xpReward)

            // Add the sticker to the user's collection
            gamificationState.collectedStickerIDs.append(stickerReward.id)

            // Add the XP
            awardXP(xpReward, type: .quizCompleted, description: "Treasure Chest Reward")

            // Reset the progress
            gamificationState.treasureChestProgress = 0
        }
    }

    func dismissTreasureChest() {
        treasureChestReward = nil
    }

    // MARK: - XP Management
    func awardXP(
        _ amount: Int, type: XPEventType, description: String? = nil, associatedData: String? = nil
    ) {
        let previousLevel = gamificationState.currentLevel.level

        gamificationState.addXP(
            amount, type: type, description: description, associatedData: associatedData)

        // Update lastXPChange for UI observation
        lastXPChange = amount

        // Subtle success haptic on XP gain
        HapticsManager.shared.trigger(.success)

        // Check for level up
        if gamificationState.currentLevel.level > previousLevel {
            // Satisfying level-up feedback
            HapticsManager.shared.trigger(.heavy)
            HapticsManager.shared.trigger(.success)
        }

        saveGamificationState()
    }

    func awardWordLearned(_ word: String) {
        if !gamificationState.xpHistory.contains(where: {
            $0.type == .wordLearned && $0.associatedData == word
        }) {
            awardXP(10, type: .wordLearned, description: "Learned: \(word)", associatedData: word)
        }
    }

    func awardLetterLearned(_ letter: String) {
        if !gamificationState.xpHistory.contains(where: {
            $0.type == .letterLearned && $0.associatedData == letter
        }) {
            awardXP(
                5, type: .letterLearned, description: "Learned letter: \(letter)",
                associatedData: letter)
        }
    }

    func awardStoryCompleted(_ title: String) {
        // Stories can be re-read for reduced XP, or just once.
        // Based on "not too wildly", let's restrict to once for now or check requirements.
        // Assuming unique completion for now to prevent spam.
        if !gamificationState.xpHistory.contains(where: {
            $0.type == .storyCompleted && $0.associatedData == title
        }) {
            awardXP(
                20, type: .storyCompleted, description: "Read story: \(title)",
                associatedData: title)
        }
    }

    func awardQuizCompleted(_ score: Double, totalQuestions: Int) {
        let baseXP = 20
        let bonusXP = score == 1.0 ? 10 : 0  // Perfect score bonus
        let totalXP = baseXP + bonusXP

        let eventType: XPEventType = score == 1.0 ? .perfectQuiz : .quizCompleted
        let description = score == 1.0 ? "Perfect quiz score!" : "Quiz completed"

        awardXP(totalXP, type: eventType, description: description)
    }

    func awardStreakMaintained() {
        let xpBonus = min(gamificationState.streakCount * 5, 50)  // Cap at 50 XP
        awardXP(
            xpBonus, type: .streakMaintained,
            description: "Streak maintained: \(gamificationState.streakCount) days")

        // Check for streak milestones
        checkStreakMilestones()
    }

    // MARK: - Badge Management
    private func checkStreakMilestones() {
        let milestone = StreakMilestone.milestones.first {
            $0.days == gamificationState.streakCount && !isBadgeUnlocked($0.badgeReward ?? "")
        }

        if let milestone = milestone {
            // Award milestone badge
            if let badgeName = milestone.badgeReward,
                let badge = gamificationState.badges.first(where: { $0.name == badgeName })
            {
                // popupManager.showBadgeEarned(badge) // Removed as per new_code
            }

            // Award milestone XP
            awardXP(
                milestone.xpBonus, type: .weekStreak,
                description: "\(milestone.teluguName) milestone reached!")
        }
    }

    private func isBadgeUnlocked(_ badgeName: String) -> Bool {
        return gamificationState.badges.first { $0.name == badgeName }?.isUnlocked ?? false
    }

    // MARK: - Daily Goals
    func updateDailyGoal() {
        let wordsLearnedToday = gamificationState.xpHistory.filter {
            Calendar.current.isDateInToday($0.timestamp) && $0.type == .wordLearned
        }.count

        if wordsLearnedToday >= gamificationState.dailyGoal.wordsToLearn
            && !gamificationState.dailyGoal.isCompleted
        {
            // Complete daily goal
            gamificationState.dailyGoal = DailyGoal(
                wordsToLearn: gamificationState.dailyGoal.wordsToLearn,
                xpTarget: gamificationState.dailyGoal.xpTarget,
                streakBonus: gamificationState.dailyGoal.streakBonus,
                isCompleted: true,
                completedAt: Date()
            )

            awardXP(
                gamificationState.dailyGoal.xpTarget, type: .dailyGoal,
                description: "Daily goal completed!")
        }
    }

    func resetDailyGoal() {
        gamificationState.dailyGoal = DailyGoal.defaultGoal
    }

    // MARK: - State Management
    private func saveGamificationState() {
        if let encoded = try? JSONEncoder().encode(gamificationState) {
            userDefaults.set(encoded, forKey: stateKey)
        }
    }

    private func syncWidgetSnapshot() {
        appGroupDefaults?.set(gamificationState.streakCount, forKey: "widget_streak")
        appGroupDefaults?.set(gamificationState.currentLevel.level, forKey: "widget_level")
    }

    private func loadState() {
        if let data = userDefaults.data(forKey: stateKey),
            let decoded = try? JSONDecoder().decode(GamificationState.self, from: data)
        {
            gamificationState = decoded
        }
    }

    // MARK: - Motivational Messages
    func getMotivationalMessage() -> String {
        let messages = [
            "Great job learning Telugu! 🎉",
            "Your streak is on fire! 🔥",
            "Keep up the amazing work! ⭐",
            "You're becoming a Telugu expert! 📚",
            "Every word brings you closer to mastery! 🌟",
            "Your dedication is inspiring! 💪",
            "Telugu is beautiful, and so is your progress! 🌺",
            "Keep the momentum going! 🚀",
        ]
        return messages.randomElement() ?? messages[0]
    }

    // MARK: - Statistics
    func getLearningStats() -> (
        totalWords: Int, totalXP: Int, currentStreak: Int, badgesEarned: Int
    ) {
        let totalWords = gamificationState.xpHistory.filter { $0.type == .wordLearned }.count
        let badgesEarned = gamificationState.badges.filter { $0.isUnlocked }.count

        return (
            totalWords: totalWords,
            totalXP: gamificationState.totalXP,
            currentStreak: gamificationState.streakCount,
            badgesEarned: badgesEarned
        )
    }

    func resetProgress() {
        gamificationState = GamificationState()
        newlyUnlockedBadges = []
        treasureChestReward = nil
        saveGamificationState()
        syncWidgetSnapshot()
    }
}

// MARK: - Gamification Integration Extensions
extension GamificationService {
    // Integration with existing learning activities
    func onWordLearned(_ word: Word) {
        awardWordLearned(word.telugu)
        gamificationState.treasureChestProgress += 1
        awardTreasureChestIfNeeded()
        updateDailyGoal()
        gamificationState.updateStreak(doingActivity: true)
    }

    func onQuizCompleted(score: Double, totalQuestions: Int) {
        awardQuizCompleted(score, totalQuestions: totalQuestions)
        updateDailyGoal()
        onActivityCompleted()
    }

    func onActivityCompleted() {
        gamificationState.updateStreak(doingActivity: true)
        awardStreakMaintained()
    }

    func onAppLaunch() {
        gamificationState.updateStreak(doingActivity: false)
        updateDailyGoal()
    }
}
