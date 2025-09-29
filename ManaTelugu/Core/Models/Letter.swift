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
