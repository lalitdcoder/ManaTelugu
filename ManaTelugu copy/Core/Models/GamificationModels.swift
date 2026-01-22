import Foundation

// MARK: - XP System
struct XPLevel: Codable, Identifiable {
    var id = UUID()
    let level: Int
    let name: String
    let teluguName: String
    let xpRequired: Int
    let description: String
    let color: String  // For theming

    static let levels: [XPLevel] = [
        XPLevel(
            level: 1, name: "Chinna Chinna Steps", teluguName: "చిన్న చిన్న అడుగులు", xpRequired: 0,
            description: "Starting your Telugu journey", color: "funBlue"),
        XPLevel(
            level: 2, name: "Mana Paatalu", teluguName: "మన పాటలు", xpRequired: 100,
            description: "Learning the basics", color: "funGreen"),
        XPLevel(
            level: 3, name: "Telugu Explorer", teluguName: "తెలుగు అన్వేషకుడు", xpRequired: 250,
            description: "Exploring new words", color: "funYellow"),
        XPLevel(
            level: 4, name: "Sahasa Yatri", teluguName: "సహస యాత్రి", xpRequired: 500,
            description: "Brave traveler of language", color: "funPink"),
        XPLevel(
            level: 5, name: "Telugu Guru", teluguName: "తెలుగు గురువు", xpRequired: 1000,
            description: "Master of Telugu", color: "primary"),
        XPLevel(
            level: 6, name: "Nitya Vidyarthi", teluguName: "నిత్య విద్యార్థి", xpRequired: 2000,
            description: "Eternal student", color: "accent"),
    ]
}

struct XPEvent: Codable, Identifiable {
    var id = UUID()
    let type: XPEventType
    let amount: Int
    let description: String
    let timestamp: Date
    let associatedData: String?  // word learned, quiz completed, etc.
}

enum XPEventType: String, CaseIterable, Codable {
    case wordLearned = "word_learned"
    case quizCompleted = "quiz_completed"
    case streakMaintained = "streak_maintained"
    case badgeEarned = "badge_earned"
    case dailyGoal = "daily_goal"
    case perfectQuiz = "perfect_quiz"
    case firstWord = "first_word"
    case weekStreak = "week_streak"
    case monthStreak = "month_streak"
    case letterLearned = "letter_learned"
    case storyCompleted = "story_completed"

    var baseXP: Int {
        switch self {
        case .wordLearned: return 10
        case .quizCompleted: return 20
        case .streakMaintained: return 5
        case .badgeEarned: return 15
        case .dailyGoal: return 25
        case .perfectQuiz: return 30
        case .firstWord: return 50
        case .weekStreak: return 100
        case .monthStreak: return 200
        case .letterLearned: return 5
        case .storyCompleted: return 20
        }
    }

    var description: String {
        switch self {
        case .wordLearned: return "Learned a new word"
        case .quizCompleted: return "Completed a quiz"
        case .streakMaintained: return "Maintained your streak"
        case .badgeEarned: return "Earned a badge"
        case .dailyGoal: return "Reached daily goal"
        case .perfectQuiz: return "Perfect quiz score"
        case .firstWord: return "First word learned"
        case .weekStreak: return "7-day streak bonus"
        case .monthStreak: return "30-day streak bonus"
        case .letterLearned: return "Learned a new letter"
        case .storyCompleted: return "Completed a story"
        }
    }
}

// MARK: - Badge System
struct GamificationBadge: Codable, Identifiable {
    var id = UUID()
    let name: String
    let teluguName: String
    let description: String
    let emoji: String
    let color: String
    let xpReward: Int
    let requirement: BadgeRequirement
    let isUnlocked: Bool
    let unlockedAt: Date?
    let rarity: BadgeRarity

    init(
        name: String, teluguName: String, description: String, emoji: String, color: String,
        xpReward: Int, requirement: BadgeRequirement, isUnlocked: Bool = false,
        unlockedAt: Date? = nil, rarity: BadgeRarity = .common
    ) {
        self.name = name
        self.teluguName = teluguName
        self.description = description
        self.emoji = emoji
        self.color = color
        self.xpReward = xpReward
        self.requirement = requirement
        self.isUnlocked = isUnlocked
        self.unlockedAt = unlockedAt
        self.rarity = rarity
    }
}

enum BadgeRequirement: Codable {
    case wordsLearned(Int)
    case streakDays(Int)
    case quizzesCompleted(Int)
    case perfectQuizzes(Int)
    case xpEarned(Int)
    case levelReached(Int)
    case daysActive(Int)
    case lettersLearned(Int)
    case storiesCompleted(Int)
    case combo([BadgeRequirement])  // Multiple requirements
}

enum BadgeRarity: String, CaseIterable, Codable {
    case common = "common"
    case uncommon = "uncommon"
    case rare = "rare"
    case epic = "epic"
    case legendary = "legendary"

    var color: String {
        switch self {
        case .common: return "funBlue"
        case .uncommon: return "funGreen"
        case .rare: return "funYellow"
        case .epic: return "funPink"
        case .legendary: return "primary"
        }
    }
}

// MARK: - Streak System Enhancement
struct StreakMilestone: Codable, Identifiable {
    var id = UUID()
    let days: Int
    let name: String
    let teluguName: String
    let description: String
    let xpBonus: Int
    let badgeReward: String?  // Badge name
    let color: String

    static let milestones: [StreakMilestone] = [
        StreakMilestone(
            days: 1, name: "First Step", teluguName: "Chinna Chinna Steps",
            description: "Started your journey", xpBonus: 5, badgeReward: nil, color: "funBlue"),
        StreakMilestone(
            days: 3, name: "Getting Started", teluguName: "Mana Paatalu",
            description: "Building momentum", xpBonus: 10, badgeReward: "Chinna Chinna Steps",
            color: "funGreen"),
        StreakMilestone(
            days: 7, name: "Week Warrior", teluguName: "Sapta Vidyarthi",
            description: "One week strong", xpBonus: 25, badgeReward: "Mana Paatalu",
            color: "funYellow"),
        StreakMilestone(
            days: 14, name: "Explorer", teluguName: "Telugu Explorer",
            description: "Two weeks exploring", xpBonus: 50, badgeReward: "Telugu Explorer",
            color: "funPink"),
        StreakMilestone(
            days: 30, name: "Adventurer", teluguName: "Sahasa Yatri",
            description: "One month adventure", xpBonus: 100, badgeReward: "Sahasa Yatri",
            color: "primary"),
        StreakMilestone(
            days: 60, name: "Guru", teluguName: "Telugu Guru", description: "Two months mastery",
            xpBonus: 200, badgeReward: "Telugu Guru", color: "accent"),
        StreakMilestone(
            days: 90, name: "Eternal Student", teluguName: "Nitya Vidyarthi",
            description: "Three months dedication", xpBonus: 300, badgeReward: "Nitya Vidyarthi",
            color: "success"),
    ]
}

// MARK: - Daily Goals
struct DailyGoal: Codable {
    let wordsToLearn: Int
    let xpTarget: Int
    let streakBonus: Int
    let isCompleted: Bool
    let completedAt: Date?

    static let defaultGoal = DailyGoal(
        wordsToLearn: 5,
        xpTarget: 50,
        streakBonus: 10,
        isCompleted: false,
        completedAt: nil
    )
}

// MARK: - Daily Mission
struct DailyMission: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let goal: Int
    var progress: Int
    let xpReward: Int
    var isCompleted: Bool {
        progress >= goal
    }
}

// MARK: - Avatar System
enum AvatarStage: String, Codable, CaseIterable {
    case sprout
    case seedling
    case plant
    case tree

    var imageName: String {
        switch self {
        case .sprout: return "🌱"
        case .seedling: return "🌿"
        case .plant: return "🪴"
        case .tree: return "🌳"
        }
    }

    var name: String {
        switch self {
        case .sprout: return "Sprout"
        case .seedling: return "Seedling"
        case .plant: return "Plant"
        case .tree: return "Tree"
        }
    }

    static func stage(forXP xp: Int) -> AvatarStage {
        if xp >= 1000 {
            return .tree
        } else if xp >= 500 {
            return .plant
        } else if xp >= 100 {
            return .seedling
        } else {
            return .sprout
        }
    }
}

// MARK: - Sticker System
struct Sticker: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let imageName: String  // Using SFSymbols for now
}

// MARK: - Gamification State
class GamificationState: ObservableObject, Codable {
    @Published var totalXP: Int = 0
    @Published var currentLevel: XPLevel = XPLevel.levels[0]
    @Published var badges: [GamificationBadge] = []
    @Published var xpHistory: [XPEvent] = []
    @Published var dailyGoal: DailyGoal = DailyGoal.defaultGoal
    @Published var streakCount: Int = 0
    @Published var lastActivityDate: Date = Date()
    @Published var wordOfTheDay: String = "స్నేహం"
    @Published var wordOfTheDayTranslation: String = "Friendship"
    @Published var collectedStickerIDs: [String] = []
    @Published var treasureChestProgress: Int = 0

    var currentAvatarStage: AvatarStage {
        .stage(forXP: totalXP)
    }

    init() {
        loadInitialBadges()
    }

    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case totalXP, currentLevel, badges, xpHistory, dailyGoal, streakCount, lastActivityDate,
            wordOfTheDay, wordOfTheDayTranslation, collectedStickerIDs, treasureChestProgress
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalXP = try container.decode(Int.self, forKey: .totalXP)
        currentLevel = try container.decode(XPLevel.self, forKey: .currentLevel)
        badges = try container.decode([GamificationBadge].self, forKey: .badges)
        xpHistory = try container.decode([XPEvent].self, forKey: .xpHistory)
        dailyGoal = try container.decode(DailyGoal.self, forKey: .dailyGoal)
        streakCount = try container.decode(Int.self, forKey: .streakCount)
        lastActivityDate = try container.decode(Date.self, forKey: .lastActivityDate)
        wordOfTheDay = try container.decode(String.self, forKey: .wordOfTheDay)
        wordOfTheDayTranslation = try container.decode(
            String.self, forKey: .wordOfTheDayTranslation)
        collectedStickerIDs =
            try container.decodeIfPresent([String].self, forKey: .collectedStickerIDs) ?? []
        treasureChestProgress =
            try container.decodeIfPresent(Int.self, forKey: .treasureChestProgress) ?? 0
        loadInitialBadges()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalXP, forKey: .totalXP)
        try container.encode(currentLevel, forKey: .currentLevel)
        try container.encode(badges, forKey: .badges)
        try container.encode(xpHistory, forKey: .xpHistory)
        try container.encode(dailyGoal, forKey: .dailyGoal)
        try container.encode(streakCount, forKey: .streakCount)
        try container.encode(lastActivityDate, forKey: .lastActivityDate)
        try container.encode(wordOfTheDay, forKey: .wordOfTheDay)
        try container.encode(wordOfTheDayTranslation, forKey: .wordOfTheDayTranslation)
        try container.encode(collectedStickerIDs, forKey: .collectedStickerIDs)
        try container.encode(treasureChestProgress, forKey: .treasureChestProgress)
    }

    private func loadInitialBadges() {
        badges = [
            // Common Badges
            GamificationBadge(
                name: "First Word", teluguName: "మొదటి పదం",
                description: "Learn your first Telugu word", emoji: "⭐", color: "funBlue",
                xpReward: 50, requirement: .wordsLearned(1), rarity: .common),
            GamificationBadge(
                name: "Streak Starter", teluguName: "చిన్న చిన్న అడుగులు", description: "3-day streak",
                emoji: "🔥", color: "funBlue", xpReward: 75, requirement: .streakDays(3),
                rarity: .common),
            GamificationBadge(
                name: "First Quiz", teluguName: "మొదటి ప్రశ్న", description: "Complete your first quiz",
                emoji: "❓", color: "funBlue", xpReward: 25, requirement: .quizzesCompleted(1),
                rarity: .common),
            GamificationBadge(
                name: "First Letter", teluguName: "మొదటి అక్షరం", description: "Learn your first letter",
                emoji: "🅰️", color: "funBlue", xpReward: 15, requirement: .lettersLearned(1),
                rarity: .common),
            GamificationBadge(
                name: "First Story", teluguName: "మొదటి కథ", description: "Read your first story",
                emoji: "📖", color: "funBlue", xpReward: 30, requirement: .storiesCompleted(1),
                rarity: .common),

            // Uncommon Badges
            GamificationBadge(
                name: "Word Learner", teluguName: "శబ్ద శిక్షక", description: "Learn 50 words",
                emoji: "📚", color: "funGreen", xpReward: 100, requirement: .wordsLearned(50),
                rarity: .uncommon),
            GamificationBadge(
                name: "Week Warrior", teluguName: "సప్త విద్యార్థి", description: "7-day streak", emoji: "📅",
                color: "funGreen", xpReward: 150, requirement: .streakDays(7), rarity: .uncommon),
            GamificationBadge(
                name: "Quiz Enthusiast", teluguName: "ప్రశ్న ప్రియుడు", description: "Complete 5 quizzes",
                emoji: "🧠", color: "funGreen", xpReward: 100, requirement: .quizzesCompleted(5),
                rarity: .uncommon),
            GamificationBadge(
                name: "Quiz Enthusiast", teluguName: "ప్రశ్న ప్రియుడు", description: "Complete 5 quizzes",
                emoji: "🧠", color: "funGreen", xpReward: 100, requirement: .quizzesCompleted(5),
                rarity: .uncommon),
            GamificationBadge(
                name: "Alphabet Starter", teluguName: "అక్షరమాల ప్రారంభం", description: "Learn 10 letters",
                emoji: "🔤", color: "funGreen", xpReward: 50, requirement: .lettersLearned(10),
                rarity: .uncommon),
            GamificationBadge(
                name: "Story Reader", teluguName: "కథా పఠనం", description: "Read 5 stories",
                emoji: "📚", color: "funGreen", xpReward: 100, requirement: .storiesCompleted(5),
                rarity: .uncommon),
            GamificationBadge(
                name: "Daily Learner", teluguName: "నిత్య విద్యార్థి", description: "Be active for 7 days",
                emoji: "✅", color: "funGreen", xpReward: 125, requirement: .daysActive(7),
                rarity: .uncommon),

            // Rare Badges
            GamificationBadge(
                name: "Language Expert", teluguName: "మన భాషా నిపుణుడు", description: "Learn 100 words",
                emoji: "🎓", color: "funYellow", xpReward: 200, requirement: .wordsLearned(100),
                rarity: .rare),
            GamificationBadge(
                name: "Month Master", teluguName: "సహస యాత్రి", description: "30-day streak",
                emoji: "👑", color: "funYellow", xpReward: 300, requirement: .streakDays(30),
                rarity: .rare),
            GamificationBadge(
                name: "Quiz Master", teluguName: "ప్రమాణ పండిత", description: "Complete 10 quizzes",
                emoji: "🧠", color: "funYellow", xpReward: 200, requirement: .quizzesCompleted(10),
                rarity: .rare),
            GamificationBadge(
                name: "Perfect Score", teluguName: "సంపూర్ణ స్కోరు",
                description: "Get perfect score in 5 quizzes", emoji: "💯", color: "funYellow",
                xpReward: 250, requirement: .perfectQuizzes(5), rarity: .rare),
            GamificationBadge(
                name: "XP Collector", teluguName: "XP సేకరకుడు", description: "Earn 1000 XP",
                emoji: "⭐", color: "funYellow", xpReward: 150, requirement: .xpEarned(1000),
                rarity: .rare),

            // Epic Badges
            GamificationBadge(
                name: "Vocabulary Master", teluguName: "శబ్దకోశ మాస్టర్", description: "Learn 250 words",
                emoji: "📖", color: "funPink", xpReward: 400, requirement: .wordsLearned(250),
                rarity: .epic),
            GamificationBadge(
                name: "Streak Legend", teluguName: "స్ట్రీక్ లెజెండ్", description: "60-day streak",
                emoji: "🔥", color: "funPink", xpReward: 500, requirement: .streakDays(60),
                rarity: .epic),
            GamificationBadge(
                name: "Quiz Champion", teluguName: "ప్రశ్న ఛాంపియన్", description: "Complete 25 quizzes",
                emoji: "🏆", color: "funPink", xpReward: 400, requirement: .quizzesCompleted(25),
                rarity: .epic),
            GamificationBadge(
                name: "Perfect Master", teluguName: "పర్ఫెక్ట్ మాస్టర్",
                description: "Get perfect score in 15 quizzes", emoji: "💯", color: "funPink",
                xpReward: 500, requirement: .perfectQuizzes(15), rarity: .epic),
            GamificationBadge(
                name: "Level 5 Achiever", teluguName: "లెవెల్ 5 అచీవర్", description: "Reach level 5",
                emoji: "5️⃣", color: "funPink", xpReward: 300, requirement: .levelReached(5),
                rarity: .epic),

            // Legendary Badges
            GamificationBadge(
                name: "Eternal Student", teluguName: "నిత్య విద్యార్థి", description: "90-day streak",
                emoji: "♾️", color: "primary", xpReward: 1000, requirement: .streakDays(90),
                rarity: .legendary),
            GamificationBadge(
                name: "Telugu Scholar", teluguName: "తెలుగు పండితుడు", description: "Learn 500 words",
                emoji: "🎓", color: "primary", xpReward: 1000, requirement: .wordsLearned(500),
                rarity: .legendary),
            GamificationBadge(
                name: "Quiz Grandmaster", teluguName: "ప్రశ్న గ్రాండ్ మాస్టర్",
                description: "Complete 50 quizzes", emoji: "🧠", color: "primary", xpReward: 800,
                requirement: .quizzesCompleted(50), rarity: .legendary),
            GamificationBadge(
                name: "Perfect Legend", teluguName: "పర్ఫెక్ట్ లెజెండ్",
                description: "Get perfect score in 30 quizzes", emoji: "💯", color: "primary",
                xpReward: 1000, requirement: .perfectQuizzes(30), rarity: .legendary),
            GamificationBadge(
                name: "Ultimate Achiever", teluguName: "అల్టిమేట్ అచీవర్", description: "Earn 5000 XP",
                emoji: "⭐", color: "primary", xpReward: 500, requirement: .xpEarned(5000),
                rarity: .legendary),
        ]
    }

    func addXP(
        _ amount: Int, type: XPEventType, description: String? = nil, associatedData: String? = nil
    ) {
        totalXP += amount
        updateLevel()

        let event = XPEvent(
            type: type,
            amount: amount,
            description: description ?? type.description,
            timestamp: Date(),
            associatedData: associatedData
        )
        xpHistory.append(event)

        // Check for badge unlocks
        checkBadgeUnlocks()
    }

    public func checkBadgeUnlocks() {
        for i in 0..<badges.count {
            if !badges[i].isUnlocked && isRequirementMet(badges[i].requirement) {
                badges[i] = GamificationBadge(
                    name: badges[i].name,
                    teluguName: badges[i].teluguName,
                    description: badges[i].description,
                    emoji: badges[i].emoji,
                    color: badges[i].color,
                    xpReward: badges[i].xpReward,
                    requirement: badges[i].requirement,
                    isUnlocked: true,
                    unlockedAt: Date(),
                    rarity: badges[i].rarity
                )

                // Award XP for badge unlock
                addXP(
                    badges[i].xpReward, type: .badgeEarned,
                    description: "Earned \(badges[i].name) badge")
            }
        }
    }

    private func updateLevel() {
        let newLevel = XPLevel.levels.last { $0.xpRequired <= totalXP } ?? XPLevel.levels[0]
        if newLevel.level != currentLevel.level {
            currentLevel = newLevel
            // Award level up badge if exists
            checkBadgeUnlocks()
        }
    }

    private func isRequirementMet(_ requirement: BadgeRequirement) -> Bool {
        switch requirement {
        case .wordsLearned(let count):
            return xpHistory.filter { $0.type == .wordLearned }.count >= count
        case .streakDays(let days):
            return streakCount >= days
        case .quizzesCompleted(let count):
            return xpHistory.filter { $0.type == .quizCompleted }.count >= count
        case .lettersLearned(let count):
            return xpHistory.filter { $0.type == .letterLearned }.count >= count
        case .storiesCompleted(let count):
            return xpHistory.filter { $0.type == .storyCompleted }.count >= count
        case .perfectQuizzes(let count):
            return xpHistory.filter { $0.type == .perfectQuiz }.count >= count
        case .xpEarned(let xp):
            return totalXP >= xp
        case .levelReached(let level):
            return currentLevel.level >= level
        case .daysActive(let days):
            // Calculate days since first activity
            guard let firstActivity = xpHistory.first?.timestamp else { return false }
            let daysSinceFirst =
                Calendar.current.dateComponents([.day], from: firstActivity, to: Date()).day ?? 0
            return daysSinceFirst >= days
        case .combo(let requirements):
            return requirements.allSatisfy { isRequirementMet($0) }
        }
    }

    func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastActivity = calendar.startOfDay(for: lastActivityDate)

        if today > lastActivity {
            if calendar.dateInterval(of: .day, for: lastActivity)?.end == today {
                // Consecutive day
                streakCount += 1
                addXP(
                    5, type: .streakMaintained,
                    description: "Streak maintained: \(streakCount) days")
            } else {
                // Streak broken
                streakCount = 1
            }
            lastActivityDate = Date()
        }
    }

    var progressToNextLevel: Double {
        let currentLevelXP = currentLevel.xpRequired
        guard
            let nextLevel = XPLevel.levels.first(where: { $0.xpRequired > currentLevelXP })
                ?? XPLevel.levels.last
        else {
            return 1.0
        }
        let xpInCurrentLevel = totalXP - currentLevelXP
        let xpNeededForNext = nextLevel.xpRequired - currentLevelXP
        return Double(xpInCurrentLevel) / Double(max(xpNeededForNext, 1))
    }

    var nextLevel: XPLevel? {
        XPLevel.levels.first { $0.xpRequired > currentLevel.xpRequired }
    }
}
