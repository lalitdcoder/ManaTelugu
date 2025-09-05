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
        dailyGoalMinutes: 10,
        unlockedBadges: [],
        lettersMastered: 0,
        lessonsCompleted: 0,
        wordsMastered: 0
    )
    @Published var awardedLetterIds: Set<String> = []
    
    let audioService: AudioServiceProtocol = AudioService()
    let dataRepository: DataRepository = DataRepository.shared
    let hapticsService: HapticsService = HapticsService.shared
    let sessionTimer: SessionTimer = SessionTimer()
    let lessonsRepository: LessonsRepository = LessonsRepository()
    let geminiService: GeminiService = GeminiService.shared
    let speechService: SpeechService = SpeechService.shared
    
    init() {
        // Load user profile from storage if exists
        loadUserProfile()
    }

    func preloadData() async {
        // This function will be called from the splash screen
        // to warm up the data caches in the background.
        _ = await dataRepository.letters()
        _ = await dataRepository.words()
        _ = await dataRepository.lessons()
        _ = await dataRepository.badges()
    }
    
    private func loadUserProfile() {
        // In a real app, we would load from Core Data or UserDefaults
        // For now we'll use default values
    }

    // MARK: - Progress Helpers
    // Adding debug logs to identify potential issues in AppSession.swift
    func awardXP(_ points: Int) {
        print("Awarding XP: \(points)")
        var profile = userProfile
        profile.totalXP += points
        userProfile = profile
    }
    
    func touchStreak() {
        print("Touching streak")
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var profile = userProfile
        if let last = profile.lastOpened {
            let lastDay = calendar.startOfDay(for: last)
            if today > lastDay {
                print("New day detected, incrementing streak")
                profile.streakDays += 1
            }
        } else {
            print("First activity detected, starting streak")
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
    
    func updateUserProfile(_ update: (inout UserProfile) -> Void) {
        var profile = userProfile
        update(&profile)
        userProfile = profile
    }
}