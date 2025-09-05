import Foundation

actor DataRepository {
    static let shared = DataRepository()
    
    private var lettersCache: [Letter]?
    private var wordsCache: [Word]?
    private var lessonsCache: [Lesson]?
    private var badgesCache: [Badge]?
    
    private init() {}
    
    // MARK: - Cache Setters
    private func setLettersCache(_ letters: [Letter]) async {
        lettersCache = letters
    }
    
    private func setWordsCache(_ words: [Word]) async {
        wordsCache = words
    }
    
    private func setLessonsCache(_ lessons: [Lesson]) async {
        lessonsCache = lessons
    }
    
    private func setBadgesCache(_ badges: [Badge]) async {
        badgesCache = badges
    }
    
    func letters() async -> [Letter] {
        if let cached = lettersCache {
            return cached
        }
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                // Try multiple approaches to find the letters.json file
                var url: URL?
                
                // 1. Try bundle resource
                if let bundleUrl = Bundle.main.url(forResource: "letters", withExtension: "json") {
                    url = bundleUrl
                    print("DEBUG: Found letters.json in bundle at: \(bundleUrl)")
                }
                // 2. Try bundle path
                else if let bundlePath = Bundle.main.path(forResource: "letters", ofType: "json") {
                    url = URL(fileURLWithPath: bundlePath)
                    print("DEBUG: Found letters.json via bundle path: \(bundlePath)")
                }
                // 3. Try source files (for development)
                else {
                    let sourceUrl = URL(fileURLWithPath: "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/Resources/Data/letters.json")
                    if FileManager.default.fileExists(atPath: sourceUrl.path) {
                        url = sourceUrl
                        print("DEBUG: Found letters.json in source at: \(sourceUrl)")
                    }
                }
                
                if let finalUrl = url {
                    print("DEBUG: Found letters.json at: \(finalUrl)")
                    if let data = try? Data(contentsOf: finalUrl) {
                        do {
                            let letters = try JSONDecoder().decode([Letter].self, from: data)
                            print("DEBUG: Successfully decoded \(letters.count) letters from JSON")
                            Task {
                                await self.setLettersCache(letters)
                                continuation.resume(returning: letters)
                            }
                            return
                        } catch {
                            print("DEBUG: Could not decode letters.json: \(error)")
                        }
                    }
                }
                
                // Fallback to embedded data
                print("DEBUG: Using embedded letters data as fallback")
                let letters = EmbeddedLettersData.letters
                print("DEBUG: Loaded \(letters.count) letters from embedded data")
                Task {
                    await self.setLettersCache(letters)
                    continuation.resume(returning: letters)
                }
            }
        }
    }
    
    func words(theme: String? = nil) async -> [Word] {
        if let cached = wordsCache {
            if let theme = theme {
                return cached.filter { $0.theme == theme }
            }
            return cached
        }
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                // Try multiple approaches to find the words.json file
                var url: URL?
                
                // 1. Try bundle resource
                if let bundleUrl = Bundle.main.url(forResource: "words", withExtension: "json") {
                    url = bundleUrl
                    print("DEBUG: Found words.json in bundle at: \(bundleUrl)")
                }
                // 2. Try bundle path
                else if let bundlePath = Bundle.main.path(forResource: "words", ofType: "json") {
                    url = URL(fileURLWithPath: bundlePath)
                    print("DEBUG: Found words.json via bundle path: \(bundlePath)")
                }
                // 3. Try source files (for development)
                else {
                    let sourceUrl = URL(fileURLWithPath: "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/Resources/Data/words.json")
                    if FileManager.default.fileExists(atPath: sourceUrl.path) {
                        url = sourceUrl
                        print("DEBUG: Found words.json in source at: \(sourceUrl)")
                    }
                }
                
                if let finalUrl = url {
                    print("DEBUG: Found words.json at: \(finalUrl)")
                    if let data = try? Data(contentsOf: finalUrl) {
                        do {
                            let words = try JSONDecoder().decode([Word].self, from: data)
                            print("DEBUG: Successfully decoded \(words.count) words from JSON")
                            Task {
                                await self.setWordsCache(words)
                                if let theme = theme {
                                    let filteredWords = words.filter { $0.theme == theme }
                                    print("DEBUG: Filtered to \(filteredWords.count) words for theme: \(theme)")
                                    continuation.resume(returning: filteredWords)
                                } else {
                                    continuation.resume(returning: words)
                                }
                            }
                            return
                        } catch {
                            print("DEBUG: Could not decode words.json: \(error)")
                        }
                    }
                }
                
                // Fallback to embedded data
                print("DEBUG: Using embedded words data as fallback")
                let words = EmbeddedWordsData.words
                print("DEBUG: Loaded \(words.count) words from embedded data")
                Task {
                    await self.setWordsCache(words)
                    if let theme = theme {
                        let filteredWords = words.filter { $0.theme == theme }
                        print("DEBUG: Filtered to \(filteredWords.count) words for theme: \(theme)")
                        continuation.resume(returning: filteredWords)
                    } else {
                        continuation.resume(returning: words)
                    }
                }
            }
        }
    }
    
    func lesson(id: String) async -> Lesson? {
        let all = await lessons()
        return all.first { $0.id == id }
    }
    
    func lessons() async -> [Lesson] {
        if let cached = lessonsCache {
            return cached
        }
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                // Try multiple approaches to find the lessons.json file
                var url: URL?
                
                // 1. Try bundle resource
                if let bundleUrl = Bundle.main.url(forResource: "lessons", withExtension: "json") {
                    url = bundleUrl
                    print("DEBUG: Found lessons.json in bundle at: \(bundleUrl)")
                }
                // 2. Try bundle path
                else if let bundlePath = Bundle.main.path(forResource: "lessons", ofType: "json") {
                    url = URL(fileURLWithPath: bundlePath)
                    print("DEBUG: Found lessons.json via bundle path: \(bundlePath)")
                }
                // 3. Try source files (for development)
                else {
                    let sourceUrl = URL(fileURLWithPath: "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/Resources/Data/lessons.json")
                    if FileManager.default.fileExists(atPath: sourceUrl.path) {
                        url = sourceUrl
                        print("DEBUG: Found lessons.json in source at: \(sourceUrl)")
                    }
                }
                
                guard let finalUrl = url else {
                    print("DEBUG: Could not find lessons.json in bundle or source")
                    continuation.resume(returning: [])
                    return
                }
                
                guard let data = try? Data(contentsOf: finalUrl) else {
                    print("DEBUG: Could not read data from lessons.json")
                    continuation.resume(returning: [])
                    return
                }
                
                do {
                    let lessons = try JSONDecoder().decode([Lesson].self, from: data)
                    print("DEBUG: Successfully decoded \(lessons.count) lessons")
                    Task {
                        await self.setLessonsCache(lessons)
                        continuation.resume(returning: lessons)
                    }
                } catch {
                    print("DEBUG: Could not decode lessons.json: \(error)")
                    continuation.resume(returning: [])
                    return
                }
            }
        }
    }
    
    func badges() async -> [Badge] {
        if let cached = badgesCache {
            return cached
        }
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                // Try multiple approaches to find the badges.json file
                var url: URL?
                
                // 1. Try bundle resource
                if let bundleUrl = Bundle.main.url(forResource: "badges", withExtension: "json") {
                    url = bundleUrl
                    print("DEBUG: Found badges.json in bundle at: \(bundleUrl)")
                }
                // 2. Try bundle path
                else if let bundlePath = Bundle.main.path(forResource: "badges", ofType: "json") {
                    url = URL(fileURLWithPath: bundlePath)
                    print("DEBUG: Found badges.json via bundle path: \(bundlePath)")
                }
                // 3. Try source files (for development)
                else {
                    let sourceUrl = URL(fileURLWithPath: "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/Resources/Data/badges.json")
                    if FileManager.default.fileExists(atPath: sourceUrl.path) {
                        url = sourceUrl
                        print("DEBUG: Found badges.json in source at: \(sourceUrl)")
                    }
                }
                
                guard let finalUrl = url else {
                    print("DEBUG: Could not find badges.json in bundle or source")
                    continuation.resume(returning: [])
                    return
                }
                
                guard let data = try? Data(contentsOf: finalUrl) else {
                    print("DEBUG: Could not read data from badges.json")
                    continuation.resume(returning: [])
                    return
                }
                
                do {
                    let badges = try JSONDecoder().decode([Badge].self, from: data)
                    print("DEBUG: Successfully decoded \(badges.count) badges")
                    Task {
                        await self.setBadgesCache(badges)
                        continuation.resume(returning: badges)
                    }
                } catch {
                    print("DEBUG: Could not decode badges.json: \(error)")
                    continuation.resume(returning: [])
                    return
                }
            }
        }
    }
    
    func unlockBadge(_ badgeName: String, session: AppSession) async {
        guard let badge = await badges().first(where: { $0.name == badgeName }) else {
            print("Badge not found: \(badgeName)")
            return
        }
        
        // Logic to unlock badge (e.g., update user profile or database)
        session.updateUserProfile { profile in
            profile.unlockedBadges.insert(badge.id)
        }
        print("Unlocked badge: \(badgeName)")
    }
}