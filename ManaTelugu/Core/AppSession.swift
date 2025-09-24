import SwiftUI
import Combine

class AppSession: ObservableObject {
    @Published var userProfile: UserProfile = UserProfile(
        name: "Learner",
        kidMode: false
    )
    @Published var awardedLetterIds: Set<String> = []
    
    let audioService: AudioServiceProtocol = AudioService()
    let dataRepository: DataRepository = DataRepository.shared
    let hapticsService: HapticsService = HapticsService.shared
    let sessionTimer: SessionTimer = SessionTimer()
    let lessonsRepository: LessonsRepository = LessonsRepository()
    var gamificationService: GamificationService = GamificationService()
    let storyService: StoryService = StoryService()
    let dailyMissionsService = DailyMissionsService()
    let stickerService = StickerService()
    let progressTrackingService = ProgressTrackingService()
    let notificationService: NotificationServiceProtocol = NotificationService.shared
    
    init() {
        // Load user profile from storage if exists
        loadUserProfile()
        // Schedule default daily reminder at 7 PM if authorized
        notificationService.requestAuthorization { granted in
            if granted {
                self.notificationService.scheduleDailyReminder(
                    hour: 19,
                    minute: 0,
                    title: "Keep your Telugu streak going!",
                    body: "Practice a quick lesson to maintain your streak and level up."
                )
            }
        }
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
        DispatchQueue.main.async {
            self.gamificationService.gamificationState.checkBadgeUnlocks()
        }
    }


    // MARK: - Progress Helpers
    func awardXP(_ points: Int) {
        gamificationService.awardXP(points, type: .quizCompleted)
    }
    
    func touchStreak() {
        gamificationService.gamificationState.updateStreak()
    }

    func awardLetterView(letterId: String) {
        if !awardedLetterIds.contains(letterId) {
            awardedLetterIds.insert(letterId)
            awardXP(1)
            touchStreak()
            
            // Integrate with gamification system
            // We'll create a dummy Word object for now.
            let dummyWord = Word(id: "letter_\(letterId)", telugu: letterId, transliteration: "", english: "", imageName: "", audioFile: "", theme: "Alphabet")
            gamificationService.onWordLearned(dummyWord)
        }
    }
    
    // MARK: - Learning Time Tracking
    func addLearningTime(minutes: Int) {
        // This logic can be moved to a dedicated service in the future
    }

    func saveLearningTime() {
        // This logic can be moved to a dedicated service in the future
    }
}