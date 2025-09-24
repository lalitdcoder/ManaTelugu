import Foundation
import Combine

struct LessonData: Codable {
    let levels: [LearningLevel]
}

class LessonsRepository: ObservableObject {
    @Published var levels: [LearningLevel] = []
    private var levelProgress: [String: Int] = [:]
    
    init() {
        self.levels = createComprehensiveLessons()
    }
    
    func loadLevels() async {
        guard levels.isEmpty else { return }
        
        self.levels = await Task.detached {
            self.createComprehensiveLessons()
        }.value
    }
    
    func markLessonComplete(lessonId: String, levelId: String) {
        levelProgress[levelId, default: 0] = max(levelProgress[levelId, default: 0], 1)
    }
    
    func getCompletedLessonCount(for levelId: String) -> Int {
        return levelProgress[levelId, default: 0]
    }
    
    func isLessonCompleted(_ lessonId: String) -> Bool {
        // Simple stub - you can implement proper logic later
        return false
    }
    
    private func createComprehensiveLessons() -> [LearningLevel] {
        let beginnerLessons = createBeginnerLessons()
        return [
            LearningLevel(
                id: "level_1_beginner",
                title: "Level 1: Beginner",
                description: "Master Telugu alphabet foundation with vowels and basic consonants.",
                difficulty: 1,
                lessons: beginnerLessons,
                requiredXP: 0,
                color: "#4CAF50"
            )
        ]
    }
    
    private func createBeginnerLessons() -> [Lesson] {
        return [
            // Lesson 1: Vowels Set 1 (అ, ఆ, ఇ, ఈ)
            Lesson(
                id: "lesson_1_1",
                title: "Vowels Set 1: అ, ఆ, ఇ, ఈ",
                description: "Learn your first four Telugu vowels with interactive activities",
                levelId: "level_1_beginner",
                order: 1,
                difficulty: 1,
                xpReward: 60,
                estimatedMinutes: 8,
                activities: createBeginnerActivities(lessonId: "lesson_1_1", lessonOrder: 1)
            ),
            
            // Lesson 2: Vowels Set 2 (ఉ, ఊ, ఋ, ఎ, ఏ)
            Lesson(
                id: "lesson_1_2",
                title: "Vowels Set 2: ఉ, ఊ, ఋ, ఎ, ఏ",
                description: "Master five more important Telugu vowels",
                levelId: "level_1_beginner",
                order: 2,
                difficulty: 1,
                xpReward: 60,
                estimatedMinutes: 8,
                activities: createBeginnerActivities(lessonId: "lesson_1_2", lessonOrder: 2)
            ),
            
            // Lesson 3: Vowels Set 3 (ఐ, ఒ, ఓ, ఔ, అం, అః)
            Lesson(
                id: "lesson_1_3",
                title: "Vowels Set 3: ఐ, ఒ, ఓ, ఔ, అం, అః",
                description: "Complete the vowel system with compound vowels and nasal sounds",
                levelId: "level_1_beginner",
                order: 3,
                difficulty: 1,
                xpReward: 60,
                estimatedMinutes: 8,
                activities: createBeginnerActivities(lessonId: "lesson_1_3", lessonOrder: 3)
            ),
            
            // Lesson 4: Consonants Set 1 (క, ఖ, గ, ఘ, ఙ)
            Lesson(
                id: "lesson_1_4",
                title: "Consonants Set 1: క, ఖ, గ, ఘ, ఙ",
                description: "Learn the ka-group consonants with interactive exercises",
                levelId: "level_1_beginner",
                order: 4,
                difficulty: 1,
                xpReward: 60,
                estimatedMinutes: 8,
                activities: createBeginnerActivities(lessonId: "lesson_1_4", lessonOrder: 4)
            ),
            
            // Lesson 5: Consonants Set 2 (చ, ఛ, జ, ఝ, ఞ)
            Lesson(
                id: "lesson_1_5",
                title: "Consonants Set 2: చ, ఛ, జ, ఝ, ఞ",
                description: "Master the cha-group consonants with fun activities",
                levelId: "level_1_beginner",
                order: 5,
                difficulty: 1,
                xpReward: 60,
                estimatedMinutes: 8,
                activities: createBeginnerActivities(lessonId: "lesson_1_5", lessonOrder: 5)
            ),
            
            // Lesson 6: Consonants Set 3 (ట, ఠ, డ, ఢ, ణ)
            Lesson(
                id: "lesson_1_6",
                title: "Consonants Set 3: ట, ఠ, డ, ఢ, ణ",
                description: "Learn the ta-group (retroflex) consonants",
                levelId: "level_1_beginner",
                order: 6,
                difficulty: 1,
                xpReward: 60,
                estimatedMinutes: 8,
                activities: createBeginnerActivities(lessonId: "lesson_1_6", lessonOrder: 6)
            ),
            
            // Lesson 7: Consonants Set 4 (త, థ, ద, ధ, న)
            Lesson(
                id: "lesson_1_7",
                title: "Consonants Set 4: త, థ, ద, ధ, న",
                description: "Master the dental consonant group",
                levelId: "level_1_beginner",
                order: 7,
                difficulty: 1,
                xpReward: 60,
                estimatedMinutes: 8,
                activities: createBeginnerActivities(lessonId: "lesson_1_7", lessonOrder: 7)
            ),
            
            // Lesson 8: Consonants Set 5 (ప, ఫ, బ, భ, మ)
            Lesson(
                id: "lesson_1_8",
                title: "Consonants Set 5: ప, ఫ, బ, భ, మ",
                description: "Learn the pa-group (labial) consonants",
                levelId: "level_1_beginner",
                order: 8,
                difficulty: 1,
                xpReward: 60,
                estimatedMinutes: 8,
                activities: createBeginnerActivities(lessonId: "lesson_1_8", lessonOrder: 8)
            ),
            
            // Lesson 9: Consonants Set 6 (య, ర, ల, వ, శ, ష, స, హ, ళ, క్ష, ఱ)
            Lesson(
                id: "lesson_1_9",
                title: "Consonants Set 6: య, ర, ల, వ, శ, ష, స, హ, ళ, క్ష, ఱ",
                description: "Complete your consonant knowledge with remaining letters",
                levelId: "level_1_beginner",
                order: 9,
                difficulty: 1,
                xpReward: 70,
                estimatedMinutes: 10,
                activities: createBeginnerActivities(lessonId: "lesson_1_9", lessonOrder: 9)
            ),
            
            // Lesson 10: Review Game & Guninthalu Intro
            Lesson(
                id: "lesson_1_10",
                title: "Review & గుణింతాలు Introduction",
                description: "Fun review games and introduction to vowel signs (guninthalu)",
                levelId: "level_1_beginner",
                order: 10,
                difficulty: 1,
                xpReward: 100,
                estimatedMinutes: 12,
                activities: createBeginnerActivities(lessonId: "lesson_1_10", lessonOrder: 10)
            )
        ]
    }
    
    private func createBasicLessons() -> [Lesson] {
        return (1...12).map { i in
            Lesson(
                id: "lesson_2_\(i)",
                title: "Not Named Yet",
                description: "This lesson is under development.",
                levelId: "level_2_basic",
                order: i,
                difficulty: 2,
                xpReward: 75,
                estimatedMinutes: 7,
                activities: createBasicActivities(for: i)
            )
        }
    }
    
    private func createIntermediateLessons() -> [Lesson] {
        return (1...12).map { i in
            Lesson(
                id: "lesson_3_\(i)",
                title: "Not Named Yet",
                description: "This lesson is under development.",
                levelId: "level_3_intermediate",
                order: i,
                difficulty: 3,
                xpReward: 100,
                estimatedMinutes: 10,
                activities: createIntermediateActivities(for: i)
            )
        }
    }
    
    private func generateBeginnerActivities(lessonId: String, lessonOrder: Int) -> [LessonActivity] {
        switch lessonOrder {
        case 1:
            // Lesson 1: Vowels Set 1 (అ, ఆ, ఇ, ఈ) - Interleaved
            return [
                // అ
                LessonActivity(
                    id: "activity_\(lessonId)_teaching_a",
                    type: .reading,
                    title: "Learn అ (a) 🌟",
                    instructions: "Learn the first Telugu vowel అ with animation and pronunciation",
                    xpValue: 10,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_teaching_a",
                            type: .characterRecognition,
                            question: "teaching_moment",
                            correctAnswer: "అ",
                            options: nil,
                            audioFile: "అ.mp3",
                            strokeOrder: [
                                "Meet అ - your first Telugu vowel! ✨",
                                "అ sounds like 'a' in 'father' (short a)",
                                "This is the most basic vowel sound",
                                "Listen to the pronunciation carefully!"
                            ],
                            explanation: "అ is the foundation vowel - you'll use it in many Telugu words!"
                        )
                    ],
                    canSkip: false
                ),
                LessonActivity(
                    id: "activity_\(lessonId)_listen_a",
                    type: .reading,
                    title: "Listen to అ 🎵",
                    instructions: "Listen to the vowel అ and identify it",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_a",
                            type: .audioIdentification,
                            question: "Which letter makes this sound?",
                            correctAnswer: "అ",
                            options: ["అ", "ఆ", "ఇ", "ఈ"],
                            audioFile: "అ.mp3",
                            strokeOrder: nil,
                            explanation: "Perfect! అ makes the 'a' sound. [Sparkle animation] ✨"
                        )
                    ],
                    canSkip: false
                ),
                LessonActivity(
                    id: "activity_\(lessonId)_trace_a",
                    type: .writing,
                    title: "Trace అ ✏️",
                    instructions: "Practice writing the vowel అ",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_a",
                            type: .tracing,
                            question: "Trace the vowel అ",
                            correctAnswer: "అ",
                            options: nil,
                            audioFile: "అ.mp3",
                            strokeOrder: [
                                "Start with the curved top",
                                "Draw the vertical line down",
                                "Add the horizontal base",
                                "Complete with the final curve"
                            ],
                            explanation: "Beautiful tracing of అ! [Gentle glow effect] ✨",
                            tolerance: 0.85
                        )
                    ],
                    canSkip: false
                ),
                // ఆ
                LessonActivity(
                    id: "activity_\(lessonId)_teaching_aa",
                    type: .reading,
                    title: "Learn ఆ (aa) 🌟",
                    instructions: "Learn the second Telugu vowel ఆ with animation and pronunciation",
                    xpValue: 10,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_teaching_aa",
                            type: .characterRecognition,
                            question: "teaching_moment",
                            correctAnswer: "ఆ",
                            options: nil,
                            audioFile: "ఆ.mp3",
                            strokeOrder: [
                                "Now meet ఆ - the long version of అ! ✨",
                                "ఆ sounds like 'aa' in 'car' (long aa)",
                                "Notice how it's longer than అ",
                                "This is the long 'a' sound!"
                            ],
                            explanation: "ఆ is the long version of అ - same sound, but held longer!"
                        )
                    ],
                    canSkip: false
                ),
                LessonActivity(
                    id: "activity_\(lessonId)_listen_aa",
                    type: .reading,
                    title: "Listen to ఆ 🎵",
                    instructions: "Listen to the vowel ఆ and identify it",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_aa",
                            type: .audioIdentification,
                            question: "Which letter makes this sound?",
                            correctAnswer: "ఆ",
                            options: ["అ", "ఆ", "ఇ", "ఈ"],
                            audioFile: "ఆ.mp3",
                            strokeOrder: nil,
                            explanation: "Excellent! ఆ makes the long 'aa' sound. [Star burst] 🌟"
                        )
                    ],
                    canSkip: false
                ),
                LessonActivity(
                    id: "activity_\(lessonId)_trace_aa",
                    type: .writing,
                    title: "Trace ఆ ✏️",
                    instructions: "Practice writing the vowel ఆ",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_aa",
                            type: .tracing,
                            question: "Trace the vowel ఆ",
                            correctAnswer: "ఆ",
                            options: nil,
                            audioFile: "ఆ.mp3",
                            strokeOrder: [
                                "Begin with the left curve",
                                "Add the central vertical line",
                                "Draw the horizontal connector",
                                "Finish with the right curve"
                            ],
                            explanation: "Excellent work on ఆ! [Success sparkles] 🌟",
                            tolerance: 0.85
                        )
                    ],
                    canSkip: false
                ),
                // ఇ
                LessonActivity(
                    id: "activity_\(lessonId)_teaching_i",
                    type: .reading,
                    title: "Learn ఇ (i) 🌟",
                    instructions: "Learn the third Telugu vowel ఇ with animation and pronunciation",
                    xpValue: 10,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_teaching_i",
                            type: .characterRecognition,
                            question: "teaching_moment",
                            correctAnswer: "ఇ",
                            options: nil,
                            audioFile: "ఇ.mp3",
                            strokeOrder: [
                                "Here's ఇ - a new vowel sound! ✨",
                                "ఇ sounds like 'i' in 'bit' (short i)",
                                "This is different from the 'a' sounds",
                                "Listen to the 'i' sound carefully!"
                            ],
                            explanation: "ఇ is the short 'i' sound - completely different from అ and ఆ!"
                        )
                    ],
                    canSkip: false
                ),
                LessonActivity(
                    id: "activity_\(lessonId)_listen_i",
                    type: .reading,
                    title: "Listen to ఇ 🎵",
                    instructions: "Listen to the vowel ఇ and identify it",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_i",
                            type: .audioIdentification,
                            question: "Which letter makes this sound?",
                            correctAnswer: "ఇ",
                            options: ["అ", "ఆ", "ఇ", "ఈ"],
                            audioFile: "ఇ.mp3",
                            strokeOrder: nil,
                            explanation: "Great! ఇ makes the short 'i' sound. [Glow effect] 💫"
                        )
                    ],
                    canSkip: false
                ),
                LessonActivity(
                    id: "activity_\(lessonId)_trace_i",
                    type: .writing,
                    title: "Trace ఇ ✏️",
                    instructions: "Practice writing the vowel ఇ",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_i",
                            type: .tracing,
                            question: "Trace the vowel ఇ",
                            correctAnswer: "ఇ",
                            options: nil,
                            audioFile: "ఇ.mp3",
                            strokeOrder: [
                                "Start with the small horizontal line",
                                "Draw the vertical line down",
                                "Add the curve at the bottom",
                                "Great job writing ఇ!"
                            ],
                            explanation: "Perfect tracing of ఇ! [Success animation] ✨",
                            tolerance: 0.85
                        )
                    ],
                    canSkip: false
                ),
                // ఈ
                LessonActivity(
                    id: "activity_\(lessonId)_teaching_ii",
                    type: .reading,
                    title: "Learn ఈ (ii) 🌟",
                    instructions: "Learn the fourth Telugu vowel ఈ with animation and pronunciation",
                    xpValue: 10,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_teaching_ii",
                            type: .characterRecognition,
                            question: "teaching_moment",
                            correctAnswer: "ఈ",
                            options: nil,
                            audioFile: "ఈ.mp3",
                            strokeOrder: [
                                "Finally, meet ఈ - the long version of ఇ! ✨",
                                "ఈ sounds like 'ee' in 'bee' (long ii)",
                                "Notice how it's longer than ఇ",
                                "This completes our first vowel set!"
                            ],
                            explanation: "ఈ is the long version of ఇ - you now know all four basic vowels!"
                        )
                    ],
                    canSkip: false
                ),
                LessonActivity(
                    id: "activity_\(lessonId)_listen_ii",
                    type: .reading,
                    title: "Listen to ఈ 🎵",
                    instructions: "Listen to the vowel ఈ and identify it",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_ii",
                            type: .audioIdentification,
                            question: "Which letter makes this sound?",
                            correctAnswer: "ఈ",
                            options: ["అ", "ఆ", "ఇ", "ఈ"],
                            audioFile: "ఈ.mp3",
                            strokeOrder: nil,
                            explanation: "Amazing! ఈ makes the long 'ee' sound. [Confetti] 🎉"
                        )
                    ],
                    canSkip: false
                ),
                LessonActivity(
                    id: "activity_\(lessonId)_trace_ii",
                    type: .writing,
                    title: "Trace ఈ ✏️",
                    instructions: "Practice writing the vowel ఈ",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_ii",
                            type: .tracing,
                            question: "Trace the vowel ఈ",
                            correctAnswer: "ఈ",
                            options: nil,
                            audioFile: "ఈ.mp3",
                            strokeOrder: [
                                "Start with the longer horizontal line",
                                "Draw the vertical line down",
                                "Add the longer curve at bottom",
                                "Notice how it's longer than ఇ!"
                            ],
                            explanation: "Excellent work on ఈ! [Celebration] 🎉",
                            tolerance: 0.85
                        )
                    ],
                    canSkip: false
                ),
                // Review
                LessonActivity(
                    id: "activity_\(lessonId)_card_match",
                    type: .reading,
                    title: "Vowel Card Match Review 🃏",
                    instructions: "Match vowel cards as a quick review",
                    xpValue: 30,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_card_match",
                            type: .characterRecognition,
                            question: "Match the vowel cards!",
                            correctAnswer: "match_all",
                            options: ["అ", "ఆ", "ఇ", "ఈ"],
                            audioFile: "card_match.mp3",
                            strokeOrder: ["Flip the cards", "Match vowels with their sounds", "Complete all pairs!"],
                            explanation: "Perfect! You matched all the vowel cards! [Card flip animation] 🃏✨"
                        )
                    ],
                    canSkip: false
                )
            ]
            
        case 2:
            // Lesson 2: Vowels Set 2 (ఉ, ఊ, ఋ, ఎ, ఏ) - Simplified
            return [
                LessonActivity(
                    id: "activity_\(lessonId)_teaching",
                    type: .reading,
                    title: "Discover More Telugu Vowels! 🌟",
                    instructions: "Learn ఉ, ఊ, ఋ, ఎ, ఏ with animations and sounds",
                    xpValue: 30,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_teaching_vowels",
                            type: .characterRecognition,
                            question: "teaching_moment",
                            correctAnswer: "ఉ, ఊ, ఋ, ఎ, ఏ",
                            options: nil,
                            audioFile: "vowel_set2_intro.mp3",
                            strokeOrder: [
                                "Here are five more Telugu vowels! ✨",
                                "ఉ sounds like 'u' in 'put' (short u)",
                                "ఊ sounds like 'oo' in 'boot' (long oo)",
                                "ఋ is a special vowel sound (ri)",
                                "ఎ sounds like 'e' in 'bed' (short e)",
                                "ఏ sounds like 'ay' in 'day' (long e)",
                                "Notice: short vowels (ఉ, ఎ) and long vowels (ఊ, ఏ)",
                                "ఋ is unique - it's a special Telugu vowel!",
                                "Let's practice each one individually!"
                            ],
                            explanation: "These vowels complete the short and long vowel pairs in Telugu - you'll learn each one step by step!"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_listen_u",
                    type: .reading,
                    title: "Listen to ఉ 🎵",
                    instructions: "Listen to the vowel ఉ and identify it",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_u",
                            type: .audioIdentification,
                            question: "Which vowel makes this sound?",
                            correctAnswer: "ఉ",
                            options: ["ఉ", "ఊ", "ఋ", "ఎ"],
                            audioFile: "ఉ.mp3",
                            strokeOrder: nil,
                            explanation: "Perfect! ఉ makes the short 'u' sound. [Sparkle animation] ✨"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_trace_u",
                    type: .writing,
                    title: "Trace ఉ ✏️",
                    instructions: "Practice writing the vowel ఉ",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_u",
                            type: .tracing,
                            question: "Trace the vowel ఉ",
                            correctAnswer: "ఉ",
                            options: nil,
                            audioFile: "ఉ.mp3",
                            strokeOrder: [
                                "Start with the top curve",
                                "Draw the vertical line",
                                "Add the bottom curve",
                                "Complete the small hook"
                            ],
                            explanation: "Beautiful tracing of ఉ! [Gentle glow] ✨"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_listen_uu",
                    type: .reading,
                    title: "Listen to ఊ 🎵",
                    instructions: "Listen to the vowel ఊ and identify it",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_uu",
                            type: .audioIdentification,
                            question: "Which vowel makes this sound?",
                            correctAnswer: "ఊ",
                            options: ["ఉ", "ఊ", "ఋ", "ఎ"],
                            audioFile: "ఊ.mp3",
                            strokeOrder: nil,
                            explanation: "Excellent! ఊ makes the long 'oo' sound. [Star burst] 🌟"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_trace_uu",
                    type: .writing,
                    title: "Trace ఊ ✏️",
                    instructions: "Practice writing the vowel ఊ",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_uu",
                            type: .tracing,
                            question: "Trace the vowel ఊ",
                            correctAnswer: "ఊ",
                            options: nil,
                            audioFile: "ఊ.mp3",
                            strokeOrder: [
                                "Start with the longer top curve",
                                "Draw the vertical line",
                                "Add the longer bottom curve",
                                "Notice how it's longer than ఉ!"
                            ],
                            explanation: "Excellent work on ఊ! [Success sparkles] 🌟"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_listen_ru",
                    type: .reading,
                    title: "Listen to ఋ 🎵",
                    instructions: "Listen to the special vowel ఋ and identify it",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_ru",
                            type: .audioIdentification,
                            question: "Which vowel makes this special sound?",
                            correctAnswer: "ఋ",
                            options: ["ఉ", "ఊ", "ఋ", "ఎ"],
                            audioFile: "ఋ.mp3",
                            strokeOrder: nil,
                            explanation: "Great! ఋ is the special 'ri' vowel. [Glow effect] 💫"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_trace_ru",
                    type: .writing,
                    title: "Trace ఋ ✏️",
                    instructions: "Practice writing the special vowel ఋ",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_ru",
                            type: .tracing,
                            question: "Trace the vowel ఋ",
                            correctAnswer: "ఋ",
                            options: nil,
                            audioFile: "ఋ.mp3",
                            strokeOrder: [
                                "Start with the top curve",
                                "Draw the vertical line down",
                                "Add the special hook at bottom",
                                "This is a unique Telugu vowel!"
                            ],
                            explanation: "Perfect tracing of ఋ! [Special animation] ✨"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_listen_e",
                    type: .reading,
                    title: "Listen to ఎ 🎵",
                    instructions: "Listen to the vowel ఎ and identify it",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_e",
                            type: .audioIdentification,
                            question: "Which vowel makes this sound?",
                            correctAnswer: "ఎ",
                            options: ["ఋ", "ఎ", "ఏ", "ఊ"],
                            audioFile: "ఎ.mp3",
                            strokeOrder: nil,
                            explanation: "Amazing! ఎ makes the short 'e' sound. [Confetti] 🎉"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_trace_e",
                    type: .writing,
                    title: "Trace ఎ ✏️",
                    instructions: "Practice writing the vowel ఎ",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_e",
                            type: .tracing,
                            question: "Trace the vowel ఎ",
                            correctAnswer: "ఎ",
                            options: nil,
                            audioFile: "ఎ.mp3",
                            strokeOrder: [
                                "Begin with the left curve",
                                "Draw the horizontal line",
                                "Add the vertical connector",
                                "Finish with the right curve"
                            ],
                            explanation: "Excellent work on ఎ! [Success sparkles] 🌟"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_listen_ee",
                    type: .reading,
                    title: "Listen to ఏ 🎵",
                    instructions: "Listen to the vowel ఏ and identify it",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_ee",
                            type: .audioIdentification,
                            question: "Which vowel makes this sound?",
                            correctAnswer: "ఏ",
                            options: ["ఋ", "ఎ", "ఏ", "ఊ"],
                            audioFile: "ఏ.mp3",
                            strokeOrder: nil,
                            explanation: "Perfect! ఏ makes the long 'ay' sound. [Rainbow animation] 🌈"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_trace_ee",
                    type: .writing,
                    title: "Trace ఏ ✏️",
                    instructions: "Practice writing the vowel ఏ",
                    xpValue: 20,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_ee",
                            type: .tracing,
                            question: "Trace the vowel ఏ",
                            correctAnswer: "ఏ",
                            options: nil,
                            audioFile: "ఏ.mp3",
                            strokeOrder: [
                                "Begin with the longer left curve",
                                "Draw the horizontal line",
                                "Add the vertical connector",
                                "Finish with the longer right curve"
                            ],
                            explanation: "Perfect tracing of ఏ! [Celebration] 🎉"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_card_match",
                    type: .reading,
                    title: "Vowel Card Match Review 🃏",
                    instructions: "Match vowel cards as a quick review",
                    xpValue: 30,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_card_match",
                            type: .characterRecognition,
                            question: "Match the vowel cards!",
                            correctAnswer: "match_all",
                            options: ["ఉ", "ఊ", "ఋ", "ఎ", "ఏ"],
                            audioFile: "card_match.mp3",
                            strokeOrder: ["Flip the cards", "Match vowels with their sounds", "Complete all pairs!"],
                            explanation: "Perfect! You matched all the vowel cards! [Card flip animation] 🃏✨"
                        )
                    ],
                    canSkip: false
                )
            ]
            
        case 3:
            // Lesson 3: Vowels Set 3 (ఐ, ఒ, ఓ, ఔ, అం, అః)
            return [
                LessonActivity(
                    id: "activity_\(lessonId)_teaching",
                    type: .reading,
                    title: "Complete Your Vowel Knowledge! 🎯",
                    instructions: "Learn compound vowels and special nasal sounds",
                    xpValue: 30,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_teaching_vowels",
                            type: .characterRecognition,
                            question: "teaching_moment",
                            correctAnswer: "ఐ",
                            options: nil,
                            audioFile: "vowel_set3_intro.mp3",
                            strokeOrder: [
                                "These are the final Telugu vowels! 🌟",
                                "ఐ sounds like 'ai' in 'aisle' (compound vowel)",
                                "ఒ sounds like 'o' in 'hot' (short o)",
                                "ఓ sounds like 'o' in 'go' (long o)",
                                "ఔ sounds like 'au' in 'caught' (compound vowel)",
                                "అం has a nasal 'm' sound (anusvara)",
                                "అః has a soft 'h' sound (visarga)",
                                "These complete the Telugu vowel system!"
                            ],
                            explanation: "Nasal sounds (అం, అః) are very important in Telugu pronunciation"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_compound_vowels",
                    type: .reading,
                    title: "Compound Vowel Challenge 🎵",
                    instructions: "Master the compound vowel sounds",
                    xpValue: 40,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_ai",
                            type: .audioIdentification,
                            question: "Which compound vowel makes this sound?",
                            correctAnswer: "ఐ",
                            options: ["ఐ", "ఔ", "ఒ", "ఓ"],
                            audioFile: "ఐ.mp3",
                            strokeOrder: nil,
                            explanation: "Perfect! ఐ makes the 'ai' compound sound. [Sparkle animation] ✨"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_au",
                            type: .audioIdentification,
                            question: "Which compound vowel makes this sound?",
                            correctAnswer: "ఔ",
                            options: ["ఐ", "ఔ", "ఒ", "ఓ"],
                            audioFile: "ఔ.mp3",
                            strokeOrder: nil,
                            explanation: "Excellent! ఔ makes the 'au' compound sound. [Star burst] 🌟"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_o_short",
                            type: .audioIdentification,
                            question: "Which vowel makes this short 'o' sound?",
                            correctAnswer: "ఒ",
                            options: ["ఐ", "ఔ", "ఒ", "ఓ"],
                            audioFile: "ఒ.mp3",
                            strokeOrder: nil,
                            explanation: "Great! ఒ makes the short 'o' sound. [Glow effect] 💫"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_o_long",
                            type: .audioIdentification,
                            question: "Which vowel makes this long 'o' sound?",
                            correctAnswer: "ఓ",
                            options: ["ఐ", "ఔ", "ఒ", "ఓ"],
                            audioFile: "ఓ.mp3",
                            strokeOrder: nil,
                            explanation: "Amazing! ఓ makes the long 'o' sound. [Confetti] 🎉"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_nasal_sounds",
                    type: .reading,
                    title: "Special Nasal Sounds Focus 👂",
                    instructions: "Learn the important nasal sounds అం and అః",
                    xpValue: 40,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_nasal_teaching",
                            type: .characterRecognition,
                            question: "teaching_moment",
                            correctAnswer: "అం",
                            options: nil,
                            audioFile: "nasal_intro.mp3",
                            strokeOrder: [
                                "Nasal sounds are special in Telugu! 🎵",
                                "అం (anusvara) - close your lips for 'm' sound",
                                "అః (visarga) - gentle breath sound 'ah'",
                                "These appear in many Telugu words",
                                "Listen carefully to the difference!"
                            ],
                            explanation: "Nasal sounds help with proper Telugu pronunciation"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_anusvara",
                            type: .audioIdentification,
                            question: "Which nasal sound is this? (Listen for the 'm' sound)",
                            correctAnswer: "అం",
                            options: ["అం", "అః", "అ", "ఆ"],
                            audioFile: "అం.mp3",
                            strokeOrder: ["Feel your lips close", "Like humming 'mmm'"],
                            explanation: "Perfect! అం is the nasal 'm' sound (anusvara). [Gentle vibration animation] 🎵"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_visarga",
                            type: .audioIdentification,
                            question: "Which nasal sound is this? (Listen for the soft 'h' sound)",
                            correctAnswer: "అః",
                            options: ["అం", "అః", "అ", "ఆ"],
                            audioFile: "అః.mp3",
                            strokeOrder: ["Feel the gentle breath", "Like a soft sigh"],
                            explanation: "Excellent! అః is the soft 'h' sound (visarga). [Breath animation] 💨"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_tracing",
                    type: .writing,
                    title: "Advanced Vowel Tracing ✏️",
                    instructions: "Practice writing compound and nasal vowels",
                    xpValue: 30,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_ai",
                            type: .tracing,
                            question: "Trace the compound vowel ఐ",
                            correctAnswer: "ఐ",
                            options: nil,
                            audioFile: "ఐ.mp3",
                            strokeOrder: [
                                "Start with the left curve",
                                "Add the vertical line",
                                "Draw the horizontal connector",
                                "Complete with the right elements"
                            ],
                            explanation: "Beautiful work on the compound vowel ఐ! [Gentle glow] ✨"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_anusvara",
                            type: .tracing,
                            question: "Trace the nasal vowel అం",
                            correctAnswer: "అం",
                            options: nil,
                            audioFile: "అం.mp3",
                            strokeOrder: [
                                "Write అ first",
                                "Add the small circle (bindu) above",
                                "This circle makes the 'm' sound"
                            ],
                            explanation: "Perfect! You've mastered the nasal sound అం! [Success sparkles] 🌟"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_vowel_master",
                    type: .reading,
                    title: "Vowel Master Challenge! 🏆",
                    instructions: "Test your knowledge of all Telugu vowels",
                    xpValue: 60,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_master_mix",
                            type: .characterRecognition,
                            question: "Identify all the vowels you hear",
                            correctAnswer: "అ, ఆ, ఇ, ఈ, ఉ, ఊ, ఋ, ఎ, ఏ, ఐ, ఒ, ఓ, ఔ, అం, అః",
                            options: ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఋ", "ఎ", "ఏ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః"],
                            audioFile: "vowel_master_mix.mp3",
                            strokeOrder: ["Listen to each sound", "Tap all the vowels you recognize", "You've learned them all!"],
                            explanation: "Incredible! You're a Telugu vowel master! [Grand celebration with all vowels dancing] 🎉🌈✨"
                        )
                    ],
                    canSkip: false
                )
            ]
            
        case 4:
            // Lesson 4: Consonants Set 1 (క, ఖ, గ, ఘ, ఙ) - Ka Group
            return [
                LessonActivity(
                    id: "activity_\(lessonId)_teaching",
                    type: .reading,
                    title: "Meet the Ka Group! 🎯",
                    instructions: "Learn the first consonant family: క, ఖ, గ, ఘ, ఙ",
                    xpValue: 30,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_teaching_ka_group",
                            type: .characterRecognition,
                            question: "teaching_moment",
                            correctAnswer: "క",
                            options: nil,
                            audioFile: "ka_group_intro.mp3",
                            strokeOrder: [
                                "Welcome to Telugu consonants! 🌟",
                                "This is the Ka group - velar consonants",
                                "క makes 'ka' sound (like 'car')",
                                "ఖ makes 'kha' sound (aspirated 'ka')",
                                "గ makes 'ga' sound (like 'go')",
                                "ఘ makes 'gha' sound (aspirated 'ga')",
                                "ఙ makes 'nga' sound (nasal)",
                                "They're all related sounds!"
                            ],
                            explanation: "Consonant groups help you learn systematic pronunciation"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_audio_recognition",
                    type: .reading,
                    title: "Sound Recognition Challenge 🎵",
                    instructions: "Listen and identify each Ka group consonant",
                    xpValue: 40,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_ka",
                            type: .audioIdentification,
                            question: "Which consonant makes this sound?",
                            correctAnswer: "క",
                            options: ["క", "ఖ", "గ", "ఘ"],
                            audioFile: "క.mp3",
                            strokeOrder: nil,
                            explanation: "Perfect! క makes the 'ka' sound. [Sparkle animation] ✨"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_kha",
                            type: .audioIdentification,
                            question: "Which consonant makes this sound?",
                            correctAnswer: "ఖ",
                            options: ["క", "ఖ", "గ", "ఘ"],
                            audioFile: "ఖ.mp3",
                            strokeOrder: nil,
                            explanation: "Excellent! ఖ makes the 'kha' sound with extra breath. [Star burst] 🌟"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_ga",
                            type: .audioIdentification,
                            question: "Which consonant makes this sound?",
                            correctAnswer: "గ",
                            options: ["క", "ఖ", "గ", "ఘ"],
                            audioFile: "గ.mp3",
                            strokeOrder: nil,
                            explanation: "Great! గ makes the 'ga' sound. [Glow effect] 💫"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_gha",
                            type: .audioIdentification,
                            question: "Which consonant makes this sound?",
                            correctAnswer: "ఘ",
                            options: ["క", "ఖ", "గ", "ఘ"],
                            audioFile: "ఘ.mp3",
                            strokeOrder: nil,
                            explanation: "Amazing! ఘ makes the 'gha' sound with breath. [Confetti] 🎉"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_tap_identify",
                    type: .reading,
                    title: "Tap-to-Identify Game 👆",
                    instructions: "Find the correct consonant in the grid",
                    xpValue: 30,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_tap_ka",
                            type: .characterRecognition,
                            question: "Tap క in the grid",
                            correctAnswer: "క",
                            options: ["క", "ఖ", "గ", "ఘ", "ఙ", "చ", "జ", "త"],
                            audioFile: "క.mp3",
                            strokeOrder: ["Listen to the sound", "Find it in the grid", "Tap to select!"],
                            explanation: "Excellent spotting! You found క! [Highlight glow] ✨"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_tap_ga",
                            type: .characterRecognition,
                            question: "Tap గ in the grid",
                            correctAnswer: "గ",
                            options: ["క", "ఖ", "గ", "ఘ", "ఙ", "చ", "జ", "త"],
                            audioFile: "గ.mp3",
                            strokeOrder: ["Listen carefully", "Spot the consonant", "Tap it!"],
                            explanation: "Great eye! You identified గ perfectly! [Success flash] 🌟"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_tracing",
                    type: .writing,
                    title: "Consonant Tracing Practice ✏️",
                    instructions: "Practice writing Ka group consonants",
                    xpValue: 40,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_ka",
                            type: .tracing,
                            question: "Trace the consonant క",
                            correctAnswer: "క",
                            options: nil,
                            audioFile: "క.mp3",
                            strokeOrder: [
                                "Start with the left vertical line",
                                "Add the top horizontal curve",
                                "Draw the middle connecting line",
                                "Finish with the bottom curve"
                            ],
                            explanation: "Beautiful tracing of క! [Gentle glow] ✨"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_ga",
                            type: .tracing,
                            question: "Trace the consonant గ",
                            correctAnswer: "గ",
                            options: nil,
                            audioFile: "గ.mp3",
                            strokeOrder: [
                                "Begin with the curved top",
                                "Draw the vertical line down",
                                "Add the horizontal base",
                                "Complete with connecting curves"
                            ],
                            explanation: "Excellent work on గ! [Success sparkles] 🌟"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_family_game",
                    type: .reading,
                    title: "Consonant Family Game! 👨‍👩‍👧‍👦",
                    instructions: "Group consonants by their sound families",
                    xpValue: 50,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_family_sort",
                            type: .characterRecognition,
                            question: "Sort these consonants into the Ka family",
                            correctAnswer: "ka_family",
                            options: ["క", "ఖ", "గ", "ఘ", "ఙ", "చ", "జ", "త", "ప"],
                            audioFile: "family_game.mp3",
                            strokeOrder: ["Listen to each sound", "Drag Ka family members together", "Leave others outside!"],
                            explanation: "Perfect family reunion! You understand consonant groups! [Family celebration] 👨‍👩‍👧‍👦✨"
                        )
                    ],
                    canSkip: false
                )
            ]
            
        case 5:
            // Lesson 5: Consonants Set 2 (చ, ఛ, జ, ఝ, ఞ) - Cha Group
            return [
                LessonActivity(
                    id: "activity_\(lessonId)_teaching",
                    type: .reading,
                    title: "Meet the Cha Group! 🎭",
                    instructions: "Learn the palatal consonants: చ, ఛ, జ, ఝ, ఞ",
                    xpValue: 30,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_teaching_cha_group",
                            type: .characterRecognition,
                            question: "teaching_moment",
                            correctAnswer: "చ",
                            options: nil,
                            audioFile: "cha_group_intro.mp3",
                            strokeOrder: [
                                "Welcome to the Cha group! 🎭",
                                "These are palatal consonants (tongue touches roof of mouth)",
                                "చ makes 'cha' sound (like 'chair')",
                                "ఛ makes 'chha' sound (aspirated 'cha')",
                                "జ makes 'ja' sound (like 'jar')",
                                "ఝ makes 'jha' sound (aspirated 'ja')",
                                "ఞ makes 'nya' sound (nasal)",
                                "They're all made with your tongue in the same position!"
                            ],
                            explanation: "Palatal consonants are made by touching your tongue to the roof of your mouth"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_audio_recognition",
                    type: .reading,
                    title: "Cha Group Sound Challenge 🎵",
                    instructions: "Listen and identify each palatal consonant",
                    xpValue: 40,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_cha",
                            type: .audioIdentification,
                            question: "Which consonant makes this sound?",
                            correctAnswer: "చ",
                            options: ["చ", "ఛ", "జ", "ఝ"],
                            audioFile: "చ.mp3",
                            strokeOrder: nil,
                            explanation: "Perfect! చ makes the 'cha' sound. [Sparkle animation] ✨"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_chha",
                            type: .audioIdentification,
                            question: "Which consonant makes this sound?",
                            correctAnswer: "ఛ",
                            options: ["చ", "ఛ", "జ", "ఝ"],
                            audioFile: "ఛ.mp3",
                            strokeOrder: nil,
                            explanation: "Excellent! ఛ makes the 'chha' sound with extra breath. [Star burst] 🌟"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_ja",
                            type: .audioIdentification,
                            question: "Which consonant makes this sound?",
                            correctAnswer: "జ",
                            options: ["చ", "ఛ", "జ", "ఝ"],
                            audioFile: "జ.mp3",
                            strokeOrder: nil,
                            explanation: "Great! జ makes the 'ja' sound. [Glow effect] 💫"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_audio_jha",
                            type: .audioIdentification,
                            question: "Which consonant makes this sound?",
                            correctAnswer: "ఝ",
                            options: ["చ", "ఛ", "జ", "ఝ"],
                            audioFile: "ఝ.mp3",
                            strokeOrder: nil,
                            explanation: "Amazing! ఝ makes the 'jha' sound with breath. [Confetti] 🎉"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_tap_identify",
                    type: .reading,
                    title: "Palatal Hunt Game 👆",
                    instructions: "Find the Cha group consonants in the grid",
                    xpValue: 30,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_tap_cha",
                            type: .characterRecognition,
                            question: "Tap చ in the grid",
                            correctAnswer: "చ",
                            options: ["చ", "ఛ", "జ", "ఝ", "ఞ", "క", "గ", "త"],
                            audioFile: "చ.mp3",
                            strokeOrder: ["Listen to the sound", "Find it in the grid", "Tap to select!"],
                            explanation: "Excellent spotting! You found చ! [Highlight glow] ✨"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_tap_ja",
                            type: .characterRecognition,
                            question: "Tap జ in the grid",
                            correctAnswer: "జ",
                            options: ["చ", "ఛ", "జ", "ఝ", "ఞ", "క", "గ", "త"],
                            audioFile: "జ.mp3",
                            strokeOrder: ["Listen carefully", "Spot the consonant", "Tap it!"],
                            explanation: "Great eye! You identified జ perfectly! [Success flash] 🌟"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_tracing",
                    type: .writing,
                    title: "Palatal Tracing Practice ✏️",
                    instructions: "Practice writing Cha group consonants",
                    xpValue: 40,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_cha",
                            type: .tracing,
                            question: "Trace the consonant చ",
                            correctAnswer: "చ",
                            options: nil,
                            audioFile: "చ.mp3",
                            strokeOrder: [
                                "Start with the curved top",
                                "Draw the vertical line down",
                                "Add the horizontal connector",
                                "Complete with the bottom curve"
                            ],
                            explanation: "Beautiful tracing of చ! [Gentle glow] ✨"
                        ),
                        ActivityQuestion(
                            id: "q_\(lessonId)_trace_ja",
                            type: .tracing,
                            question: "Trace the consonant జ",
                            correctAnswer: "జ",
                            options: nil,
                            audioFile: "జ.mp3",
                            strokeOrder: [
                                "Begin with the left curve",
                                "Add the central vertical line",
                                "Draw the horizontal base",
                                "Finish with connecting elements"
                            ],
                            explanation: "Excellent work on జ! [Success sparkles] 🌟"
                        )
                    ],
                    canSkip: false
                ),
                
                LessonActivity(
                    id: "activity_\(lessonId)_tongue_position",
                    type: .reading,
                    title: "Tongue Position Game! 👅",
                    instructions: "Learn how tongue position creates different consonant families",
                    xpValue: 50,
                    questions: [
                        ActivityQuestion(
                            id: "q_\(lessonId)_position_game",
                            type: .characterRecognition,
                            question: "Which consonants are made with tongue touching the roof of mouth?",
                            correctAnswer: "palatal_family",
                            options: ["చ", "ఛ", "జ", "ఝ", "ఞ", "క", "త", "ప"],
                            audioFile: "tongue_position.mp3",
                            strokeOrder: ["Feel your tongue position", "Select palatal consonants", "Cha group uses roof of mouth!"],
                            explanation: "Perfect understanding! You know how consonants are made! [Anatomy diagram animation] 🧠✨"
                        )
                    ],
                    canSkip: false
                )
            ]
            
        case 6:
            // Lesson 6: Consonants Set 3 (ట, ఠ, డ, ఢ, ణ) - Ta Group (Retroflex)
            return createRetroflexConsonantLesson(lessonId: lessonId)
            
        case 7:
            // Lesson 7: Consonants Set 4 (త, థ, ద, ధ, న) - Dental Group
            return createDentalConsonantLesson(lessonId: lessonId)
            
        case 8:
            // Lesson 8: Consonants Set 5 (ప, ఫ, బ, భ, మ) - Pa Group (Labial)
            return createLabialConsonantLesson(lessonId: lessonId)
            
        case 9:
            // Lesson 9: Consonants Set 6 (య, ర, ల, వ, శ, ష, స, హ, ళ, క్ష, ఱ) - Remaining Consonants
            return createFinalConsonantLesson(lessonId: lessonId)
            
        case 10:
            // Lesson 10: Review Game & Guninthalu Introduction
            return createReviewAndGuninthaluLesson(lessonId: lessonId)
            

            
        default:
            return []
        }
    }
    
    private func createBeginnerActivities(lessonId: String, lessonOrder: Int) -> [LessonActivity] {
        return generateBeginnerActivities(lessonId: lessonId, lessonOrder: lessonOrder)
    }
    
    private func createVowelLessonActivities(lessonId: String, vowel: String, romanization: String, explanation: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_learn",
                type: .reading,
                title: "Learn \(vowel)",
                instructions: "Learn to recognize and write the Telugu vowel \(vowel)",
                xpValue: 50,
                questions: [
                    // Teaching moment
                    ActivityQuestion(
                        id: "q_\(lessonId)_teach",
                        type: .characterRecognition,
                        question: "teaching_moment",
                        correctAnswer: vowel,
                        options: nil,
                        audioFile: "\(vowel).mp3",
                        strokeOrder: [
                            "This is the Telugu vowel \(vowel)",
                            "It sounds like '\(romanization)'",
                            "Listen carefully to the pronunciation"
                        ],
                        explanation: explanation
                    ),
                    
                    // Recognition question
                    ActivityQuestion(
                        id: "q_\(lessonId)_recognize",
                        type: .characterRecognition,
                        question: "Which letter makes the '\(romanization)' sound?",
                        correctAnswer: vowel,
                        options: [vowel, "అ", "ఆ", "ఇ"],
                        audioFile: "\(vowel).mp3",
                        strokeOrder: nil,
                        explanation: "Correct! \(vowel) makes the '\(romanization)' sound."
                    ),
                    
                    // Audio recognition
                    ActivityQuestion(
                        id: "q_\(lessonId)_audio",
                        type: .audioIdentification,
                        question: "Listen and select the correct vowel",
                        correctAnswer: vowel,
                        options: [vowel, "అ", "ఆ", "ఇ"],
                        audioFile: "\(vowel).mp3",
                        strokeOrder: nil,
                        explanation: "Great! You recognized the sound of \(vowel)."
                    )
                ],
                canSkip: false
            )
        ]
    }
    
    private func createVowelReviewActivities(lessonId: String, vowels: [String]) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_review",
                type: .reading,
                title: "Review Vowels",
                instructions: "Practice the vowels you've learned so far",
                xpValue: 75,
                questions: vowels.map { vowel in
                    ActivityQuestion(
                        id: "q_\(lessonId)_review_\(vowel)",
                        type: .characterRecognition,
                        question: "What sound does this make?",
                        correctAnswer: vowel,
                        options: Array(vowels.shuffled().prefix(4)),
                        audioFile: "\(vowel).mp3",
                        strokeOrder: nil,
                        explanation: "Excellent! This is \(vowel)."
                    )
                },
                canSkip: false
            )
        ]
    }
    
    private func createDoubleVowelActivities(lessonId: String, vowel1: String, vowel2: String, explanation: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_double",
                type: .reading,
                title: "Learn \(vowel1) and \(vowel2)",
                instructions: explanation,
                xpValue: 50,
                questions: [
                    ActivityQuestion(
                        id: "q_\(lessonId)_\(vowel1)",
                        type: .characterRecognition,
                        question: "Select the correct vowel",
                        correctAnswer: vowel1,
                        options: [vowel1, vowel2, "అ", "ఆ"],
                        audioFile: "\(vowel1).mp3",
                        strokeOrder: nil,
                        explanation: "This is \(vowel1)"
                    ),
                    ActivityQuestion(
                        id: "q_\(lessonId)_\(vowel2)",
                        type: .characterRecognition,
                        question: "Select the correct vowel",
                        correctAnswer: vowel2,
                        options: [vowel1, vowel2, "ఇ", "ఈ"],
                        audioFile: "\(vowel2).mp3",
                        strokeOrder: nil,
                        explanation: "This is \(vowel2)"
                    )
                ],
                canSkip: false
            )
        ]
    }
    
    private func createTripleVowelActivities(lessonId: String, vowels: [String], explanation: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_triple",
                type: .reading,
                title: "Learn Multiple Vowels",
                instructions: explanation,
                xpValue: 50,
                questions: vowels.map { vowel in
                    ActivityQuestion(
                        id: "q_\(lessonId)_\(vowel)",
                        type: .characterRecognition,
                        question: "What is this vowel?",
                        correctAnswer: vowel,
                        options: vowels + ["అ"],
                        audioFile: "\(vowel).mp3",
                        strokeOrder: nil,
                        explanation: "This is the vowel \(vowel)"
                    )
                },
                canSkip: false
            )
        ]
    }
    
    private func createCompleteVowelReview(lessonId: String) -> [LessonActivity] {
        let allVowels = ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఐ", "ఒ", "ఓ", "ఔ"]
        return [
            LessonActivity(
                id: "activity_\(lessonId)_master",
                type: .reading,
                title: "Master All Vowels",
                instructions: "Final test of all Telugu vowels",
                xpValue: 100,
                questions: allVowels.shuffled().prefix(8).map { vowel in
                    ActivityQuestion(
                        id: "q_\(lessonId)_master_\(vowel)",
                        type: .characterRecognition,
                        question: "Identify this vowel",
                        correctAnswer: vowel,
                        options: Array(allVowels.shuffled().prefix(4)),
                        audioFile: "\(vowel).mp3",
                        strokeOrder: nil,
                        explanation: "Perfect! You've mastered \(vowel)."
                    )
                },
                canSkip: false
            )
        ]
    }
    
    private func createBasicActivities(for lesson: Int) -> [LessonActivity] {
        let consonants = ["క", "గ", "చ", "జ", "ట", "డ", "త", "ద", "న", "ప", "బ", "మ"]
        let currentConsonant = consonants[min(lesson - 1, consonants.count - 1)]
        
        return [
            LessonActivity(
                id: "activity_2_\(lesson)_intro",
                type: .reading,
                title: "Learn \(currentConsonant)",
                instructions: "Learn to recognize and pronounce this Telugu consonant",
                xpValue: 75,
                questions: [
                    ActivityQuestion(
                        id: "q_2_\(lesson)_1",
                        type: .characterRecognition,
                        question: "What sound does this letter make?",
                        correctAnswer: currentConsonant,
                        options: [currentConsonant, "క", "గ", "చ"],
                        audioFile: "\(currentConsonant).mp3",
                        strokeOrder: ["Draw the main shape", "Add connecting lines", "Complete the consonant"],
                        explanation: "This is the consonant \(currentConsonant)"
                    )
                ],
                canSkip: false
            )
        ]
    }
    
    private func createIntermediateActivities(for lesson: Int) -> [LessonActivity] {
        let combinations = ["కా", "గా", "చా", "జా", "టా", "డా", "తా", "దా", "నా", "పా", "బా", "మా"]
        let currentCombination = combinations[min(lesson - 1, combinations.count - 1)]
        
        return [
            LessonActivity(
                id: "activity_3_\(lesson)_combo",
                type: .reading,
                title: "Learn \(currentCombination)",
                instructions: "Learn consonant-vowel combinations (guninthalu)",
                xpValue: 100,
                questions: [
                    ActivityQuestion(
                        id: "q_3_\(lesson)_1",
                        type: .characterRecognition,
                        question: "What does this combination sound like?",
                        correctAnswer: currentCombination,
                        options: [currentCombination, "కా", "గా", "చా"],
                        audioFile: "\(currentCombination).mp3",
                        strokeOrder: ["Start with the consonant", "Add the vowel sign", "Complete the combination"],
                        explanation: "This is \(currentCombination) - a consonant-vowel combination"
                    )
                ],
                canSkip: false
            )
        ]
    }
    
    // Additional helper functions for the new beginner structure
    private func createConsonantLessonActivities(lessonId: String, consonant: String, romanization: String, explanation: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_learn",
                type: .reading,
                title: "Learn \(consonant)",
                instructions: "Learn to recognize and write the Telugu consonant \(consonant)",
                xpValue: 50,
                questions: [
                    ActivityQuestion(
                        id: "q_\(lessonId)_teach",
                        type: .characterRecognition,
                        question: "teaching_moment",
                        correctAnswer: consonant,
                        options: nil,
                        audioFile: "\(consonant).mp3",
                        strokeOrder: [
                            "This is the Telugu consonant \(consonant)",
                            "It sounds like '\(romanization)'",
                            explanation
                        ],
                        explanation: explanation
                    )
                ],
                canSkip: false
            )
        ]
    }
    
    private func createCombinationActivities(lessonId: String, consonant: String, combinations: [String], explanation: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_combinations",
                type: .reading,
                title: "Letter Combinations",
                instructions: "Learn how to combine \(consonant) with vowel signs",
                xpValue: 50,
                questions: combinations.map { combo in
                    ActivityQuestion(
                        id: "q_\(lessonId)_\(combo)",
                        type: .characterRecognition,
                        question: "What does this say?",
                        correctAnswer: combo,
                        options: nil,
                        audioFile: "\(combo).mp3",
                        strokeOrder: nil,
                        explanation: "This combination makes the sound '\(combo)'"
                    )
                },
                canSkip: false
            )
        ]
    }
    
    private func createWordLessonActivities(lessonId: String, words: [String], meanings: [String], explanation: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_words",
                type: .reading,
                title: "First Words",
                instructions: "Learn your first Telugu words",
                xpValue: 75,
                questions: zip(words, meanings).map { word, meaning in
                    ActivityQuestion(
                        id: "q_\(lessonId)_\(word)",
                        type: .wordTranslation,
                        question: "What does \(word) mean?",
                        correctAnswer: meaning,
                        options: nil,
                        audioFile: "\(word).mp3",
                        strokeOrder: nil,
                        explanation: "\(word) means '\(meaning)' in English"
                    )
                },
                canSkip: false
            )
        ]
    }
    
    private func createDoubleConsonantActivities(lessonId: String, consonant1: String, consonant2: String, explanation: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_consonants",
                type: .reading,
                title: "Two New Letters",
                instructions: "Learn two new Telugu consonants",
                xpValue: 50,
                questions: [consonant1, consonant2].map { consonant in
                    ActivityQuestion(
                        id: "q_\(lessonId)_\(consonant)",
                        type: .characterRecognition,
                        question: "What letter is this?",
                        correctAnswer: consonant,
                        options: nil,
                        audioFile: "\(consonant).mp3",
                        strokeOrder: nil,
                        explanation: "This is the Telugu letter \(consonant)"
                    )
                },
                canSkip: false
            )
        ]
    }
    
    private func createMixedReviewActivities(lessonId: String, vowels: [String], consonants: [String]) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_review",
                type: .reading,
                title: "Review All Letters",
                instructions: "Practice all the vowels and consonants you've learned",
                xpValue: 75,
                questions: (vowels + consonants).map { letter in
                    ActivityQuestion(
                        id: "q_\(lessonId)_\(letter)",
                        type: .characterRecognition,
                        question: "What letter is this?",
                        correctAnswer: letter,
                        options: nil,
                        audioFile: "\(letter).mp3",
                        strokeOrder: nil,
                        explanation: "This is the Telugu letter \(letter)"
                    )
                },
                canSkip: false
            )
        ]
    }
    
    private func createReadingPracticeActivities(lessonId: String, words: [String]) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_reading",
                type: .reading,
                title: "Reading Practice",
                instructions: "Practice reading the words you've learned",
                xpValue: 75,
                questions: words.map { word in
                    ActivityQuestion(
                        id: "q_\(lessonId)_read_\(word)",
                        type: .wordTranslation,
                        question: "Read this word aloud",
                        correctAnswer: word,
                        options: nil,
                        audioFile: "\(word).mp3",
                        strokeOrder: nil,
                        explanation: "Practice reading \(word)"
                    )
                },
                canSkip: false
            )
        ]
    }
    
    private func createBeginnerMasterReview(lessonId: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_master",
                type: .reading,
                title: "Master Review",
                instructions: "Show mastery of all beginner concepts",
                xpValue: 100,
                questions: [
                    ActivityQuestion(
                        id: "q_\(lessonId)_mastery",
                        type: .characterRecognition,
                        question: "Congratulations! You've completed Beginner Level!",
                        correctAnswer: "అమ్మ",
                        options: nil,
                        audioFile: "అమ్మ.mp3",
                        strokeOrder: nil,
                        explanation: "You now know basic Telugu vowels, consonants, and family words!"
                    )
                ],
                canSkip: false
            )
        ]
    }
    
    // MARK: - Helper Functions for New Lesson Structure
    
    private func createRetroflexConsonantLesson(lessonId: String) -> [LessonActivity] {
        return createConsonantGroupLessonActivities(
            lessonId: lessonId,
            consonants: ["ట", "ఠ", "డ", "ఢ", "ణ"],
            groupName: "Ta Group (Retroflex)",
            groupDescription: "retroflex consonants made with tongue curled back",
            audioFile: "ta_retroflex_group_intro.mp3"
        )
    }
    
    private func createDentalConsonantLesson(lessonId: String) -> [LessonActivity] {
        return createConsonantGroupLessonActivities(
            lessonId: lessonId,
            consonants: ["త", "థ", "ద", "ధ", "న"],
            groupName: "Dental Group",
            groupDescription: "dental consonants made with tongue touching teeth",
            audioFile: "dental_group_intro.mp3"
        )
    }
    
    private func createLabialConsonantLesson(lessonId: String) -> [LessonActivity] {
        return createConsonantGroupLessonActivities(
            lessonId: lessonId,
            consonants: ["ప", "ఫ", "బ", "భ", "మ"],
            groupName: "Pa Group (Labial)",
            groupDescription: "labial consonants made with lips",
            audioFile: "pa_group_intro.mp3"
        )
    }
    
    private func createFinalConsonantLesson(lessonId: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_final_consonants",
                type: .reading,
                title: "Complete Your Consonant Journey! 🏁",
                instructions: "Learn the remaining important Telugu consonants",
                xpValue: 50,
                questions: [
                    ActivityQuestion(
                        id: "q_\(lessonId)_teaching_final",
                        type: .characterRecognition,
                        question: "teaching_moment",
                        correctAnswer: "య",
                        options: nil,
                        audioFile: "final_consonants_intro.mp3",
                        strokeOrder: [
                            "These are the final consonants! 🌟",
                            "య (ya), ర (ra), ల (la), వ (va) - semi-vowels",
                            "శ (sha), ష (sha), స (sa) - sibilants",
                            "హ (ha) - aspirate",
                            "ళ (la) - retroflex lateral",
                            "క్ష (ksha) - conjunct consonant",
                            "ఱ (rra) - special 'r' sound",
                            "Now you know all Telugu consonants!"
                        ],
                        explanation: "These consonants complete the Telugu alphabet system"
                    )
                ],
                canSkip: false
            )
        ]
    }
    
    private func createReviewAndGuninthaluLesson(lessonId: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_grand_review",
                type: .reading,
                title: "Telugu Alphabet Master! 🏆",
                instructions: "Review all vowels and consonants with fun games",
                xpValue: 50,
                questions: [
                    ActivityQuestion(
                        id: "q_\(lessonId)_master_review",
                        type: .characterRecognition,
                        question: "You've learned all Telugu letters! Show your mastery!",
                        correctAnswer: "master",
                        options: ["అ", "క", "చ", "ట", "త", "ప", "య", "ర", "ల", "వ", "స", "హ"],
                        audioFile: "alphabet_mastery.mp3",
                        strokeOrder: ["Identify each letter", "Remember their sounds", "You're ready for words!"],
                        explanation: "Incredible! You've mastered the Telugu alphabet! 🎉"
                    )
                ],
                canSkip: false
            ),
            LessonActivity(
                id: "activity_\(lessonId)_guninthalu_intro",
                type: .reading,
                title: "Introduction to గుణింతాలు (Vowel Signs) ✨",
                instructions: "Learn how vowels attach to consonants",
                xpValue: 50,
                questions: [
                    ActivityQuestion(
                        id: "q_\(lessonId)_guninthalu_teaching",
                        type: .characterRecognition,
                        question: "teaching_moment",
                        correctAnswer: "కా",
                        options: nil,
                        audioFile: "guninthalu_intro.mp3",
                        strokeOrder: [
                            "Now you'll learn గుణింతాలు! ✨",
                            "These are vowel signs that attach to consonants",
                            "క + ా = కా (ka + aa = kaa)",
                            "క + ి = కి (ka + i = ki)",
                            "This is how Telugu words are formed!",
                            "You're ready for the Basic level!"
                        ],
                        explanation: "గుణింతాలు (guninthalu) are the key to reading Telugu words!"
                    )
                ],
                canSkip: false
            )
        ]
    }
    
    private func createConsonantGroupLessonActivities(lessonId: String, consonants: [String], groupName: String, groupDescription: String, audioFile: String) -> [LessonActivity] {
        return [
            LessonActivity(
                id: "activity_\(lessonId)_teaching",
                type: .reading,
                title: "Meet the \(groupName)! 🎯",
                instructions: "Learn \(groupDescription): \(consonants.joined(separator: ", "))",
                xpValue: 40,
                questions: [
                    ActivityQuestion(
                        id: "q_\(lessonId)_teaching_group",
                        type: .characterRecognition,
                        question: "teaching_moment",
                        correctAnswer: consonants[0],
                        options: nil,
                        audioFile: audioFile,
                        strokeOrder: [
                            "Welcome to the \(groupName)! 🌟",
                            "These are \(groupDescription)",
                            "Listen to each sound and notice the pattern"
                        ] + consonants.map { "\($0) makes its unique sound" },
                        explanation: "\(groupName) consonants share similar pronunciation methods"
                    )
                ],
                canSkip: false
            ),
            LessonActivity(
                id: "activity_\(lessonId)_audio_practice",
                type: .reading,
                title: "\(groupName) Sound Challenge 🎵",
                instructions: "Listen and identify each consonant",
                xpValue: 50,
                questions: consonants.prefix(4).map { consonant in
                    ActivityQuestion(
                        id: "q_\(lessonId)_audio_\(consonant)",
                        type: .audioIdentification,
                        question: "Which consonant makes this sound?",
                        correctAnswer: consonant,
                        options: Array(consonants.prefix(4)),
                        audioFile: "\(consonant).mp3",
                        strokeOrder: nil,
                        explanation: "Perfect! \(consonant) makes this sound. [Celebration] ✨"
                    )
                },
                canSkip: false
            )
        ]
    }

    func findLesson(byId lessonId: String) -> Lesson? {
        for level in levels {
            if let lesson = level.lessons.first(where: { $0.id == lessonId }) {
                return lesson
            }
        }
        return nil
    }

    private func loadLevels() -> [LearningLevel] {
        guard let url = Bundle.main.url(forResource: "lessons", withExtension: "json") else {
            print("Warning: Failed to locate lessons.json in bundle. Using empty levels.")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let lessonData = try decoder.decode(LessonData.self, from: data)
            return lessonData.levels
        } catch {
            print("Warning: Failed to load lessons from bundle: \(error). Using empty levels.")
            return []
        }
    }
}
