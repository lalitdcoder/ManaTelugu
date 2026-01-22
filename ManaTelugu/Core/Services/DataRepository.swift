import Combine
import Foundation

@MainActor
class DataRepository: ObservableObject {
    @Published var letters: [Letter] = []
    @Published var words: [Word] = []
    @Published var lessons: [Lesson] = []
    @Published var isLoading = false
    @Published var error: DataError?

    private let userDefaults = UserDefaults.standard
    private let learnedLetterIDsKey = "learnedLetterIDs"
    private let learnedWordIDsKey = "learnedWordIDs"  // <-- NEW

    // MARK: - Letter Progress

    public func updateLetterProgress(letterID: String, isLearned: Bool) {
        if let index = letters.firstIndex(where: { $0.id == letterID }) {
            letters[index].isLearned = isLearned

            var learnedIDs = Set(loadProgress([String].self, key: learnedLetterIDsKey) ?? [])
            if isLearned {
                learnedIDs.insert(letterID)
            } else {
                learnedIDs.remove(letterID)
            }
            saveProgress(Array(learnedIDs), key: learnedLetterIDsKey)
        }
    }

    public func markLetterAsLearned(_ letterID: String) {
        updateLetterProgress(letterID: letterID, isLearned: true)
    }

    public func unmarkLetterAsLearned(_ letterID: String) {
        updateLetterProgress(letterID: letterID, isLearned: false)
    }

    // MARK: - Word Progress

    public func isWordLearned(_ wordID: String) -> Bool {
        let learnedIDs = Set(loadProgress([String].self, key: learnedWordIDsKey) ?? [])
        return learnedIDs.contains(wordID)
    }

    public func markWordAsLearned(_ wordID: String) {
        var learnedIDs = Set(loadProgress([String].self, key: learnedWordIDsKey) ?? [])
        learnedIDs.insert(wordID)
        saveProgress(Array(learnedIDs), key: learnedWordIDsKey)
    }

    public func resetProgress() {
        userDefaults.removeObject(forKey: learnedLetterIDsKey)
        userDefaults.removeObject(forKey: learnedWordIDsKey)

        for index in letters.indices {
            letters[index].isLearned = false
        }
    }

    enum DataError: LocalizedError {
        case loadingFailed(String)
        case savingFailed(String)
        case notFound(String)

        var errorDescription: String? {
            switch self {
            case .loadingFailed(let item): return "Failed to load \(item)"
            case .savingFailed(let item): return "Failed to save \(item)"
            case .notFound(let item): return "\(item) not found"
            }
        }
    }

    init() {
        loadData()
    }

    // MARK: - Data Loading
    func loadData() {
        isLoading = true
        error = nil

        Task {
            do {
                // Sequential loading to ensure specific error context
                do {
                    self.letters = try await loadLetters()
                } catch {
                    print("⚠️ Letters load failed, using fallbacks: \(error.localizedDescription)")
                    self.letters = fallbackLetters()
                }

                do {
                    self.words = try await loadWords()
                } catch {
                    print("⚠️ Words load failed, using fallbacks: \(error.localizedDescription)")
                    self.words = EmbeddedWordsData.words
                }

                do {
                    self.lessons = try await loadLessons()
                } catch {
                    print("⚠️ Lessons load failed, using fallbacks: \(error.localizedDescription)")
                    self.lessons = fallbackLessons()
                }

                await MainActor.run {
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = .loadingFailed(
                        "Essential data is missing or corrupted. Please restart the app.")
                    self.isLoading = false
                }
            }
        }
    }

    private func fallbackLetters() -> [Letter] {
        return [
            Letter(
                id: "1", character: "అ", romanization: "a", meaning: "vowel a", category: .vowel),
            Letter(
                id: "2", character: "ఆ", romanization: "aa", meaning: "vowel aa", category: .vowel),
            Letter(
                id: "3", character: "ఇ", romanization: "i", meaning: "vowel i", category: .vowel),
            Letter(
                id: "4", character: "ఈ", romanization: "ee", meaning: "vowel ee", category: .vowel),
        ]
    }

    private func fallbackLessons() -> [Lesson] {
        return [
            Lesson(
                id: "1", title: "Telugu Vowels", description: "Learn basic vowel sounds",
                levelId: "beginner", order: 1, difficulty: 1, xpReward: 50, estimatedMinutes: 10,
                activities: []),
            Lesson(
                id: "2", title: "Basic Consonants", description: "Learn consonant sounds",
                levelId: "beginner", order: 2, difficulty: 2, xpReward: 75, estimatedMinutes: 15,
                activities: []),
        ]
    }

    private func loadLetters() async throws -> [Letter] {
        struct LetterEntry: Decodable {
            let id: String
            let glyph: String
            let transliteration: String
            let audioFile: String?
            let strokePathPoints: [[[String: Double]]]
        }
        guard let url = Bundle.main.url(forResource: "letters", withExtension: "json") else {
            // Fallback to minimal seed if JSON missing
            return [
                Letter(
                    id: "1", character: "అ", romanization: "a", meaning: "vowel a", category: .vowel
                ),
                Letter(
                    id: "2", character: "ఆ", romanization: "aa", meaning: "vowel aa",
                    category: .vowel),
                Letter(
                    id: "3", character: "ఇ", romanization: "i", meaning: "vowel i", category: .vowel
                ),
                Letter(
                    id: "4", character: "ఈ", romanization: "ee", meaning: "vowel ee",
                    category: .vowel),
            ]
        }
        let data = try Data(contentsOf: url)
        let entries = try JSONDecoder().decode([LetterEntry].self, from: data)

        let learnedIDs = Set(loadProgress([String].self, key: learnedLetterIDsKey) ?? [])

        let vowelSet: Set<String> = [
            "అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఋ", "ౠ", "ఎ", "ఏ", "ఐ", "ఒ", "ఓ", "ఔ", "అఁ", "అం", "అః",
        ]
        func toCGPointArray(_ raw: [[String: Double]]) -> [CGPointCodable] {
            raw.compactMap { dict in
                if let x = dict["x"], let y = dict["y"] { return CGPointCodable(x: x, y: y) }
                return nil
            }
        }
        return entries.map { entry in
            let points: [[CGPointCodable]] = entry.strokePathPoints.map { toCGPointArray($0) }
            let category: LetterCategory = vowelSet.contains(entry.glyph) ? .vowel : .consonant
            var letter = Letter(
                id: entry.id,
                character: entry.glyph,
                romanization: entry.transliteration,
                meaning: entry.transliteration,
                category: category,
                strokePathPoints: points,
                audioFileName: entry.audioFile,
                difficulty: 1
            )
            if learnedIDs.contains(letter.id) {
                letter.isLearned = true
            }
            return letter
        }
    }

    private func loadWords() async throws -> [Word] {
        if let url = Bundle.main.url(forResource: "words", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let words = try JSONDecoder().decode([Word].self, from: data)
                return words
            } catch {
                // Log error to analytics if needed
            }
        }
        return EmbeddedWordsData.words
    }

    private func loadLessons() async throws -> [Lesson] {
        return [
            Lesson(
                id: "1", title: "Telugu Vowels", description: "Learn basic vowel sounds",
                levelId: "beginner", order: 1, difficulty: 1, xpReward: 50, estimatedMinutes: 10,
                activities: []),
            Lesson(
                id: "2", title: "Basic Consonants", description: "Learn consonant sounds",
                levelId: "beginner", order: 2, difficulty: 2, xpReward: 75, estimatedMinutes: 15,
                activities: []),
        ]
    }

    // MARK: - Getters with Error Handling
    func getLetter(by id: String) -> Letter? {
        letters.first { $0.id == id }
    }

    func getLetters(by category: LetterCategory) -> [Letter] {
        letters.filter { $0.category == category }
    }

    func getWord(by id: String) -> Word? {
        words.first { $0.id == id }
    }

    func getLesson(by id: String) -> Lesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - Progress Persistence
    func saveProgress<T: Codable>(_ data: T, key: String) {
        do {
            let encoded = try JSONEncoder().encode(data)
            userDefaults.set(encoded, forKey: key)
        } catch {
            self.error = .savingFailed(key)
        }
    }

    func loadProgress<T: Codable>(_ type: T.Type, key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
