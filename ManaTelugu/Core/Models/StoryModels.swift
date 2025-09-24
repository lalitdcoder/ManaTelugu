import Foundation

// MARK: - Story Category
enum StoryCategory: String, CaseIterable, Codable {
    case folktales = "folktales"
    case moral = "moral"
    case children = "children"
    case mythology = "mythology"
    case festivals = "festivals"
    case historical = "historical"
    case nature = "nature"
    case contemporary = "contemporary"
    
    var displayName: String {
        switch self {
        case .folktales: return "పురాణ కథలు"
        case .moral: return "నైతిక కథలు"
        case .children: return "పిల్లల కథలు"
        case .mythology: return "పురాణ గాథలు"
        case .festivals: return "పండుగలు"
        case .historical: return "చారిత్రక కథలు"
        case .nature: return "ప్రకృతి కథలు"
        case .contemporary: return "ఆధునిక కథలు"
        }
    }
    
    var icon: String {
        switch self {
        case .folktales: return "book.closed"
        case .moral: return "heart"
        case .children: return "figure.child"
        case .mythology: return "crown"
        case .festivals: return "party.popper"
        case .historical: return "building.columns"
        case .nature: return "leaf"
        case .contemporary: return "sparkles"
        }
    }
}

// MARK: - Story Difficulty
enum StoryDifficulty: String, CaseIterable, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    var displayName: String {
        switch self {
        case .beginner: return "ప్రారంభ"
        case .intermediate: return "మధ్యమ"
        case .advanced: return "అధునాతన"
        }
    }
    
    var color: String {
        switch self {
        case .beginner: return "green"
        case .intermediate: return "orange"
        case .advanced: return "red"
        }
    }
}

// MARK: - Story
struct TeluguStory: Identifiable, Codable {
    let id = UUID()
    let title: String
    let titleEnglish: String
    let author: String
    let category: StoryCategory
    let difficulty: StoryDifficulty
    let estimatedReadingTime: Int // in minutes
    let content: String
    let contentEnglish: String?
    let culturalContext: String
    let moral: String?
    let keywords: [String]
    let audioFileName: String?
    let illustrationFileName: String?
    let culturalNotes: [CulturalNote]
    var isBookmarked: Bool
    var isCompleted: Bool
    var readingProgress: Double // 0.0 to 1.0
    let dateAdded: Date
    var lastRead: Date?
    
    init(title: String, titleEnglish: String, author: String, category: StoryCategory, difficulty: StoryDifficulty, estimatedReadingTime: Int, content: String, contentEnglish: String? = nil, culturalContext: String, moral: String? = nil, keywords: [String] = [], audioFileName: String? = nil, illustrationFileName: String? = nil, culturalNotes: [CulturalNote] = []) {
        self.title = title
        self.titleEnglish = titleEnglish
        self.author = author
        self.category = category
        self.difficulty = difficulty
        self.estimatedReadingTime = estimatedReadingTime
        self.content = content
        self.contentEnglish = contentEnglish
        self.culturalContext = culturalContext
        self.moral = moral
        self.keywords = keywords
        self.audioFileName = audioFileName
        self.illustrationFileName = illustrationFileName
        self.culturalNotes = culturalNotes
        self.isBookmarked = false
        self.isCompleted = false
        self.readingProgress = 0.0
        self.dateAdded = Date()
        self.lastRead = nil
    }
}

// MARK: - Reading Settings
struct ReadingSettings: Codable {
    var fontSize: FontSize = .medium
    var backgroundTheme: BackgroundTheme = .light
    var showEnglishTranslation: Bool = true
    var autoPlayAudio: Bool = false
    var showCulturalNotes: Bool = true
    var showGlossary: Bool = true
    
    enum FontSize: String, CaseIterable, Codable {
        case small = "small"
        case medium = "medium"
        case large = "large"
        case extraLarge = "extraLarge"
        
        var displayName: String {
            switch self {
            case .small: return "చిన్న"
            case .medium: return "మధ్యమ"
            case .large: return "పెద్ద"
            case .extraLarge: return "చాలా పెద్ద"
            }
        }
        
        var size: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 16
            case .large: return 18
            case .extraLarge: return 20
            }
        }
    }
    
    enum BackgroundTheme: String, CaseIterable, Codable {
        case light = "light"
        case sepia = "sepia"
        case dark = "dark"
        case parchment = "parchment"
        
        var displayName: String {
            switch self {
            case .light: return "తెలుపు"
            case .sepia: return "సెపియా"
            case .dark: return "నలుపు"
            case .parchment: return "కాగితం"
            }
        }
    }
}

// MARK: - Reading Progress
struct ReadingProgress: Codable {
    let storyId: UUID
    let currentPage: Int
    let totalPages: Int
    let readingTime: TimeInterval
    let lastReadDate: Date
    let isCompleted: Bool
    
    var progressPercentage: Double {
        return Double(currentPage) / Double(totalPages)
    }
}

// MARK: - Story Collection
struct StoryCollection: Identifiable, Codable {
    let id = UUID()
    let name: String
    let nameEnglish: String
    let description: String
    let storyIds: [UUID]
    let coverImage: String?
    let isFeatured: Bool
    let dateCreated: Date
    
    init(name: String, nameEnglish: String, description: String, storyIds: [UUID], coverImage: String? = nil, isFeatured: Bool = false) {
        self.name = name
        self.nameEnglish = nameEnglish
        self.description = description
        self.storyIds = storyIds
        self.coverImage = coverImage
        self.isFeatured = isFeatured
        self.dateCreated = Date()
    }
}

// MARK: - Cultural Note
struct CulturalNote: Identifiable, Codable {
    let id = UUID()
    let keyword: String
    let keywordMeaning: String
    let context: String
    let culturalSignificance: String
    
    init(keyword: String, keywordMeaning: String, context: String, culturalSignificance: String) {
        self.keyword = keyword
        self.keywordMeaning = keywordMeaning
        self.context = context
        self.culturalSignificance = culturalSignificance
    }
}
