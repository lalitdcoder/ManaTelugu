import SwiftUI
import Combine

@MainActor
class AppSession: ObservableObject {
    @Published var userProfile: UserProfile = UserProfile(name: "Student", kidMode: true)
    
    let audioService: AudioServiceProtocol = AudioService()
    let audioFeedback: AudioFeedbackService = AudioFeedbackService()
    let dataRepository = DataRepository()
    let hapticsService: HapticsService = HapticsService.shared
    let sessionTimer: SessionTimer = SessionTimer()
    let lessonsRepository: LessonsRepository = LessonsRepository()
    var gamificationService: GamificationService = GamificationService()
    let storyService: StoryService = StoryService()
    let dailyMissionsService = DailyMissionsService()
    let stickerService = StickerService()
    
    // MARK: - Initialization
    init() {
        loadUserProfile()
        setupBindings()
    }
    
    // MARK: - Data Loading
    func preloadData() async {
        // This function will be called from the splash screen
        // to warm up the data caches in the background.
        dataRepository.loadData()
    }
    
    private func loadUserProfile() {
        // In a real app, we would load from Core Data or UserDefaults
        // For now, we'll use mock data
        userProfile = UserProfile(name: "Student", kidMode: true)
    }
    
    private func setupBindings() {
        // Set up any necessary bindings between services
        // Gamification service will be configured separately
    }
    
    // MARK: - Session Management
    func startSession() {
        sessionTimer.start()
        // Check daily missions if method exists
    }
    
    func endSession() {
        sessionTimer.stop()
        saveUserProgress()
    }
    
    private func saveUserProgress() {
        // Save user progress to persistent storage
        // This would typically involve Core Data or UserDefaults
    }
    
    // MARK: - Convenience Methods
    func playAudio(for item: String) {
        audioService.play(name: item, rate: 1.0)
    }
    
    func provideFeedback(correct: Bool) {
        if correct {
            audioFeedback.playSuccess()
            hapticsService.lightImpact()
        } else {
            audioFeedback.playTryAgain()
            hapticsService.mediumImpact()
        }
    }
}
