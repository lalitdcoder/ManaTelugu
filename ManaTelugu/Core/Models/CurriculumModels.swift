import Foundation

// MARK: - Curriculum Stage
struct CurriculumStage: Identifiable, Codable, Hashable {
    let id: String
    let stageNumber: Int
    let title: String
    let description: String?
    let orderIndex: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case stageNumber = "stage_number"
        case title
        case description
        case orderIndex = "order_index"
    }
}

// MARK: - Curriculum Module
struct CurriculumModule: Identifiable, Codable, Hashable {
    let id: String
    let stageId: String?
    let moduleNumber: Int
    let title: String
    let teluguTitle: String?
    let description: String?
    let objective: String?
    let learningOutcome: String?
    let difficulty: Int?
    let estimatedMinutes: Int?
    let orderIndex: Int?
    let level: Int?
    let isPublished: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case stageId = "stage_id"
        case moduleNumber = "module_number"
        case title
        case teluguTitle = "telugu_title"
        case description
        case objective
        case learningOutcome = "learning_outcome"
        case difficulty
        case estimatedMinutes = "estimated_minutes"
        case orderIndex = "order_index"
        case level
        case isPublished = "is_published"
    }
}

// MARK: - Content Item
struct ContentItem: Identifiable, Codable, Hashable {
    let id: String
    let teluguText: String?
    let transliteration: String?
    let contentType: String?
    let difficulty: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case teluguText = "telugu_text"
        case transliteration
        case contentType = "content_type"
        case difficulty
        case createdAt = "created_at"
    }
}

// MARK: - Grammar Point
struct GrammarPoint: Identifiable, Codable, Hashable {
    let id: String
    let name: String?
    let explanation: String?
    let examples: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case explanation
        case examples
        case createdAt = "created_at"
    }
}

// MARK: - Learner Models
struct LearnerSkill: Identifiable, Codable {
    let id: String?
    let userId: String
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case updatedAt = "updated_at"
    }
}

// MARK: - Generated Lesson & Attempt Models
struct GeneratedLesson: Identifiable, Codable {
    let id: String?
    let userId: String?
    let moduleId: String?
    let title: String?
    let objective: String?
    let lessonJson: String?
    let plannerVersion: String?
    let createdAt: String?

    var lessonTitle: String {
        title ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case moduleId = "module_id"
        case title
        case objective
        case lessonJson = "lesson_json"
        case plannerVersion = "planner_version"
        case createdAt = "created_at"
    }
}

struct LessonAttempt: Identifiable, Codable {
    let id: String?
    let userId: String
    let lessonId: String
    let score: Double
    let completedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case lessonId = "lesson_id"
        case score
        case completedAt = "completed_at"
    }
}

struct ActivityAttempt: Identifiable, Codable {
    let id: String?
    let lessonAttemptId: String?
    let activityType: String?
    let isCorrect: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case lessonAttemptId = "lesson_attempt_id"
        case activityType = "activity_type"
        case isCorrect = "is_correct"
    }
}

struct LearnerMistake: Identifiable, Codable {
    let id: String?
    let userId: String
    let mistakeType: String
    let contentId: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case mistakeType = "mistake_type"
        case contentId = "content_id"
        case createdAt = "created_at"
    }
}
