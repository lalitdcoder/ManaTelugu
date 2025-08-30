import SwiftUI
import Combine

class AppSession: ObservableObject {
    @Published var userProfile: UserProfile = UserProfile(
        kidMode: false,
        streakDays: 0,
        lastOpened: nil,
        totalXP: 0,
        dailyLearningMinutes: 0,
        lastLearningDate: nil,
        dailyGoalMinutes: 10
    )
    @Published var awardedLetterIds: Set<String> = []
    
    let audioService: AudioServiceProtocol = AudioService()
    let dataRepository: DataRepository = DataRepository.shared
    let hapticsService: HapticsService = HapticsService.shared
    let sessionTimer: SessionTimer = SessionTimer()
    
    init() {
        // Load user profile from storage if exists
        loadUserProfile()
    }
    
    private func loadUserProfile() {
        // In a real app, we would load from Core Data or UserDefaults
        // For now we'll use default values
    }

    // MARK: - Progress Helpers
    func awardXP(_ points: Int) {
        var profile = userProfile
        profile.totalXP += points
        userProfile = profile
    }
    
    func touchStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var profile = userProfile
        if let last = profile.lastOpened {
            let lastDay = calendar.startOfDay(for: last)
            if today > lastDay {
                // New day: increment streak (no gap logic for MVP)
                profile.streakDays += 1
            }
        } else {
            // First activity ever starts streak at 1
            profile.streakDays = max(1, profile.streakDays)
        }
        profile.lastOpened = Date()
        userProfile = profile
    }

    func awardLetterView(letterId: String) {
        if !awardedLetterIds.contains(letterId) {
            awardedLetterIds.insert(letterId)
            awardXP(1)
            touchStreak()
        }
    }
    
    // MARK: - Learning Time Tracking
    func addLearningTime(minutes: Int) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var profile = userProfile
        
        // Check if this is a new day
        if let lastDate = profile.lastLearningDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            if today > lastDay {
                // New day: reset daily minutes
                profile.dailyLearningMinutes = minutes
            } else {
                // Same day: add to existing minutes
                profile.dailyLearningMinutes += minutes
            }
        } else {
            // First learning session ever
            profile.dailyLearningMinutes = minutes
        }
        
        profile.lastLearningDate = Date()
        userProfile = profile
        
        // Award XP for learning time (1 XP per minute)
        awardXP(minutes)
        touchStreak()
    }
    
    func getDailyProgress() -> (current: Int, goal: Int, percentage: Double) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var currentMinutes = 0
        
        // Check if we have learning time for today
        if let lastDate = userProfile.lastLearningDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            if today == lastDay {
                currentMinutes = userProfile.dailyLearningMinutes
            }
        }
        
        let goal = userProfile.dailyGoalMinutes
        let percentage = min(Double(currentMinutes) / Double(goal), 1.0)
        
        return (current: currentMinutes, goal: goal, percentage: percentage)
    }
}