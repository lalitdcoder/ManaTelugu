import Foundation

struct QuizItem: Identifiable, Codable, Hashable {
    let id: String
    let prompt: String
    let correctId: String
    let options: [String]
    let kind: QuizKind
}

enum QuizKind: String, Codable {
    case soundMatch
    case cardMatch
    case trace
}