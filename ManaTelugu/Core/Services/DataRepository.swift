import Foundation
import Combine

@MainActor
class DataRepository: ObservableObject {
    @Published var letters: [Letter] = []
    @Published var words: [Word] = []
    @Published var lessons: [Lesson] = []
    @Published var isLoading = false
    @Published var error: DataError?
    
    private let userDefaults = UserDefaults.standard
    
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
                async let lettersTask = loadLetters()
                async let wordsTask = loadWords()
                async let lessonsTask = loadLessons()
                
                let (loadedLetters, loadedWords, loadedLessons) = try await (lettersTask, wordsTask, lessonsTask)
                
                await MainActor.run {
                    self.letters = loadedLetters
                    self.words = loadedWords
                    self.lessons = loadedLessons
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = .loadingFailed("data")
                    self.isLoading = false
                }
            }
        }
    }
    
    private func loadLetters() async throws -> [Letter] {
        return [
            Letter(id: "1", character: "అ", romanization: "a", meaning: "vowel a", category: .vowel),
            Letter(id: "2", character: "ఆ", romanization: "aa", meaning: "vowel aa", category: .vowel),
            Letter(id: "3", character: "ఇ", romanization: "i", meaning: "vowel i", category: .vowel),
            Letter(id: "4", character: "ఈ", romanization: "ee", meaning: "vowel ee", category: .vowel),
            Letter(id: "5", character: "ఉ", romanization: "u", meaning: "vowel u", category: .vowel),
            Letter(id: "6", character: "క", romanization: "ka", meaning: "consonant ka", category: .consonant),
            Letter(id: "7", character: "గ", romanization: "ga", meaning: "consonant ga", category: .consonant),
            Letter(id: "8", character: "చ", romanization: "cha", meaning: "consonant cha", category: .consonant)
        ]
    }
    
    private func loadWords() async throws -> [Word] {
        return [
            Word(id: "1", telugu: "అమ్మ", transliteration: "amma", english: "Mother", imageName: "family_mother", audioFile: "amma.mp3", theme: "Family"),
            Word(id: "2", telugu: "నాన్న", transliteration: "naanna", english: "Father", imageName: "family_father", audioFile: "naanna.mp3", theme: "Family"),
            Word(id: "3", telugu: "నీరు", transliteration: "neeru", english: "Water", imageName: "basic_water", audioFile: "neeru.mp3", theme: "Basic")
        ]
    }
    
    private func loadLessons() async throws -> [Lesson] {
        return [
            Lesson(id: "1", title: "Telugu Vowels", description: "Learn basic vowel sounds", levelId: "beginner", order: 1, difficulty: 1, xpReward: 50, estimatedMinutes: 10, activities: []),
            Lesson(id: "2", title: "Basic Consonants", description: "Learn consonant sounds", levelId: "beginner", order: 2, difficulty: 2, xpReward: 75, estimatedMinutes: 15, activities: [])
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
