import Combine
import SwiftUI

@MainActor
class AppSession: ObservableObject {
    // MARK: - Core Data & Services
    let lessonsRepository: LessonsRepository
    let progressTrackingService: ProgressTrackingService

    @Published var userProfile: UserProfile = UserProfile(name: "Student", kidMode: true) {
        didSet {
            saveUserProfile()
        }
    }
    @Published var darkModeEnabled: Bool = false {
        didSet {
            saveAppearancePreference()
        }
    }
    @Published var systemColorScheme: ColorScheme = .light

    // Additional app-wide services
    let audioService: AudioServiceProtocol = AudioService()
    let audioFeedback: AudioFeedbackService = AudioFeedbackService.shared
    let dataRepository = DataRepository()
    let hapticsService: HapticsService = HapticsService.shared
    let sessionTimer = SessionTimer()
    let gamificationService = GamificationService()
    let storyService = StoryService()
    let dailyMissionsService = DailyMissionsService()

    // MARK: - Enhanced Properties for Modern UI
    @Published var currentStreak: Int = 0
    @Published var totalXP: Int = 0
    @Published var todayXP: Int = 0
    @Published var dailyGoal: Int = 100
    @Published var level: Int = 1
    @Published var learnedLetters: Int = 0
    @Published var totalLetters: Int = 56
    @Published var masteredWords: Int = 0
    @Published var totalWords: Int = 200
    @Published var completedLessons: Int = 0
    @Published var totalLessons: Int = 30
    @Published var currentLesson: Lesson?
    @Published var recentAchievements: [TeluguAchievementBadge.Achievement] = []
    @Published var teluguLetters: [Letter] = []
    let stickerService = StickerService()

    private var cancellables = Set<AnyCancellable>()

    var isDarkModeActive: Bool {
        darkModeEnabled || systemColorScheme == .dark
    }

    // Used for SwiftUI .preferredColorScheme
    var preferredColorScheme: ColorScheme? {
        // Follow system appearance by default (HIG), only force dark when explicitly enabled
        darkModeEnabled ? .dark : nil
    }

    // MARK: - Initialization
    init() {
        self.lessonsRepository = LessonsRepository()
        self.progressTrackingService = ProgressTrackingService(
            lessonsRepository: self.lessonsRepository)
        loadAppearancePreference()
        loadUserProfile()
        setupBindings()
    }

    // MARK: - User Profile Persistence
    private let userProfileKey = "userProfile"

    private func loadUserProfile() {
        if let data = UserDefaults.standard.data(forKey: userProfileKey),
            let profile = try? JSONDecoder().decode(UserProfile.self, from: data)
        {
            self.userProfile = profile
        } else {
            // Keep default profile if nothing saved
        }
    }

    private func saveUserProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: userProfileKey)
        }
    }

    // MARK: - Bindings
    private func setupBindings() {
        // Forward updates from nested services so views observing AppSession refresh
        storyService.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        gamificationService.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        dataRepository.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        progressTrackingService.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        dailyMissionsService.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // MARK: - Preloading
    func preloadData() async {
        // Load Telugu letters
        await loadTeluguLetters()

        // Load current lesson
        await loadCurrentLesson()

        // Load achievements
        await loadRecentAchievements()

        // Load user progress from UserDefaults
        loadUserProgress()
    }

    private func loadTeluguLetters() async {
        teluguLetters = Letter.sampleLetters
    }

    private func loadCurrentLesson() async {
        currentLesson = Lesson(
            id: "basic_vowels",
            title: "Basic Vowels",
            description: "Learn the fundamental Telugu vowel sounds",
            levelId: "level_1",
            order: 1,
            difficulty: 1,
            xpReward: 50,
            estimatedMinutes: 10,
            activities: []
        )
    }

    private func loadRecentAchievements() async {
        // Load achievements from persistence or keep empty
        // For now, we'll start with empty for new users
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            // Load from somewhere if needed, or keep empty
        } else {
            recentAchievements = []
        }
    }

    private func loadUserProgress() {
        // Check if first launch
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")

        if hasLaunchedBefore {
            currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
            totalXP = UserDefaults.standard.integer(forKey: "totalXP")
            todayXP = UserDefaults.standard.integer(forKey: "todayXP")
            dailyGoal = UserDefaults.standard.integer(forKey: "dailyGoal")
            level = UserDefaults.standard.integer(forKey: "level")
            learnedLetters = UserDefaults.standard.integer(forKey: "learnedLetters")
            masteredWords = UserDefaults.standard.integer(forKey: "masteredWords")
            completedLessons = UserDefaults.standard.integer(forKey: "completedLessons")
        } else {
            // First launch defaults
            currentStreak = 0
            totalXP = 0
            todayXP = 0
            dailyGoal = 100
            level = 1
            learnedLetters = 0
            masteredWords = 0
            completedLessons = 0

            // Mark as launched
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            saveAllProgress()
        }

        // Safety checks
        if dailyGoal == 0 { dailyGoal = 100 }
        if level == 0 { level = 1 }
    }

    // MARK: - Progress Updates
    func updateProgress(xp: Int = 0, letters: Int = 0, words: Int = 0, lessons: Int = 0) {
        if xp > 0 {
            totalXP += xp
            todayXP += xp
            checkForLevelUp()
        }

        if letters > 0 {
            learnedLetters += letters
        }

        if words > 0 {
            masteredWords += words
        }

        if lessons > 0 {
            completedLessons += lessons
        }

        saveAllProgress()
    }

    private func checkForLevelUp() {
        let newLevel = (totalXP / 500) + 1
        if newLevel > level {
            level = newLevel
            // Could trigger a notification or animation here
        }
    }

    private func saveAllProgress() {
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(totalXP, forKey: "totalXP")
        UserDefaults.standard.set(todayXP, forKey: "todayXP")
        UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal")
        UserDefaults.standard.set(level, forKey: "level")
        UserDefaults.standard.set(learnedLetters, forKey: "learnedLetters")
        UserDefaults.standard.set(masteredWords, forKey: "masteredWords")
        UserDefaults.standard.set(completedLessons, forKey: "completedLessons")
    }

    // MARK: - Appearance Persistence
    private let appearanceKey = "darkModeEnabled"

    private func loadAppearancePreference() {
        if UserDefaults.standard.object(forKey: appearanceKey) != nil {
            darkModeEnabled = UserDefaults.standard.bool(forKey: appearanceKey)
        }
    }

    private func saveAppearancePreference() {
        UserDefaults.standard.set(darkModeEnabled, forKey: appearanceKey)
    }
}
