import Foundation
import Combine

class StoryService: ObservableObject {
    static let sampleStories = [
        TeluguStory(
            title: "పిల్లి మరియు ఎలుక",
            titleEnglish: "The Cat and the Mouse",
            author: "ప్రాచీన కథ",
            category: .folktales,
            difficulty: .beginner,
            estimatedReadingTime: 5,
            content: """
                ఒకప్పుడు ఒక పిల్లి ఉండేది. అది చాలా చురుకుగా ఉండేది. ఒక రోజు అది ఒక ఎలుకను చూసింది. ఎలుక చాలా చిన్నది, కానీ చురుకుగా ఉండేది.
                
                పిల్లి ఎలుకను పట్టుకోవాలని అనుకుంది. కానీ ఎలుక చాలా తెలివైనది. అది పిల్లి వచ్చినప్పుడు ఒక రంధ్రంలోకి దూరింది.
                
                పిల్లి ఎలుకను పట్టుకోలేకపోయింది. ఎలుక రంధ్రంలో నుంచి చూస్తూ, "పిల్లి అమ్మా, నేను ఇక్కడే ఉన్నాను!" అని అన్నది.
                
                పిల్లి చాలా కోపంతో ఉండింది. కానీ ఎలుకను పట్టుకోలేకపోయింది. చివరికి పిల్లి వెళ్లిపోయింది.
                """,
                contentEnglish: """
                Once upon a time, there was a cat. It was very clever. One day it saw a mouse. The mouse was very small but clever.
                
                The cat wanted to catch the mouse. But the mouse was very smart. When the cat came, it ran into a hole.
                
                The cat couldn't catch the mouse. The mouse looked out from the hole and said, "Cat, I'm here!"
                
                The cat was very angry. But it couldn't catch the mouse. Finally, the cat went away.
                """,
                culturalContext: "ఈ కథ తెలుగు సంస్కృతిలో చాలా ప్రసిద్ధమైన నైతిక కథ. ఇది చిన్న పిల్లలకు తెలివితేటల గురించి చెప్పుతుంది.",
                moral: "తెలివితేటలు శక్తి కంటే ముఖ్యమైనవి.",
                keywords: ["పిల్లి", "ఎలుక", "తెలివితేటలు", "నైతిక కథ"],
                audioFileName: "cat_mouse_story.mp3",
                culturalNotes: [
                    CulturalNote(keyword: "పిల్లి", keywordMeaning: "Cat", context: "In many Telugu stories, cats are portrayed as clever and cunning animals.", culturalSignificance: "Cats are common pets in Telugu households and are often seen as symbols of independence.")
                ]
            ),
            
            TeluguStory(
                title: "కాకి మరియు కుండ",
                titleEnglish: "The Crow and the Water Pot",
                author: "ప్రాచీన కథ",
                category: .folktales,
                difficulty: .beginner,
                estimatedReadingTime: 6,
                content: """
                ఒక వేసవి రోజు, ఒక కాకి చాలా దాహంతో ఉండింది. అది నీటి కోసం చాలా వెతుకుతూ ఉండింది.
                
                చివరికి అది ఒక ఇంటి ముందు ఒక చిన్న నీటి కుండను చూసింది. కుండలో నీరు ఉంది, కానీ చాలా తక్కువ.
                
                కాకి నీటిని తాకలేకపోయింది. అది చాలా బాధపడింది. కానీ అది ఒక ఆలోచన చేసింది.
                
                అది చిన్న రాళ్లను కుండలోకి వేసింది. రాళ్లు వేసినప్పుడు నీరు పైకి వచ్చింది. కాకి నీటిని తాగింది.
                """,
                contentEnglish: """
                One summer day, a crow was very thirsty. It was searching for water everywhere.
                
                Finally, it saw a small water pot in front of a house. There was water in the pot, but very little.
                
                The crow couldn't reach the water. It was very sad. But it had an idea.
                
                It dropped small stones into the pot. When the stones were dropped, the water level rose. The crow drank the water.
                """,
                culturalContext: "ఈ కథ తెలివితేటలు మరియు ధైర్యం గురించి చెప్పుతుంది. ఇది చిన్న పిల్లలకు సమస్యలను పరిష్కరించే విధానం నేర్పుతుంది.",
                moral: "సమస్యలను తెలివితేటలతో పరిష్కరించవచ్చు.",
                keywords: ["కాకి", "నీటి కుండ", "తెలివితేటలు", "ధైర్యం"],
                audioFileName: "crow_pot_story.mp3"
            ),
            
            // Moral Stories
            TeluguStory(
                title: "నిజాయితీ గల రాకుమారుడు",
                titleEnglish: "The Truthful Prince",
                author: "ప్రాచీన కథ",
                category: .moral,
                difficulty: .intermediate,
                estimatedReadingTime: 8,
                content: """
                ఒక రాజ్యంలో ఒక రాజు ఉండేవాడు. అతనికి ఒక కుమారుడు ఉండేవాడు. ఆ కుమారుడు చాలా సత్యవాది.
                
                ఒక రోజు రాజు తన కుమారుడిని పిలిచి, "నీవు ఎప్పుడూ సత్యం మాట్లాడతావు. ఇది మంచిది. కానీ కొన్ని సమయాలలో తెలివిగా మాట్లాడాలి" అన్నాడు.
                
                కుమారుడు, "తండ్రీ, సత్యం ఎప్పుడూ మంచిదే. నేను ఎప్పుడూ సత్యం మాట్లాడతాను" అన్నాడు.
                
                రాజు ఒక పరీక్ష చేయాలని అనుకుంది. అతను ఒక చిన్న పెట్టెను తీసుకువచ్చి, "ఇందులో ఏమి ఉందో చెప్పు" అన్నాడు.
                
                కుమారుడు పెట్టెను తెరిచి చూస్తే, అందులో ఒక చిన్న పిల్లి ఉంది. అది చనిపోయింది.
                
                "ఇందులో ఏమి ఉంది?" రాజు అడిగాడు.
                
                "ఒక చనిపోయిన పిల్లి" కుమారుడు సత్యం చెప్పాడు.
                
                రాజు చాలా సంతోషించాడు. "నీవు నిజంగా సత్యవాది. నీవు రాజ్యానికి తగిన రాజు అవుతావు" అన్నాడు.
                """,
                contentEnglish: """
                In a kingdom, there was a king. He had a son. The son was very truthful.
                
                One day the king called his son and said, "You always speak the truth. This is good. But sometimes you need to speak wisely."
                
                The prince said, "Father, truth is always good. I will always speak the truth."
                
                The king wanted to test him. He brought a small box and said, "Tell me what's inside this."
                
                When the prince opened the box, there was a small cat inside. It was dead.
                
                "What's inside?" the king asked.
                
                "A dead cat," the prince told the truth.
                
                The king was very happy. "You are truly truthful. You will be a good king for the kingdom," he said.
                """,
                culturalContext: "ఈ కథ సత్యవాదిత్వం యొక్క ప్రాముఖ్యతను చెప్పుతుంది. ఇది తెలుగు సంస్కృతిలో చాలా ప్రసిద్ధమైన నైతిక కథ.",
                moral: "సత్యం ఎప్పుడూ విజయిస్తుంది.",
                keywords: ["నిజాయితీ", "రాజు", "కుమారుడు", "నైతికత"],
                audioFileName: "truthful_prince_story.mp3"
            ),
            
            // Children's Stories
            TeluguStory(
                title: "చిన్న పెద్ద కుక్క",
                titleEnglish: "The Little and Big Dog",
                author: "ఆధునిక కథ",
                category: .children,
                difficulty: .beginner,
                estimatedReadingTime: 4,
                content: """
                ఒక చిన్న కుక్క ఉండేది. దాని పేరు చిన్న. అది చాలా చురుకుగా ఉండేది.
                
                ఒక పెద్ద కుక్క ఉండేది. దాని పేరు పెద్ద. అది చాలా బలంగా ఉండేది.
                
                ఒక రోజు చిన్న కుక్క ఒక బోనును చూసింది. అందులో చాలా మంచి ఆహారం ఉంది.
                
                "ఈ బోను నాది!" చిన్న కుక్క అన్నది.
                
                "లేదు, ఇది నాది!" పెద్ద కుక్క అన్నది.
                
                రెండు కుక్కలు కొట్టుకుంటున్నాయి. చివరికి పెద్ద కుక్క గెలిచింది.
                
                కానీ చిన్న కుక్క చాలా బాధపడింది. పెద్ద కుక్క చిన్న కుక్కను చూసి, "అలాగే, మనం ఇద్దరం కలిసి తిందాం" అన్నది.
                
                రెండు కుక్కలు కలిసి ఆహారాన్ని తిన్నాయి. అవి మంచి స్నేహితులు అయ్యాయి.
                """,
                contentEnglish: """
                There was a little dog. Its name was Little. It was very clever.
                
                There was a big dog. Its name was Big. It was very strong.
                
                One day the little dog saw a bowl. There was very good food in it.
                
                "This bowl is mine!" said the little dog.
                
                "No, it's mine!" said the big dog.
                
                The two dogs fought. Finally, the big dog won.
                
                But the little dog was very sad. The big dog looked at the little dog and said, "Okay, let's eat together."
                
                The two dogs ate the food together. They became good friends.
                """,
                culturalContext: "ఈ కథ స్నేహం మరియు భాగస్వామ్యం గురించి చెప్పుతుంది. ఇది చిన్న పిల్లలకు స్నేహం యొక్క ప్రాముఖ్యతను నేర్పుతుంది.",
                moral: "స్నేహం బలం కంటే ముఖ్యమైనది.",
                keywords: ["కుక్క", "స్నేహం", "భాగస్వామ్యం", "పిల్లల కథ"],
                audioFileName: "little_big_dog_story.mp3"
            ),
            
            // Mythology
            TeluguStory(
                title: "కృష్ణుడు మరియు కాళియుడు",
                titleEnglish: "Krishna and Kaliya",
                author: "పురాణ గాథ",
                category: .mythology,
                difficulty: .advanced,
                estimatedReadingTime: 12,
                content: """
                ఒకప్పుడు యమునా నదిలో ఒక పెద్ద సర్పం ఉండేది. దాని పేరు కాళియ. అది చాలా భయంకరమైనది.
                
                కాళియ సర్పం నదిలో విషాన్ని విడుదల చేస్తూ ఉండేది. దీనివల్ల నది నీరు విషపూరితమైంది.
                
                గోపకులు నదికి వెళ్లలేకపోయారు. వారి పశువులు నీరు తాగలేకపోయాయి.
                
                ఒక రోజు కృష్ణుడు నదికి వెళ్లాడు. అతను కాళియ సర్పంపై నృత్యం చేసాడు.
                
                కాళియ సర్పం కృష్ణుడి పాదాలను కుట్టింది. కానీ కృష్ణుడు విషాన్ని తన పాదాలలో నిలుపుకున్నాడు.
                
                చివరికి కాళియ సర్పం అంగీకరించింది. అది నదిని వదిలి వెళ్లిపోయింది.
                
                యమునా నది మళ్లీ శుభ్రమైంది. గోపకులు సంతోషించారు.
                """,
                contentEnglish: """
                Once upon a time, there was a big serpent in the Yamuna river. Its name was Kaliya. It was very terrible.
                
                The Kaliya serpent was releasing poison into the river. Because of this, the river water became poisonous.
                
                The cowherds couldn't go to the river. Their cattle couldn't drink the water.
                
                One day Krishna went to the river. He danced on the Kaliya serpent.
                
                The Kaliya serpent bit Krishna's feet. But Krishna contained the poison in his feet.
                
                Finally, the Kaliya serpent agreed. It left the river and went away.
                
                The Yamuna river became clean again. The cowherds were happy.
                """,
                culturalContext: "ఈ కథ హిందూ పురాణాలలో చాలా ప్రసిద్ధమైనది. ఇది కృష్ణుడి బాల్య కాలం గురించి చెప్పుతుంది. ఇది ధైర్యం మరియు ధర్మం యొక్క విజయాన్ని చెప్పుతుంది.",
                moral: "ధర్మం ఎప్పుడూ అధర్మాన్ని జయిస్తుంది.",
                keywords: ["కృష్ణుడు", "కాళియ", "యమునా", "పురాణం", "ధర్మం"],
                audioFileName: "krishna_kaliya_story.mp3",
                culturalNotes: [
                    CulturalNote(keyword: "కృష్ణుడు", keywordMeaning: "Lord Krishna", context: "A major deity in Hinduism, known for his bravery and wisdom.", culturalSignificance: "Stories of Krishna are central to Hindu mythology and are told to children to impart values of courage and righteousness.")
                ]
            )
        ]
    
    @Published var stories: [TeluguStory] = []
    @Published var settings = ReadingSettings()
    @Published var readingProgress: [UUID: ReadingProgress] = [:]
    
    private let userDefaults = UserDefaults.standard
    private let storiesKey = "telugu_stories"
    private let settingsKey = "reading_settings"
    private let progressKey = "reading_progress"
    
    init() {
        loadStories()
        loadSettings()
        loadReadingProgress()
    }
    
    // MARK: - Computed Properties
    var featuredStories: [TeluguStory] {
        stories.filter { story in
            story.category == .folktales || story.category == .mythology
        }.prefix(5).map { $0 }
    }
    
    var bookmarkedStories: [TeluguStory] {
        stories.filter { $0.isBookmarked }
    }
    
    var completedStoriesCount: Int {
        stories.filter { $0.isCompleted }.count
    }
    
    var bookmarkedStoriesCount: Int {
        stories.filter { $0.isBookmarked }.count
    }
    
    // MARK: - Story Management
    func loadStories() {
        if let data = userDefaults.data(forKey: storiesKey),
           let loadedStories = try? JSONDecoder().decode([TeluguStory].self, from: data) {
            stories = loadedStories
        } else {
            loadDefaultStories()
        }
    }
    
    func saveStories() {
        if let data = try? JSONEncoder().encode(stories) {
            userDefaults.set(data, forKey: storiesKey)
        }
    }
    
    private func loadDefaultStories() {
        stories = StoryService.sampleStories
        saveStories()
    }
    
    // MARK: - Settings Management
    func loadSettings() {
        if let data = userDefaults.data(forKey: settingsKey),
           let loadedSettings = try? JSONDecoder().decode(ReadingSettings.self, from: data) {
            settings = loadedSettings
        }
    }
    
    func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            userDefaults.set(data, forKey: settingsKey)
        }
    }
    
    func updateSettings(_ newSettings: ReadingSettings) {
        settings = newSettings
        saveSettings()
    }
    
    // MARK: - Reading Progress
    func loadReadingProgress() {
        if let data = userDefaults.data(forKey: progressKey),
           let loadedProgress = try? JSONDecoder().decode([UUID: ReadingProgress].self, from: data) {
            readingProgress = loadedProgress
        }
    }
    
    func saveReadingProgress() {
        if let data = try? JSONEncoder().encode(readingProgress) {
            userDefaults.set(data, forKey: progressKey)
        }
    }
    
    func getReadingProgress(for storyId: UUID) -> Double {
        return readingProgress[storyId]?.progressPercentage ?? 0.0
    }
    
    func updateReadingProgress(for storyId: UUID, progress: Double) {
        let currentProgress = readingProgress[storyId]
        let newProgress = ReadingProgress(
            storyId: storyId,
            currentPage: Int(progress * 10), // Assuming 10 pages per story
            totalPages: 10,
            readingTime: currentProgress?.readingTime ?? 0,
            lastReadDate: Date(),
            isCompleted: progress >= 1.0
        )
        readingProgress[storyId] = newProgress
        saveReadingProgress()
    }
    
    func markStoryAsCompleted(_ storyId: UUID) {
        if let index = stories.firstIndex(where: { $0.id == storyId }) {
            stories[index].isCompleted = true
            stories[index].lastRead = Date()
            saveStories()
        }
    }
    
    // MARK: - Bookmark Management
    func toggleBookmark(for storyId: UUID) {
        if let index = stories.firstIndex(where: { $0.id == storyId }) {
            stories[index].isBookmarked.toggle()
            saveStories()
        }
    }
    
    // MARK: - Search and Filter
    func searchStories(query: String) -> [TeluguStory] {
        if query.isEmpty {
            return stories
        }
        
        return stories.filter { story in
            story.title.localizedCaseInsensitiveContains(query) ||
            story.titleEnglish.localizedCaseInsensitiveContains(query) ||
            story.author.localizedCaseInsensitiveContains(query) ||
            story.keywords.contains { $0.localizedCaseInsensitiveContains(query) }
        }
    }
    
    func filterStories(by category: StoryCategory?) -> [TeluguStory] {
        if let category = category {
            return stories.filter { $0.category == category }
        }
        return stories
    }
}
