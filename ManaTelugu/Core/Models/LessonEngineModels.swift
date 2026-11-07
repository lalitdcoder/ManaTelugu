import Foundation

// MARK: - Supported Activity Types (Production Engine Schema)
enum EngineActivityType: String, Codable, CaseIterable {
    case introduction
    case vocabulary
    case multipleChoice = "multiple_choice"
    case matching
    case listening
    case reading
    case sentenceBuilder = "sentence_builder"
    case fillBlank = "fill_blank"
    case writing
    case speaking
    case translation
    case review
    case conversation

    var displayName: String {
        switch self {
        case .introduction: return "Introduction"
        case .vocabulary: return "Vocabulary"
        case .multipleChoice: return "Multiple Choice"
        case .matching: return "Matching"
        case .listening: return "Listening"
        case .reading: return "Reading"
        case .sentenceBuilder: return "Sentence Builder"
        case .fillBlank: return "Fill in the Blank"
        case .writing: return "Writing & Tracing"
        case .speaking: return "Speaking Practice"
        case .translation: return "Translation"
        case .review: return "Review"
        case .conversation: return "Conversation"
        }
    }

    var iconName: String {
        switch self {
        case .introduction: return "sparkles"
        case .vocabulary: return "book.fill"
        case .multipleChoice: return "checkmark.circle.fill"
        case .matching: return "square.grid.2x2.fill"
        case .listening: return "speaker.wave.2.fill"
        case .reading: return "eye.fill"
        case .sentenceBuilder: return "character.cursor"
        case .fillBlank: return "square.and.pencil"
        case .writing: return "pencil.tip"
        case .speaking: return "mic.fill"
        case .translation: return "arrow.left.and.right"
        case .review: return "arrow.clockwise"
        case .conversation: return "bubble.left.and.bubble.right.fill"
        }
    }
}

// MARK: - Production Engine Lesson Activity Model
struct EngineLessonActivity: Identifiable, Codable, Hashable {
    var id: String { "\(type.rawValue)_\(title)_\(prompt.prefix(10))" }
    let type: EngineActivityType
    let title: String
    let instruction: String?
    let contentIds: [String]?
    let prompt: String
    let teluguText: String?
    let transliteration: String?
    let englishTranslation: String?
    let options: [String]?
    let answer: String?
    let explanation: String?

    enum CodingKeys: String, CodingKey {
        case type, title, instruction, prompt, options, answer, explanation
        case contentIds = "content_ids"
        case teluguText = "telugu_text"
        case transliteration
        case englishTranslation = "english_translation"
    }
}

// MARK: - Production Lesson Response Model
struct LessonResponse: Codable, Identifiable {
    var id: String { title }
    let title: String
    let objective: String
    let estimatedMinutes: Int
    let activities: [EngineLessonActivity]

    enum CodingKeys: String, CodingKey {
        case title, objective, activities
        case estimatedMinutes = "estimated_minutes"
    }
}
