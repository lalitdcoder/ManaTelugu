import Foundation

struct Letter: Identifiable, Codable, Hashable {
    let id: String
    let character: String
    let romanization: String
    let meaning: String
    let category: LetterCategory
    let strokePathPoints: [[CGPointCodable]]
    let audioFileName: String?
    let difficulty: Int
    var isLearned: Bool = false
    
    init(id: String, character: String, romanization: String, meaning: String, category: LetterCategory, strokePathPoints: [[CGPointCodable]] = [], audioFileName: String? = nil, difficulty: Int = 1) {
        self.id = id
        self.character = character
        self.romanization = romanization
        self.meaning = meaning
        self.category = category
        self.strokePathPoints = strokePathPoints
        self.audioFileName = audioFileName
        self.difficulty = difficulty
    }
}

enum LetterCategory: String, Codable, CaseIterable {
    case vowel = "vowel"
    case consonant = "consonant"
    case compound = "compound"
    
    var displayName: String {
        switch self {
        case .vowel: return "Vowels"
        case .consonant: return "Consonants"
        case .compound: return "Compounds"
        }
    }
}

struct CGPointCodable: Codable, Hashable {
    let x: Double
    let y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init(_ point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }
    
    var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}

// MARK: - Sample Data Extension
extension Letter {
    static let sampleLetters: [Letter] = [
        // Vowels
        Letter(
            id: "అ",
            character: "అ",
            romanization: "a",
            meaning: "Basic vowel sound",
            category: .vowel,
            audioFileName: "అ",
            difficulty: 1
        ),
        Letter(
            id: "ఆ",
            character: "ఆ",
            romanization: "aa",
            meaning: "Long vowel sound",
            category: .vowel,
            audioFileName: "ఆ",
            difficulty: 1
        ),
        Letter(
            id: "ఇ",
            character: "ఇ",
            romanization: "i",
            meaning: "Short 'i' sound",
            category: .vowel,
            audioFileName: "ఇ",
            difficulty: 1
        ),
        Letter(
            id: "ఈ",
            character: "ఈ",
            romanization: "ee",
            meaning: "Long 'i' sound",
            category: .vowel,
            audioFileName: "ఈ",
            difficulty: 1
        ),
        Letter(
            id: "ఉ",
            character: "ఉ",
            romanization: "u",
            meaning: "Short 'u' sound",
            category: .vowel,
            audioFileName: "ఉ",
            difficulty: 1
        ),
        
        // Consonants
        Letter(
            id: "క",
            character: "క",
            romanization: "ka",
            meaning: "Basic consonant",
            category: .consonant,
            audioFileName: "క",
            difficulty: 1
        ),
        Letter(
            id: "ఖ",
            character: "ఖ",
            romanization: "kha",
            meaning: "Aspirated consonant",
            category: .consonant,
            audioFileName: "ఖ",
            difficulty: 2
        ),
        Letter(
            id: "గ",
            character: "గ",
            romanization: "ga",
            meaning: "Common consonant",
            category: .consonant,
            audioFileName: "గ",
            difficulty: 1
        ),
        Letter(
            id: "ఘ",
            character: "ఘ",
            romanization: "gha",
            meaning: "Aspirated consonant",
            category: .consonant,
            audioFileName: "ఘ",
            difficulty: 2
        ),
        Letter(
            id: "ఙ",
            character: "ఙ",
            romanization: "nga",
            meaning: "Nasal consonant",
            category: .consonant,
            audioFileName: "ఙ",
            difficulty: 2
        )
    ]
}
