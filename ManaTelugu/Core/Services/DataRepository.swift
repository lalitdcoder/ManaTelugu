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
        
        // Try multiple approaches to find the letters.json file
        var url: URL?
        
        // 1. Try bundle resource
        if let bundleUrl = Bundle.main.url(forResource: "letters", withExtension: "json") {
            url = bundleUrl
        }
        // 2. Try bundle path
        else if let bundlePath = Bundle.main.path(forResource: "letters", ofType: "json") {
            url = URL(fileURLWithPath: bundlePath)
        }
        // 3. Try source files (for development)
        else {
            let sourceUrl = URL(fileURLWithPath: "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/Resources/Data/letters.json")
            if FileManager.default.fileExists(atPath: sourceUrl.path) {
                url = sourceUrl
            }
        }
        
        var letters: [Letter] = []
        
        if let finalUrl = url {
            if let data = try? Data(contentsOf: finalUrl) {
                do {
                    letters = try JSONDecoder().decode([Letter].self, from: data)
                } catch {
                    // Fallback to embedded data
                    letters = EmbeddedLettersData.letters
                }
            } else {
                // Fallback to embedded data
                letters = EmbeddedLettersData.letters
            }
        } else {
            // Fallback to embedded data
            letters = EmbeddedLettersData.letters
        }
        
        // Apply stroke overrides
        if let overrides = await loadStrokeOverrides() {
            letters = await applyStrokeOverrides(overrides, to: letters)
        }
        
        await setLettersCache(letters)
        return letters
    }

    // MARK: - Stroke Overrides
    private func loadStrokeOverrides() -> [String: [[CGPointCodable]]]? {
        // 1) Look in app bundle
        if let bundleUrl = Bundle.main.url(forResource: "strokes", withExtension: "json") {
            if let data = try? Data(contentsOf: bundleUrl) {
                if let decoded = try? JSONDecoder().decode([String: [[CGPointCodable]]].self, from: data) {
                    return decoded
                }
            }
        }
        // 2) Dev path
        let devPath = "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/Resources/Data/strokes.json"
        if FileManager.default.fileExists(atPath: devPath) {
            let url = URL(fileURLWithPath: devPath)
            if let data = try? Data(contentsOf: url) {
                if let decoded = try? JSONDecoder().decode([String: [[CGPointCodable]]].self, from: data) {
                    return decoded
                }
            }
        }
        return nil
    }
    
    private func applyStrokeOverrides(_ overrides: [String: [[CGPointCodable]]], to letters: [Letter]) -> [Letter] {
        var map: [String: [[CGPointCodable]]] = overrides
        return letters.map { letter in
            if let newStrokes = map[letter.id], !newStrokes.isEmpty {
                return Letter(
                    id: letter.id,
                    glyph: letter.glyph,
                    name: letter.name,
                    transliteration: letter.transliteration,
                    audioFile: letter.audioFile,
                    strokePathPoints: newStrokes
                )
            } else {
                return letter
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
                }
                // 2. Try bundle path
                else if let bundlePath = Bundle.main.path(forResource: "words", ofType: "json") {
                    url = URL(fileURLWithPath: bundlePath)
                }
                // 3. Try source files (for development)
                else {
                    let sourceUrl = URL(fileURLWithPath: "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/Resources/Data/words.json")
                    if FileManager.default.fileExists(atPath: sourceUrl.path) {
                        url = sourceUrl
                    }
                }
                
                if let finalUrl = url {
                    if let data = try? Data(contentsOf: finalUrl) {
                        do {
                            let words = try JSONDecoder().decode([Word].self, from: data)
                            Task {
                                await self.setWordsCache(words)
                                if let theme = theme {
                                    let filteredWords = words.filter { $0.theme == theme }
                                    continuation.resume(returning: filteredWords)
                                } else {
                                    continuation.resume(returning: words)
                                }
                            }
                            return
                        } catch {
                            // Fallback to embedded data
                        }
                    }
                }
                
                // Fallback to embedded data
                let words = EmbeddedWordsData.words
                Task {
                    await self.setWordsCache(words)
                    if let theme = theme {
                        let filteredWords = words.filter { $0.theme == theme }
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
                    let decoder = JSONDecoder()
                    // First try new dictionary format: { "levels": [...] }
                    if let lessonData = try? decoder.decode(LessonData.self, from: data) {
                        let lessons = lessonData.levels.flatMap { $0.lessons }
                        print("DEBUG: Successfully decoded lessons from LessonData: total \(lessons.count)")
                        Task {
                            await self.setLessonsCache(lessons)
                            continuation.resume(returning: lessons)
                        }
                        return
                    }
                    // Fallback to legacy format: [Lesson]
                    let lessons = try decoder.decode([Lesson].self, from: data)
                    print("DEBUG: Successfully decoded \(lessons.count) lessons (legacy array format)")
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
        
        // Badge unlocking is now handled by GamificationService
        print("Badge unlocked: \(badgeName)")
    }
}