import Foundation
import SwiftUI

// MARK: - Enhanced App Session
@MainActor
class EnhancedAppSession: ObservableObject {
    // MARK: - User Progress
    @Published var currentStreak: Int = 7
    @Published var totalXP: Int = 1250
    @Published var todayXP: Int = 85
    @Published var dailyGoal: Int = 100
    @Published var level: Int = 5
    @Published var preferredColorScheme: ColorScheme? = nil

    // MARK: - Learning Progress
    @Published var learnedLetters: Int = 0
    @Published var totalLetters: Int = 56
    @Published var masteredWords: Int = 45
    @Published var totalWords: Int = 200
    @Published var completedLessons: Int = 12
    @Published var totalLessons: Int = 30

    // MARK: - Current Learning State
    @Published var currentLesson: Lesson?
    @Published var recentAchievements: [TeluguAchievementBadge.Achievement] = []
    @Published var teluguLetters: [Letter] = []

    // MARK: - App Settings
    @Published var isKidModeEnabled: Bool = false
    @Published var audioEnabled: Bool = true
    @Published var hapticFeedbackEnabled: Bool = true
    @Published var notificationsEnabled: Bool = true

    init() {
        loadInitialData()
    }

    func preloadData() async {
        // Simulate loading data
        try? await Task.sleep(nanoseconds: 500_000_000)

        // Load Telugu letters
        await loadTeluguLetters()

        // Load current lesson
        await loadCurrentLesson()

        // Load achievements
        await loadRecentAchievements()
    }

    private func loadInitialData() {
        // Load user preferences from UserDefaults
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        totalXP = UserDefaults.standard.integer(forKey: "totalXP")
        todayXP = UserDefaults.standard.integer(forKey: "todayXP")
        dailyGoal = UserDefaults.standard.integer(forKey: "dailyGoal")
        level = UserDefaults.standard.integer(forKey: "level")

        // Set defaults if first launch
        if dailyGoal == 0 { dailyGoal = 100 }
        if currentStreak == 0 { currentStreak = 1 }
        if level == 0 { level = 1 }
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
        recentAchievements = [
            TeluguAchievementBadge.Achievement(
                id: "first_letter",
                title: "First Letter",
                description: "Learned your first Telugu letter",
                icon: "star.fill",
                color: AppleHIGDesign.Colors.systemYellow
            ),
            TeluguAchievementBadge.Achievement(
                id: "week_streak",
                title: "Week Warrior",
                description: "7 day learning streak",
                icon: "flame.fill",
                color: AppleHIGDesign.Colors.systemOrange
            ),
            TeluguAchievementBadge.Achievement(
                id: "vowel_master",
                title: "Vowel Master",
                description: "Mastered all Telugu vowels",
                icon: "a.circle.fill",
                color: AppleHIGDesign.Colors.vowelColor
            ),
        ]
    }

    // MARK: - Progress Methods
    func addXP(_ amount: Int) {
        todayXP += amount
        totalXP += amount

        // Check for level up
        let newLevel = (totalXP / 250) + 1
        if newLevel > level {
            level = newLevel
            // Trigger level up celebration
        }

        saveProgress()
    }

    func completeLesson() {
        completedLessons += 1
        addXP(50)

        // Update current lesson
        // This would typically load the next lesson
    }

    func learnLetter() {
        learnedLetters += 1
        addXP(10)
    }

    func masterWord() {
        masteredWords += 1
        addXP(25)
    }

    private func saveProgress() {
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(totalXP, forKey: "totalXP")
        UserDefaults.standard.set(todayXP, forKey: "todayXP")
        UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal")
        UserDefaults.standard.set(level, forKey: "level")
    }
}

// MARK: - Word Model
struct TeluguWord: Identifiable {
    let id = UUID()
    let telugu: String
    let english: String
    let pronunciation: String
    let category: Category
    let difficulty: Difficulty
    let audioFile: String
    let examples: [String]

    enum Category: String, CaseIterable {
        case family = "Family"
        case food = "Food"
        case colors = "Colors"
        case numbers = "Numbers"
        case animals = "Animals"
        case nature = "Nature"
        case body = "Body Parts"
        case home = "Home"
        case emotions = "Emotions"
        case actions = "Actions"
    }

    enum Difficulty: Int, CaseIterable {
        case beginner = 1
        case intermediate = 2
        case advanced = 3
    }
}

// MARK: - Quiz Question Model
struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let audioFile: String?
    let type: QuestionType

    enum QuestionType {
        case multipleChoice
        case listening
        case matching
        case fillInBlank
    }
}

// MARK: - Game Model
struct TeluguGame: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let difficulty: TeluguWord.Difficulty
    let estimatedTime: Int  // in minutes
    let category: Category

    enum Category: String, CaseIterable {
        case letters = "Letters"
        case words = "Words"
        case listening = "Listening"
        case writing = "Writing"
        case memory = "Memory"
    }
}
