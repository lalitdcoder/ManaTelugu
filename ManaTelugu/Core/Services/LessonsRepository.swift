import Foundation

class LessonsRepository: ObservableObject {
    @Published var levels: [LearningLevel] = []
    @Published var lessonProgress: [String: LessonProgress] = [:]
    @Published var levelProgress: [String: LevelProgress] = [:]
    
    private let userDefaults = UserDefaults.standard
    private let progressKey = "lesson_progress"
    private let levelProgressKey = "level_progress"
    
    init() {
        loadLevels()
        loadProgress()
    }
    
    // MARK: - Data Loading
    private func loadLevels() {
        guard let url = Bundle.main.url(forResource: "lessons", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("❌ Failed to load lessons.json from bundle")
            // Add fallback sample data
            createSampleLevels()
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let lessonsData = try decoder.decode(LessonsData.self, from: data)
            // Ensure each level has 10 lessons even if JSON provides fewer, then apply topic titles and enrich
            var loadedLevels = padLevelsToTen(from: lessonsData.levels)
            loadedLevels = assignTopicTitles(to: loadedLevels)
            loadedLevels = customizeContentForTopics(loadedLevels)
            self.levels = loadedLevels.map { level in
                let enrichedLessons = level.lessons.map { ensureTenQuestionsPerLesson($0) }
                return LearningLevel(id: level.id, title: level.title, description: level.description, difficulty: level.difficulty, lessons: enrichedLessons, requiredXP: level.requiredXP, color: level.color)
            }
            print("✅ Successfully loaded \(levels.count) levels with \(levels.flatMap(\.lessons).count) total lessons (padded, titled, topic-customized, enriched)")
            initializeLevelProgress()
        } catch {
            print("❌ Failed to decode lessons: \(error)")
            // Add fallback sample data
            createSampleLevels()
        }
    }

    private func padLevelsToTen(from levels: [LearningLevel]) -> [LearningLevel] {
        return levels.map { level in
            if level.lessons.count >= 10 { return level }
            let existing = level.lessons
            let startIndex = existing.count + 1
            let generated: [Lesson]
            switch level.id {
            case "level_1_beginner":
                generated = (startIndex...10).map { i in
                    Lesson(
                        id: "lesson_1_\(i)",
                        title: "Lesson \(i)",
                        description: getBeginnerDescription(i),
                        levelId: level.id,
                        order: i,
                        difficulty: 1,
                        xpReward: 80 + (i * 5),
                        estimatedMinutes: 12 + i,
                        activities: createStandardActivities("1_\(i)", level: 1)
                    )
                }
            case "level_2_basic":
                generated = (startIndex...10).map { i in
                    Lesson(
                        id: "lesson_2_\(i)",
                        title: "Lesson \(i)",
                        description: getBasicDescription(i),
                        levelId: level.id,
                        order: i,
                        difficulty: 2,
                        xpReward: 130 + (i * 5),
                        estimatedMinutes: 20 + i,
                        activities: createStandardActivities("2_\(i)", level: 2)
                    )
                }
            case "level_3_intermediate":
                generated = (startIndex...10).map { i in
                    Lesson(
                        id: "lesson_3_\(i)",
                        title: "Lesson \(i)",
                        description: getIntermediateDescription(i),
                        levelId: level.id,
                        order: i,
                        difficulty: 3,
                        xpReward: 180 + (i * 5),
                        estimatedMinutes: 25 + i,
                        activities: createStandardActivities("3_\(i)", level: 3)
                    )
                }
            case "level_4_advanced":
                generated = (startIndex...10).map { i in
                    Lesson(
                        id: "lesson_4_\(i)",
                        title: "Lesson \(i)",
                        description: getAdvancedDescription(i),
                        levelId: level.id,
                        order: i,
                        difficulty: 4,
                        xpReward: 230 + (i * 5),
                        estimatedMinutes: 30 + i,
                        activities: createStandardActivities("4_\(i)", level: 4)
                    )
                }
            default:
                // If unknown id, pad using the level's difficulty
                let levelNum = max(min(level.difficulty, 4), 1)
                generated = (startIndex...10).map { i in
                    Lesson(
                        id: "lesson_\(levelNum)_\(i)",
                        title: "Lesson \(i)",
                        description: "Additional lesson \(i)",
                        levelId: level.id,
                        order: i,
                        difficulty: level.difficulty,
                        xpReward: 50 + (i * 5),
                        estimatedMinutes: 10 + i,
                        activities: createStandardActivities("4_\(i)", level: levelNum)
                    )
                }
            }
            let mergedLessons = existing + generated
            return LearningLevel(id: level.id, title: level.title, description: level.description, difficulty: level.difficulty, lessons: mergedLessons, requiredXP: level.requiredXP, color: level.color)
        }
    }
    
    private func createSampleLevels() {
        print("🔧 Creating sample lesson data as fallback")
        // BEGINNER LEVEL: 10 lessons progressing from letters → syllables → simple words
        let beginnerLessons = [
            // Lesson 1: Basic Vowels అ, ఆ
            Lesson(
                id: "lesson_1_1",
                title: "Lesson 1",
                description: "First Telugu vowels: అ, ఆ",
                levelId: "level_1_beginner",
                order: 1,
                difficulty: 1,
                xpReward: 80,
                estimatedMinutes: 12,
                activities: [
                    LessonActivity(
                        id: "activity_1_1_reading",
                        type: .reading,
                        title: "Reading Practice",
                        instructions: "Identify the Telugu vowels and their sounds",
                        xpValue: 20,
                        questions: [
                            ActivityQuestion(
                                id: "q1_1_r1",
                                type: .characterRecognition,
                                question: "Which Telugu character makes the 'a' sound?",
                                correctAnswer: "అ",
                                options: ["అ", "ఆ", "ఇ", "ఈ"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "అ is the first vowel in Telugu, pronounced as 'a' in 'apple'"
                            ),
                            ActivityQuestion(
                                id: "q1_1_r2",
                                type: .multipleChoice,
                                question: "What sound does 'ఆ' make?",
                                correctAnswer: "aa",
                                options: ["a", "aa", "i", "ee"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "ఆ makes the 'aa' sound like in 'father'"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_1_1_writing",
                        type: .writing,
                        title: "Writing Practice",
                        instructions: "Practice writing Telugu vowels with proper stroke order",
                        xpValue: 20,
                        questions: [
                            ActivityQuestion(
                                id: "q1_1_w1",
                                type: .tracing,
                                question: "Trace the character 'అ'",
                                correctAnswer: "అ",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: ["Start with vertical line", "Add curved top", "Complete the base"],
                                explanation: "Practice writing అ with proper stroke order. Start from top to bottom."
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_1_1_listening",
                        type: .listening,
                        title: "Listening Practice",
                        instructions: "Listen and identify the correct vowel",
                        xpValue: 20,
                        questions: [
                            ActivityQuestion(
                                id: "q1_1_l1",
                                type: .audioIdentification,
                                question: "Listen to the audio and select the correct Telugu vowel:",
                                correctAnswer: "అ",
                                options: ["అ", "ఆ", "ఇ", "ఈ"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "This is the sound of the first Telugu vowel 'అ' (a)"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_1_1_speaking",
                        type: .speaking,
                        title: "Speaking Practice",
                        instructions: "Practice pronunciation of Telugu vowels",
                        xpValue: 20,
                        questions: [
                            ActivityQuestion(
                                id: "q1_1_s1",
                                type: .speaking,
                                question: "Pronounce the Telugu vowel: అ",
                                correctAnswer: "a",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "Speaking practice - coming soon!"
                            )
                        ],
                        canSkip: true
                    )
                ]
            ),
            Lesson(
                id: "lesson_1_2",
                title: "Telugu Consonants Part 1",
                description: "Learn basic Telugu consonants",
                levelId: "level_1_beginner",
                order: 2,
                difficulty: 1,
                xpReward: 100,
                estimatedMinutes: 18,
                activities: [
                    LessonActivity(
                        id: "activity_1_2_reading",
                        type: .reading,
                        title: "Reading Practice",
                        instructions: "Identify Telugu consonants and their sounds",
                        xpValue: 25,
                        questions: [
                            ActivityQuestion(
                                id: "q1_2_r1",
                                type: .multipleChoice,
                                question: "Which character is 'ka'?",
                                correctAnswer: "క",
                                options: ["క", "ఖ", "గ", "ఘ"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "క is the 'ka' consonant in Telugu"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_1_2_writing",
                        type: .writing,
                        title: "Writing Practice",
                        instructions: "Practice writing Telugu consonants",
                        xpValue: 25,
                        questions: [
                            ActivityQuestion(
                                id: "q1_2_w1",
                                type: .tracing,
                                question: "Trace the character 'క'",
                                correctAnswer: "క",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: ["Start with vertical line", "Add horizontal curves", "Complete the character"],
                                explanation: "Practice writing క with proper stroke order"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_1_2_listening",
                        type: .listening,
                        title: "Listening Practice",
                        instructions: "Listen and identify the correct consonant",
                        xpValue: 25,
                        questions: [
                            ActivityQuestion(
                                id: "q1_2_l1",
                                type: .audioIdentification,
                                question: "Listen to the audio and select the correct Telugu consonant:",
                                correctAnswer: "క",
                                options: ["క", "ఖ", "గ", "ఘ"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "This is the sound of the Telugu consonant 'క' (ka)"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_1_2_speaking",
                        type: .speaking,
                        title: "Speaking Practice",
                        instructions: "Practice pronunciation of Telugu consonants",
                        xpValue: 25,
                        questions: [
                            ActivityQuestion(
                                id: "q1_2_s1",
                                type: .speaking,
                                question: "Pronounce the Telugu consonant: క",
                                correctAnswer: "ka",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "Speaking practice - coming soon!"
                            )
                        ],
                        canSkip: true
                    )
                ]
            )
        ]
        
        let basicLessons = [
            Lesson(
                id: "lesson_2_1",
                title: "Vowel Combinations",
                description: "Learn how vowels combine with consonants",
                levelId: "level_2_basic",
                order: 1,
                difficulty: 2,
                xpReward: 120,
                estimatedMinutes: 20,
                activities: [
                    LessonActivity(
                        id: "activity_2_1_reading",
                        type: .reading,
                        title: "Reading Practice",
                        instructions: "Identify vowel-consonant combinations",
                        xpValue: 30,
                        questions: [
                            ActivityQuestion(
                                id: "q2_1_r1",
                                type: .multipleChoice,
                                question: "What does 'కా' sound like?",
                                correctAnswer: "kaa",
                                options: ["ka", "kaa", "ki", "kee"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "కా combines క (ka) + ఆ (aa) = kaa"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_2_1_writing",
                        type: .writing,
                        title: "Writing Practice",
                        instructions: "Practice writing vowel-consonant combinations",
                        xpValue: 30,
                        questions: [
                            ActivityQuestion(
                                id: "q2_1_w1",
                                type: .tracing,
                                question: "Trace the combination 'కా'",
                                correctAnswer: "కా",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: ["Write క first", "Add ఆ vowel mark"],
                                explanation: "Practice writing కా (ka + aa)"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_2_1_listening",
                        type: .listening,
                        title: "Listening Practice",
                        instructions: "Listen and identify vowel-consonant combinations",
                        xpValue: 30,
                        questions: [
                            ActivityQuestion(
                                id: "q2_1_l1",
                                type: .audioIdentification,
                                question: "Listen and select the correct combination:",
                                correctAnswer: "కా",
                                options: ["కా", "కి", "కు", "కే"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "This is కా (kaa)"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_2_1_speaking",
                        type: .speaking,
                        title: "Speaking Practice",
                        instructions: "Practice pronunciation of combinations",
                        xpValue: 30,
                        questions: [
                            ActivityQuestion(
                                id: "q2_1_s1",
                                type: .speaking,
                                question: "Pronounce: కా",
                                correctAnswer: "kaa",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "Speaking practice - coming soon!"
                            )
                        ],
                        canSkip: true
                    )
                ]
            )
        ]
        
        let intermediateLessons = [
            Lesson(
                id: "lesson_3_1",
                title: "Simple Words",
                description: "Learn to read and write simple Telugu words",
                levelId: "level_3_intermediate",
                order: 1,
                difficulty: 3,
                xpReward: 150,
                estimatedMinutes: 25,
                activities: [
                    LessonActivity(
                        id: "activity_3_1_reading",
                        type: .reading,
                        title: "Reading Practice",
                        instructions: "Read simple Telugu words",
                        xpValue: 37,
                        questions: [
                            ActivityQuestion(
                                id: "q3_1_r1",
                                type: .multipleChoice,
                                question: "What does 'అమ్మ' mean?",
                                correctAnswer: "Mother",
                                options: ["Mother", "Father", "Water", "Food"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "అమ్మ means 'Mother' in Telugu"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_3_1_writing",
                        type: .writing,
                        title: "Writing Practice",
                        instructions: "Practice writing simple words",
                        xpValue: 38,
                        questions: [
                            ActivityQuestion(
                                id: "q3_1_w1",
                                type: .tracing,
                                question: "Trace the word 'అమ్మ'",
                                correctAnswer: "అమ్మ",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: ["Write అ", "Write మ్మ"],
                                explanation: "Practice writing అమ్మ (Mother)"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_3_1_listening",
                        type: .listening,
                        title: "Listening Practice",
                        instructions: "Listen and identify simple words",
                        xpValue: 37,
                        questions: [
                            ActivityQuestion(
                                id: "q3_1_l1",
                                type: .audioIdentification,
                                question: "Listen and select the correct word:",
                                correctAnswer: "అమ్మ",
                                options: ["అమ్మ", "నాన్న", "నీరు", "అన్నం"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "This is అమ్మ (Mother)"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_3_1_speaking",
                        type: .speaking,
                        title: "Speaking Practice",
                        instructions: "Practice pronunciation of simple words",
                        xpValue: 38,
                        questions: [
                            ActivityQuestion(
                                id: "q3_1_s1",
                                type: .speaking,
                                question: "Pronounce: అమ్మ",
                                correctAnswer: "amma",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "Speaking practice - coming soon!"
                            )
                        ],
                        canSkip: true
                    )
                ]
            )
        ]
        
        let advancedLessons = [
            Lesson(
                id: "lesson_4_1",
                title: "Complex Sentences",
                description: "Learn to construct and read complex Telugu sentences",
                levelId: "level_4_advanced",
                order: 1,
                difficulty: 4,
                xpReward: 200,
                estimatedMinutes: 30,
                activities: [
                    LessonActivity(
                        id: "activity_4_1_reading",
                        type: .reading,
                        title: "Reading Practice",
                        instructions: "Read and understand complex sentences",
                        xpValue: 50,
                        questions: [
                            ActivityQuestion(
                                id: "q4_1_r1",
                                type: .multipleChoice,
                                question: "What does 'నేను పుస్తకం చదువుతున్నాను' mean?",
                                correctAnswer: "I am reading a book",
                                options: ["I am reading a book", "I am writing a book", "I have a book", "I want a book"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "This sentence means 'I am reading a book' in Telugu"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_4_1_writing",
                        type: .writing,
                        title: "Writing Practice",
                        instructions: "Practice writing complex sentences",
                        xpValue: 50,
                        questions: [
                            ActivityQuestion(
                                id: "q4_1_w1",
                                type: .tracing,
                                question: "Trace: 'నేను'",
                                correctAnswer: "నేను",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: ["Write న", "Write ే", "Write న", "Write ు"],
                                explanation: "Practice writing నేను (I/me)"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_4_1_listening",
                        type: .listening,
                        title: "Listening Practice",
                        instructions: "Listen and understand complex sentences",
                        xpValue: 50,
                        questions: [
                            ActivityQuestion(
                                id: "q4_1_l1",
                                type: .audioIdentification,
                                question: "Listen and select the correct sentence:",
                                correctAnswer: "నేను పుస్తకం చదువుతున్నాను",
                                options: ["నేను పుస్తకం చదువుతున్నాను", "నేను అన్నం తింటున్నాను", "నేను పాట పాడుతున్నాను", "నేను నడుస్తున్నాను"],
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "This is 'I am reading a book'"
                            )
                        ],
                        canSkip: false
                    ),
                    LessonActivity(
                        id: "activity_4_1_speaking",
                        type: .speaking,
                        title: "Speaking Practice",
                        instructions: "Practice pronunciation of complex sentences",
                        xpValue: 50,
                        questions: [
                            ActivityQuestion(
                                id: "q4_1_s1",
                                type: .speaking,
                                question: "Pronounce: నేను పుస్తకం చదువుతున్నాను",
                                correctAnswer: "nenu pustakam chaduvutunnanu",
                                options: nil,
                                audioFile: nil,
                                strokeOrder: nil,
                                explanation: "Speaking practice - coming soon!"
                            )
                        ],
                        canSkip: true
                    )
                ]
            )
        ]
        
        // Create comprehensive lesson structure with 10 lessons per level
        self.levels = createComprehensiveLessons()
        initializeLevelProgress()
    }
    
    private func createComprehensiveLessons() -> [LearningLevel] {
        // BEGINNER: 10 lessons - letters → syllables → simple words
        let beginnerLessons = (1...10).map { i in
            Lesson(
                id: "lesson_1_\(i)",
                title: "Lesson \(i)",
                description: getBeginnerDescription(i),
                levelId: "level_1_beginner",
                order: i,
                difficulty: 1,
                xpReward: 80 + (i * 5),
                estimatedMinutes: 12 + i,
                activities: createStandardActivities("1_\(i)", level: 1)
            )
        }
        
        // BASIC: 10 lessons - combinations → words → phrases  
        let basicLessons = (1...10).map { i in
            Lesson(
                id: "lesson_2_\(i)",
                title: "Lesson \(i)",
                description: getBasicDescription(i),
                levelId: "level_2_basic",
                order: i,
                difficulty: 2,
                xpReward: 130 + (i * 5),
                estimatedMinutes: 20 + i,
                activities: createStandardActivities("2_\(i)", level: 2)
            )
        }
        
        // INTERMEDIATE: 10 lessons - sentences → passages → grammar
        let intermediateLessons = (1...10).map { i in
            Lesson(
                id: "lesson_3_\(i)",
                title: "Lesson \(i)",
                description: getIntermediateDescription(i),
                levelId: "level_3_intermediate",
                order: i,
                difficulty: 3,
                xpReward: 180 + (i * 5),
                estimatedMinutes: 25 + i,
                activities: createStandardActivities("3_\(i)", level: 3)
            )
        }
        
        // ADVANCED: 10 lessons - complex sentences → idioms → texts
        let advancedLessons = (1...10).map { i in
            Lesson(
                id: "lesson_4_\(i)",
                title: "Lesson \(i)",
                description: getAdvancedDescription(i),
                levelId: "level_4_advanced",
                order: i,
                difficulty: 4,
                xpReward: 230 + (i * 5),
                estimatedMinutes: 30 + i,
                activities: createStandardActivities("4_\(i)", level: 4)
            )
        }
        
        return assignTopicTitles(to: [
            LearningLevel(id: "level_1_beginner", title: "Level 1: Beginner", description: "New to Telugu - Learn vowels, basic consonants, and simple words", difficulty: 1, lessons: beginnerLessons, requiredXP: 0, color: "#4CAF50"),
            LearningLevel(id: "level_2_basic", title: "Level 2: Basic", description: "Build on basics - Learn vowel combinations and simple syllables", difficulty: 2, lessons: basicLessons, requiredXP: 0, color: "#2196F3"),
            LearningLevel(id: "level_3_intermediate", title: "Level 3: Intermediate", description: "Expand vocabulary - Learn common words and phrases", difficulty: 3, lessons: intermediateLessons, requiredXP: 0, color: "#FF9800"),
            LearningLevel(id: "level_4_advanced", title: "Level 4: Advanced", description: "Master Telugu - Learn complex sentences and grammar", difficulty: 4, lessons: advancedLessons, requiredXP: 0, color: "#9C27B0")
        ])
    }
    
    private func getBeginnerDescription(_ lesson: Int) -> String {
        let descriptions = [
            "First Telugu vowels: అ, ఆ — Examples: అకు, ఆకు",
            "Telugu vowels: ఇ, ఈ — Examples: ఇల్లు, ఈగ", 
            "Complete vowel set: ఉ, ఊ, ఎ, ఏ — Examples: ఉడు, ఊరు, ఎలుగు, ఏనుగు",
            "First consonants: క-వర్గం — Examples: క, ఖ, గ, ఘ, ఙ",
            "More consonants: చ-వర్గం — Examples: చ, ఛ, జ, ఝ, ఞ",
            "Simple syllables: కా, కి, కు — Build words like కాలి, కిలో, కుడి",
            "Common syllables: మా, నా, పా — Examples: మామ, నాన్న, పాలు",
            "Family words: అమ్మ, నాన్న — Example sentences: అమ్మ వంట చేస్తుంది",
            "Basic needs: నీరు, అన్నం — Example sentences: నాకు నీరు కావాలి",
            "Greetings: నమస్కారం, వచ్చు — Dialogues: నమస్కారం! ఎలా ఉన్నారు?"
        ]
        return descriptions[lesson - 1]
    }
    
    private func getBasicDescription(_ lesson: Int) -> String {
        let descriptions = [
            "Complex syllables with all vowels — Combine: కా, కి, కు, కె, కో",
            "Double consonants: క్క, ప్ప — Words: పప్పు, ముక్క",
            "Body parts: తల, కన్ను, చేయి — Sentences: నాకు కన్ను నొప్పి",
            "Colors: ఎరుపు, నీలం, పసుపు — Match colors to objects",
            "Numbers: ఒకటి, రెండు, మూడు — Count items and answer",
            "Animals: కుక్క, పిల్లి, పక్షి — Identify sounds and names",
            "First phrases: ఇది ఏమిటి? — Short Q&A practice",
            "Basic actions: తిను, త్రాగు, నడవు — Conjugation practice",
            "Possessives: నా, నీ — Build phrases: నా పుస్తకం",
            "Simple conversation starters — Greetings and introductions"
        ]
        return descriptions[lesson - 1]
    }
    
    private func getIntermediateDescription(_ lesson: Int) -> String {
        let descriptions = [
            "Present tense: నేను చేస్తున్నాను — Build present continuous sentences",
            "Past tense: నేను చేశాను — Convert present to past",
            "Future tense: నేను చేస్తాను — Express plans and intentions",
            "Questions: ఎక్కడ? ఎప్పుడు? — Form WH-questions",
            "Directions: ఎడమ, కుడి, ముందు — Give and follow directions",
            "Time: ఇప్పుడు, రేపు, నిన్న — Talk about time",
            "Short story reading — Comprehension questions",
            "Adjectives: పెద్ద, చిన్న, మంచి — Modify nouns",
            "Comparisons: కంటే, చాలా — Comparative sentences",
            "Complex sentences with అయితే, కానీ — Contrast and condition"
        ]
        return descriptions[lesson - 1]
    }
    
    private func getAdvancedDescription(_ lesson: Int) -> String {
        let descriptions = [
            "Conditional sentences: అయితే, అయినా — If-then nuances",
            "Passive voice constructions — Transform active to passive",
            "Telugu idioms and phrases — Meanings in context",
            "Formal speech: మీరు, తమరు — Polite forms and usage",
            "Simple Telugu poetry — Meter and meaning",
            "Reading news articles — Summarize key points",
            "Formal letter structure — Openings and closings",
            "Telugu culture and traditions — Short notes",
            "Complex grammar rules — Exceptions and edge cases",
            "Comprehensive assessment — Mixed practice"
        ]
        return descriptions[lesson - 1]
    }
    
    private func createStandardActivities(_ lessonId: String, level: Int) -> [LessonActivity] {
        let baseXP = level * 20
        // Target distribution: 3 reading, 3 writing, 2 listening, 2 speaking = 10
        let readingQuestions: [ActivityQuestion] = (1...3).map { idx in
            ActivityQuestion(
                id: "q\(lessonId)_r\(idx)",
                type: .multipleChoice,
                question: "Choose the correct option (Reading) #\(idx)",
                correctAnswer: "అ",
                options: ["అ", "ఆ", "ఇ", "ఈ"],
                audioFile: nil,
                strokeOrder: nil,
                explanation: "Practice recognizing characters"
            )
        }
        let writingQuestions: [ActivityQuestion] = (1...3).map { idx in
            ActivityQuestion(
                id: "q\(lessonId)_w\(idx)",
                type: idx == 1 ? .tracing : .textInput,
                question: idx == 1 ? "Trace the character:" : "Type the shown character:",
                correctAnswer: "అ",
                options: nil,
                audioFile: nil,
                strokeOrder: idx == 1 ? ["Start with main stroke", "Add details"] : nil,
                explanation: "Writing practice"
            )
        }
        let listeningQuestions: [ActivityQuestion] = (1...2).map { idx in
            ActivityQuestion(
                id: "q\(lessonId)_l\(idx)",
                type: .audioIdentification,
                question: "Listen and select (Listening) #\(idx)",
                correctAnswer: "అ",
                options: ["అ", "ఆ", "ఇ", "ఈ"],
                audioFile: nil,
                strokeOrder: nil,
                explanation: "Listening practice"
            )
        }
        let speakingQuestions: [ActivityQuestion] = (1...2).map { idx in
            ActivityQuestion(
                id: "q\(lessonId)_s\(idx)",
                type: .speaking,
                question: "Pronounce clearly (Speaking) #\(idx)",
                correctAnswer: "అ",
                options: nil,
                audioFile: nil,
                strokeOrder: nil,
                explanation: "Speaking practice"
            )
        }
        return [
            LessonActivity(
                id: "activity_\(lessonId)_reading",
                type: .reading,
                title: "Reading Practice",
                instructions: "Practice reading Telugu text",
                xpValue: baseXP,
                questions: readingQuestions,
                canSkip: false
            ),
            LessonActivity(
                id: "activity_\(lessonId)_writing",
                type: .writing,
                title: "Writing Practice",
                instructions: "Practice writing Telugu characters",
                xpValue: baseXP,
                questions: writingQuestions,
                canSkip: false
            ),
            LessonActivity(
                id: "activity_\(lessonId)_listening",
                type: .listening,
                title: "Listening Practice",
                instructions: "Listen and identify sounds",
                xpValue: baseXP,
                questions: listeningQuestions,
                canSkip: false
            ),
            LessonActivity(
                id: "activity_\(lessonId)_speaking",
                type: .speaking,
                title: "Speaking Practice",
                instructions: "Practice pronunciation",
                xpValue: baseXP,
                questions: speakingQuestions,
                canSkip: true
            )
        ]
    }

    // Ensure minimum of 10 practice questions per lesson (top-up if JSON provides fewer)
    private func ensureTenQuestionsPerLesson(_ lesson: Lesson) -> Lesson {
        let totalExisting = lesson.activities.reduce(0) { $0 + $1.questions.count }
        guard totalExisting < 10 else { return lesson }
        var activities = lesson.activities
        var remaining = 10 - totalExisting
        func appendQuestions(to type: ActivityType, count: Int) {
            guard remaining > 0, let idx = activities.firstIndex(where: { $0.type == type }) else { return }
            let addCount = min(count, remaining)
            let start = activities[idx].questions.count
            let newQuestions: [ActivityQuestion] = (0..<addCount).map { j in
                let qIndex = start + j + 1
                switch type {
                case .reading:
                    return ActivityQuestion(id: "q_\(lesson.id)_r_extra_\(qIndex)", type: .multipleChoice, question: "Choose the correct option (Reading) #\(qIndex)", correctAnswer: "అ", options: ["అ", "ఆ", "ఇ", "ఈ"], audioFile: nil, strokeOrder: nil, explanation: "Auto-generated reading practice")
                case .writing:
                    return ActivityQuestion(id: "q_\(lesson.id)_w_extra_\(qIndex)", type: .textInput, question: "Type the answer (Writing) #\(qIndex)", correctAnswer: "అ", options: nil, audioFile: nil, strokeOrder: nil, explanation: "Auto-generated writing practice")
                case .listening:
                    return ActivityQuestion(id: "q_\(lesson.id)_l_extra_\(qIndex)", type: .audioIdentification, question: "Listen and select (Listening) #\(qIndex)", correctAnswer: "అ", options: ["అ", "ఆ", "ఇ", "ఈ"], audioFile: nil, strokeOrder: nil, explanation: "Auto-generated listening practice")
                case .speaking:
                    return ActivityQuestion(id: "q_\(lesson.id)_s_extra_\(qIndex)", type: .speaking, question: "Pronounce clearly (Speaking) #\(qIndex)", correctAnswer: "అ", options: nil, audioFile: nil, strokeOrder: nil, explanation: "Auto-generated speaking practice")
                }
            }
            var act = activities[idx]
            act = LessonActivity(id: act.id, type: act.type, title: act.title, instructions: act.instructions, xpValue: act.xpValue, questions: act.questions + newQuestions, canSkip: act.canSkip)
            activities[idx] = act
            remaining -= addCount
        }
        // Top-up order
        appendQuestions(to: .reading, count: remaining)
        appendQuestions(to: .writing, count: remaining)
        appendQuestions(to: .listening, count: remaining)
        appendQuestions(to: .speaking, count: remaining)
        return Lesson(id: lesson.id, title: lesson.title, description: lesson.description, levelId: lesson.levelId, order: lesson.order, difficulty: lesson.difficulty, xpReward: lesson.xpReward, estimatedMinutes: lesson.estimatedMinutes, activities: activities)
    }
    
    private func loadProgress() {
        if let data = userDefaults.data(forKey: progressKey),
           let progress = try? JSONDecoder().decode([String: LessonProgress].self, from: data) {
            self.lessonProgress = progress
        }
        
        if let data = userDefaults.data(forKey: levelProgressKey),
           let progress = try? JSONDecoder().decode([String: LevelProgress].self, from: data) {
            self.levelProgress = progress
        }
    }
    
    private func initializeLevelProgress() {
        for level in levels {
            if levelProgress[level.id] == nil {
                levelProgress[level.id] = LevelProgress(
                    id: UUID().uuidString,
                    levelId: level.id,
                    userId: "current_user",
                    completedLessons: 0,
                    totalLessons: level.lessons.count,
                    isCompleted: false,
                    completionDate: nil,
                    totalXPEarned: 0
                )
            }
        }
        saveLevelProgress()
    }
    
    // MARK: - Progress Management
    func completeLesson(_ lesson: Lesson, xpEarned: Int, correctAnswers: Int, totalQuestions: Int, timeSpent: TimeInterval, responses: [ActivityResponse]) {
        let progressId = UUID().uuidString
        let progress = LessonProgress(
            id: progressId,
            lessonId: lesson.id,
            userId: "current_user",
            isCompleted: true,
            completionDate: Date(),
            xpEarned: xpEarned,
            correctAnswers: correctAnswers,
            totalQuestions: totalQuestions,
            timeSpent: timeSpent,
            attempts: 1,
            activityResponses: responses
        )
        
        lessonProgress[lesson.id] = progress
        updateLevelProgress(for: lesson.levelId, xpEarned: xpEarned)
        saveProgress()
    }
    
    private func updateLevelProgress(for levelId: String, xpEarned: Int) {
        guard var progress = levelProgress[levelId] else { return }
        
        let completedCount = levels.first(where: { $0.id == levelId })?.lessons.compactMap { lesson in
            lessonProgress[lesson.id]?.isCompleted == true ? lesson : nil
        }.count ?? 0
        
        progress.completedLessons = completedCount
        progress.totalXPEarned += xpEarned
        
        if completedCount == progress.totalLessons && !progress.isCompleted {
            progress.isCompleted = true
            progress.completionDate = Date()
        }
        
        levelProgress[levelId] = progress
        saveLevelProgress()
    }
    
    private func saveProgress() {
        if let data = try? JSONEncoder().encode(lessonProgress) {
            userDefaults.set(data, forKey: progressKey)
        }
    }
    
    private func saveLevelProgress() {
        if let data = try? JSONEncoder().encode(levelProgress) {
            userDefaults.set(data, forKey: levelProgressKey)
        }
    }
    
    // MARK: - Helper Methods
    func isLessonCompleted(_ lessonId: String) -> Bool {
        return lessonProgress[lessonId]?.isCompleted ?? false
    }
    
    func getLessonProgress(_ lessonId: String) -> LessonProgress? {
        return lessonProgress[lessonId]
    }
    
    func getLevelProgress(_ levelId: String) -> LevelProgress? {
        return levelProgress[levelId]
    }
    
    func isLevelUnlocked(_ level: LearningLevel, userXP: Int) -> Bool {
        return true // All levels are now accessible regardless of XP
    }
    
    func getNextLevel(after levelId: String) -> LearningLevel? {
        guard let currentIndex = levels.firstIndex(where: { $0.id == levelId }),
              currentIndex + 1 < levels.count else { return nil }
        return levels[currentIndex + 1]
    }
}

// MARK: - Data Structure for JSON
private struct LessonsData: Codable {
    let levels: [LearningLevel]
}

private func assignTopicTitles(to levels: [LearningLevel]) -> [LearningLevel] {
    return levels.map { level in
        let topics = topicTitles(for: level.id)
        let sorted = level.lessons.sorted { $0.order < $1.order }
        let renamed = sorted.enumerated().map { (idx, lesson) in
            let newTitle = idx < topics.count ? topics[idx] : lesson.title
            return Lesson(id: lesson.id, title: newTitle, description: lesson.description, levelId: lesson.levelId, order: lesson.order, difficulty: lesson.difficulty, xpReward: lesson.xpReward, estimatedMinutes: lesson.estimatedMinutes, activities: lesson.activities)
        }
        return LearningLevel(id: level.id, title: level.title, description: level.description, difficulty: level.difficulty, lessons: renamed, requiredXP: level.requiredXP, color: level.color)
    }
}

private func topicTitles(for levelId: String) -> [String] {
    switch levelId {
    case "level_1_beginner":
        return [
            "Vowels – Part 1 (అ, ఆ, ఇ, ఈ)",
            "Vowels – Part 2 (ఉ, ఊ, ఎ, ఏ)",
            "Velar Consonants (క ఖ గ ఘ ఙ)",
            "Palatal Consonants (చ ఛ జ ఝ ఞ)",
            "Forming Syllables (క + vowels)",
            "Numbers 1–10",
            "Greetings and Politeness",
            "Family and People Words",
            "Daily Activities – Common Verbs",
            "Simple Present-Tense Sentences"
        ]
    case "level_2_basic":
        return [
            "Complex Syllables – All Vowels",
            "Double Consonants (క్క, ప్ప, etc.)",
            "Body Parts Vocabulary",
            "Colors and Objects",
            "Numbers 11–20",
            "Animals and Sounds",
            "Basic Phrases and Q&A",
            "Action Verbs – Conjugation",
            "Possessives (నా, నీ) in Phrases",
            "Conversation Starters"
        ]
    case "level_3_intermediate":
        return [
            "Present Tense – Continuous",
            "Past Tense – Simple",
            "Future Tense – Intentions",
            "Forming Questions (ఎక్కడ? ఎప్పుడు?)",
            "Directions and Movement",
            "Talking About Time",
            "Short Story – Comprehension",
            "Adjectives in Sentences",
            "Comparisons (కంటే, చాలా)",
            "Complex Sentences (అయితే, కానీ)"
        ]
    case "level_4_advanced":
        return [
            "Conditionals (అయితే, అయినా)",
            "Passive Voice Transformations",
            "Idioms and Phrases in Context",
            "Formal Speech (మీరు, తమరు)",
            "Simple Telugu Poetry",
            "Reading News – Summaries",
            "Formal Letter Writing",
            "Culture and Traditions",
            "Complex Grammar – Exceptions",
            "Comprehensive Mixed Practice"
        ]
    default:
        return (1...10).map { "Lesson \($0)" }
    }
}

    private func customizeContentForTopics(_ levels: [LearningLevel]) -> [LearningLevel] {
        return levels.map { level in
            let updatedLessons = level.lessons.map { lesson in
                let newDescription = topicDescriptionFor(levelId: level.id, title: lesson.title, fallback: lesson.description)
                let newActivities = topicActivitiesFor(levelId: level.id, title: lesson.title, lessonId: lesson.id, difficulty: level.difficulty)
                print("🔍 Customizing lesson '\(lesson.title)' - Generated \(newActivities.count) activities")
                return Lesson(id: lesson.id, title: lesson.title, description: newDescription, levelId: lesson.levelId, order: lesson.order, difficulty: lesson.difficulty, xpReward: lesson.xpReward, estimatedMinutes: lesson.estimatedMinutes, activities: newActivities.isEmpty ? lesson.activities : newActivities)
            }
            return LearningLevel(id: level.id, title: level.title, description: level.description, difficulty: level.difficulty, lessons: updatedLessons, requiredXP: level.requiredXP, color: level.color)
        }
    }

    private func topicDescriptionFor(levelId: String, title: String, fallback: String) -> String {
        // Basic keyword matching to produce tailored descriptions
        if title.contains("Vowels – Part 1") { return "Topic: Vowels అ, ఆ, ఇ, ఈ — Short vs long vowels. Examples: అ (అన్నం), ఆ (ఆకు), ఇ (ఇల్లు), ఈ (ఈగ)." }
        if title.contains("Vowels – Part 2") { return "Topic: Vowels ఉ, ఊ, ఎ, ఏ — Mid/back vowels. Examples: ఉ (ఉల్లి), ఊ (ఊరు), ఎ (ఎలుక), ఏ (ఏనుగు)." }
        if title.contains("Velar Consonants") { return "Topic: Velars క ఖ గ ఘ ఙ — Back-of-mouth sounds. Examples: కుక్క, ఖడ్గం, గాలి, ఘంటా." }
        if title.contains("Palatal Consonants") { return "Topic: Palatals చ ఛ జ ఝ ఞ — Hard palate sounds. Examples: చలి, జేబు, ఝంకారం, ఞానం (in conjuncts)." }
        if title.contains("Forming Syllables") { return "Topic: Combining క with vowels — క, కా, కి, కీ, కు, కూ, కె, కేసి. How signs change sound and meaning." }
        if title.contains("Numbers 1–10") { return "Topic: Numbers 1–10 — ఒకటి…పది. Use in counting items and basic sentences." }
        if title.contains("Greetings and Politeness") { return "Topic: Greetings — నమస్కారం, ఎలా ఉన్నారు?, బాగున్నాను, ధన్యవాదాలు, దయచేసి, క్షమించండి." }
        if title.contains("Family and People Words") { return "Topic: Family words — అమ్మ, నాన్న, అక్క, అన్న, తమ్ముడు, చెల్లి. Simple introductions." }
        if title.contains("Daily Activities") { return "Topic: Daily verbs — తిను, త్రాగు, నడువు, చదువు, రాయు. Form present sentences." }
        if title.contains("Simple Present-Tense") { return "Topic: SOV present sentences — నేను నీరు త్రాగుతాను, నేను పుస్తకం చదువుతాను. Word order practice." }
        // BASIC
        if title.contains("Complex Syllables") { return "Topic: Complex syllables across vowels — build and read multisyllabic patterns." }
        if title.contains("Double Consonants") { return "Topic: Doubling: క్క, ప్ప, ట్ట — how gemination changes pronunciation. Examples: పప్పు, ముక్క." }
        if title.contains("Body Parts") { return "Topic: Body parts — తల, కన్ను, చేయి, కాలు. Describe with adjectives." }
        if title.contains("Colors") { return "Topic: Colors — ఎరుపు, నీలం, పసుపు, ఆకుపచ్చ, నలుపు. Match colors to objects." }
        if title.contains("Numbers 11–20") { return "Topic: Numbers 11–20 — పదకొండు…ఇరవై. Counting money and items." }
        if title.contains("Animals") { return "Topic: Animals — కుక్క, పిల్లి, పక్షి, ఆవు, ఏనుగు. Sounds and features." }
        if title.contains("Basic Phrases") { return "Topic: Basic phrases and Q&A — ఇది ఏమిటి?, ఎక్కడ?, ఎంత?, ఎవరు? Short dialogues." }
        if title.contains("Action Verbs") { return "Topic: Present conjugations for common verbs — I/you/he-she forms in context." }
        if title.contains("Possessives") { return "Topic: Possessives నా, నీ — Build noun phrases: నా పుస్తకం, నీ ఇల్లు." }
        if title.contains("Conversation Starters") { return "Topic: Openings and small talk — introductions, likes, and polite turns." }
        // INTERMEDIATE
        if title.contains("Continuous") { return "Topic: Present continuous — చేస్తున్నాను/చేస్తున్నాను patterns in real contexts." }
        if title.contains("Past Tense") { return "Topic: Simple past — చేశాను/తిన్నాను forms. Tell recent actions." }
        if title.contains("Future Tense") { return "Topic: Future intentions — చేస్తాను/వెళ్తాను. Plans and promises." }
        if title.contains("Forming Questions") { return "Topic: WH-questions — ఎక్కడ, ఎప్పుడు, ఎవరు, ఎందుకు. Structure and tone." }
        if title.contains("Directions") { return "Topic: Directions — ఎడమ, కుడి, ముందు, వెనుక. Asking and giving routes." }
        if title.contains("Talking About Time") { return "Topic: Time — ఇప్పుడు, ఈరోజు, రేపు, నిన్న, గంటలు-నిమిషాలు." }
        if title.contains("Short Story") { return "Topic: Short story reading — gist, keywords, and sequencing." }
        if title.contains("Adjectives") { return "Topic: Adjectives — పెద్ద, చిన్న, మంచి, వేగంగా. Modify nouns correctly." }
        if title.contains("Comparisons") { return "Topic: Comparatives — కంటే, చాలా, అత్యంత. Compare people and things." }
        if title.contains("Complex Sentences") { return "Topic: Connectors అయితే, కానీ — Contrast and conditions in multi-clause sentences." }
        // ADVANCED
        if title.contains("Conditionals") { return "Topic: If/then nuances — అయితే, అయినా; hypothetical vs real conditions." }
        if title.contains("Passive Voice") { return "Topic: Passive voice — transform and interpret agentless sentences." }
        if title.contains("Idioms") { return "Topic: Idioms — meaning in context; avoid literal translations." }
        if title.contains("Formal Speech") { return "Topic: Formal address — మీరు, తమరు; polite verb forms and honorifics." }
        if title.contains("Poetry") { return "Topic: Simple poetry — meter hints, imagery, and pronunciation." }
        if title.contains("News") { return "Topic: News reading — headline grammar, summarizing key points." }
        if title.contains("Letter") { return "Topic: Formal letter — salutations, body, closing with respect markers." }
        if title.contains("Culture") { return "Topic: Culture — festivals, customs, and respectful forms in speech." }
        if title.contains("Grammar – Exceptions") { return "Topic: Complex grammar — exceptions, irregulars, and edge cases." }
        if title.contains("Comprehensive Mixed Practice") { return "Topic: Mixed practice — combine grammar, vocab, and reading." }
        return fallback
    }

    private func topicActivitiesFor(levelId: String, title: String, lessonId: String, difficulty: Int) -> [LessonActivity] {
        // Build 10 questions with varied types mapped to the topic. Use deterministic IDs.
        func mcq(_ id: String, _ q: String, _ ans: String, _ opts: [String]) -> ActivityQuestion {
            return ActivityQuestion(id: id, type: .multipleChoice, question: q, correctAnswer: ans, options: opts, audioFile: nil, strokeOrder: nil, explanation: nil)
        }
        func mcq(_ id: String, _ q: String, _ ans: String) -> ActivityQuestion {
            return ActivityQuestion(id: id, type: .textInput, question: q, correctAnswer: ans, options: nil, audioFile: nil, strokeOrder: nil, explanation: nil)
        }
        func listen(_ id: String, _ q: String, _ ans: String, _ opts: [String]) -> ActivityQuestion {
            return ActivityQuestion(id: id, type: .audioIdentification, question: q, correctAnswer: ans, options: opts, audioFile: nil, strokeOrder: nil, explanation: nil)
        }
        func trace(_ id: String, _ q: String, _ target: String) -> ActivityQuestion {
            return ActivityQuestion(id: id, type: .tracing, question: q, correctAnswer: target, options: nil, audioFile: nil, strokeOrder: ["Follow the stroke order"], explanation: nil)
        }
        func speak(_ id: String, _ q: String, _ ans: String) -> ActivityQuestion {
            return ActivityQuestion(id: id, type: .speaking, question: q, correctAnswer: ans, options: nil, audioFile: nil, strokeOrder: nil, explanation: nil)
        }

        let baseXP = max(1, difficulty) * 20
        // Vowels Part 1
        if title.contains("Vowels – Part 1") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Which is short 'a'?", "అ", ["అ", "ఆ", "ఇ", "ఈ"]),
                mcq("q_\(lessonId)_r2", "Which is long 'aa'?", "ఆ", ["అ", "ఆ", "ఇ", "ఈ"]),
                mcq("q_\(lessonId)_r3", "Which makes 'ii'?", "ఈ", ["ఇ", "ఈ", "అ", "ఆ"])
            ]
            let writing = [
                trace("q_\(lessonId)_w1", "Trace 'అ'", "అ"),
                mcq("q_\(lessonId)_w2", "Type the vowel for 'aa'", "ఆ", ["ఆ", "అ", "ఇ", "ఈ"]),
                mcq("q_\(lessonId)_w3", "Type the vowel in 'ఇల్లు' (house)", "ఇ", ["ఇ", "ఆ", "ఈ", "ఎ"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify the sound (short a)", "అ", ["అ", "ఆ", "ఇ", "ఈ"]),
                listen("q_\(lessonId)_l2", "Identify the sound (long ii)", "ఈ", ["ఇ", "ఈ", "అ", "ఆ"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Pronounce 'అ' clearly", "అ"),
                speak("q_\(lessonId)_s2", "Pronounce 'ఈ' clearly", "ఈ")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize vowels", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Trace/type vowels", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say vowels", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // Vowels Part 2
        if title.contains("Vowels – Part 2") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Which is long 'uu'?", "ఊ", ["ఉ", "ఊ", "ఎ", "ఏ"]),
                mcq("q_\(lessonId)_r2", "Which is long 'ee' (open)", "ఏ", ["ఎ", "ఏ", "ఉ", "ఊ"]),
                mcq("q_\(lessonId)_r3", "Pick 'ఎ'", "ఎ", ["ఎ", "ఏ", "ఉ", "ఊ"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Type the vowel in 'ఏనుగు'", "ఏ", ["ఏ", "ఎ", "ఉ", "ఊ"]),
                mcq("q_\(lessonId)_w2", "Type the vowel in 'ఉల్లి'", "ఉ", ["ఉ", "ఊ", "ఎ", "ఏ"]),
                trace("q_\(lessonId)_w3", "Trace 'ఊ'", "ఊ")
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify long 'uu'", "ఊ", ["ఉ", "ఊ", "ఎ", "ఏ"]),
                listen("q_\(lessonId)_l2", "Identify 'ఎ' vs 'ఏ'", "ఏ", ["ఎ", "ఏ", "ఉ", "ఊ"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Pronounce 'ఉ' clearly", "ఉ"),
                speak("q_\(lessonId)_s2", "Pronounce 'ఏ' clearly", "ఏ")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize vowels", xpValue: baseXP, questions: reading, canSkip: false), 
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Trace/type vowels", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say vowels", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // Velar Consonants (క ఖ గ ఘ ఙ)
        if title.contains("Velar Consonants") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Pick 'క' (ka)", "క", ["క", "గ", "ఙ", "ఛ"]),
                mcq("q_\(lessonId)_r2", "Which is aspirated 'ఖ' (kha)?", "ఖ", ["క", "ఖ", "గ", "ఘ"]),
                mcq("q_\(lessonId)_r3", "Back nasal letter?", "ఙ", ["ఙ", "ణ", "న", "ఞ"])
            ]
            let writing = [
                trace("q_\(lessonId)_w1", "Trace 'క'", "క"),
                mcq("q_\(lessonId)_w2", "Write the letter for 'ga'", "గ", ["గ", "క", "ఘ", "ఙ"]),
                mcq("q_\(lessonId)_w3", "Write the aspirated 'gha'", "ఘ", ["ఘ", "గ", "క", "ఖ"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'ga' sound", "గ", ["క", "ఖ", "గ", "ఘ"]),
                listen("q_\(lessonId)_l2", "Identify 'kha' sound", "ఖ", ["ఖ", "ఘ", "క", "గ"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Pronounce 'క' clearly", "క"),
                speak("q_\(lessonId)_s2", "Pronounce 'ఘ' clearly", "ఘ")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize velars", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write velar letters", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify velars by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say velar letters", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // Palatal Consonants (చ ఛ జ ఝ ఞ)
        if title.contains("Palatal Consonants") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Pick 'చ' (cha)", "చ", ["చ", "జ", "ఛ", "ఝ"]),
                mcq("q_\(lessonId)_r2", "Which is 'జ' (ja)?", "జ", ["ఝ", "జ", "ఛ", "చ"]),
                mcq("q_\(lessonId)_r3", "Palatal nasal?", "ఞ", ["ఙ", "ఞ", "ణ", "న"])
            ]
            let writing = [
                trace("q_\(lessonId)_w1", "Trace 'చ'", "చ"),
                mcq("q_\(lessonId)_w2", "Write aspirated 'ఛ'", "ఛ", ["ఛ", "చ", "జ", "ఝ"]),
                mcq("q_\(lessonId)_w3", "Write 'జ'", "జ", ["జ", "చ", "ఛ", "ఝ"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'cha' sound", "చ", ["చ", "ఛ", "జ", "ఝ"]),
                listen("q_\(lessonId)_l2", "Identify 'ja' sound", "జ", ["ఝ", "జ", "ఛ", "చ"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Pronounce 'ఛ' clearly", "ఛ"),
                speak("q_\(lessonId)_s2", "Pronounce 'జ' clearly", "జ")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize palatals", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write palatal letters", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify palatals by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say palatal letters", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // Forming Syllables (క + vowels)
        if title.contains("Forming Syllables") {
            let reading = [
                mcq("q_\(lessonId)_r1", "క + ఆ = ?", "కా", ["క", "కా", "కి", "కీ"]),
                mcq("q_\(lessonId)_r2", "క + ఇ = ?", "కి", ["కి", "కీ", "క", "కా"]),
                mcq("q_\(lessonId)_r3", "క + ఈ = ?", "కీ", ["కీ", "కి", "కూ", "కె"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Form 'కూ' (క + ఊ)", "కూ", ["కూ", "కు", "కా", "కి"]),
                mcq("q_\(lessonId)_w2", "Form 'కె' (క + ఎ)", "కె", ["కె", "కే", "కా", "కి"]),
                mcq("q_\(lessonId)_w3", "Form 'కో' (క + ఓ)", "కో", ["కో", "కూ", "కా", "కె"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'కా' sound", "కా", ["కా", "కి", "కీ", "కె"]),
                listen("q_\(lessonId)_l2", "Identify 'కీ' sound", "కీ", ["కీ", "కూ", "కె", "కొ"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'కా' clearly", "కా"),
                speak("q_\(lessonId)_s2", "Say 'కి' clearly", "కి")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Combine క with vowels", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write syllables", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify syllable sounds", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Pronounce syllables", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // Numbers 1–10
        if title.contains("Numbers 1–10") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Pick 'ఒకటి'", "ఒకటి", ["ఒకటి", "రెండు", "మూడు", "నాలుగు"]),
                mcq("q_\(lessonId)_r2", "Which is 'ఏడు' (7)?", "ఏడు", ["ఆరు", "ఏడు", "ఎనిమిది", "తొమ్మిది"]),
                mcq("q_\(lessonId)_r3", "Which means '10'?", "పది", ["ఏడు", "మూడు", "పది", "ఐదు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'రెండు' (2)", "రెండు", ["రెండు", "మూడు", "నాలుగు", "ఐదు"]),
                mcq("q_\(lessonId)_w2", "Write 'మూడు' (3)", "మూడు", ["మూడు", "రెండు", "నాలుగు", "ఆరు"]),
                mcq("q_\(lessonId)_w3", "Write 'ఐదు' (5)", "ఐదు", ["ఐదు", "ఆరు", "ఏడు", "ఎనిమిది"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'ఆరు' sound", "ఆరు", ["ఆరు", "ఏడు", "ఎనిమిది", "పది"]),
                listen("q_\(lessonId)_l2", "Identify 'ఒకటి' sound", "ఒకటి", ["ఒకటి", "రెండు", "మూడు", "నాలుగు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'ఏడు' clearly", "ఏడు"),
                speak("q_\(lessonId)_s2", "Say 'పది' clearly", "పది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize numbers 1–10", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write Telugu numbers", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify numbers by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say numbers", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // Greetings and Politeness
        if title.contains("Greetings and Politeness") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Hello' (formal) in Telugu", "నమస్కారం", ["నమస్కారం", "హలో", "ధన్యవాదాలు", "శుభోదయం"]),
                mcq("q_\(lessonId)_r2", "'Thank you' in Telugu", "ధన్యవాదాలు", ["దయచేసి", "క్షమించండి", "ధన్యవాదాలు", "వీడ్కోలు"]),
                mcq("q_\(lessonId)_r3", "Response to 'ఎలా ఉన్నారు?'", "బాగున్నాను", ["బాగున్నాను", "వీడ్కోలు", "ధన్యవాదాలు", "నమస్కారం"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Type 'దయచేసి' (please)", "దయచేసి", ["దయచేసి", "క్షమించండి", "ధన్యవాదాలు", "నమస్కారం"]),
                mcq("q_\(lessonId)_w2", "Type 'క్షమించండి' (sorry)", "క్షమించండి", ["క్షమించండి", "దయచేసి", "వీడ్కోలు", "శుభోదయం"]),
                mcq("q_\(lessonId)_w3", "Type 'శుభోదయం' (good morning)", "శుభోదయం", ["శుభోదయం", "శుభరాత్రి", "నమస్కారం", "వీడ్కోలు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'వీడ్కోలు'", "వీడ్కోలు", ["వీడ్కోలు", "నమస్కారం", "ధన్యవాదాలు", "దయచేసి"]),
                listen("q_\(lessonId)_l2", "Identify 'నమస్కారం'", "నమస్కారం", ["నమస్కారం", "శుభోదయం", "క్షమించండి", "దయచేసి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నమస్కారం' clearly", "నమస్కారం"),
                speak("q_\(lessonId)_s2", "Say 'ధన్యవాదాలు' clearly", "ధన్యవాదాలు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize greetings", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Type greetings", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify greetings by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say greetings", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // Family and People Words
        if title.contains("Family and People Words") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Pick 'అమ్మ' (mother)", "అమ్మ", ["అమ్మ", "నాన్న", "అక్క", "అన్న"]),
                mcq("q_\(lessonId)_r2", "Which is 'నాన్న' (father)?", "నాన్న", ["నాన్న", "అమ్మ", "తమ్ముడు", "చెల్లి"]),
                mcq("q_\(lessonId)_r3", "Which means 'older sister'?", "అక్క", ["అక్క", "చెల్లి", "అన్న", "తమ్ముడు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Type 'అన్న' (older brother)", "అన్న", ["అన్న", "తమ్ముడు", "అక్క", "చెల్లి"]),
                mcq("q_\(lessonId)_w2", "Type 'చెల్లి' (younger sister)", "చెల్లి", ["చెల్లి", "అక్క", "అన్న", "తమ్ముడు"]),
                mcq("q_\(lessonId)_w3", "Type 'నానమ్మ' (grandmother)", "నానమ్మ", ["నానమ్మ", "తాతయ్య", "అమ్మ", "నాన్న"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'అక్క'", "అక్క", ["అక్క", "చెల్లి", "అన్న", "తమ్ముడు"]),
                listen("q_\(lessonId)_l2", "Identify 'నాన్న'", "నాన్న", ["నాన్న", "అమ్మ", "అన్న", "అక్క"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'అమ్మ' clearly", "అమ్మ"),
                speak("q_\(lessonId)_s2", "Say 'తమ్ముడు' clearly", "తమ్ముడు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize family words", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Type family words", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say family words", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // Daily Activities – Common Verbs
        if title.contains("Daily Activities") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'eat' in Telugu", "తిను", ["తిను", "త్రాగు", "నడువు", "రాయు"]),
                mcq("q_\(lessonId)_r2", "'drink' in Telugu", "త్రాగు", ["రాయు", "తిను", "త్రాగు", "చదువు"]),
                mcq("q_\(lessonId)_r3", "'walk' in Telugu", "నడువు", ["రాయు", "నడువు", "త్రాగు", "తిను"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'చదువు' (study)", "చదువు", ["చదువు", "రాయు", "తిను", "నడువు"]),
                mcq("q_\(lessonId)_w2", "Write 'రాయు' (write)", "రాయు", ["రాయు", "చదువు", "త్రాగు", "నడువు"]),
                mcq("q_\(lessonId)_w3", "Write 'నడువు' (walk)", "నడువు", ["నడువు", "రాయు", "తిను", "చదువు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'తిను'", "తిను", ["తిను", "త్రాగు", "రాయు", "చదువు"]),
                listen("q_\(lessonId)_l2", "Identify 'త్రాగు'", "త్రాగు", ["తిను", "త్రాగు", "రాయు", "నడువు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'చదువు' clearly", "చదువు"),
                speak("q_\(lessonId)_s2", "Say 'రాయు' clearly", "రాయు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize daily verbs", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Type verbs", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify verbs by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say verbs", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // Simple Present-Tense Sentences
        if title.contains("Simple Present-Tense") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Pick the SOV sentence", "నేను నీరు త్రాగుతాను", ["నేను నీరు త్రాగుతాను", "త్రాగుతాను నేను నీరు", "నీరు త్రాగుతాను నేను", "నేను త్రాగుతాను నీరు"]),
                mcq("q_\(lessonId)_r2", "Meaning: నేను రాస్తాను", "I write", ["I write", "I ate", "I will write", "I walk"]),
                mcq("q_\(lessonId)_r3", "Present of 'నడువు' (I walk)", "నేను నడుస్తాను", ["నేను నడిచాను", "నేను నడుస్తాను", "నేను నడుస్తాను (typo)", "నేను నడుస్తాను"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Complete: నేను పుస్తకం __ తాను (study)", "చదువుతాను", ["చదువుతాను", "చదివాను", "చదువుచున్నాను", "చదువుకుంటాను"]),
                mcq("q_\(lessonId)_w2", "Complete: నేను నీరు __ తాను (drink)", "త్రాగుతాను", ["త్రాగుతాను", "త్రాగాను", "త్రాగుచున్నాను", "త్రాగుకుంటాను"]),
                mcq("q_\(lessonId)_w3", "Complete: నేను అన్నం __ తాను (eat)", "తింటాను", ["తింటాను", "తిన్నాను", "తింటున్నాను", "తింటుకుంటాను"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify: నేను రాస్తాను", "నేను రాస్తాను", ["నేను రాస్తాను", "నేను రాసాను", "నేను రాశాను", "నేను రాసుకుంటాను"]),
                listen("q_\(lessonId)_l2", "Identify: నేను నడుస్తాను", "నేను నడుస్తాను", ["నేను నడుస్తాను", "నేను నడుస్తాను (alt)", "నేను నడిచాను", "నేను నడుస్తాను"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say: నేను నీరు త్రాగుతాను", "నేను నీరు త్రాగుతాను"),
                speak("q_\(lessonId)_s2", "Say: నేను పాఠం చదువుతాను", "నేను పాఠం చదువుతాను")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Present tense SOV", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Complete sentences", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify sentences by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say sentences", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        // BASIC LEVEL TOPICS (Level 2)
        if title.contains("Complex Syllables") {
            let reading = [
                mcq("q_\(lessonId)_r1", "కా + ఇ = ?", "కాయి", ["కాయి", "కాలు", "కాకి", "కాటు"]),
                mcq("q_\(lessonId)_r2", "మా + మా = ?", "మామా", ["మామా", "మాలా", "మాట", "మాము"]),
                mcq("q_\(lessonId)_r3", "పా + లు = ?", "పాలు", ["పాలు", "పాట", "పాము", "పాకు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write కా + లు", "కాలు", ["కాలు", "కాట", "కాలి", "కాకు"]),
                mcq("q_\(lessonId)_w2", "Write మా + ట", "మాట", ["మాట", "మాలు", "మాకు", "మాము"]),
                mcq("q_\(lessonId)_w3", "Write పా + ట", "పాట", ["పాట", "పాలు", "పాము", "పాకు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'కాలు'", "కాలు", ["కాలు", "కాయి", "కాకి", "కాటు"]),
                listen("q_\(lessonId)_l2", "Identify 'పాలు'", "పాలు", ["పాలు", "పాట", "పాము", "పాకు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'మామా' clearly", "మామా"),
                speak("q_\(lessonId)_s2", "Say 'కాయి' clearly", "కాయి")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read complex syllables", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Form complex syllables", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify complex sounds", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say complex syllables", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Double Consonants") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Which has double consonant?", "పప్పు", ["పాలు", "పప్పు", "పాట", "పాము"]),
                mcq("q_\(lessonId)_r2", "Pick the word with క్క", "ముక్క", ["ముక్క", "మాట", "కాలు", "పాలు"]),
                mcq("q_\(lessonId)_r3", "Which has ట్ట?", "పట్టు", ["పట్టు", "పాట", "కట్టు", "మట్టి"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'అక్క' (sister)", "అక్క", ["అక్క", "చెల్లి", "అన్న", "తమ్ముడు"]),
                mcq("q_\(lessonId)_w2", "Write 'బట్ట' (cloth)", "బట్ట", ["బట్ట", "చెట్టు", "పట్టు", "కట్టు"]),
                mcq("q_\(lessonId)_w3", "Write 'చెట్టు' (tree)", "చెట్టు", ["చెట్టు", "బట్ట", "పట్టు", "కట్టు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'పప్పు'", "పప్పు", ["పప్పు", "పాలు", "పాట", "పాము"]),
                listen("q_\(lessonId)_l2", "Identify 'ముక్క'", "ముక్క", ["ముక్క", "మాట", "కాలు", "పాలు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'పప్పు' clearly", "పప్పు"),
                speak("q_\(lessonId)_s2", "Say 'చెట్టు' clearly", "చెట్టు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize double consonants", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write double consonants", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify double sounds", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say double consonants", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Body Parts") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Head' in Telugu", "తల", ["తల", "కన్ను", "చేయి", "కాలు"]),
                mcq("q_\(lessonId)_r2", "'Eye' in Telugu", "కన్ను", ["కన్ను", "చేయి", "తల", "కాలు"]),
                mcq("q_\(lessonId)_r3", "'Hand' in Telugu", "చేయి", ["చేయి", "కాలు", "తల", "కన్ను"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'కాలు' (leg)", "కాలు", ["కాలు", "చేయి", "తల", "కన్ను"]),
                mcq("q_\(lessonId)_w2", "Write 'నోరు' (mouth)", "నోరు", ["నోరు", "కన్ను", "చెవి", "ముక్కు"]),
                mcq("q_\(lessonId)_w3", "Write 'చెవి' (ear)", "చెవి", ["చెవి", "కన్ను", "నోరు", "ముక్కు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'తల'", "తల", ["తల", "కన్ను", "చేయి", "కాలు"]),
                listen("q_\(lessonId)_l2", "Identify 'చేయి'", "చేయి", ["చేయి", "కాలు", "తల", "కన్ను"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'కన్ను' clearly", "కన్ను"),
                speak("q_\(lessonId)_s2", "Say 'చెవి' clearly", "చెవి")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize body parts", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write body part names", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify body parts by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say body part names", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Colors") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Red' in Telugu", "ఎరుపు", ["ఎరుపు", "నీలం", "పసుపు", "ఆకుపచ్చ"]),
                mcq("q_\(lessonId)_r2", "'Blue' in Telugu", "నీలం", ["నీలం", "ఎరుపు", "పసుపు", "నలుపు"]),
                mcq("q_\(lessonId)_r3", "'Green' in Telugu", "ఆకుపచ్చ", ["ఆకుపచ్చ", "పసుపు", "నీలం", "ఎరుపు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'పసుపు' (yellow)", "పసుపు", ["పసుపు", "ఎరుపు", "నీలం", "ఆకుపచ్చ"]),
                mcq("q_\(lessonId)_w2", "Write 'నలుపు' (black)", "నలుపు", ["నలుపు", "తెలుపు", "ఎరుపు", "నీలం"]),
                mcq("q_\(lessonId)_w3", "Write 'తెలుపు' (white)", "తెలుపు", ["తెలుపు", "నలుపు", "పసుపు", "ఎరుపు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'ఎరుపు'", "ఎరుపు", ["ఎరుపు", "నీలం", "పసుపు", "ఆకుపచ్చ"]),
                listen("q_\(lessonId)_l2", "Identify 'ఆకుపచ్చ'", "ఆకుపచ్చ", ["ఆకుపచ్చ", "పసుపు", "నీలం", "ఎరుపు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నీలం' clearly", "నీలం"),
                speak("q_\(lessonId)_s2", "Say 'తెలుపు' clearly", "తెలుపు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize colors", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write color names", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify colors by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say color names", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Numbers 11–20") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Pick 'పదకొండు' (11)", "పదకొండు", ["పదకొండు", "పన్నెండు", "పదమూడు", "పద్నాలుగు"]),
                mcq("q_\(lessonId)_r2", "Which is '15'?", "పదిహేను", ["పదిహేను", "పదిఆరు", "పదిఏడు", "పదిఎనిమిది"]),
                mcq("q_\(lessonId)_r3", "Which means '20'?", "ఇరవై", ["పందొమ్మిది", "ఇరవై", "పదిఎనిమిది", "పదిఏడు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'పన్నెండు' (12)", "పన్నెండు", ["పన్నెండు", "పదమూడు", "పద్నాలుగు", "పదిహేను"]),
                mcq("q_\(lessonId)_w2", "Write 'పదిఆరు' (16)", "పదిఆరు", ["పదిఆరు", "పదిహేను", "పదిఏడు", "పదిఎనిమిది"]),
                mcq("q_\(lessonId)_w3", "Write 'పందొమ్మిది' (19)", "పందొమ్మిది", ["పందొమ్మిది", "పదిఎనిమిది", "ఇరవై", "పదిఏడు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'పదమూడు'", "పదమూడు", ["పదమూడు", "పద్నాలుగు", "పదిహేను", "పదిఆరు"]),
                listen("q_\(lessonId)_l2", "Identify 'ఇరవై'", "ఇరవై", ["ఇరవై", "పందొమ్మిది", "పదిఎనిమిది", "పదిఏడు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'పద్నాలుగు' clearly", "పద్నాలుగు"),
                speak("q_\(lessonId)_s2", "Say 'పదిఎనిమిది' clearly", "పదిఎనిమిది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize numbers 11-20", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write teen numbers", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify teen numbers", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say teen numbers", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Animals") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Dog' in Telugu", "కుక్క", ["కుక్క", "పిల్లి", "పక్షి", "ఆవు"]),
                mcq("q_\(lessonId)_r2", "'Cat' in Telugu", "పిల్లి", ["పిల్లి", "కుక్క", "ఏనుగు", "గుర్రం"]),
                mcq("q_\(lessonId)_r3", "'Elephant' in Telugu", "ఏనుగు", ["ఏనుగు", "సింహం", "పులి", "ఎలుగుబంటి"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'పక్షి' (bird)", "పక్షి", ["పక్షి", "కుక్క", "పిల్లి", "ఆవు"]),
                mcq("q_\(lessonId)_w2", "Write 'ఆవు' (cow)", "ఆవు", ["ఆవు", "గుర్రం", "ఏనుగు", "సింహం"]),
                mcq("q_\(lessonId)_w3", "Write 'గుర్రం' (horse)", "గుర్రం", ["గుర్రం", "ఆవు", "ఏనుగు", "పక్షి"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'కుక్క'", "కుక్క", ["కుక్క", "పిల్లి", "పక్షి", "ఆవు"]),
                listen("q_\(lessonId)_l2", "Identify 'ఏనుగు'", "ఏనుగు", ["ఏనుగు", "సింహం", "పులి", "ఎలుగుబంటి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'పిల్లి' clearly", "పిల్లి"),
                speak("q_\(lessonId)_s2", "Say 'గుర్రం' clearly", "గుర్రం")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Recognize animal names", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write animal names", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify animals by sound", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say animal names", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // INTERMEDIATE LEVEL TOPICS (Level 3)
        if title.contains("Present Tense – Continuous") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Present continuous of 'చేయు'", "చేస్తున్నాను", ["చేస్తున్నాను", "చేశాను", "చేస్తాను", "చేసాను"]),
                mcq("q_\(lessonId)_r2", "'I am eating' in Telugu", "నేను తింటున్నాను", ["నేను తింటున్నాను", "నేను తిన్నాను", "నేను తింటాను", "నేను తిన్నాను"]),
                mcq("q_\(lessonId)_r3", "'He is reading'", "అతను చదువుతున్నాడు", ["అతను చదువుతున్నాడు", "అతను చదివాడు", "అతను చదువుతాడు", "అతను చదివాడు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Complete: నేను పుస్తకం __ తున్నాను", "చదువు", ["చదువు", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w2", "Complete: అమ్మ వంట __ తుంది", "చేస్", ["చేస్", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w3", "Complete: పిల్లలు ఆట __ తున్నారు", "ఆడు", ["ఆడు", "Option2", "Option3", "Option4"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify continuous form", "చేస్తున్నాను", ["చేస్తున్నాను", "చేశాను", "చేస్తాను", "చేసాను"]),
                listen("q_\(lessonId)_l2", "Identify 'తింటున్నాను'", "తింటున్నాను", ["తింటున్నాను", "తిన్నాను", "తింటాను", "తిన్నాను"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say: నేను చదువుతున్నాను", "నేను చదువుతున్నాను"),
                speak("q_\(lessonId)_s2", "Say: అతను రాస్తున్నాడు", "అతను రాస్తున్నాడు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Present continuous tense", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Complete continuous sentences", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify continuous forms", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say continuous sentences", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // INTERMEDIATE LEVEL TOPICS (Level 3)
        if title.contains("Present Tense – Continuous") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'I am eating' in Telugu", "నేను తింటున్నాను", ["నేను తింటున్నాను", "నేను తిన్నాను", "నేను తింటాను", "నేను తింటాను"]),
                mcq("q_\(lessonId)_r2", "'You are reading' in Telugu", "నువ్వు చదువుతున్నావు", ["నువ్వు చదువుతున్నావు", "నువ్వు చదివావు", "నువ్వు చదువుతావు", "నువ్వు చదవాలి"]),
                mcq("q_\(lessonId)_r3", "'She is walking' in Telugu", "ఆమె నడుస్తుంది", ["ఆమె నడుస్తుంది", "ఆమె నడిచింది", "ఆమె నడుస్తుంది", "ఆమె నడవాలి"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'నేను రాస్తున్నాను' (I am writing)", "నేను రాస్తున్నాను", ["నేను రాస్తున్నాను", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w2", "Write 'అతను వస్తున్నాడు' (he is coming)", "అతను వస్తున్నాడు", ["అతను వస్తున్నాడు", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w3", "Write 'మేము మాట్లాడుతున్నాము' (we are talking)", "మేము మాట్లాడుతున్నాము", ["మేము మాట్లాడుతున్నాము", "Option2", "Option3", "Option4"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'నేను తింటున్నాను'", "నేను తింటున్నాను", ["నేను తింటున్నాను", "నేను తిన్నాను", "నేను తింటాను", "నేను తింటాను"]),
                listen("q_\(lessonId)_l2", "Identify 'ఆమె నడుస్తుంది'", "ఆమె నడుస్తుంది", ["ఆమె నడుస్తుంది", "ఆమె నడిచింది", "ఆమె నడుస్తుంది", "ఆమె నడవాలి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నేను తింటున్నాను'", "నేను తింటున్నాను"),
                speak("q_\(lessonId)_s2", "Say 'అతను వస్తున్నాడు'", "అతను వస్తున్నాడు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read continuous tense", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write continuous forms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify continuous tense", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say continuous forms", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Past Tense") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'I ate' in Telugu", "నేను తిన్నాను", ["నేను తిన్నాను", "నేను తింటాను", "నేను తింటున్నాను", "నేను తింటాను"]),
                mcq("q_\(lessonId)_r2", "'You went' in Telugu", "నువ్వు వెళ్లావు", ["నువ్వు వెళ్లావు", "నువ్వు వెళ్తావు", "నువ్వు వెళ్తున్నావు", "నువ్వు వెళ్లాలి"]),
                mcq("q_\(lessonId)_r3", "'He came' in Telugu", "అతను వచ్చాడు", ["అతను వచ్చాడు", "అతను వస్తాడు", "అతను వస్తున్నాడు", "అతను రావాలి"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'నేను చదివాను' (I read)", "నేను చదివాను", ["నేను చదివాను", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w2", "Write 'ఆమె రాసింది' (she wrote)", "ఆమె రాసింది", ["ఆమె రాసింది", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w3", "Write 'మేము చూశాము' (we saw)", "మేము చూశాము", ["మేము చూశాము", "Option2", "Option3", "Option4"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'నేను తిన్నాను'", "నేను తిన్నాను", ["నేను తిన్నాను", "నేను తింటాను", "నేను తింటున్నాను", "నేను తింటాను"]),
                listen("q_\(lessonId)_l2", "Identify 'అతను వచ్చాడు'", "అతను వచ్చాడు", ["అతను వచ్చాడు", "అతను వస్తాడు", "అతను వస్తున్నాడు", "అతను రావాలి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నేను తిన్నాను'", "నేను తిన్నాను"),
                speak("q_\(lessonId)_s2", "Say 'అతను వచ్చాడు'", "అతను వచ్చాడు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read past tense", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write past forms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify past tense", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say past forms", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Future Tense") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'I will eat' in Telugu", "నేను తింటాను", ["నేను తింటాను", "నేను తిన్నాను", "నేను తింటున్నాను", "నేను తిన్నాను"]),
                mcq("q_\(lessonId)_r2", "'You will go' in Telugu", "నువ్వు వెళ్తావు", ["నువ్వు వెళ్తావు", "నువ్వు వెళ్లావు", "నువ్వు వెళ్తున్నావు", "నువ్వు వెళ్లావు"]),
                mcq("q_\(lessonId)_r3", "'She will come' in Telugu", "ఆమె వస్తుంది", ["ఆమె వస్తుంది", "ఆమె వచ్చింది", "ఆమె వస్తుంది", "ఆమె వచ్చింది"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'నేను చదువుతాను' (I will read)", "నేను చదువుతాను", ["నేను చదువుతాను", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w2", "Write 'అతను రాస్తాడు' (he will write)", "అతను రాస్తాడు", ["అతను రాస్తాడు", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w3", "Write 'మేము చూస్తాము' (we will see)", "మేము చూస్తాము", ["మేము చూస్తాము", "Option2", "Option3", "Option4"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'నేను తింటాను'", "నేను తింటాను", ["నేను తింటాను", "నేను తిన్నాను", "నేను తింటున్నాను", "నేను తిన్నాను"]),
                listen("q_\(lessonId)_l2", "Identify 'ఆమె వస్తుంది'", "ఆమె వస్తుంది", ["ఆమె వస్తుంది", "ఆమె వచ్చింది", "ఆమె వస్తుంది", "ఆమె వచ్చింది"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నేను తింటాను'", "నేను తింటాను"),
                speak("q_\(lessonId)_s2", "Say 'ఆమె వస్తుంది'", "ఆమె వస్తుంది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read future tense", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write future forms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify future tense", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say future forms", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Forming Questions") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Where?' in Telugu", "ఎక్కడ?", ["ఎక్కడ?", "ఎప్పుడు?", "ఎవరు?", "ఎందుకు?"]),
                mcq("q_\(lessonId)_r2", "'When?' in Telugu", "ఎప్పుడు?", ["ఎప్పుడు?", "ఎక్కడ?", "ఎవరు?", "ఎలా?"]),
                mcq("q_\(lessonId)_r3", "'Why?' in Telugu", "ఎందుకు?", ["ఎందుకు?", "ఎలా?", "ఎంత?", "ఎవరు?"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'ఎవరు?' (who)", "ఎవరు?", ["ఎవరు?", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w2", "Write 'ఎలా?' (how)", "ఎలా?", ["ఎలా?", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w3", "Write 'ఎంత?' (how much)", "ఎంత?", ["ఎంత?", "Option2", "Option3", "Option4"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'ఎక్కడ?'", "ఎక్కడ?", ["ఎక్కడ?", "ఎప్పుడు?", "ఎవరు?", "ఎందుకు?"]),
                listen("q_\(lessonId)_l2", "Identify 'ఎందుకు?'", "ఎందుకు?", ["ఎందుకు?", "ఎలా?", "ఎంత?", "ఎవరు?"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Ask 'ఎక్కడ?'", "ఎక్కడ?"),
                speak("q_\(lessonId)_s2", "Ask 'ఎప్పుడు?'", "ఎప్పుడు?")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read question words", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write question words", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify question words", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Ask questions", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // ADVANCED LEVEL TOPICS (Level 4)
        if title.contains("Conditionals") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'If it rains' in Telugu", "వర్షం పడితే", ["వర్షం పడితే", "వర్షం పడుతుంది", "వర్షం పడింది", "వర్షం పడాలి"]),
                mcq("q_\(lessonId)_r2", "'If you come' in Telugu", "నువ్వు వస్తే", ["నువ్వు వస్తే", "నువ్వు వచ్చావు", "నువ్వు వస్తావు", "నువ్వు రావాలి"]),
                mcq("q_\(lessonId)_r3", "Complete: 'అయితే...' means", "If/But", ["If/But", "When", "Because", "Although"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'నేను వస్తే' (if I come)", "నేను వస్తే", ["నేను వస్తే", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w2", "Write 'అయితే మంచిది' (then it's good)", "అయితే మంచిది", ["అయితే మంచిది", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w3", "Write 'కానీ సమస్య లేదు' (but no problem)", "కానీ సమస్య లేదు", ["కానీ సమస్య లేదు", "Option2", "Option3", "Option4"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'వర్షం పడితే'", "వర్షం పడితే", ["వర్షం పడితే", "వర్షం పడుతుంది", "వర్షం పడింది", "వర్షం పడాలి"]),
                listen("q_\(lessonId)_l2", "Identify 'నువ్వు వస్తే'", "నువ్వు వస్తే", ["నువ్వు వస్తే", "నువ్వు వచ్చావు", "నువ్వు వస్తావు", "నువ్వు రావాలి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'వర్షం పడితే'", "వర్షం పడితే"),
                speak("q_\(lessonId)_s2", "Say 'అయితే మంచిది'", "అయితే మంచిది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read conditional sentences", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write conditional forms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify conditionals", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say conditional sentences", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Passive Voice") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'The book was read' in Telugu", "పుస్తకం చదవబడింది", ["పుస్తకం చదవబడింది", "పుస్తకం చదివాను", "పుస్తకం చదువుతాను", "పుస్తకం చదవాలి"]),
                mcq("q_\(lessonId)_r2", "'Food is being cooked' in Telugu", "భోజనం వండబడుతోంది", ["భోజనం వండబడుతోంది", "భోజనం వండాను", "భోజనం వండుతాను", "భోజనం వండాలి"]),
                mcq("q_\(lessonId)_r3", "'Letter will be written' in Telugu", "లేఖ రాయబడుతుంది", ["లేఖ రాయబడుతుంది", "లేఖ రాశాను", "లేఖ రాస్తాను", "లేఖ రాయాలి"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'కథ చెప్పబడింది' (story was told)", "కథ చెప్పబడింది", ["కథ చెప్పబడింది", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w2", "Write 'పని చేయబడుతోంది' (work is being done)", "పని చేయబడుతోంది", ["పని చేయబడుతోంది", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w3", "Write 'ఇల్లు కట్టబడుతుంది' (house will be built)", "ఇల్లు కట్టబడుతుంది", ["ఇల్లు కట్టబడుతుంది", "Option2", "Option3", "Option4"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'పుస్తకం చదవబడింది'", "పుస్తకం చదవబడింది", ["పుస్తకం చదవబడింది", "పుస్తకం చదివాను", "పుస్తకం చదువుతాను", "పుస్తకం చదవాలి"]),
                listen("q_\(lessonId)_l2", "Identify 'భోజనం వండబడుతోంది'", "భోజనం వండబడుతోంది", ["భోజనం వండబడుతోంది", "భోజనం వండాను", "భోజనం వండుతాను", "భోజనం వండాలి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'పుస్తకం చదవబడింది'", "పుస్తకం చదవబడింది"),
                speak("q_\(lessonId)_s2", "Say 'భోజనం వండబడుతోంది'", "భోజనం వండబడుతోంది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read passive voice", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write passive forms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify passive voice", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say passive forms", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Idioms") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'చేతిలో ఉంది' means", "It's in hand/control", ["It's in hand/control", "It's expensive", "It's far away", "It's broken"]),
                mcq("q_\(lessonId)_r2", "'కన్నుమూసి' means", "Blindly/without thinking", ["Blindly/without thinking", "Very carefully", "With eyes closed", "Very slowly"]),
                mcq("q_\(lessonId)_r3", "'గాలికి వదిలేయడం' means", "To abandon/let go", ["To abandon/let go", "To fly a kite", "To open windows", "To run fast"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'మనసులో పెట్టుకో' (keep in mind)", "మనసులో పెట్టుకో", ["మనసులో పెట్టుకో", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w2", "Write 'చేతులు కట్టుకుని' (hands tied/helpless)", "చేతులు కట్టుకుని", ["చేతులు కట్టుకుని", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w3", "Write 'కాలం చెల్లిపోయింది' (time has passed)", "కాలం చెల్లిపోయింది", ["కాలం చెల్లిపోయింది", "Option2", "Option3", "Option4"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'చేతిలో ఉంది'", "చేతిలో ఉంది", ["చేతిలో ఉంది", "చేతిలో లేదు", "చేతితో పట్టు", "చేతిని కడుక్కో"]),
                listen("q_\(lessonId)_l2", "Identify 'కన్నుమూసి'", "కన్నుమూసి", ["కన్నుమూసి", "కన్నుతెరువు", "కన్నులు కడుక్కో", "కన్నుల్లో నీళ్లు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'చేతిలో ఉంది'", "చేతిలో ఉంది"),
                speak("q_\(lessonId)_s2", "Say 'మనసులో పెట్టుకో'", "మనసులో పెట్టుకో")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read Telugu idioms", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write idiomatic expressions", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify idioms", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say idiomatic expressions", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        if title.contains("Formal Speech") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Formal 'you' in Telugu", "మీరు", ["మీరు", "నువ్వు", "నీవు", "తాము"]),
                mcq("q_\(lessonId)_r2", "'Please come' (formal) in Telugu", "దయచేసి రండి", ["దయచేసి రండి", "దయచేసి రా", "వచ్చేయ్", "రావు"]),
                mcq("q_\(lessonId)_r3", "'Thank you' (very formal) in Telugu", "ధన్యవాదములు", ["ధన్యవాదములు", "ధన్యవాదాలు", "థాంక్స్", "మెర్సీ"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'మీరు ఎలా ఉన్నారు?' (how are you - formal)", "మీరు ఎలా ఉన్నారు?", ["మీరు ఎలా ఉన్నారు?", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w2", "Write 'క్షమించండి' (excuse me - formal)", "క్షమించండి", ["క్షమించండి", "Option2", "Option3", "Option4"]),
                mcq("q_\(lessonId)_w3", "Write 'తమరి అభిప్రాయం?' (your opinion - very formal)", "తమరి అభిప్రాయం?", ["తమరి అభిప్రాయం?", "Option2", "Option3", "Option4"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'మీరు'", "మీరు", ["మీరు", "నువ్వు", "నీవు", "తాము"]),
                listen("q_\(lessonId)_l2", "Identify 'దయచేసి రండి'", "దయచేసి రండి", ["దయచేసి రండి", "దయచేసి రా", "వచ్చేయ్", "రావు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'మీరు ఎలా ఉన్నారు?'", "మీరు ఎలా ఉన్నారు?"),
                speak("q_\(lessonId)_s2", "Say 'ధన్యవాదములు'", "ధన్యవాదములు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read formal speech", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write formal expressions", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify formal speech", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Practice formal speech", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Basic Phrases and Q&A
        if title.contains("Basic Phrases") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'What is this?' in Telugu", "ఇది ఏమిటి?", ["ఇది ఏమిటి?", "అది ఏమిటి?", "ఎక్కడ ఉంది?", "ఎవరిది?"]),
                mcq("q_\(lessonId)_r2", "'Where is it?' in Telugu", "ఎక్కడ ఉంది?", ["ఎక్కడ ఉంది?", "ఇది ఏమిటి?", "ఎవరిది?", "ఎంత ధర?"]),
                mcq("q_\(lessonId)_r3", "'How much?' in Telugu", "ఎంత?", ["ఎంత?", "ఎక్కడ?", "ఎప్పుడు?", "ఎలా?"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'ఎవరు?' (who)", "ఎవరు?", ["ఎవరు?", "ఎక్కడ?", "ఎప్పుడు?", "ఎంత?"]),
                mcq("q_\(lessonId)_w2", "Write 'ఎలా?' (how)", "ఎలా?", ["ఎలా?", "ఎంత?", "ఎక్కడ?", "ఎవరు?"]),
                mcq("q_\(lessonId)_w3", "Write 'అది ఏమిటి?' (what is that)", "అది ఏమిటి?", ["అది ఏమిటి?", "ఇది ఏమిటి?", "ఎక్కడ ఉంది?", "ఎవరిది?"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'ఇది ఏమిటి?'", "ఇది ఏమిటి?", ["ఇది ఏమిటి?", "అది ఏమిటి?", "ఎక్కడ ఉంది?", "ఎవరిది?"]),
                listen("q_\(lessonId)_l2", "Identify 'ఎంత?'", "ఎంత?", ["ఎంత?", "ఎక్కడ?", "ఎప్పుడు?", "ఎలా?"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Ask 'ఇది ఏమిటి?'", "ఇది ఏమిటి?"),
                speak("q_\(lessonId)_s2", "Ask 'ఎక్కడ ఉంది?'", "ఎక్కడ ఉంది?")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read basic questions", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write question words", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify questions", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Ask questions", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Action Verbs – Conjugation
        if title.contains("Action Verbs") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'I eat' in Telugu", "నేను తింటాను", ["నేను తింటాను", "నువ్వు తింటావు", "అతను తింటాడు", "మేము తింటాము"]),
                mcq("q_\(lessonId)_r2", "'You write' in Telugu", "నువ్వు రాస్తావు", ["నువ్వు రాస్తావు", "నేను రాస్తాను", "అతను రాస్తాడు", "మేము రాస్తాము"]),
                mcq("q_\(lessonId)_r3", "'We walk' in Telugu", "మేము నడుస్తాము", ["మేము నడుస్తాము", "నేను నడుస్తాను", "నువ్వు నడుస్తావు", "అతను నడుస్తాడు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'అతను చదువుతాడు' (he reads)", "అతను చదువుతాడు", ["అతను చదువుతాడు", "ఆమె చదువుతుంది", "మేము చదువుతాము", "వారు చదువుతారు"]),
                mcq("q_\(lessonId)_w2", "Write 'ఆమె వంట చేస్తుంది' (she cooks)", "ఆమె వంట చేస్తుంది", ["ఆమె వంట చేస్తుంది", "అతను వంట చేస్తాడు", "నేను వంట చేస్తాను", "మేము వంట చేస్తాము"]),
                mcq("q_\(lessonId)_w3", "Write 'వారు ఆడుతారు' (they play)", "వారు ఆడుతారు", ["వారు ఆడుతారు", "మేము ఆడుతాము", "నేను ఆడుతాను", "నువ్వు ఆడుతావు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'నేను తింటాను'", "నేను తింటాను", ["నేను తింటాను", "నువ్వు తింటావు", "అతను తింటాడు", "మేము తింటాము"]),
                listen("q_\(lessonId)_l2", "Identify 'వారు ఆడుతారు'", "వారు ఆడుతారు", ["వారు ఆడుతారు", "మేము ఆడుతాము", "నేను ఆడుతాను", "నువ్వు ఆడుతావు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నేను చదువుతాను'", "నేను చదువుతాను"),
                speak("q_\(lessonId)_s2", "Say 'ఆమె వంట చేస్తుంది'", "ఆమె వంట చేస్తుంది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read verb conjugations", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write conjugated verbs", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify verb forms", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say verb conjugations", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Possessives (నా, నీ) in Phrases
        if title.contains("Possessives") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'My book' in Telugu", "నా పుస్తకం", ["నా పుస్తకం", "నీ పుస్తకం", "అతని పుస్తకం", "ఆమె పుస్తకం"]),
                mcq("q_\(lessonId)_r2", "'Your house' in Telugu", "నీ ఇల్లు", ["నీ ఇల్లు", "నా ఇల్లు", "అతని ఇల్లు", "ఆమె ఇల్లు"]),
                mcq("q_\(lessonId)_r3", "'His car' in Telugu", "అతని కారు", ["అతని కారు", "ఆమె కారు", "నా కారు", "నీ కారు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'నా పేరు' (my name)", "నా పేరు", ["నా పేరు", "నీ పేరు", "అతని పేరు", "ఆమె పేరు"]),
                mcq("q_\(lessonId)_w2", "Write 'నీ అమ్మ' (your mother)", "నీ అమ్మ", ["నీ అమ్మ", "నా అమ్మ", "అతని అమ్మ", "ఆమె అమ్మ"]),
                mcq("q_\(lessonId)_w3", "Write 'మా ఇల్లు' (our house)", "మా ఇల్లు", ["మా ఇల్లు", "మీ ఇల్లు", "వారి ఇల్లు", "నా ఇల్లు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'నా పుస్తకం'", "నా పుస్తకం", ["నా పుస్తకం", "నీ పుస్తకం", "అతని పుస్తకం", "ఆమె పుస్తకం"]),
                listen("q_\(lessonId)_l2", "Identify 'మా ఇల్లు'", "మా ఇల్లు", ["మా ఇల్లు", "మీ ఇల్లు", "వారి ఇల్లు", "నా ఇల్లు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నా పేరు రాము'", "నా పేరు రాము"),
                speak("q_\(lessonId)_s2", "Say 'నీ ఇల్లు ఎక్కడ?'", "నీ ఇల్లు ఎక్కడ?")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read possessive phrases", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write possessive forms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify possessives", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Say possessive phrases", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Conversation Starters
        if title.contains("Conversation Starters") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'What is your name?' in Telugu", "మీ పేరు ఏమిటి?", ["మీ పేరు ఏమిటి?", "మీరు ఎక్కడ నుండి?", "మీకు ఎంత వయస్సు?", "మీరు ఏం చేస్తారు?"]),
                mcq("q_\(lessonId)_r2", "'I like Telugu' in Telugu", "నాకు తెలుగు అంటే ఇష్టం", ["నాకు తెలుగు అంటే ఇష్టం", "నేను తెలుగు నేర్చుకుంటున్నాను", "తెలుగు కష్టం", "తెలుగు సులభం"]),
                mcq("q_\(lessonId)_r3", "'Nice to meet you' in Telugu", "మిమ్మల్ని కలవడం సంతోషం", ["మిమ్మల్ని కలవడం సంతోషం", "మీరు ఎలా ఉన్నారు?", "మళ్లీ కలుద్దాం", "వీడ్కోలు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'నేను రాము' (I am Ramu)", "నేను రాము", ["నేను రాము", "నా పేరు రాము", "రాము నేను", "నేను రాము అని"]),
                mcq("q_\(lessonId)_w2", "Write 'మీరు ఎక్కడ నుండి?' (where are you from)", "మీరు ఎక్కడ నుండి?", ["మీరు ఎక్కడ నుండి?", "మీరు ఎక్కడ ఉంటారు?", "మీ ఇల్లు ఎక్కడ?", "మీరు ఎవరు?"]),
                mcq("q_\(lessonId)_w3", "Write 'మళ్లీ కలుద్దాం' (let's meet again)", "మళ్లీ కలుద్దాం", ["మళ్లీ కలుద్దాం", "మళ్లీ రండి", "మళ్లీ చూద్దాం", "మళ్లీ మాట్లాడుదాం"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'మీ పేరు ఏమిటి?'", "మీ పేరు ఏమిటి?", ["మీ పేరు ఏమిటి?", "మీరు ఎక్కడ నుండి?", "మీకు ఎంత వయస్సు?", "మీరు ఏం చేస్తారు?"]),
                listen("q_\(lessonId)_l2", "Identify 'నాకు తెలుగు అంటే ఇష్టం'", "నాకు తెలుగు అంటే ఇష్టం", ["నాకు తెలుగు అంటే ఇష్టం", "నేను తెలుగు నేర్చుకుంటున్నాను", "తెలుగు కష్టం", "తెలుగు సులభం"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నా పేరు రాము'", "నా పేరు రాము"),
                speak("q_\(lessonId)_s2", "Say 'మిమ్మల్ని కలవడం సంతోషం'", "మిమ్మల్ని కలవడం సంతోషం")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read conversation starters", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write introductions", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify conversation phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Practice introductions", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Directions and Movement
        if title.contains("Directions") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Left' in Telugu", "ఎడమ", ["ఎడమ", "కుడి", "ముందు", "వెనుక"]),
                mcq("q_\(lessonId)_r2", "'Go straight' in Telugu", "నేరుగా వెళ్లు", ["నేరుగా వెళ్లు", "ఎడమకు తిరుగు", "కుడికి తిరుగు", "వెనుకకు రా"]),
                mcq("q_\(lessonId)_r3", "'Turn right' in Telugu", "కుడికి తిరుగు", ["కుడికి తిరుగు", "ఎడమకు తిరుగు", "నేరుగా వెళ్లు", "ఆగు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'ముందు' (front/ahead)", "ముందు", ["ముందు", "వెనుక", "ఎడమ", "కుడి"]),
                mcq("q_\(lessonId)_w2", "Write 'వెనుక' (back/behind)", "వెనుక", ["వెనుక", "ముందు", "పక్కన", "దగ్గర"]),
                mcq("q_\(lessonId)_w3", "Write 'దూరం' (far)", "దూరం", ["దూరం", "దగ్గర", "పక్కన", "మధ్యలో"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'ఎడమకు తిరుగు'", "ఎడమకు తిరుగు", ["ఎడమకు తిరుగు", "కుడికి తిరుగు", "నేరుగా వెళ్లు", "ఆగు"]),
                listen("q_\(lessonId)_l2", "Identify 'దగ్గర'", "దగ్గర", ["దగ్గర", "దూరం", "పక్కన", "మధ్యలో"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నేరుగా వెళ్లు'", "నేరుగా వెళ్లు"),
                speak("q_\(lessonId)_s2", "Say 'కుడికి తిరుగు'", "కుడికి తిరుగు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read directions", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write direction words", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify directions", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Give directions", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Talking About Time
        if title.contains("Talking About Time") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Today' in Telugu", "ఈరోజు", ["ఈరోజు", "రేపు", "నిన్న", "ఇప్పుడు"]),
                mcq("q_\(lessonId)_r2", "'Yesterday' in Telugu", "నిన్న", ["నిన్న", "ఈరోజు", "రేపు", "మొన్న"]),
                mcq("q_\(lessonId)_r3", "'What time?' in Telugu", "ఎంత సమయం?", ["ఎంత సమయం?", "ఎప్పుడు?", "ఎక్కడ?", "ఎలా?"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'రేపు' (tomorrow)", "రేపు", ["రేపు", "ఈరోజు", "నిన్న", "మొన్న"]),
                mcq("q_\(lessonId)_w2", "Write 'ఇప్పుడు' (now)", "ఇప్పుడు", ["ఇప్పుడు", "తర్వాత", "ముందు", "అప్పుడు"]),
                mcq("q_\(lessonId)_w3", "Write 'ఉదయం' (morning)", "ఉదయం", ["ఉదయం", "మధ్యాహ్నం", "సాయంత్రం", "రాత్రి"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'ఈరోజు'", "ఈరోజు", ["ఈరోజు", "రేపు", "నిన్న", "ఇప్పుడు"]),
                listen("q_\(lessonId)_l2", "Identify 'సాయంత్రం'", "సాయంత్రం", ["సాయంత్రం", "ఉదయం", "మధ్యాహ్నం", "రాత్రి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'ఈరోజు ఉదయం'", "ఈరోజు ఉదయం"),
                speak("q_\(lessonId)_s2", "Say 'రేపు సాయంత్రం'", "రేపు సాయంత్రం")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read time expressions", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write time words", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify time expressions", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Talk about time", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Short Story Comprehension
        if title.contains("Short Story") {
            let reading = [
                mcq("q_\(lessonId)_r1", "In the story, what did రాము do?", "రాము పుస్తకం చదివాడు", ["రాము పుస్తకం చదివాడు", "రాము ఆట ఆడాడు", "రాము తిన్నాడు", "రాము నిద్రపోయాడు"]),
                mcq("q_\(lessonId)_r2", "Where did సీత go?", "సీత పాఠశాలకు వెళ్లింది", ["సీత పాఠశాలకు వెళ్లింది", "సీత ఇంటికి వెళ్లింది", "సీత దుకాణానికి వెళ్లింది", "సీత పార్కుకు వెళ్లింది"]),
                mcq("q_\(lessonId)_r3", "What happened at the end?", "అందరూ సంతోషంగా ఉన్నారు", ["అందరూ సంతోషంగా ఉన్నారు", "అందరూ ఇంటికి వెళ్లారు", "అందరూ తిన్నారు", "అందరూ నిద్రపోయారు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'కథ' (story)", "కథ", ["కథ", "పుస్తకం", "పాట", "సినిమా"]),
                mcq("q_\(lessonId)_w2", "Write 'హీరో' (hero)", "హీరో", ["హీరో", "విలన్", "రాజు", "రాణి"]),
                mcq("q_\(lessonId)_w3", "Write 'ముగింపు' (ending)", "ముగింపు", ["ముగింపు", "మొదలు", "మధ్య", "చివర"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'కథ చెప్పు'", "కథ చెప్పు", ["కథ చెప్పు", "పాట పాడు", "నృత్యం చేయి", "ఆట ఆడు"]),
                listen("q_\(lessonId)_l2", "Identify 'చాలా బాగుంది'", "చాలా బాగుంది", ["చాలా బాగుంది", "బాలేదు", "సరిపోలేదు", "అర్థం కాలేదు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'కథ చాలా బాగుంది'", "కథ చాలా బాగుంది"),
                speak("q_\(lessonId)_s2", "Say 'మరో కథ చెప్పు'", "మరో కథ చెప్పు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read story comprehension", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write story elements", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify story phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Discuss stories", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Complex Sentence Structures
        if title.contains("Complex Sentence") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Complex sentence with 'because'", "నేను వెళ్లలేదు ఎందుకంటే వర్షం వస్తోంది", ["నేను వెళ్లలేదు ఎందుకంటే వర్షం వస్తోంది", "నేను వెళ్లాను కానీ ఆలస్యం అయింది", "అతను వచ్చాడు మరియు మాట్లాడాడు", "ఆమె పాడింది లేదా నృత్యం చేసింది"]),
                mcq("q_\(lessonId)_r2", "Sentence with 'although'", "వర్షం వచ్చినప్పటికీ నేను వెళ్లాను", ["వర్షం వచ్చినప్పటికీ నేను వెళ్లాను", "వర్షం వస్తే నేను వెళ్లను", "వర్షం లేకపోతే వెళ్లతాను", "వర్షం వచ్చాక వెళ్లాను"]),
                mcq("q_\(lessonId)_r3", "Conditional sentence", "మీరు వస్తే నేను వంట చేస్తాను", ["మీరు వస్తే నేను వంట చేస్తాను", "మీరు వచ్చాక నేను వంట చేసాను", "మీరు రాకపోతే వంట చేయను", "మీరు వచ్చినప్పుడు వంట చేస్తున్నాను"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'ఎందుకంటే' (because)", "ఎందుకంటే", ["ఎందుకంటే", "అయినప్పటికీ", "కానీ", "మరియు"]),
                mcq("q_\(lessonId)_w2", "Write 'అయినప్పటికీ' (although)", "అయినప్పటికీ", ["అయినప్పటికీ", "ఎందుకంటే", "కానీ", "లేదా"]),
                mcq("q_\(lessonId)_w3", "Write 'అయితే' (if/then)", "అయితే", ["అయితే", "అప్పుడు", "ఇప్పుడు", "తర్వాత"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify complex sentence", "నేను వెళ్లలేదు ఎందుకంటే వర్షం వస్తోంది", ["నేను వెళ్లలేదు ఎందుకంటే వర్షం వస్తోంది", "నేను వెళ్లాను కానీ ఆలస్యం అయింది", "వర్షం వస్తే వెళ్లను", "వర్షం లేకపోతే వెళ్లతాను"]),
                listen("q_\(lessonId)_l2", "Identify 'అయినప్పటికీ'", "అయినప్పటికీ", ["అయినప్పటికీ", "ఎందుకంటే", "కానీ", "మరియు"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నేను వెళ్లలేదు ఎందుకంటే అనారోగ్యం'", "నేను వెళ్లలేదు ఎందుకంటే అనారోగ్యం"),
                speak("q_\(lessonId)_s2", "Say 'వర్షం వచ్చినప్పటికీ నేను వెళ్లాను'", "వర్షం వచ్చినప్పటికీ నేను వెళ్లాను")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read complex sentences", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write connectors", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify complex structures", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Form complex sentences", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Advanced Grammar Concepts
        if title.contains("Advanced Grammar") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Passive voice: 'The book was read'", "పుస్తకం చదవబడింది", ["పుస్తకం చదవబడింది", "పుస్తకం చదివాను", "పుస్తకం చదువుతున్నాను", "పుస్తకం చదవాలి"]),
                mcq("q_\(lessonId)_r2", "Causative: 'Made him eat'", "అతనిని తినిపించాడు", ["అతనిని తినిపించాడు", "అతను తిన్నాడు", "అతనికి తినిపించాడు", "అతను తినిపించుకున్నాడు"]),
                mcq("q_\(lessonId)_r3", "Reported speech marker", "అని అన్నాడు", ["అని అన్నాడు", "అని అడిగాడు", "అని చెప్పాడు", "అని వినిపించింది"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write passive form of 'write'", "రాయబడింది", ["రాయబడింది", "రాశాడు", "రాస్తున్నాడు", "రాయాలి"]),
                mcq("q_\(lessonId)_w2", "Write 'అని' (quotative)", "అని", ["అని", "అని అన్నాడు", "అని చెప్పాడు", "అని అడిగాడు"]),
                mcq("q_\(lessonId)_w3", "Write causative 'made to go'", "వెళ్లిపించాడు", ["వెళ్లిపించాడు", "వెళ్లాడు", "వెళ్లుతున్నాడు", "వెళ్లాలి"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify passive construction", "పుస్తకం చదవబడింది", ["పుస్తకం చదవబడింది", "పుస్తకం చదివాను", "పుస్తకం చదువుతున్నాను", "పుస్తకం చదవాలి"]),
                listen("q_\(lessonId)_l2", "Identify 'అని అన్నాడు'", "అని అన్నాడు", ["అని అన్నాడు", "అని అడిగాడు", "అని చెప్పాడు", "అని వినిపించింది"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'అతను రాము అని అన్నాడు'", "అతను రాము అని అన్నాడు"),
                speak("q_\(lessonId)_s2", "Say 'పని చేయించాడు'", "పని చేయించాడు")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read advanced grammar", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write complex forms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify grammar patterns", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Use advanced grammar", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Literature and Poetry
        if title.contains("Literature") || title.contains("Poetry") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Poetic word for 'moon'", "చంద్రుడు", ["చంద్రుడు", "సూర్యుడు", "నక్షత్రం", "ఆకాశం"]),
                mcq("q_\(lessonId)_r2", "Classical word for 'woman'", "స్త్రీ", ["స్త్రీ", "అమ్మాయి", "ఆడది", "మహిళ"]),
                mcq("q_\(lessonId)_r3", "Poetic expression for 'beautiful'", "సుందరమైన", ["సుందరమైన", "అందమైన", "చక్కని", "మంచి"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'కవిత' (poem)", "కవిత", ["కవిత", "కథ", "పాట", "నాటకం"]),
                mcq("q_\(lessonId)_w2", "Write 'కవి' (poet)", "కవి", ["కవి", "రచయిత", "గాయకుడు", "నటుడు"]),
                mcq("q_\(lessonId)_w3", "Write 'ఛందస్సు' (meter/rhythm)", "ఛందస్సు", ["ఛందస్సు", "తాళం", "స్వరం", "రాగం"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'కవిత చదువు'", "కవిత చదువు", ["కవిత చదువు", "కథ చదువు", "పాట పాడు", "నాటకం చూడు"]),
                listen("q_\(lessonId)_l2", "Identify 'చంద్రుడు'", "చంద్రుడు", ["చంద్రుడు", "సూర్యుడు", "నక్షత్రం", "ఆకాశం"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'కవిత చాలా అందంగా ఉంది'", "కవిత చాలా అందంగా ఉంది"),
                speak("q_\(lessonId)_s2", "Say 'నాకు కవిత్వం అంటే ఇష్టం'", "నాకు కవిత్వం అంటే ఇష్టం")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read literary texts", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write literary terms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify poetic language", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Discuss literature", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Cultural Context and Traditions
        if title.contains("Cultural") || title.contains("Traditions") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Festival' in Telugu", "పండుగ", ["పండుగ", "వేడుక", "కార్యక్రమం", "సభ"]),
                mcq("q_\(lessonId)_r2", "'Traditional dress' in Telugu", "సాంప్రదాయ దుస్తులు", ["సాంప్రదాయ దుస్తులు", "కొత్త దుస్తులు", "పాత దుస్తులు", "అందమైన దుస్తులు"]),
                mcq("q_\(lessonId)_r3", "'Respect elders' in Telugu", "పెద్దలను గౌరవించు", ["పెద్దలను గౌరవించు", "చిన్నవాళ్లను చూసుకో", "అందరినీ ప్రేమించు", "మంచిగా ప్రవర్తించు"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'దీవాలి' (Diwali)", "దీవాలి", ["దీవాలి", "దసరా", "హోలీ", "ఉగాది"]),
                mcq("q_\(lessonId)_w2", "Write 'ప్రార్థన' (prayer)", "ప్రార్థన", ["ప్రార్థన", "పూజ", "వేడుక", "కార్యక్రమం"]),
                mcq("q_\(lessonId)_w3", "Write 'సంస్కృతి' (culture)", "సంస్కృతి", ["సంస్కృతి", "సంప్రదాయం", "ఆచారం", "నియమం"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'పండుగ జరుపుకుంటాము'", "పండుగ జరుపుకుంటాము", ["పండుగ జరుపుకుంటాము", "వేడుక చేస్తాము", "కార్యక్రమం ఉంది", "సభ ఉంది"]),
                listen("q_\(lessonId)_l2", "Identify 'సాంప్రదాయం'", "సాంప్రదాయం", ["సాంప్రదాయం", "సంస్కృతి", "ఆచారం", "నియమం"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'మన సంస్కృతి గొప్పది'", "మన సంస్కృతి గొప్పది"),
                speak("q_\(lessonId)_s2", "Say 'పండుగలు చాలా ముఖ్యం'", "పండుగలు చాలా ముఖ్యం")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read about culture", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write cultural terms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify traditions", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Discuss culture", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Business and Professional
        if title.contains("Business") || title.contains("Professional") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Meeting' in Telugu", "సమావేశం", ["సమావేశం", "చర్చ", "సభ", "కార్యక్రమం"]),
                mcq("q_\(lessonId)_r2", "'Office' in Telugu", "కార్యాలయం", ["కార్యాలయం", "దుకాణం", "కంపెనీ", "ఇల్లు"]),
                mcq("q_\(lessonId)_r3", "'Project' in Telugu", "ప్రాజెక్టు", ["ప్రాజెక్టు", "పని", "పనిముట్టు", "కార్యం"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'వ్యాపారం' (business)", "వ్యాపారం", ["వ్యాపారం", "పని", "కంపెనీ", "దుకాణం"]),
                mcq("q_\(lessonId)_w2", "Write 'ఉద్యోగం' (job)", "ఉద్యోగం", ["ఉద్యోగం", "పని", "వృత్తి", "సేవ"]),
                mcq("q_\(lessonId)_w3", "Write 'లాభం' (profit)", "లాభం", ["లాభం", "నష్టం", "ఆదాయం", "ఖర్చు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'సమావేశం ఉంది'", "సమావేశం ఉంది", ["సమావేశం ఉంది", "చర్చ ఉంది", "సభ ఉంది", "కార్యక్రమం ఉంది"]),
                listen("q_\(lessonId)_l2", "Identify 'వ్యాపారం బాగుంది'", "వ్యాపారం బాగుంది", ["వ్యాపారం బాగుంది", "పని బాగుంది", "ఉద్యోగం బాగుంది", "కంపెనీ బాగుంది"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నా ఉద్యోగం కార్యాలయంలో'", "నా ఉద్యోగం కార్యాలయంలో"),
                speak("q_\(lessonId)_s2", "Say 'సమావేశం రేపు ఉంది'", "సమావేశం రేపు ఉంది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read business terms", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write professional vocabulary", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify business phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Professional communication", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Technology and Modern Life
        if title.contains("Technology") || title.contains("Modern") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Computer' in Telugu", "కంప్యూటర్", ["కంప్యూటర్", "ఫోన్", "టీవీ", "రేడియో"]),
                mcq("q_\(lessonId)_r2", "'Internet' in Telugu", "ఇంటర్నెట్", ["ఇంటర్నెట్", "వెబ్‌సైట్", "ఇమెయిల్", "మెసేజ్"]),
                mcq("q_\(lessonId)_r3", "'Mobile phone' in Telugu", "మొబైల్ ఫోన్", ["మొబైల్ ఫోన్", "ల్యాండ్‌లైన్", "టెలిఫోన్", "స్మార్ట్‌ఫోన్"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'యాప్' (app)", "యాప్", ["యాప్", "సాఫ్ట్‌వేర్", "ప్రోగ్రామ్", "గేమ్"]),
                mcq("q_\(lessonId)_w2", "Write 'వీడియో' (video)", "వీడియో", ["వీడియో", "ఫోటో", "ఆడియో", "ఫైల్"]),
                mcq("q_\(lessonId)_w3", "Write 'డౌన్‌లోడ్' (download)", "డౌన్‌లోడ్", ["డౌన్‌లోడ్", "అప్‌లోడ్", "షేర్", "సేవ్"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'కంప్యూటర్ ఆన్ చేయి'", "కంప్యూటర్ ఆన్ చేయి", ["కంప్యూటర్ ఆన్ చేయి", "ఫోన్ ఆన్ చేయి", "టీవీ ఆన్ చేయి", "లైట్ ఆన్ చేయి"]),
                listen("q_\(lessonId)_l2", "Identify 'ఇంటర్నెట్ కనెక్ట్ చేయి'", "ఇంటర్నెట్ కనెక్ట్ చేయి", ["ఇంటర్నెట్ కనెక్ట్ చేయి", "వైఫై కనెక్ట్ చేయి", "బ్లూటూత్ కనెక్ట్ చేయి", "కేబుల్ కనెక్ట్ చేయి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నా ఫోన్ చార్జ్ అయిపోయింది'", "నా ఫోన్ చార్జ్ అయిపోయింది"),
                speak("q_\(lessonId)_s2", "Say 'ఇంటర్నెట్ స్పీడ్ తక్కువగా ఉంది'", "ఇంటర్నెట్ స్పీడ్ తక్కువగా ఉంది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read technology terms", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write tech vocabulary", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify tech phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Discuss technology", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Travel and Transportation
        if title.contains("Travel") || title.contains("Transportation") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Train' in Telugu", "రైలు", ["రైలు", "బస్సు", "కారు", "ఆటో"]),
                mcq("q_\(lessonId)_r2", "'Airport' in Telugu", "విమానాశ్రయం", ["విమానాశ్రయం", "రైల్వే స్టేషన్", "బస్ స్టాండ్", "టాక్సీ స్టాండ్"]),
                mcq("q_\(lessonId)_r3", "'Ticket' in Telugu", "టికెట్", ["టికెట్", "పాస్", "కార్డ్", "టోకెన్"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'ప్రయాణం' (journey)", "ప్రయాణం", ["ప్రయాణం", "యాత్র", "పర్యటన", "విహారం"]),
                mcq("q_\(lessonId)_w2", "Write 'సామాన్లు' (luggage)", "సామాన్లు", ["సామాన్లు", "బ్యాగులు", "వస్తువులు", "సరుకులు"]),
                mcq("q_\(lessonId)_w3", "Write 'రిజర్వేషన్' (reservation)", "రిజర్వేషన్", ["రిజర్వేషన్", "బుకింగ్", "టికెట్", "సీట్"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'రైలు వస్తోంది'", "రైలు వస్తోంది", ["రైలు వస్తోంది", "బస్సు వస్తోంది", "కారు వస్తోంది", "ఆటో వస్తోంది"]),
                listen("q_\(lessonId)_l2", "Identify 'టికెట్ కావాలి'", "టికెట్ కావాలి", ["టికెట్ కావాలి", "పాస్ కావాలి", "కార్డ్ కావాలి", "టోకెన్ కావాలి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నేను రైలులో వెళ్లాలి'", "నేను రైలులో వెళ్లాలి"),
                speak("q_\(lessonId)_s2", "Say 'విమానాశ్రయం ఎక్కడ ఉంది?'", "విమానాశ్రయం ఎక్కడ ఉంది?")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read travel terms", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write transportation vocabulary", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify travel phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Discuss travel", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Health and Medical
        if title.contains("Health") || title.contains("Medical") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Doctor' in Telugu", "వైద్యుడు", ["వైద్యుడు", "నర్సు", "రోగి", "ఆసుపత్రి"]),
                mcq("q_\(lessonId)_r2", "'Medicine' in Telugu", "మందు", ["మందు", "మాత్ర", "ఇంజెక్షన్", "చికిత్స"]),
                mcq("q_\(lessonId)_r3", "'I have a headache' in Telugu", "నాకు తలనొప్పి ఉంది", ["నాకు తలనొప్పి ఉంది", "నాకు జ్వరం ఉంది", "నాకు దగ్గు ఉంది", "నాకు కడుపునొప్పి ఉంది"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'ఆసుపత్రి' (hospital)", "ఆసుపత్రి", ["ఆసుపత్రి", "క్లినిక్", "వైద్యశాల", "ఫార్మసీ"]),
                mcq("q_\(lessonId)_w2", "Write 'అనారోగ్యం' (illness)", "అనారోగ్యం", ["అనారోగ్యం", "వ్యాధి", "రోగం", "జబ్బు"]),
                mcq("q_\(lessonId)_w3", "Write 'ఆరోగ్యం' (health)", "ఆరోగ్యం", ["ఆరోగ్యం", "శక్తి", "బలం", "ఫిట్‌నెస్"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'వైద్యుడిని కలవాలి'", "వైద్యుడిని కలవాలి", ["వైద్యుడిని కలవాలి", "నర్సును కలవాలి", "ఆసుపత్రికి వెళ్లాలి", "మందు తీసుకోవాలి"]),
                listen("q_\(lessonId)_l2", "Identify 'మందు తీసుకో'", "మందు తీసుకో", ["మందు తీసుకో", "మాత్ర తీసుకో", "ఇంజెక్షన్ వేయించుకో", "చికిత్స చేయించుకో"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నాకు జ్వరం ఉంది'", "నాకు జ్వరం ఉంది"),
                speak("q_\(lessonId)_s2", "Say 'వైద్యుడిని కలవాలి'", "వైద్యుడిని కలవాలి")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read health terms", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write medical vocabulary", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify health phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Discuss health", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Education and Learning
        if title.contains("Education") || title.contains("Learning") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Student' in Telugu", "విద్యార్థి", ["విద్యార్థి", "ఉపాధ్యాయుడు", "ప్రిన్సిపాల్", "పాఠశాల"]),
                mcq("q_\(lessonId)_r2", "'Homework' in Telugu", "ఇంటి పని", ["ఇంటి పని", "పాఠం", "పరీక్ష", "అధ్యయనం"]),
                mcq("q_\(lessonId)_r3", "'University' in Telugu", "విశ్వవిద్యాలయం", ["విశ్వవిద్యాలయం", "కళాశాల", "పాఠశాల", "ఇన్‌స్టిట్యూట్"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'పరీక్ష' (exam)", "పరీక్ష", ["పరీక్ష", "టెస్ట్", "అసైన్‌మెంట్", "క్విజ్"]),
                mcq("q_\(lessonId)_w2", "Write 'గ్రేడ్' (grade)", "గ్రేడ్", ["గ్రేడ్", "మార్కులు", "స్కోర్", "రేటింగ్"]),
                mcq("q_\(lessonId)_w3", "Write 'డిగ్రీ' (degree)", "డిగ్రీ", ["డిగ్రీ", "సర్టిఫికేట్", "డిప్లోమా", "కోర్సు"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'పాఠం చదువుకో'", "పాఠం చదువుకో", ["పాఠం చదువుకో", "ఇంటి పని చేయి", "పరీక్షకు సిద్ధం కావు", "నోట్స్ రాయి"]),
                listen("q_\(lessonId)_l2", "Identify 'విద్యార్థి జీవితం'", "విద్యార్థి జీవితం", ["విద్యార్థి జీవితం", "ఉపాధ్యాయుడి జీవితం", "పాఠశాల జీవితం", "కళాశాల జీవితం"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నేను విద్యార్థిని'", "నేను విద్యార్థిని"),
                speak("q_\(lessonId)_s2", "Say 'పరీక్ష రేపు ఉంది'", "పరీక్ష రేపు ఉంది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read education terms", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write academic vocabulary", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify education phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Discuss education", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Sports and Recreation
        if title.contains("Sports") || title.contains("Recreation") || title.contains("Games") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Cricket' in Telugu", "క్రికెట్", ["క్రికెట్", "ఫుట్‌బాల్", "టెన్నిస్", "బ్యాడ్మింటన్"]),
                mcq("q_\(lessonId)_r2", "'Player' in Telugu", "ఆటగాడు", ["ఆటగాడు", "కోచ్", "రిఫరీ", "అభిమాని"]),
                mcq("q_\(lessonId)_r3", "'Victory' in Telugu", "విజయం", ["విజయం", "ఓటమి", "డ్రా", "మ్యాచ్"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'ఆట' (game/sport)", "ఆట", ["ఆట", "క్రీడ", "మ్యాచ్", "పోటీ"]),
                mcq("q_\(lessonId)_w2", "Write 'స్టేడియం' (stadium)", "స్టేడియం", ["స్టేడియం", "మైదానం", "కోర్ట్", "గ్రౌండ్"]),
                mcq("q_\(lessonId)_w3", "Write 'పోటీ' (competition)", "పోటీ", ["పోటీ", "మ్యాచ్", "టోర్నమెంట్", "చాంపియన్‌షిప్"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'ఆట ఆడుతున్నాను'", "ఆట ఆడుతున్నాను", ["ఆట ఆడుతున్నాను", "క్రీడ చేస్తున్నాను", "మ్యాచ్ చూస్తున్నాను", "పోటీలో పాల్గొంటున్నాను"]),
                listen("q_\(lessonId)_l2", "Identify 'విజయం సాధించాను'", "విజయం సాధించాను", ["విజయం సాధించాను", "ఓడిపోయాను", "డ్రా అయింది", "మ్యాచ్ గెలిచాను"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'నాకు క్రికెట్ అంటే ఇష్టం'", "నాకు క్రికెట్ అంటే ఇష్టం"),
                speak("q_\(lessonId)_s2", "Say 'మ్యాచ్ చాలా రోమాంచకంగా ఉంది'", "మ్యాచ్ చాలా రోమాంచకంగా ఉంది")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read sports terms", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write sports vocabulary", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify sports phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Discuss sports", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Nature and Environment
        if title.contains("Nature") || title.contains("Environment") || title.contains("Weather") {
            let reading = [
                mcq("q_\(lessonId)_r1", "'Tree' in Telugu", "చెట్టు", ["చెట్టు", "పువ్వు", "ఆకు", "కొమ్మ"]),
                mcq("q_\(lessonId)_r2", "'River' in Telugu", "నది", ["నది", "సముద్రం", "కొలను", "బావి"]),
                mcq("q_\(lessonId)_r3", "'Mountain' in Telugu", "కొండ", ["కొండ", "లోయ", "మైదానం", "అడవి"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'వర్షం' (rain)", "వర్షం", ["వర్షం", "ఎండ", "గాలి", "మంచు"]),
                mcq("q_\(lessonId)_w2", "Write 'పక్షి' (bird)", "పక్షి", ["పక్షి", "జంతువు", "చేప", "కీటకం"]),
                mcq("q_\(lessonId)_w3", "Write 'పర్యావరణం' (environment)", "పర్యావరణం", ["పర్యావరణం", "ప్రకృతి", "వాతావరణం", "భూమి"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'వర్షం వస్తోంది'", "వర్షం వస్తోంది", ["వర్షం వస్తోంది", "ఎండ వేస్తోంది", "గాలి వీస్తోంది", "మంచు కురుస్తోంది"]),
                listen("q_\(lessonId)_l2", "Identify 'చెట్లను కాపాడాలి'", "చెట్లను కాపాడాలి", ["చెట్లను కాపాడాలి", "పక్షులను కాపాడాలి", "నదులను కాపాడాలి", "పర్యావరణాన్ని కాపాడాలి"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'ప్రకృతి చాలా అందంగా ఉంది'", "ప్రకృతి చాలా అందంగా ఉంది"),
                speak("q_\(lessonId)_s2", "Say 'పర్యావరణాన్ని కాపాడుకోవాలి'", "పర్యావరణాన్ని కాపాడుకోవాలి")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read nature terms", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write environmental vocabulary", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify nature phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Discuss nature", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // Generic catch-all for any remaining topics
        if title.contains("Practice") || title.contains("Review") || title.contains("Mixed") {
            let reading = [
                mcq("q_\(lessonId)_r1", "Mixed vocabulary: 'Important'", "ముఖ్యమైన", ["ముఖ్యమైన", "సాధారణ", "కష్టమైన", "సులభమైన"]),
                mcq("q_\(lessonId)_r2", "Mixed vocabulary: 'Different'", "వేరు", ["వేరు", "ఒకే", "సమానం", "భిన్నం"]),
                mcq("q_\(lessonId)_r3", "Mixed vocabulary: 'Together'", "కలిసి", ["కలిసి", "వేరుగా", "ఒంటరిగా", "సమూహంగా"])
            ]
            let writing = [
                mcq("q_\(lessonId)_w1", "Write 'అవసరం' (need)", "అవసరం", ["అవసరం", "కోరిక", "కావాలి", "వద్దు"]),
                mcq("q_\(lessonId)_w2", "Write 'సమస్య' (problem)", "సమస్య", ["సమస్య", "పరిష్కారం", "కష్టం", "ఇబ్బంది"]),
                mcq("q_\(lessonId)_w3", "Write 'అవకాశం' (opportunity)", "అవకాశం", ["అవకాశం", "అవకాశం లేదు", "అవకాశం ఉంది", "అవకాశం వచ్చింది"])
            ]
            let listening = [
                listen("q_\(lessonId)_l1", "Identify 'చాలా ముఖ్యం'", "చాలా ముఖ్యం", ["చాలా ముఖ్యం", "అంత ముఖ్యం కాదు", "సాధారణం", "కొత్తది"]),
                listen("q_\(lessonId)_l2", "Identify 'కలిసి చేద్దాం'", "కలిసి చేద్దాం", ["కలిసి చేద్దాం", "వేరుగా చేద్దాం", "ఒంటరిగా చేస్తాను", "సమూహంగా చేద్దాం"])
            ]
            let speaking = [
                speak("q_\(lessonId)_s1", "Say 'ఇది చాలా ముఖ్యం'", "ఇది చాలా ముఖ్యం"),
                speak("q_\(lessonId)_s2", "Say 'మనం కలిసి చేద్దాం'", "మనం కలిసి చేద్దాం")
            ]
            return [
                LessonActivity(id: "activity_\(lessonId)_reading", type: .reading, title: "Reading Practice", instructions: "Read mixed vocabulary", xpValue: baseXP, questions: reading, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_writing", type: .writing, title: "Writing Practice", instructions: "Write general terms", xpValue: baseXP, questions: writing, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_listening", type: .listening, title: "Listening Practice", instructions: "Identify common phrases", xpValue: baseXP, questions: listening, canSkip: false),
                LessonActivity(id: "activity_\(lessonId)_speaking", type: .speaking, title: "Speaking Practice", instructions: "Practice general conversation", xpValue: baseXP, questions: speaking, canSkip: true)
            ]
        }
        
        // If a topic is not handled specifically, fall back to the existing builder
        return createStandardActivitiesGlobal(lessonId.replacingOccurrences(of: "lesson_", with: ""), level: difficulty)
    }

private func createStandardActivitiesGlobal(_ lessonId: String, level: Int) -> [LessonActivity] {
    let baseXP = level * 20
    let readingQuestions: [ActivityQuestion] = (1...3).map { idx in
        ActivityQuestion(
            id: "q\(lessonId)_r\(idx)",
            type: .multipleChoice,
            question: "Choose the correct option (Reading) #\(idx)",
            correctAnswer: "అ",
            options: ["అ", "ఆ", "ఇ", "ఈ"],
            audioFile: nil,
            strokeOrder: nil,
            explanation: "Practice recognizing characters"
        )
    }
    let writingQuestions: [ActivityQuestion] = (1...3).map { idx in
        ActivityQuestion(
            id: "q\(lessonId)_w\(idx)",
            type: idx == 1 ? .tracing : .textInput,
            question: idx == 1 ? "Trace the character:" : "Type the shown character:",
            correctAnswer: "అ",
            options: nil,
            audioFile: nil,
            strokeOrder: idx == 1 ? ["Start with main stroke", "Add details"] : nil,
            explanation: "Writing practice"
        )
    }
    let listeningQuestions: [ActivityQuestion] = (1...2).map { idx in
        ActivityQuestion(
            id: "q\(lessonId)_l\(idx)",
            type: .audioIdentification,
            question: "Listen and select (Listening) #\(idx)",
            correctAnswer: "అ",
            options: ["అ", "ఆ", "ఇ", "ఈ"],
            audioFile: nil,
            strokeOrder: nil,
            explanation: "Listening practice"
        )
    }
    let speakingQuestions: [ActivityQuestion] = (1...2).map { idx in
        ActivityQuestion(
            id: "q\(lessonId)_s\(idx)",
            type: .speaking,
            question: "Pronounce clearly (Speaking) #\(idx)",
            correctAnswer: "అ",
            options: nil,
            audioFile: nil,
            strokeOrder: nil,
            explanation: "Speaking practice"
        )
    }
    return [
        LessonActivity(
            id: "activity_\(lessonId)_reading",
            type: .reading,
            title: "Reading Practice",
            instructions: "Practice reading Telugu text",
            xpValue: baseXP,
            questions: readingQuestions,
            canSkip: false
        ),
        LessonActivity(
            id: "activity_\(lessonId)_writing",
            type: .writing,
            title: "Writing Practice",
            instructions: "Practice writing Telugu characters",
            xpValue: baseXP,
            questions: writingQuestions,
            canSkip: false
        ),
        LessonActivity(
            id: "activity_\(lessonId)_listening",
            type: .listening,
            title: "Listening Practice",
            instructions: "Listen and identify sounds",
            xpValue: baseXP,
            questions: listeningQuestions,
            canSkip: false
        ),
        LessonActivity(
            id: "activity_\(lessonId)_speaking",
            type: .speaking,
            title: "Speaking Practice",
            instructions: "Practice pronunciation",
            xpValue: baseXP,
            questions: speakingQuestions,
            canSkip: true
        )
    ]
}
