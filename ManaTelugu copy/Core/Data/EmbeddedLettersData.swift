import Foundation

struct EmbeddedLettersData {
    static let letters: [Letter] = [
        // Vowels
        Letter(id: "1", character: "అ", romanization: "a", meaning: "vowel a", category: .vowel),
        Letter(id: "2", character: "ఆ", romanization: "aa", meaning: "vowel aa", category: .vowel),
        Letter(id: "3", character: "ఇ", romanization: "i", meaning: "vowel i", category: .vowel),
        Letter(id: "4", character: "ఈ", romanization: "ee", meaning: "vowel ee", category: .vowel),
        Letter(id: "5", character: "ఉ", romanization: "u", meaning: "vowel u", category: .vowel),
        
        // Consonants
        Letter(id: "6", character: "క", romanization: "ka", meaning: "consonant ka", category: .consonant),
        Letter(id: "7", character: "గ", romanization: "ga", meaning: "consonant ga", category: .consonant),
        Letter(id: "8", character: "చ", romanization: "cha", meaning: "consonant cha", category: .consonant)
    ]
}
