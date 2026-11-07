import Foundation

enum GameStep: Hashable {
    case introduction(word: Word)
    case vocabulary(words: [Word])
    case multipleChoice(question: ActivityQuestion)
    case matching(words: [Word])
    case listening(word: Word)
    case reading(word: Word)
    case sentenceBuilder(words: [Word])
    case fillBlank(question: ActivityQuestion)
    case writing(letter: Letter, anchorWord: Word)
    case speaking(word: Word)
    case translation(word: Word)
    case review(words: [Word])
    case conversation(topic: String)
    case cardMatch(words: [Word])
    case tracing(letter: Letter, anchorWord: Word)
}

@MainActor
class LessonGenerator {
    static let shared = LessonGenerator()
    private let repository: DataRepository

    init(repository: DataRepository? = nil) {
        self.repository = repository ?? DataRepository()
    }

    /// Primary production lesson retriever with offline generation and local caching.
    func fetchOrGenerateLesson(forModule module: CurriculumModule, forceRefresh: Bool = false) async -> LessonResponse {
        // Step 1: Check cache unless force refreshed
        if !forceRefresh, let cached = LearnerRepository.shared.getCachedLesson(forModuleId: module.id) {
            return cached
        }

        // Step 2: Generate structured lesson offline
        let response = MockLessonProvider.shared.loadMockLesson(forModuleId: module.id, title: module.title)
        LearnerRepository.shared.cacheGeneratedLesson(response, forModuleId: module.id)
        return response
    }

    /// Asynchronously generates a lesson sequence using local offline curriculum rules.
    func generateLessonAsync(moduleId: String, topic: String, tier: Int) async -> [GameStep] {
        return generateLesson(topic: topic, tier: tier)
    }

    /// Generates a lesson sequence based on a topic and difficulty tier.
    func generateLesson(topic: String, tier: Int) -> [GameStep] {
        let themeWords = repository.words.filter { $0.theme.lowercased() == topic.lowercased() }
        let selectedWords = Array(themeWords.isEmpty ? repository.words.shuffled().prefix(4) : themeWords.shuffled().prefix(4))

        guard !selectedWords.isEmpty else {
            print("⚠️ No words found for topic: \(topic)")
            return []
        }

        var steps: [GameStep] = []

        switch tier {
        case 1: // Bronze - Foundations & Recognition
            for word in selectedWords {
                steps.append(.introduction(word: word))
                steps.append(.listening(word: word))
            }
            steps.append(.matching(words: selectedWords))
            steps.append(.cardMatch(words: selectedWords))
            steps.append(.review(words: selectedWords))

        case 2: // Silver - Active Recall & Tracing
            for word in selectedWords {
                steps.append(.reading(word: word))
                if let firstLetterChar = word.telugu.first {
                    let matchingLetter = repository.letters.first { $0.character == String(firstLetterChar) }
                        ?? Letter(id: "L_\(firstLetterChar)", character: String(firstLetterChar), romanization: word.transliteration, meaning: word.english, category: .consonant)
                    steps.append(.writing(letter: matchingLetter, anchorWord: word))
                }
            }
            steps.append(.sentenceBuilder(words: selectedWords))
            steps.append(.review(words: selectedWords))

        case 3: // Gold - Mastery & Full Application
            for word in selectedWords {
                steps.append(.speaking(word: word))
                steps.append(.translation(word: word))
            }
            steps.append(.sentenceBuilder(words: selectedWords))
            steps.append(.conversation(topic: topic))
            steps.append(.review(words: selectedWords))

        default:
            for word in selectedWords {
                steps.append(.introduction(word: word))
            }
            steps.append(.review(words: selectedWords))
        }

        return steps
    }
}
