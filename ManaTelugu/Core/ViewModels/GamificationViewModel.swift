import Combine
import SwiftUI

// MARK: - Gamification View Model
/// Centralized MVVM architecture for gamification logic
/// Separates all business logic from UI, provides reactive updates via @Published properties
class GamificationViewModel: ObservableObject {

    // MARK: - Published Properties (Reactive UI)
    @Published var userLevel: Int = 1
    @Published var currentXP: Int = 0
    @Published var xpForNextLevel: Int = 100
    @Published var xpProgress: Double = 0.0
    @Published var streakCount: Int = 0
    @Published var unlockedBadges: [GamificationBadge] = []
    @Published var lockedBadges: [GamificationBadge] = []
    @Published var allBadges: [GamificationBadge] = []
    @Published var recentXPEvents: [XPEvent] = []
    @Published var showBadgeUnlockAnimation: Bool = false
    @Published var newlyUnlockedBadge: GamificationBadge?
    @Published var hearts: Int = 5
    @Published var maxHearts: Int = 5
    @Published var collectedStickers: [Sticker] = []
    @Published var totalStickers: [Sticker] = []

    // MARK: - Dependencies
    private let gamificationService: GamificationService
    private let userDefaults: UserDefaults
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Constants
    private let xpCacheKey = "cached_xp"
    private let levelCacheKey = "cached_level"
    private let streakCacheKey = "cached_streak"

    // MARK: - Initialization
    init(gamificationService: GamificationService, userDefaults: UserDefaults = .standard) {
        self.gamificationService = gamificationService
        self.userDefaults = userDefaults

        // Load cached data immediately
        loadCachedData()

        // Setup reactive bindings
        setupBindings()
    }

    // MARK: - Data Loading
    /// Load cached data from UserDefaults for instant UI updates
    private func loadCachedData() {
        currentXP = userDefaults.integer(forKey: xpCacheKey)
        userLevel = max(1, userDefaults.integer(forKey: levelCacheKey))
        streakCount = userDefaults.integer(forKey: streakCacheKey)

        // Calculate initial progress
        updateXPProgress()
    }

    /// Setup reactive bindings to GamificationService
    private func setupBindings() {
        // Observe gamification state changes
        gamificationService.$gamificationState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateFromState(state)
            }
            .store(in: &cancellables)

        // Observe newly unlocked badges
        gamificationService.$newlyUnlockedBadges
            .receive(on: DispatchQueue.main)
            .sink { [weak self] badges in
                if let badge = badges.first {
                    self?.triggerBadgeUnlockAnimation(badge)
                }
            }
            .store(in: &cancellables)
    }

    /// Update ViewModel from GamificationState
    private func updateFromState(_ state: GamificationState) {
        // Update XP and Level
        currentXP = state.totalXP
        userLevel = state.currentLevel.level
        xpForNextLevel = state.currentLevel.xpRequired

        // Update streak
        streakCount = state.streakCount

        // Update badges
        allBadges = state.badges
        unlockedBadges = state.badges.filter { $0.isUnlocked }
        lockedBadges = state.badges.filter { !$0.isUnlocked }

        // Update XP events
        recentXPEvents = Array(state.xpHistory.suffix(10))

        // Update stickers
        let allStickerIDs = state.collectedStickerIDs
        // Note: You'll need to get actual sticker objects from StickerService

        // Update hearts (if using heart system)
        // hearts = state.hearts ?? maxHearts

        // Calculate progress
        updateXPProgress()

        // Cache the data
        cacheData()
    }

    /// Calculate XP progress for current level
    private func updateXPProgress() {
        let previousLevelXP = userLevel > 1 ? XPLevel.levels[userLevel - 2].xpRequired : 0
        let xpInCurrentLevel = currentXP - previousLevelXP
        let xpNeededForLevel = xpForNextLevel - previousLevelXP

        xpProgress =
            xpNeededForLevel > 0 ? Double(xpInCurrentLevel) / Double(xpNeededForLevel) : 0.0
        xpProgress = min(max(xpProgress, 0.0), 1.0)  // Clamp between 0 and 1
    }

    /// Cache data to UserDefaults for persistence
    private func cacheData() {
        userDefaults.set(currentXP, forKey: xpCacheKey)
        userDefaults.set(userLevel, forKey: levelCacheKey)
        userDefaults.set(streakCount, forKey: streakCacheKey)
    }

    // MARK: - XP Management
    /// Award XP and handle level-up calculations
    /// Publishes updates immediately for reactive UI
    func awardXP(amount: Int, type: XPEventType = .wordLearned, description: String? = nil) {
        let previousLevel = userLevel

        // Award XP through service
        gamificationService.awardXP(amount, type: type, description: description)

        // Check for level up
        if userLevel > previousLevel {
            handleLevelUp(from: previousLevel, to: userLevel)
        }
    }

    /// Handle level up event with animations and feedback
    private func handleLevelUp(from oldLevel: Int, to newLevel: Int) {
        // Trigger haptic feedback
        HapticsManager.shared.notification(.success)

        // You can add additional celebration logic here
        print("🎉 Level Up! \(oldLevel) → \(newLevel)")
    }

    // MARK: - Badge Management
    /// Trigger badge unlock animation
    private func triggerBadgeUnlockAnimation(_ badge: GamificationBadge) {
        newlyUnlockedBadge = badge
        showBadgeUnlockAnimation = true

        // Trigger haptic feedback
        HapticsManager.shared.notification(.success)
    }

    /// Dismiss badge unlock animation
    func dismissBadgeUnlock() {
        showBadgeUnlockAnimation = false
        newlyUnlockedBadge = nil
    }

    // MARK: - Streak Management
    /// Update streak (called on app launch or activity completion)
    func updateStreak() {
        gamificationService.onActivityCompleted()
    }

    // MARK: - Heart System
    /// Deduct a heart (for wrong answers)
    func deductHeart() {
        if hearts > 0 {
            hearts -= 1
            HapticsManager.shared.notification(.error)
        }
    }

    /// Restore hearts (via gems or time)
    func restoreHearts() {
        hearts = maxHearts
    }

    // MARK: - Computed Properties
    var xpProgressPercentage: Int {
        Int(xpProgress * 100)
    }

    var heartsPercentage: Double {
        Double(hearts) / Double(maxHearts)
    }

    var recentBadges: [GamificationBadge] {
        Array(
            unlockedBadges.sorted {
                ($0.unlockedAt ?? Date.distantPast) > ($1.unlockedAt ?? Date.distantPast)
            }.prefix(3))
    }

    var badgeCompletionPercentage: Int {
        guard !allBadges.isEmpty else { return 0 }
        return Int((Double(unlockedBadges.count) / Double(allBadges.count)) * 100)
    }

    // MARK: - Sticker Management
    func unlockSticker(_ sticker: Sticker) {
        if !collectedStickers.contains(where: { $0.id == sticker.id }) {
            collectedStickers.append(sticker)
        }
    }

    var stickerCompletionPercentage: Int {
        guard !totalStickers.isEmpty else { return 0 }
        return Int((Double(collectedStickers.count) / Double(totalStickers.count)) * 100)
    }
}

// MARK: - Preview Helper
extension GamificationViewModel {
    static var preview: GamificationViewModel {
        let service = GamificationService()
        return GamificationViewModel(gamificationService: service)
    }
}
