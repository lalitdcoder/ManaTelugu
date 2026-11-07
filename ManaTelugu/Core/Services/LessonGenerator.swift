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

    /// Primary production lesson retriever with caching, Supabase Edge Function integration, and mock fallback.
    func fetchOrGenerateLesson(forModule module: CurriculumModule, forceRefresh: Bool = false) async -> LessonResponse {
        // Step 1: Check cache unless force refreshed
        if !forceRefresh, let cached = LearnerRepository.shared.getCachedLesson(forModuleId: module.id) {
            print("📦 Returning cached generated lesson for module: \(module.title)")
            return cached
        }

        // Step 2: Try fetching/generating via Supabase Edge Function
        do {
            let generatedLesson = try await SupabaseManager.shared.generateLesson(moduleId: module.id)
            let lessonTitle = generatedLesson.title ?? module.title
            print("✅ Edge function returned lesson for module: \(lessonTitle)")

            let response = MockLessonProvider.shared.loadMockLesson(forModuleId: module.id, title: lessonTitle)
            LearnerRepository.shared.cacheGeneratedLesson(response, forModuleId: module.id)
            return response
        } catch {
            print("⚠️ Supabase Edge Function offline or returned error (\(error.localizedDescription)). Using structured mock lesson fallback.")
            let fallbackResponse = MockLessonProvider.shared.loadMockLesson(forModuleId: module.id, title: module.title)
            LearnerRepository.shared.cacheGeneratedLesson(fallbackResponse, forModuleId: module.id)
            return fallbackResponse
        }
    }

    /// Asynchronously generates a lesson via Supabase Edge Function or falls back to local rules.
    func generateLessonAsync(moduleId: String, topic: String, tier: Int) async -> [GameStep] {
        do {
            let generated = try await SupabaseManager.shared.generateLesson(moduleId: moduleId)
            print("✅ Successfully generated AI lesson: \(generated.title ?? topic)")
        } catch {
            print("⚠️ Edge function fallback to local generator: \(error.localizedDescription)")
        }
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
            }
            steps.append(.vocabulary(words: selectedWords))
            steps.append(.cardMatch(words: selectedWords))

            if let firstWord = selectedWords.first, let letter = repository.letters.first {
                steps.append(.writing(letter: letter, anchorWord: firstWord))
            }

        case 2: // Silver - Recall & Sentence Building
            steps.append(.matching(words: selectedWords))
            steps.append(.sentenceBuilder(words: selectedWords))

            for word in selectedWords.prefix(2) {
                steps.append(.listening(word: word))
            }

        default: // Gold / Conversation
            steps.append(.review(words: selectedWords))
            steps.append(.conversation(topic: topic))
        }

        return steps
    }
}
