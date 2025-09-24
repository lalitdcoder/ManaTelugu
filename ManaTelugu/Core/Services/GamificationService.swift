import Foundation
import SwiftUI
import Combine // Added for Combine

// MARK: - Gamification Service
class GamificationService: ObservableObject {
    @Published var gamificationState = GamificationState()
    @Published var newlyUnlockedBadges: [GamificationBadge] = []
    @Published var treasureChestReward: (sticker: Sticker, xp: Int)? = nil
    
    private let treasureChestWordGoal = 10 // Every 10 words, a treasure chest is awarded
    
    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard
    private let appGroupDefaults = UserDefaults(suiteName: "group.com.LalitDusanapudi.ManaTelugu")
    private let stateKey = "gamification_state"
    
    init() {
        loadState()
        gamificationState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
            self?.saveGamificationState()
            self?.syncWidgetSnapshot()
            
            // Check for newly unlocked badges
            if let self = self {
                let unlockedAndUnseen = self.gamificationState.badges.filter { badge in
                    badge.isUnlocked && !self.newlyUnlockedBadges.contains(where: { $0.name == badge.name }) && !self.wasBadgeSeen(badge)
                }
                if !unlockedAndUnseen.isEmpty {
                    self.newlyUnlockedBadges.append(contentsOf: unlockedAndUnseen)
                }
            }
            
        }.store(in: &cancellables)
    }
    
    func dismissNewlyUnlockedBadge() {
        if !newlyUnlockedBadges.isEmpty {
            let seenBadge = newlyUnlockedBadges.removeFirst()
            markBadgeAsSeen(seenBadge)
        }
    }
    
    private func wasBadgeSeen(_ badge: GamificationBadge) -> Bool {
        // In a real app, you'd persist this 'seen' state.
        // For now, we'll just check if it's not in the newly unlocked list.
        return false // A simple implementation for now
    }
    
    private func markBadgeAsSeen(_ badge: GamificationBadge) {
        // In a real app, you'd persist this 'seen' state.
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
            let stickerReward = StickerService().allStickers.randomElement()!
            
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
    func awardXP(_ amount: Int, type: XPEventType, description: String? = nil, associatedData: String? = nil) {
        let previousLevel = gamificationState.currentLevel.level
        
        gamificationState.addXP(amount, type: type, description: description, associatedData: associatedData)
        
        // Show XP popup
        // popupManager.showXPGain(amount, type: type, description: description ?? type.description) // Removed as per new_code
        
        // Check for level up
        if gamificationState.currentLevel.level > previousLevel {
            // popupManager.showLevelUp(state.currentLevel) // Removed as per new_code
        }
        
        saveGamificationState()
    }
    
    func awardWordLearned(_ word: String) {
        awardXP(10, type: .wordLearned, description: "Learned: \(word)", associatedData: word)
    }
    
    func awardQuizCompleted(_ score: Double, totalQuestions: Int) {
        let baseXP = 20
        let bonusXP = score == 1.0 ? 10 : 0 // Perfect score bonus
        let totalXP = baseXP + bonusXP
        
        let eventType: XPEventType = score == 1.0 ? .perfectQuiz : .quizCompleted
        let description = score == 1.0 ? "Perfect quiz score!" : "Quiz completed"
        
        awardXP(totalXP, type: eventType, description: description)
    }
    
    func awardStreakMaintained() {
        let xpBonus = min(gamificationState.streakCount * 5, 50) // Cap at 50 XP
        awardXP(xpBonus, type: .streakMaintained, description: "Streak maintained: \(gamificationState.streakCount) days")
        
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
               let badge = gamificationState.badges.first(where: { $0.name == badgeName }) {
                // popupManager.showBadgeEarned(badge) // Removed as per new_code
            }
            
            // Award milestone XP
            awardXP(milestone.xpBonus, type: .weekStreak, description: "\(milestone.teluguName) milestone reached!")
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
        
        if wordsLearnedToday >= gamificationState.dailyGoal.wordsToLearn && !gamificationState.dailyGoal.isCompleted {
            // Complete daily goal
            gamificationState.dailyGoal = DailyGoal(
                wordsToLearn: gamificationState.dailyGoal.wordsToLearn,
                xpTarget: gamificationState.dailyGoal.xpTarget,
                streakBonus: gamificationState.dailyGoal.streakBonus,
                isCompleted: true,
                completedAt: Date()
            )
            
            awardXP(gamificationState.dailyGoal.xpTarget, type: .dailyGoal, description: "Daily goal completed!")
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
           let decoded = try? JSONDecoder().decode(GamificationState.self, from: data) {
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
            "Keep the momentum going! 🚀"
        ]
        return messages.randomElement() ?? messages[0]
    }
    
    // MARK: - Statistics
    func getLearningStats() -> (totalWords: Int, totalXP: Int, currentStreak: Int, badgesEarned: Int) {
        let totalWords = gamificationState.xpHistory.filter { $0.type == .wordLearned }.count
        let badgesEarned = gamificationState.badges.filter { $0.isUnlocked }.count
        
        return (
            totalWords: totalWords,
            totalXP: gamificationState.totalXP,
            currentStreak: gamificationState.streakCount,
            badgesEarned: badgesEarned
        )
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
        gamificationState.updateStreak()
    }
    
    func onQuizCompleted(score: Double, totalQuestions: Int) {
        awardQuizCompleted(score, totalQuestions: totalQuestions)
        updateDailyGoal()
    }
    
    func onActivityCompleted() {
        gamificationState.updateStreak()
        awardStreakMaintained()
    }
    
    func onAppLaunch() {
        gamificationState.updateStreak()
        updateDailyGoal()
    }
}

