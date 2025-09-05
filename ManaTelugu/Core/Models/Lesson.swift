import Foundation

// MARK: - Learning Level
struct LearningLevel: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let difficulty: Int // 1-4 stars
    let lessons: [Lesson]
    let requiredXP: Int
    let color: String // Hex color for UI
}

// MARK: - Lesson
struct Lesson: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let levelId: String
    let order: Int
    let difficulty: Int // 1-4 stars
    let xpReward: Int
    let estimatedMinutes: Int
    let activities: [LessonActivity]
}

// MARK: - Lesson Activities
struct LessonActivity: Identifiable, Codable, Hashable {
    let id: String
    let type: ActivityType
    let title: String
    let instructions: String
    let xpValue: Int
    let questions: [ActivityQuestion]
    let canSkip: Bool
}

enum ActivityType: String, Codable, CaseIterable {
    case reading = "reading"
    case writing = "writing"
    case listening = "listening"
    case speaking = "speaking"
    
    var displayName: String {
        switch self {
        case .reading: return "Reading Practice"
        case .writing: return "Writing Practice"
        case .listening: return "Listening Practice"
        case .speaking: return "Speaking Practice"
        }
    }
    
    var icon: String {
        switch self {
        case .reading: return "book.open"
        case .writing: return "pencil"
        case .listening: return "headphones"
        case .speaking: return "mic"
        }
    }
}

// MARK: - Activity Questions
struct ActivityQuestion: Identifiable, Codable, Hashable {
    let id: String
    let type: QuestionType
    let question: String
    let correctAnswer: String
    let options: [String]? // For multiple choice
    let audioFile: String? // For listening activities
    let strokeOrder: [String]? // For writing activities
    let explanation: String?
    let tolerance: Double? // For tracing accuracy (0.0-1.0, default 0.85)
    
    init(id: String, type: QuestionType, question: String, correctAnswer: String, options: [String]? = nil, audioFile: String? = nil, strokeOrder: [String]? = nil, explanation: String? = nil, tolerance: Double? = nil) {
        self.id = id
        self.type = type
        self.question = question
        self.correctAnswer = correctAnswer
        self.options = options
        self.audioFile = audioFile
        self.strokeOrder = strokeOrder
        self.explanation = explanation
        self.tolerance = tolerance
    }
}

enum QuestionType: String, Codable, CaseIterable {
    case multipleChoice = "multiple_choice"
    case textInput = "text_input"
    case characterRecognition = "character_recognition"
    case wordTranslation = "word_translation"
    case sentenceTranslation = "sentence_translation"
    case tracing = "tracing"
    case audioIdentification = "audio_identification"
    case speaking = "speaking"
    case listening = "listening"
}

// MARK: - Activity Response
struct ActivityResponse: Identifiable, Codable {
    let id: String
    let activityId: String
    let questionId: String
    let userAnswer: String
    let isCorrect: Bool
    let timeSpent: TimeInterval
    let xpEarned: Int
    let timestamp: Date
}

// MARK: - Progress Tracking
struct LessonProgress: Identifiable, Codable {
    let id: String
    let lessonId: String
    let userId: String
    var isCompleted: Bool
    var completionDate: Date?
    var xpEarned: Int
    var correctAnswers: Int
    var totalQuestions: Int
    var timeSpent: TimeInterval
    var attempts: Int
    var activityResponses: [ActivityResponse]
    
    var accuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions)
    }
}

struct LevelProgress: Identifiable, Codable {
    let id: String
    let levelId: String
    let userId: String
    var completedLessons: Int
    var totalLessons: Int
    var isCompleted: Bool
    var completionDate: Date?
    var totalXPEarned: Int
    
    var completionPercentage: Double {
        guard totalLessons > 0 else { return 0 }
        return Double(completedLessons) / Double(totalLessons) * 100
    }
}