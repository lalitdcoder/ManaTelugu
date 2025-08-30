import Foundation

class DataRepository {
    static let shared = DataRepository()
    
    private var lettersCache: [Letter]?
    private var wordsCache: [Word]?
    private var lessonsCache: [Lesson]?
    private var badgesCache: [Badge]?
    
    private init() {}
    
    func letters() -> [Letter] {
        if let cached = lettersCache {
            return cached
        }
        
        guard let url = Bundle.main.url(forResource: "letters", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let letters = try? JSONDecoder().decode([Letter].self, from: data) else {
            return []
        }
        
        lettersCache = letters
        return letters
    }
    
    func words(theme: String? = nil) -> [Word] {
        if let cached = wordsCache {
            if let theme = theme {
                return cached.filter { $0.theme == theme }
            }
            return cached
        }
        
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let words = try? JSONDecoder().decode([Word].self, from: data) else {
            return []
        }
        
        wordsCache = words
        
        if let theme = theme {
            return words.filter { $0.theme == theme }
        }
        return words
    }
    
    func lesson(id: String) -> Lesson? {
        return lessons().first { $0.id == id }
    }
    
    func lessons() -> [Lesson] {
        if let cached = lessonsCache {
            return cached
        }
        
        guard let url = Bundle.main.url(forResource: "lessons", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let lessons = try? JSONDecoder().decode([Lesson].self, from: data) else {
            return []
        }
        
        lessonsCache = lessons
        return lessons
    }
    
    func badges() -> [Badge] {
        if let cached = badgesCache {
            return cached
        }
        
        guard let url = Bundle.main.url(forResource: "badges", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let badges = try? JSONDecoder().decode([Badge].self, from: data) else {
            return []
        }
        
        badgesCache = badges
        return badges
    }
}