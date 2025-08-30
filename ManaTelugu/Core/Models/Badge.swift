import Foundation

struct Badge: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let criteria: BadgeCriteria
    let imageName: String
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
}