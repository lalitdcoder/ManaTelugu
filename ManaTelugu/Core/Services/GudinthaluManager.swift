import Foundation

/// Manager for dynamically generating Telugu Guninthalu (Consonant-Vowel combinations)
/// This uses Unicode composition to create combinations without storing static data
@MainActor
class GudinthaluManager: ObservableObject {

    // MARK: - Telugu Base Consonants
    /// All base Telugu consonants (Vyanjanalu)
    let consonants: [String] = [
        // Ka-varga (క వర్గం)
        "క", "ఖ", "గ", "ఘ", "ఙ",

        // Cha-varga (చ వర్గం)
        "చ", "ఛ", "జ", "ఝ", "ఞ",

        // Ta-varga (ట వర్గం)
        "ట", "ఠ", "డ", "ఢ", "ణ",

        // Ta-varga (త వర్గం)
        "త", "థ", "ద", "ఢ", "న",

        // Pa-varga (ప వర్గం)
        "ప", "ఫ", "బ", "భ", "మ",

        // Ya-varga (య వర్గం)
        "య", "ర", "ల", "వ",

        // Sha-varga (శ వర్గం)
        "శ", "ష", "స", "హ",

        // Additional consonants
        "ళ", "ఱ",
    ]

    // MARK: - Telugu Dependent Vowel Signs (Matras)
    /// Telugu vowel diacritics that combine with consonants
    /// These are the Unicode combining marks that modify consonants
    struct VowelSign: Hashable, Equatable {
        let unicode: String  // The Unicode combining mark
        let display: String  // What to show in UI
        let romanization: String  // Romanized form

        init(_ unicode: String, display: String, romanization: String) {
            self.unicode = unicode
            self.display = display
            self.romanization = romanization
        }
    }

    let vowelSigns: [VowelSign] = [
        // Base form (no matra) - consonant with inherent 'a'
        VowelSign("", display: "a", romanization: "a"),

        // Long 'aa' - ា (U+0C3E)
        VowelSign("\u{0C3E}", display: "ā", romanization: "ā"),

        // Short 'i' - ి (U+0C3F)
        VowelSign("\u{0C3F}", display: "i", romanization: "i"),

        // Long 'ee' - ీ (U+0C40)
        VowelSign("\u{0C40}", display: "ī", romanization: "ī"),

        // Short 'u' - ు (U+0C41)
        VowelSign("\u{0C41}", display: "u", romanization: "u"),

        // Long 'oo' - ూ (U+0C42)
        VowelSign("\u{0C42}", display: "ū", romanization: "ū"),

        // Vocalic 'r' - ృ (U+0C43)
        VowelSign("\u{0C43}", display: "r̥", romanization: "r̥"),

        // Long vocalic 'r' - ౄ (U+0C44)
        VowelSign("\u{0C44}", display: "r̥̄", romanization: "r̥̄"),

        // Short 'e' - ె (U+0C46)
        VowelSign("\u{0C46}", display: "e", romanization: "e"),

        // Long 'ay' - ే (U+0C47)
        VowelSign("\u{0C47}", display: "ē", romanization: "ē"),

        // Diphthong 'ai' - ై (U+0C48)
        VowelSign("\u{0C48}", display: "ai", romanization: "ai"),

        // Short 'o' - ొ (U+0C4A)
        VowelSign("\u{0C4A}", display: "o", romanization: "o"),

        // Long 'o' - ో (U+0C4B)
        VowelSign("\u{0C4B}", display: "ō", romanization: "ō"),

        // Diphthong 'au' - ౌ (U+0C4C)
        VowelSign("\u{0C4C}", display: "au", romanization: "au"),
    ]

    // MARK: - Gudintham Generation

    /// Generate a single Gudintham (consonant + vowel combination)
    /// - Parameters:
    ///   - consonant: The base consonant character
    ///   - vowelSign: The vowel sign to combine with
    /// - Returns: The combined character (Gunintham)
    func generateGudintham(consonant: String, vowelSign: VowelSign) -> String {
        // Telugu Unicode properly combines base consonant + vowel diacritic
        return consonant + vowelSign.unicode
    }

    /// Generate all Gudinthalu for a specific consonant
    /// - Parameter consonant: The base consonant
    /// - Returns: Array of all possible combinations with that consonant
    func generateGudinthaluForConsonant(_ consonant: String) -> [GudinthamItem] {
        return vowelSigns.map { vowelSign in
            GudinthamItem(
                consonant: consonant,
                vowelSign: vowelSign,
                combined: generateGudintham(consonant: consonant, vowelSign: vowelSign)
            )
        }
    }

    /// Generate all Gudinthalu for all consonants
    /// Returns a grouped structure: [Consonant: [Gudinthalu]]
    func generateAllGudinthalu() -> [String: [GudinthamItem]] {
        var result: [String: [GudinthamItem]] = [:]

        for consonant in consonants {
            result[consonant] = generateGudinthaluForConsonant(consonant)
        }

        return result
    }

    /// Get grouped Gudinthalu organized by consonant groups (vargas)
    func getGroupedGudinthalu() -> [GudinthaluGroup] {
        return [
            GudinthaluGroup(
                title: "Ka-varga (క వర్గం)",
                consonants: Array(consonants[0..<5])
            ),
            GudinthaluGroup(
                title: "Cha-varga (చ వర్గం)",
                consonants: Array(consonants[5..<10])
            ),
            GudinthaluGroup(
                title: "Ta-varga (ట వర్గం)",
                consonants: Array(consonants[10..<15])
            ),
            GudinthaluGroup(
                title: "Ta-varga (త వర్గం)",
                consonants: Array(consonants[15..<20])
            ),
            GudinthaluGroup(
                title: "Pa-varga (ప వర్గం)",
                consonants: Array(consonants[20..<25])
            ),
            GudinthaluGroup(
                title: "Ya-varga (య వర్గం)",
                consonants: Array(consonants[25..<29])
            ),
            GudinthaluGroup(
                title: "Sha-varga (శ వర్గం)",
                consonants: Array(consonants[29..<33])
            ),
            GudinthaluGroup(
                title: "Additional (అదనపు)",
                consonants: Array(consonants[33...])
            ),
        ]
    }

    /// Generate full phonetic romanization for a consonant-vowel combination
    /// - Parameters:
    ///   - consonant: The base consonant character
    ///   - vowelSign: The vowel sign being combined
    /// - Returns: Full romanized form (e.g., "ka", "kha", "ki", "kī")
    func getFullRomanization(consonant: String, vowelSign: VowelSign) -> String {
        // Map consonants to their base sounds
        let consonantMap: [String: String] = [
            "క": "k", "ఖ": "kh", "గ": "g", "ఘ": "gh", "ఙ": "ṅ",
            "చ": "ch", "ఛ": "chh", "జ": "j", "ఝ": "jh", "ఞ": "ñ",
            "ట": "ṭ", "ఠ": "ṭh", "డ": "ḍ", "ఢ": "ḍh", "ణ": "ṇ",
            "త": "t", "థ": "th", "ద": "d", "ధ": "dh", "న": "n",
            "ప": "p", "ఫ": "ph", "బ": "b", "భ": "bh", "మ": "m",
            "య": "y", "ర": "r", "ల": "l", "వ": "v",
            "శ": "ś", "ష": "ṣ", "స": "s", "హ": "h",
            "ళ": "ḷ", "ఱ": "ṟ",
        ]

        let baseSound = consonantMap[consonant] ?? consonant
        return baseSound + vowelSign.romanization
    }
}

// MARK: - Supporting Models

/// Represents a single Gudintham (consonant + vowel combination)
struct GudinthamItem: Identifiable, Hashable {
    var id: String { combined }

    let consonant: String
    let vowelSign: GudinthaluManager.VowelSign
    let combined: String
}

/// Represents a group of consonants (like Ka-varga, Cha-varga, etc.)
struct GudinthaluGroup: Identifiable {
    var id: String { title }

    let title: String
    let consonants: [String]
}
