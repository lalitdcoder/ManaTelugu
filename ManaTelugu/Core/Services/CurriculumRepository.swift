import Foundation

@MainActor
final class CurriculumRepository: ObservableObject {
    @Published var stages: [CurriculumStage] = []
    @Published var modules: [CurriculumModule] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    init() {
        loadOfflineCurriculum()
    }

    // MARK: - Load 100% Offline Curriculum
    func fetchCurriculum() async {
        loadOfflineCurriculum()
    }

    func loadOfflineCurriculum() {
        self.isLoading = false
        self.errorMessage = nil
        self.stages = Self.offlineStages
        self.modules = Self.offlineModules
    }

    // MARK: - Query Helpers
    func modules(forStage stageId: String) -> [CurriculumModule] {
        modules.filter { $0.stageId == stageId }
    }

    func modules(forLevel level: Int) -> [CurriculumModule] {
        modules.filter { $0.level == level }
    }

    func module(byNumber number: Int) -> CurriculumModule? {
        modules.first { $0.moduleNumber == number }
    }

    // MARK: - Offline Static Data
    static let offlineStages: [CurriculumStage] = [
        CurriculumStage(
            id: "stage_1",
            stageNumber: 1,
            title: "Alphabet & Phonetics",
            description: "Master vowels, basic consonants, and their native pronunciation",
            orderIndex: 1
        ),
        CurriculumStage(
            id: "stage_2",
            stageNumber: 2,
            title: "Guninthalu & Syllables",
            description: "Learn vowel diacritics, compound letters, and syllable blending",
            orderIndex: 2
        ),
        CurriculumStage(
            id: "stage_3",
            stageNumber: 3,
            title: "Essential Vocabulary",
            description: "Build a strong vocabulary in numbers, family, food, animals, and objects",
            orderIndex: 3
        ),
        CurriculumStage(
            id: "stage_4",
            stageNumber: 4,
            title: "Conversations & Sentences",
            description: "Speak fluently in everyday situations, asking questions, and understanding stories",
            orderIndex: 4
        )
    ]

    static let offlineModules: [CurriculumModule] = [
        // Level 1: Alphabet & Phonetics (Modules 1-12)
        CurriculumModule(
            id: "module_1", stageId: "stage_1", moduleNumber: 1,
            title: "Vowels 1: అ, ఆ", teluguTitle: "అచ్చులు: అ, ఆ",
            description: "Learn the foundational Telugu vowel sounds with pronunciation.",
            objective: "Recognize and pronounce అ and ఆ correctly.",
            learningOutcome: "Identify short and long 'a' sounds in Telugu script.",
            difficulty: 1, estimatedMinutes: 6, orderIndex: 1, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_2", stageId: "stage_1", moduleNumber: 2,
            title: "Vowels 2: ఇ, ఈ", teluguTitle: "అచ్చులు: ఇ, ఈ",
            description: "Master the 'i' and 'ee' vowel sounds with examples.",
            objective: "Distinguish between short 'i' and long 'ee'.",
            learningOutcome: "Read and trace ఇ and ఈ confidently.",
            difficulty: 1, estimatedMinutes: 6, orderIndex: 2, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_3", stageId: "stage_1", moduleNumber: 3,
            title: "Vowels 3: ఉ, ఊ, ఋ", teluguTitle: "అచ్చులు: ఉ, ఊ, ఋ",
            description: "Learn 'u', 'oo', and the retroflex vocalic 'ru'.",
            objective: "Recognize and write ఉ, ఊ, and ఋ.",
            learningOutcome: "Pronounce rounded vowels with proper mouth shape.",
            difficulty: 1, estimatedMinutes: 7, orderIndex: 3, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_4", stageId: "stage_1", moduleNumber: 4,
            title: "Vowels 4: ఎ, ఏ, ఐ", teluguTitle: "అచ్చులు: ఎ, ఏ, ఐ",
            description: "Explore the front vowels 'e', 'ae', and diphthong 'ai'.",
            objective: "Identify and pronounce ఎ, ఏ, and ఐ.",
            learningOutcome: "Distinguish short 'e' vs elongated 'ae' and diphthong 'ai'.",
            difficulty: 1, estimatedMinutes: 7, orderIndex: 4, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_5", stageId: "stage_1", moduleNumber: 5,
            title: "Vowels 5: ఒ, ఓ, ఔ", teluguTitle: "అచ్చులు: ఒ, ఓ, ఔ",
            description: "Learn back round vowels 'o', 'oh', and diphthong 'au'.",
            objective: "Master writing and reading ఒ, ఓ, and ఔ.",
            learningOutcome: "Complete the primary vowel family.",
            difficulty: 1, estimatedMinutes: 7, orderIndex: 5, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_6", stageId: "stage_1", moduleNumber: 6,
            title: "Vowels 6: అం, అః & Review", teluguTitle: "అనుస్వార, విసర్గ",
            description: "Anusvara (అం), Visarga (అః) and complete vowels review quiz.",
            objective: "Master nasal and aspirated vowel modifiers.",
            learningOutcome: "Fluency across all 16 traditional Telugu vowels.",
            difficulty: 1, estimatedMinutes: 8, orderIndex: 6, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_7", stageId: "stage_1", moduleNumber: 7,
            title: "Consonants 1: క, ఖ, గ, ఘ, ఙ", teluguTitle: "క-వర్గం హల్లులు",
            description: "Velar consonants: ka, aspirated kha, ga, aspirated gha, and nya.",
            objective: "Learn the first consonant row of Telugu.",
            learningOutcome: "Pronounce unaspirated vs aspirated velar stops.",
            difficulty: 1, estimatedMinutes: 8, orderIndex: 7, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_8", stageId: "stage_1", moduleNumber: 8,
            title: "Consonants 2: చ, ఛ, జ, ఝ, ఞ", teluguTitle: "చ-వర్గం హల్లులు",
            description: "Palatal consonants: cha, chha, ja, jha, and nya.",
            objective: "Learn palatal consonant sounds and script shapes.",
            learningOutcome: "Accurate recognition of the cha group.",
            difficulty: 1, estimatedMinutes: 8, orderIndex: 8, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_9", stageId: "stage_1", moduleNumber: 9,
            title: "Consonants 3: ట, ఠ, డ, ఢ, ణ", teluguTitle: "ట-వర్గం హల్లులు",
            description: "Retroflex consonants: curled tongue sounds ta, tha, da, dha, na.",
            objective: "Master authentic retroflex tongue placement.",
            learningOutcome: "Distinguish retroflex from dental consonants.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 9, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_10", stageId: "stage_1", moduleNumber: 10,
            title: "Consonants 4: త, థ, ద, ధ, న", teluguTitle: "త-వర్గం హల్లులు",
            description: "Dental consonants: soft tongue-to-teeth sounds ta, tha, da, dha, na.",
            objective: "Produce crisp dental consonant sounds.",
            learningOutcome: "Comfortable distinction between ట and త rows.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 10, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_11", stageId: "stage_1", moduleNumber: 11,
            title: "Consonants 5: ప, ఫ, బ, భ, మ", teluguTitle: "ప-వర్గం హల్లులు",
            description: "Labial consonants: lip-articulated pa, pha, ba, bha, ma.",
            objective: "Learn the versatile pa-group consonants.",
            learningOutcome: "Read and write common words with labial letters.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 11, level: 1, isPublished: true
        ),
        CurriculumModule(
            id: "module_12", stageId: "stage_1", moduleNumber: 12,
            title: "Consonants 6: య to ఱ & Alphabet Mastery", teluguTitle: "హల్లుల ముగింపు",
            description: "Semivowels, sibilants, and aspirates: ya, ra, la, va, sha, sa, ha, lla, ksha, rra.",
            objective: "Complete the full Telugu alphabet.",
            learningOutcome: "Full mastery of all Telugu consonants and vowels.",
            difficulty: 2, estimatedMinutes: 10, orderIndex: 12, level: 1, isPublished: true
        ),

        // Level 2: Guninthalu & Syllables (Modules 13-24)
        CurriculumModule(
            id: "module_13", stageId: "stage_2", moduleNumber: 13,
            title: "Intro to Guninthalu: Talakattu & Deergham", teluguTitle: "తలకట్టు & దీర్ఘం",
            description: "Understand how vowels combine with consonants (e.g. క, కా).",
            objective: "Learn the inherent vowel and the long 'aa' marker.",
            learningOutcome: "Transform basic consonants into long vowel syllables.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 13, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_14", stageId: "stage_2", moduleNumber: 14,
            title: "Gudi & Gudi Deergham: ి, ీ", teluguTitle: "గుడి & గుడిదీర్ఘం",
            description: "The 'i' and 'ee' markers attached to consonants (కి, కీ, గి, గీ).",
            objective: "Recognize and write top-loop vowel signs.",
            learningOutcome: "Read words featuring కి, చి, తి, పి.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 14, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_15", stageId: "stage_2", moduleNumber: 15,
            title: "Kommu & Kommu Deergham: ు, ూ", teluguTitle: "కొమ్ము & కొమ్ముదీర్ఘం",
            description: "Vowel markers for 'u' and 'oo' sounds (కు, కూ, గు, గూ).",
            objective: "Master the bottom curved markers.",
            learningOutcome: "Spell common words like పువ్వు, గుడి, ముల్లు.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 15, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_16", stageId: "stage_2", moduleNumber: 16,
            title: "Rutvamu & E-karam: ృ, ె, ే", teluguTitle: "రుత్వము & ఎ, ఏ-త్వాలు",
            description: "Vocalic r sign (కృ) and e/ae markers (కె, కే).",
            objective: "Learn diacritics for ృ, ె, and ే.",
            learningOutcome: "Read essential vocabulary like గెల, చెట్టు, పేరు.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 16, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_17", stageId: "stage_2", moduleNumber: 17,
            title: "Ai, O, Au Karalu: ై, ొ, ో, ౌ", teluguTitle: "ఐ, ఒ, ఓ, ఔ-త్వాలు",
            description: "Complete compound vowel signs (కై, కొ, కో, కౌ).",
            objective: "Recognize complex multi-part vowel diacritics.",
            learningOutcome: "Master the remaining vowel signs on any consonant.",
            difficulty: 2, estimatedMinutes: 9, orderIndex: 17, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_18", stageId: "stage_2", moduleNumber: 18,
            title: "Gunintham Practice: క & గ", teluguTitle: "క, గ గుణింతాల సాధన",
            description: "Full 16-step syllable tables for Ka and Ga.",
            objective: "Chant and write full guninthalu for velars.",
            learningOutcome: "Effortless speed reading of Ka and Ga syllables.",
            difficulty: 2, estimatedMinutes: 9, orderIndex: 18, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_19", stageId: "stage_2", moduleNumber: 19,
            title: "Gunintham Practice: చ & జ", teluguTitle: "చ, జ గుణింతాల సాధన",
            description: "Full syllable tables for palatal consonants Cha and Ja.",
            objective: "Practice distinctive palatal gunintham shapes.",
            learningOutcome: "High accuracy distinguishing చ and జ vowel combos.",
            difficulty: 2, estimatedMinutes: 9, orderIndex: 19, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_20", stageId: "stage_2", moduleNumber: 20,
            title: "Gunintham Practice: త & ద", teluguTitle: "త, ద గుణింతాల సాధన",
            description: "Full syllable tables for dentals Ta and Da.",
            objective: "Master dental consonant syllable tables.",
            learningOutcome: "Speed read words with తి, తే, తో, దు, దూ, దొ.",
            difficulty: 2, estimatedMinutes: 9, orderIndex: 20, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_21", stageId: "stage_2", moduleNumber: 21,
            title: "Gunintham Practice: ప & బ", teluguTitle: "ప, బ గుణింతాల సాధన",
            description: "Full syllable tables for labials Pa and Ba.",
            objective: "Write and read complete Pa and Ba gunintham rows.",
            learningOutcome: "Confidence in everyday vocabulary spelling.",
            difficulty: 2, estimatedMinutes: 9, orderIndex: 21, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_22", stageId: "stage_2", moduleNumber: 22,
            title: "Conjunct Consonants (వత్తులు) - Part 1", teluguTitle: "వత్తులు: క నుండి ణ",
            description: "Subscript consonant signs (వత్తులు) for doubled sounds.",
            objective: "Identify sub-letter forms for stops and nasals.",
            learningOutcome: "Read geminated words like అక్క, కుక్క, అత్త.",
            difficulty: 3, estimatedMinutes: 10, orderIndex: 22, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_23", stageId: "stage_2", moduleNumber: 23,
            title: "Conjunct Consonants (వత్తులు) - Part 2", teluguTitle: "వత్తులు: త నుండి ఱ",
            description: "Remaining subscript signs: య, ర, ల, వ and complex conjuncts.",
            objective: "Master r-vattu (ర-వత్తు) and y-vattu (య-వత్తు).",
            learningOutcome: "Read words like సూర్యుడు, పుస్తకం, పిల్లి, రాత్రి.",
            difficulty: 3, estimatedMinutes: 10, orderIndex: 23, level: 2, isPublished: true
        ),
        CurriculumModule(
            id: "module_24", stageId: "stage_2", moduleNumber: 24,
            title: "Stage 2 Mastery Review & Reading Test", teluguTitle: "గుణింతాల పరీక్ష",
            description: "Comprehensive reading challenge across all syllable combinations.",
            objective: "Demonstrate independent Telugu word reading ability.",
            learningOutcome: "Read full authentic Telugu words without romaji/transliteration.",
            difficulty: 3, estimatedMinutes: 10, orderIndex: 24, level: 2, isPublished: true
        ),

        // Level 3: Essential Vocabulary (Modules 25-36)
        CurriculumModule(
            id: "module_25", stageId: "stage_3", moduleNumber: 25,
            title: "Numbers 1 to 10", teluguTitle: "సంఖ్యలు: ఒకటి నుండి పది",
            description: "Count from 1 to 10 in Telugu with numerals and words.",
            objective: "Count objects and recognize Telugu number digits.",
            learningOutcome: "Use ఒకటి, రెండు, మూడు, నాలుగు, ఐదు... comfortably.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 25, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_26", stageId: "stage_3", moduleNumber: 26,
            title: "Numbers 11 to 20 & Tens", teluguTitle: "సంఖ్యలు: 11 నుండి 20 & పదులు",
            description: "Count 11-20 and learn major milestones: 20, 50, 100.",
            objective: "Count money and tell quantities up to 100.",
            learningOutcome: "Understand number compounding in Telugu.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 26, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_27", stageId: "stage_3", moduleNumber: 27,
            title: "Colors & Basic Shapes", teluguTitle: "రంగులు & ఆకారాలు",
            description: "Red (ఎరుపు), Green (ఆకుపచ్చ), Blue (నీలం), Yellow (పసుపు) and shapes.",
            objective: "Describe objects using vivid color adjectives.",
            learningOutcome: "Form descriptive noun phrases in Telugu.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 27, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_28", stageId: "stage_3", moduleNumber: 28,
            title: "Immediate Family Members", teluguTitle: "సమీప కుటుంబం",
            description: "Amma (అమ్మ), Nanna (నాన్న), Anna (అన్న), Chelli (చెల్లి), Thammudu (తమ్ముడు).",
            objective: "Name immediate family members with respect.",
            learningOutcome: "Discuss your family in conversational Telugu.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 28, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_29", stageId: "stage_3", moduleNumber: 29,
            title: "Extended Family & Relatives", teluguTitle: "చుట్టాలు & బంధువులు",
            description: "Thatha (తాత), Ammamma (అమ్మమ్మ), Babai (బాబాయ్), Pinni (పిన్ని).",
            objective: "Navigate the nuanced Indian family relationship terms.",
            learningOutcome: "Correctly address maternal and paternal relatives.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 29, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_30", stageId: "stage_3", moduleNumber: 30,
            title: "Common Animals & Pets", teluguTitle: "జంతువులు & పెంపుడు జంతువులు",
            description: "Dog (కుక్క), Cat (పిల్లి), Cow (ఆవు), Elephant (ఏనుగు), Lion (సింహం).",
            objective: "Identify popular domestic and wild animals.",
            learningOutcome: "Recognize animals in stories and daily talk.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 30, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_31", stageId: "stage_3", moduleNumber: 31,
            title: "Common Birds & Nature", teluguTitle: "పక్షులు & ప్రకృతి",
            description: "Bird (పిట్ట), Parrot (చిలుక), Peacock (నెమలి), Tree (చెట్టు), Sky (ఆకాశం).",
            objective: "Describe nature and outdoor scenes.",
            learningOutcome: "Use nature vocabulary in descriptive contexts.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 31, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_32", stageId: "stage_3", moduleNumber: 32,
            title: "Fruits & Vegetables", teluguTitle: "పండ్లు & కూరగాయలు",
            description: "Mango (మామిడి), Banana (అరటి), Tomato (టమాటా), Onion (ఉల్లిపాయ).",
            objective: "Identify produce for grocery shopping.",
            learningOutcome: "Ask for fruits and vegetables in markets.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 32, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_33", stageId: "stage_3", moduleNumber: 33,
            title: "Food, Drinks & Kitchen", teluguTitle: "ఆహారం & వంటగది",
            description: "Rice (అన్నం), Water (నీళ్లు), Milk (పాలు), Curry (కూర), Ghee (నెయ్యి).",
            objective: "Express hunger, thirst, and favorite Telugu dishes.",
            learningOutcome: "Order and discuss everyday meals in Telugu.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 33, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_34", stageId: "stage_3", moduleNumber: 34,
            title: "Parts of the Body", teluguTitle: "శరీర భాగాలు",
            description: "Head (తల), Eyes (కళ్ళు), Ears (చెవులు), Hand (చేయి), Leg (కాలు).",
            objective: "Name major anatomical features in Telugu.",
            learningOutcome: "Express physical feelings, aches, and health states.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 34, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_35", stageId: "stage_3", moduleNumber: 35,
            title: "Days of the Week & Calendar", teluguTitle: "వారాలు & సమయం",
            description: "Monday to Sunday (సోమవారం to ఆదివారం), Today, Tomorrow, Yesterday.",
            objective: "Schedule events and discuss weekly plans.",
            learningOutcome: "Say dates, days, and time intervals in Telugu.",
            difficulty: 2, estimatedMinutes: 8, orderIndex: 35, level: 3, isPublished: true
        ),
        CurriculumModule(
            id: "module_36", stageId: "stage_3", moduleNumber: 36,
            title: "Household Objects & Vocab Quiz", teluguTitle: "ఇంటి వస్తువులు & సమీక్ష",
            description: "Door (తలుపు), Book (పుస్తకం), Pen (కలం), Chair (కుర్చీ) and milestone quiz.",
            objective: "Name everyday items around the house.",
            learningOutcome: "Full mastery of 100+ high-frequency Telugu words.",
            difficulty: 2, estimatedMinutes: 9, orderIndex: 36, level: 3, isPublished: true
        ),

        // Level 4: Conversations & Sentences (Modules 37-48)
        CurriculumModule(
            id: "module_37", stageId: "stage_4", moduleNumber: 37,
            title: "Polite Greetings & Etiquette", teluguTitle: "నమస్కారం & మర్యాదలు",
            description: "Namaskaram, Dhanyavadalu, Dayachesi, and respectful pronouns (మీరు).",
            objective: "Greet elders and peers with proper Telugu cultural warmth.",
            learningOutcome: "Polite everyday social exchanges.",
            difficulty: 3, estimatedMinutes: 9, orderIndex: 37, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_38", stageId: "stage_4", moduleNumber: 38,
            title: "Introducing Yourself & Origin", teluguTitle: "స్వీయ పరిచయం",
            description: "Saying your name, where you live, and what you do.",
            objective: "Introduce yourself in complete Telugu sentences.",
            learningOutcome: "Hold a basic 1-minute self-introduction.",
            difficulty: 3, estimatedMinutes: 9, orderIndex: 38, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_39", stageId: "stage_4", moduleNumber: 39,
            title: "Questions 1: Who, What, Where", teluguTitle: "ప్రశ్నలు: ఎవరు, ఏమిటి, ఎక్కడ",
            description: "Evaru (Who), Emiti (What), Ekkada (Where) in conversation.",
            objective: "Ask fundamental information-gathering questions.",
            learningOutcome: "Inquire about people, items, and locations.",
            difficulty: 3, estimatedMinutes: 9, orderIndex: 39, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_40", stageId: "stage_4", moduleNumber: 40,
            title: "Questions 2: When, Why, How", teluguTitle: "ప్రశ్నలు: ఎప్పుడు, ఎందుకు, ఎలా",
            description: "Eppudu (When), Enduku (Why), Ela (How) sentence patterns.",
            objective: "Construct nuanced conversational questions.",
            learningOutcome: "Ask for explanations, timing, and conditions.",
            difficulty: 3, estimatedMinutes: 9, orderIndex: 40, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_41", stageId: "stage_4", moduleNumber: 41,
            title: "Expressing Likes & Dislikes", teluguTitle: "ఇష్టం & అయిష్టం",
            description: "Naaku istam (నాకు ఇష్టం) and Naaku istam ledu (నాకు ఇష్టం లేదు).",
            objective: "Express preferences, hobbies, and dietary choices.",
            learningOutcome: "Clearly convey what you enjoy or prefer to avoid.",
            difficulty: 3, estimatedMinutes: 9, orderIndex: 41, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_42", stageId: "stage_4", moduleNumber: 42,
            title: "Everyday Action Verbs", teluguTitle: "రోజువారీ క్రియలు",
            description: "Eat (తినడం), Drink (తాగడం), Go (వెళ్ళడం), Come (రావడం), Sleep (పడుకోవడం).",
            objective: "Use common verbs in the present and past tenses.",
            learningOutcome: "Form complete Subject-Object-Verb Telugu sentences.",
            difficulty: 3, estimatedMinutes: 10, orderIndex: 42, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_43", stageId: "stage_4", moduleNumber: 43,
            title: "Food Ordering & Restaurant Talk", teluguTitle: "హోటల్ సంభాషణ",
            description: "Ordering dosa, idli, asking for the bill, and complimenting food (బాగుంది).",
            objective: "Order food smoothly at a Telugu restaurant or tiffin center.",
            learningOutcome: "Confident dining interactions.",
            difficulty: 3, estimatedMinutes: 10, orderIndex: 43, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_44", stageId: "stage_4", moduleNumber: 44,
            title: "Shopping & Asking Prices", teluguTitle: "ధర ఎంత? షాపింగ్",
            description: "Dhara entha? (How much?), negotiation, and quantity requests.",
            objective: "Conduct market transactions in Telugu.",
            learningOutcome: "Ask for discounts and specify weights and numbers.",
            difficulty: 3, estimatedMinutes: 10, orderIndex: 44, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_45", stageId: "stage_4", moduleNumber: 45,
            title: "Asking for Directions & Travel", teluguTitle: "దారి & ప్రయాణం",
            description: "Left (ఎడమ), Right (కుడి), Straight (తిన్నగా), Near (దగ్గర), Far (దూరం).",
            objective: "Navigate roads and auto-rickshaws in Telugu-speaking towns.",
            learningOutcome: "Ask and give navigational instructions.",
            difficulty: 3, estimatedMinutes: 10, orderIndex: 45, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_46", stageId: "stage_4", moduleNumber: 46,
            title: "Telugu Idioms & Popular Proverbs", teluguTitle: "సామెతలు & జాతీయాలు",
            description: "Fun, memorable Telugu proverbs (సామెతలు) used in daily life.",
            objective: "Understand cultural humor and wisdom in native Telugu.",
            learningOutcome: "Enrich your speaking with beloved idioms.",
            difficulty: 3, estimatedMinutes: 10, orderIndex: 46, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_47", stageId: "stage_4", moduleNumber: 47,
            title: "Classic Mini-Story Reading", teluguTitle: "చిన్న కథ: చందమామ కథ",
            description: "Read an illustrated folk tale with comprehension questions.",
            objective: "Apply all reading, vocabulary, and grammar skills to a story.",
            learningOutcome: "Read and comprehend an authentic Telugu paragraph.",
            difficulty: 3, estimatedMinutes: 12, orderIndex: 47, level: 4, isPublished: true
        ),
        CurriculumModule(
            id: "module_48", stageId: "stage_4", moduleNumber: 48,
            title: "Course Capstone: Conversationalist", teluguTitle: "తెలుగు సంపూర్ణ ప్రావీణ్యం",
            description: "Final comprehensive evaluation across all 4 levels and graduation.",
            objective: "Demonstrate conversational proficiency in Telugu.",
            learningOutcome: "Earn the Telugu Master Learner Badge & Certification.",
            difficulty: 3, estimatedMinutes: 15, orderIndex: 48, level: 4, isPublished: true
        )
    ]
}
