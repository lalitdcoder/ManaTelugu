import Foundation

// MARK: - Embedded Words Data
// This file contains comprehensive vocabulary data embedded directly in the code
// to ensure it's always available regardless of bundle resource issues

struct EmbeddedWordsData {
    static let words: [Word] = [
        // Family Theme
        Word(id: "word_1", telugu: "అమ్మ", transliteration: "amma", english: "Mother", imageName: "amma", audioFile: "amma.mp3", theme: "Family"),
        Word(id: "word_2", telugu: "నాన్న", transliteration: "nanna", english: "Father", imageName: "nanna", audioFile: "nanna.mp3", theme: "Family"),
        Word(id: "word_3", telugu: "అక్క", transliteration: "akka", english: "Elder Sister", imageName: "akka", audioFile: "akka.mp3", theme: "Family"),
        Word(id: "word_4", telugu: "అన్న", transliteration: "anna", english: "Elder Brother", imageName: "anna", audioFile: "anna.mp3", theme: "Family"),
        Word(id: "word_5", telugu: "తమ్ముడు", transliteration: "tammuḍu", english: "Younger Brother", imageName: "tammuḍu", audioFile: "tammuḍu.mp3", theme: "Family"),
        Word(id: "word_6", telugu: "చెల్లి", transliteration: "chelli", english: "Younger Sister", imageName: "chelli", audioFile: "chelli.mp3", theme: "Family"),
        Word(id: "word_7", telugu: "తాత", transliteration: "tāta", english: "Grandfather", imageName: "tāta", audioFile: "tāta.mp3", theme: "Family"),
        Word(id: "word_8", telugu: "అవ్వ", transliteration: "avva", english: "Grandmother", imageName: "avva", audioFile: "avva.mp3", theme: "Family"),
        Word(id: "word_9", telugu: "మామ", transliteration: "māma", english: "Maternal Uncle", imageName: "māma", audioFile: "māma.mp3", theme: "Family"),
        Word(id: "word_10", telugu: "పిన్ని", transliteration: "pinni", english: "Maternal Aunt", imageName: "pinni", audioFile: "pinni.mp3", theme: "Family"),
        
        // Colors Theme
        Word(id: "word_11", telugu: "ఎరుపు", transliteration: "erupu", english: "Red", imageName: "erupu", audioFile: "erupu.mp3", theme: "Colors"),
        Word(id: "word_12", telugu: "నీలం", transliteration: "nīlaṁ", english: "Blue", imageName: "nīlaṁ", audioFile: "nīlaṁ.mp3", theme: "Colors"),
        Word(id: "word_13", telugu: "పసుపు", transliteration: "pasupu", english: "Yellow", imageName: "pasupu", audioFile: "pasupu.mp3", theme: "Colors"),
        Word(id: "word_14", telugu: "ఆకుపచ్చ", transliteration: "ākupacca", english: "Green", imageName: "ākupacca", audioFile: "ākupacca.mp3", theme: "Colors"),
        Word(id: "word_15", telugu: "నలుపు", transliteration: "nalupu", english: "Black", imageName: "nalupu", audioFile: "nalupu.mp3", theme: "Colors"),
        Word(id: "word_16", telugu: "తెలుపు", transliteration: "telupu", english: "White", imageName: "telupu", audioFile: "telupu.mp3", theme: "Colors"),
        Word(id: "word_17", telugu: "ఊదా", transliteration: "ūdā", english: "Purple", imageName: "ūdā", audioFile: "ūdā.mp3", theme: "Colors"),
        Word(id: "word_18", telugu: "నారింజ", transliteration: "nāriṁja", english: "Orange", imageName: "nāriṁja", audioFile: "nāriṁja.mp3", theme: "Colors"),
        Word(id: "word_19", telugu: "గులాబీ", transliteration: "gulābī", english: "Pink", imageName: "gulābī", audioFile: "gulābī.mp3", theme: "Colors"),
        Word(id: "word_20", telugu: "గోధుమ", transliteration: "gōdhuma", english: "Brown", imageName: "gōdhuma", audioFile: "gōdhuma.mp3", theme: "Colors"),
        
        // Animals Theme
        Word(id: "word_21", telugu: "పులి", transliteration: "puli", english: "Tiger", imageName: "puli", audioFile: "puli.mp3", theme: "Animals"),
        Word(id: "word_22", telugu: "ఏనుగు", transliteration: "ēnugu", english: "Elephant", imageName: "ēnugu", audioFile: "ēnugu.mp3", theme: "Animals"),
        Word(id: "word_23", telugu: "సింహం", transliteration: "siṁhaṁ", english: "Lion", imageName: "siṁhaṁ", audioFile: "siṁhaṁ.mp3", theme: "Animals"),
        Word(id: "word_24", telugu: "జింక", transliteration: "Jiṅka", english: "Deer", imageName: "Jiṅka", audioFile: "జింక.mp3", theme: "Animals"),
        Word(id: "word_25", telugu: "కుక్క", transliteration: "kukka", english: "Dog", imageName: "kukka", audioFile: "kukka.mp3", theme: "Animals"),
        Word(id: "word_26", telugu: "పిల్లి", transliteration: "pilli", english: "Cat", imageName: "pilli", audioFile: "pilli.mp3", theme: "Animals"),
        Word(id: "word_27", telugu: "పక్షి", transliteration: "pakṣi", english: "Bird", imageName: "pakṣi", audioFile: "pakṣi.mp3", theme: "Animals"),
        Word(id: "word_28", telugu: "చేప", transliteration: "cēpa", english: "Fish", imageName: "cēpa", audioFile: "cēpa.mp3", theme: "Animals"),
        Word(id: "word_29", telugu: "అడవి", transliteration: "aḍavi", english: "Forest", imageName: "aḍavi", audioFile: "aḍavi.mp3", theme: "Animals"),
        Word(id: "word_30", telugu: "జంతువు", transliteration: "jaṁtuvu", english: "Animal", imageName: "jaṁtuvu", audioFile: "jaṁtuvu.mp3", theme: "Animals"),
        
        // Food Theme
        Word(id: "word_31", telugu: "అన్నం", transliteration: "annaṁ", english: "Rice", imageName: "annaṁ", audioFile: "annaṁ.mp3", theme: "Food"),
        Word(id: "word_32", telugu: "రొట్టె", transliteration: "roṭṭe", english: "Bread", imageName: "roṭṭe", audioFile: "roṭṭe.mp3", theme: "Food"),
        Word(id: "word_33", telugu: "పాలు", transliteration: "pālu", english: "Milk", imageName: "pālu", audioFile: "pālu.mp3", theme: "Food"),
        Word(id: "word_34", telugu: "నీళ్లు", transliteration: "nīḷlu", english: "Water", imageName: "nīḷlu", audioFile: "nīḷlu.mp3", theme: "Food"),
        Word(id: "word_35", telugu: "కూర", transliteration: "kūra", english: "Curry", imageName: "kūra", audioFile: "kūra.mp3", theme: "Food"),
        Word(id: "word_36", telugu: "పండు", transliteration: "paṁḍu", english: "Fruit", imageName: "paṁḍu", audioFile: "paṁḍu.mp3", theme: "Food"),
        Word(id: "word_37", telugu: "కాయ", transliteration: "kāya", english: "Vegetable", imageName: "kāya", audioFile: "kāya.mp3", theme: "Food"),
        Word(id: "word_38", telugu: "బియ్యం", transliteration: "biyyaṁ", english: "Rice Grain", imageName: "biyyaṁ", audioFile: "biyyaṁ.mp3", theme: "Food"),
        Word(id: "word_39", telugu: "అన్నపూర్ణ", transliteration: "annapūrṇa", english: "Full Meal", imageName: "annapūrṇa", audioFile: "annapūrṇa.mp3", theme: "Food"),
        Word(id: "word_40", telugu: "రుచి", transliteration: "ruci", english: "Taste", imageName: "ruci", audioFile: "ruci.mp3", theme: "Food"),
        
        // Numbers Theme
        Word(id: "word_41", telugu: "ఒక్కటి", transliteration: "okkaṭi", english: "One", imageName: "okkaṭi", audioFile: "okkaṭi.mp3", theme: "Numbers"),
        Word(id: "word_42", telugu: "ఇద్దరు", transliteration: "iddaru", english: "Two", imageName: "iddaru", audioFile: "iddaru.mp3", theme: "Numbers"),
        Word(id: "word_43", telugu: "ముగ్దరు", transliteration: "mugdaru", english: "Three", imageName: "mugdaru", audioFile: "mugdaru.mp3", theme: "Numbers"),
        Word(id: "word_44", telugu: "నలుగురు", transliteration: "naluguru", english: "Four", imageName: "naluguru", audioFile: "naluguru.mp3", theme: "Numbers"),
        Word(id: "word_45", telugu: "అయిదుగురు", transliteration: "ayiduguru", english: "Five", imageName: "ayiduguru", audioFile: "ayiduguru.mp3", theme: "Numbers"),
        Word(id: "word_46", telugu: "ఆరుగురు", transliteration: "āruguru", english: "Six", imageName: "āruguru", audioFile: "āruguru.mp3", theme: "Numbers"),
        Word(id: "word_47", telugu: "ఏడుగురు", transliteration: "ēḍuguru", english: "Seven", imageName: "ēḍuguru", audioFile: "ēḍuguru.mp3", theme: "Numbers"),
        Word(id: "word_48", telugu: "ఎనిమిదిమంది", transliteration: "enimidimaṁdi", english: "Eight", imageName: "enimidimaṁdi", audioFile: "enimidimaṁdi.mp3", theme: "Numbers"),
        Word(id: "word_49", telugu: "తొమ్మిదిమంది", transliteration: "tommidimaṁdi", english: "Nine", imageName: "tommidimaṁdi", audioFile: "tommidimaṁdi.mp3", theme: "Numbers"),
        Word(id: "word_50", telugu: "పదిమంది", transliteration: "padimaṁdi", english: "Ten", imageName: "padimaṁdi", audioFile: "padimaṁdi.mp3", theme: "Numbers"),
        
        // Body Parts Theme
        Word(id: "word_51", telugu: "తల", transliteration: "tala", english: "Head", imageName: "tala", audioFile: "tala.mp3", theme: "Body Parts"),
        Word(id: "word_52", telugu: "కళ్లు", transliteration: "kaḷlu", english: "Eyes", imageName: "kaḷlu", audioFile: "kaḷlu.mp3", theme: "Body Parts"),
        Word(id: "word_53", telugu: "చెవులు", transliteration: "cevulu", english: "Ears", imageName: "cevulu", audioFile: "cevulu.mp3", theme: "Body Parts"),
        Word(id: "word_54", telugu: "ముక్కు", transliteration: "mukku", english: "Nose", imageName: "mukku", audioFile: "mukku.mp3", theme: "Body Parts"),
        Word(id: "word_55", telugu: "నోరు", transliteration: "nōru", english: "Mouth", imageName: "nōru", audioFile: "nōru.mp3", theme: "Body Parts"),
        Word(id: "word_56", telugu: "చేతులు", transliteration: "cētulu", english: "Hands", imageName: "cētulu", audioFile: "cētulu.mp3", theme: "Body Parts"),
        Word(id: "word_57", telugu: "కాళ్లు", transliteration: "kāḷlu", english: "Legs", imageName: "kāḷlu", audioFile: "kāḷlu.mp3", theme: "Body Parts"),
        Word(id: "word_58", telugu: "గుండె", transliteration: "guṁḍe", english: "Heart", imageName: "guṁḍe", audioFile: "guṁḍe.mp3", theme: "Body Parts"),
        Word(id: "word_59", telugu: "మెదడు", transliteration: "medaḍu", english: "Brain", imageName: "medaḍu", audioFile: "medaḍu.mp3", theme: "Body Parts"),
        Word(id: "word_60", telugu: "ఎముక", transliteration: "emuka", english: "Bone", imageName: "emuka", audioFile: "emuka.mp3", theme: "Body Parts"),
        
        // Nature Theme
        Word(id: "word_61", telugu: "సూర్యుడు", transliteration: "sūryuḍu", english: "Sun", imageName: "sūryuḍu", audioFile: "sūryuḍu.mp3", theme: "Nature"),
        Word(id: "word_62", telugu: "చంద్రుడు", transliteration: "caṁdruḍu", english: "Moon", imageName: "caṁdruḍu", audioFile: "caṁdruḍu.mp3", theme: "Nature"),
        Word(id: "word_63", telugu: "నక్షత్రాలు", transliteration: "nakṣatrālu", english: "Stars", imageName: "nakṣatrālu", audioFile: "nakṣatrālu.mp3", theme: "Nature"),
        Word(id: "word_64", telugu: "ఆకాశం", transliteration: "ākāśaṁ", english: "Sky", imageName: "ākāśaṁ", audioFile: "ākāśaṁ.mp3", theme: "Nature"),
        Word(id: "word_65", telugu: "భూమి", transliteration: "bhūmi", english: "Earth", imageName: "bhūmi", audioFile: "bhūmi.mp3", theme: "Nature"),
        Word(id: "word_66", telugu: "వృక్షం", transliteration: "vṛkṣaṁ", english: "Tree", imageName: "vṛkṣaṁ", audioFile: "vṛkṣaṁ.mp3", theme: "Nature"),
        Word(id: "word_67", telugu: "పువ్వు", transliteration: "puvvu", english: "Flower", imageName: "puvvu", audioFile: "puvvu.mp3", theme: "Nature"),
        Word(id: "word_68", telugu: "ఆకు", transliteration: "āku", english: "Leaf", imageName: "āku", audioFile: "āku.mp3", theme: "Nature"),
        Word(id: "word_69", telugu: "పర్వతం", transliteration: "parvataṁ", english: "Mountain", imageName: "parvataṁ", audioFile: "parvataṁ.mp3", theme: "Nature"),
        Word(id: "word_70", telugu: "నది", transliteration: "nadi", english: "River", imageName: "nadi", audioFile: "nadi.mp3", theme: "Nature"),
        
        // Time Theme
        Word(id: "word_71", telugu: "ఉదయం", transliteration: "udayaṁ", english: "Morning", imageName: "udayaṁ", audioFile: "udayaṁ.mp3", theme: "Time"),
        Word(id: "word_72", telugu: "మధ్యాహ్నం", transliteration: "madhyāhnaṁ", english: "Afternoon", imageName: "madhyāhnaṁ", audioFile: "madhyāhnaṁ.mp3", theme: "Time"),
        Word(id: "word_73", telugu: "సాయంత్రం", transliteration: "sāyaṁtraṁ", english: "Evening", imageName: "sāyaṁtraṁ", audioFile: "sāyaṁtraṁ.mp3", theme: "Time"),
        Word(id: "word_74", telugu: "రాత్రి", transliteration: "rātri", english: "Night", imageName: "rātri", audioFile: "rātri.mp3", theme: "Time"),
        Word(id: "word_75", telugu: "వారం", transliteration: "vāraṁ", english: "Week", imageName: "vāraṁ", audioFile: "vāraṁ.mp3", theme: "Time"),
        Word(id: "word_76", telugu: "నెల", transliteration: "nela", english: "Month", imageName: "nela", audioFile: "nela.mp3", theme: "Time"),
        Word(id: "word_77", telugu: "సంవత్సరం", transliteration: "saṁvatsaraṁ", english: "Year", imageName: "saṁvatsaraṁ", audioFile: "saṁvatsaraṁ.mp3", theme: "Time"),
        Word(id: "word_78", telugu: "కాలం", transliteration: "kālaṁ", english: "Time", imageName: "kālaṁ", audioFile: "kālaṁ.mp3", theme: "Time"),
        Word(id: "word_79", telugu: "ఇప్పుడు", transliteration: "ippuḍu", english: "Now", imageName: "ippuḍu", audioFile: "ippuḍu.mp3", theme: "Time"),
        Word(id: "word_80", telugu: "అప్పుడు", transliteration: "appuḍu", english: "Then", imageName: "appuḍu", audioFile: "appuḍu.mp3", theme: "Time"),
        
        // Greetings Theme
        Word(id: "word_81", telugu: "నమస్కారం", transliteration: "namaskāraṁ", english: "Greetings", imageName: "namaskāraṁ", audioFile: "namaskāraṁ.mp3", theme: "Greetings"),
        Word(id: "word_82", telugu: "ధన్యవాదాలు", transliteration: "dhanyavādālu", english: "Thank you", imageName: "dhanyavādālu", audioFile: "dhanyavādālu.mp3", theme: "Greetings"),
        Word(id: "word_83", telugu: "క్షమించండి", transliteration: "kṣamiṁcaṁḍi", english: "Sorry", imageName: "kṣamiṁcaṁḍi", audioFile: "kṣamiṁcaṁḍi.mp3", theme: "Greetings"),
        Word(id: "word_84", telugu: "మీరు ఎలా ఉన్నారు?", transliteration: "mīru elā unnāru?", english: "How are you?", imageName: "mīru_elā_unnāru", audioFile: "mīru_elā_unnāru.mp3", theme: "Greetings"),
        Word(id: "word_85", telugu: "మంచిది", transliteration: "maṁcidi", english: "Good", imageName: "maṁcidi", audioFile: "maṁcidi.mp3", theme: "Greetings"),
        Word(id: "word_86", telugu: "చెడ్డ", transliteration: "ceḍḍa", english: "Bad", imageName: "ceḍḍa", audioFile: "ceḍḍa.mp3", theme: "Greetings"),
        Word(id: "word_87", telugu: "అవును", transliteration: "avunu", english: "Yes", imageName: "avunu", audioFile: "avunu.mp3", theme: "Greetings"),
        Word(id: "word_88", telugu: "కాదు", transliteration: "kādu", english: "No", imageName: "kādu", audioFile: "kādu.mp3", theme: "Greetings"),
        Word(id: "word_89", telugu: "మీరు", transliteration: "mīru", english: "You", imageName: "mīru", audioFile: "mīru.mp3", theme: "Greetings"),
        Word(id: "word_90", telugu: "నేను", transliteration: "nēnu", english: "I", imageName: "nēnu", audioFile: "nēnu.mp3", theme: "Greetings"),
        
        // School Objects Theme
        Word(id: "word_91", telugu: "పుస్తకం", transliteration: "pustakaṁ", english: "Book", imageName: "pustakaṁ", audioFile: "pustakaṁ.mp3", theme: "School Objects"),
        Word(id: "word_92", telugu: "పెన్ను", transliteration: "pennu", english: "Pen", imageName: "pennu", audioFile: "pennu.mp3", theme: "School Objects"),
        Word(id: "word_93", telugu: "పెన్సిల్", transliteration: "pensil", english: "Pencil", imageName: "pensil", audioFile: "pensil.mp3", theme: "School Objects"),
        Word(id: "word_94", telugu: "బోర్డు", transliteration: "bōrḍu", english: "Blackboard", imageName: "bōrḍu", audioFile: "bōrḍu.mp3", theme: "School Objects"),
        Word(id: "word_95", telugu: "కుర్చీ", transliteration: "kurcī", english: "Chair", imageName: "kurcī", audioFile: "kurcī.mp3", theme: "School Objects"),
        Word(id: "word_96", telugu: "మేజా", transliteration: "mējā", english: "Table", imageName: "mējā", audioFile: "mējā.mp3", theme: "School Objects"),
        Word(id: "word_97", telugu: "సంచీ", transliteration: "San̄cī", english: "Bag", imageName: "San̄cī", audioFile: "సంచీ.mp3", theme: "School Objects"),
        Word(id: "word_98", telugu: "రబ్బరు", transliteration: "rabbaru", english: "Eraser", imageName: "rabbaru", audioFile: "rabbaru.mp3", theme: "School Objects"),
        Word(id: "word_99", telugu: "రూలర్", transliteration: "rūlar", english: "Ruler", imageName: "rūlar", audioFile: "rūlar.mp3", theme: "School Objects"),
        Word(id: "word_100", telugu: "కంప్యూటర్", transliteration: "kaṁpyūṭar", english: "Computer", imageName: "kaṁpyūṭar", audioFile: "kaṁpyūṭar.mp3", theme: "School Objects"),
        
        // Weather Theme
        Word(id: "word_101", telugu: "వర్షం", transliteration: "varṣaṁ", english: "Rain", imageName: "varṣaṁ", audioFile: "వర్షం.mp3", theme: "Weather"),
        Word(id: "word_102", telugu: "ఎండ", transliteration: "eṁḍa", english: "Sun", imageName: "eṁḍa", audioFile: "ఎండ.mp3", theme: "Weather"),
        Word(id: "word_103", telugu: "మేఘం", transliteration: "mēghaṁ", english: "Cloud", imageName: "mēghaṁ", audioFile: "మేఘం.mp3", theme: "Weather"),
        Word(id: "word_104", telugu: "గాలి", transliteration: "gāli", english: "Wind", imageName: "gāli", audioFile: "గాలి.mp3", theme: "Weather"),
        Word(id: "word_105", telugu: "వేడి", transliteration: "vēḍi", english: "Hot", imageName: "vēḍi", audioFile: "వేడి.mp3", theme: "Weather"),
        Word(id: "word_106", telugu: "చలి", transliteration: "cali", english: "Cold", imageName: "cali", audioFile: "cali.mp3", theme: "Weather"),
        Word(id: "word_107", telugu: "మంచు", transliteration: "maṁcu", english: "Snow", imageName: "maṁcu", audioFile: "మంచు.mp3", theme: "Weather"),
        Word(id: "word_108", telugu: "విద్యుత్", transliteration: "vidyut", english: "Lightning", imageName: "vidyut", audioFile: "విద్యుత్.mp3", theme: "Weather"),
        Word(id: "word_109", telugu: "గర్జన", transliteration: "garjana", english: "Thunder", imageName: "garjana", audioFile: "గర్జన.mp3", theme: "Weather"),
        Word(id: "word_110", telugu: "వాతావరణం", transliteration: "vātāvaraṇaṁ", english: "Weather", imageName: "vātāvaraṇaṁ", audioFile: "వాతావరణం.mp3", theme: "Weather"),
        
        // Daily Actions Theme
        Word(id: "word_111", telugu: "తినడం", transliteration: "tinaḍaṁ", english: "Eating", imageName: "tinaḍaṁ", audioFile: "తినడం.mp3", theme: "Daily Actions"),
        Word(id: "word_112", telugu: "త్రాగడం", transliteration: "trāgaḍaṁ", english: "Drinking", imageName: "trāgaḍaṁ", audioFile: "త్రాగడం.mp3", theme: "Daily Actions"),
        Word(id: "word_113", telugu: "నిద్ర", transliteration: "nidra", english: "Sleep", imageName: "nidra", audioFile: "నిద్ర.mp3", theme: "Daily Actions"),
        Word(id: "word_114", telugu: "వస్త్రం", transliteration: "vastraṁ", english: "Dressing", imageName: "vastraṁ", audioFile: "వస్త్రం.mp3", theme: "Daily Actions"),
        Word(id: "word_115", telugu: "స్నానం", transliteration: "snānaṁ", english: "Bathing", imageName: "snānaṁ", audioFile: "స్నానం.mp3", theme: "Daily Actions"),
        Word(id: "word_116", telugu: "చదవడం", transliteration: "cadavaḍaṁ", english: "Reading", imageName: "cadavaḍaṁ", audioFile: "చదవడం.mp3", theme: "Daily Actions"),
        Word(id: "word_117", telugu: "వ్రాయడం", transliteration: "vrāyaḍaṁ", english: "Writing", imageName: "vrāyaḍaṁ", audioFile: "వ్రాయడం.mp3", theme: "Daily Actions"),
        Word(id: "word_118", telugu: "పాడడం", transliteration: "pāḍaḍaṁ", english: "Singing", imageName: "pāḍaḍaṁ", audioFile: "పాడడం.mp3", theme: "Daily Actions"),
        Word(id: "word_119", telugu: "అడుగడం", transliteration: "aḍugaḍaṁ", english: "Walking", imageName: "aḍugaḍaṁ", audioFile: "అడుగడం.mp3", theme: "Daily Actions"),
        Word(id: "word_120", telugu: "పని", transliteration: "pani", english: "Work", imageName: "pani", audioFile: "పని.mp3", theme: "Daily Actions")
    ]
}