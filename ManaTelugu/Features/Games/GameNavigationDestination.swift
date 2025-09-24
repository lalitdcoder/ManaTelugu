import Foundation

enum GameNavigationDestination: Hashable {
    case sentenceBuilder
    case listeningChallenge
    case cardMatch
    case soundMatch
    case traceLetters
}

extension GameNavigationDestination {
    static func from(gameTag: Int) -> GameNavigationDestination {
        switch gameTag {
        case 0: return .sentenceBuilder
        case 1: return .listeningChallenge
        case 2: return .cardMatch
        case 3: return .soundMatch
        case 4: return .traceLetters
        default: return .sentenceBuilder
        }
    }
}
