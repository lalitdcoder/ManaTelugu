import Foundation

struct Badge: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let criteria: BadgeCriteria
    let emoji: String
}

enum BadgeCriteria: Codable, Hashable {
    case streak(Int)
    case lettersMastered(Int)
    case lessonsCompleted(Int)
    case wordsMastered(Int)
    
    private enum CodingKeys: String, CodingKey { case streak, lettersMastered, lessonsCompleted, wordsMastered }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(Int.self, forKey: .streak) { self = .streak(value); return }
        if let value = try container.decodeIfPresent(Int.self, forKey: .lettersMastered) { self = .lettersMastered(value); return }
        if let value = try container.decodeIfPresent(Int.self, forKey: .lessonsCompleted) { self = .lessonsCompleted(value); return }
        if let value = try container.decodeIfPresent(Int.self, forKey: .wordsMastered) { self = .wordsMastered(value); return }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown BadgeCriteria"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .streak(let v): try container.encode(v, forKey: .streak)
        case .lettersMastered(let v): try container.encode(v, forKey: .lettersMastered)
        case .lessonsCompleted(let v): try container.encode(v, forKey: .lessonsCompleted)
        case .wordsMastered(let v): try container.encode(v, forKey: .wordsMastered)
        }
    }
    
    // Helper function to get human-readable description
    func description() -> String {
        switch self {
        case .streak(let count):
            return "Maintain a \(count) day learning streak"
        case .lettersMastered(let count):
            return "Master \(count) Telugu letters"
        case .lessonsCompleted(let count):
            return "Complete \(count) lesson\(count == 1 ? "" : "s")"
        case .wordsMastered(let count):
            return "Master \(count) Telugu word\(count == 1 ? "" : "s")"
        }
    }
    
    // Helper function to get the target value
    func targetValue() -> Int {
        switch self {
        case .streak(let count), .lettersMastered(let count), .lessonsCompleted(let count), .wordsMastered(let count):
            return count
        }
    }
}