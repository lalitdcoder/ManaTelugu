import Foundation

class Transliteration {
    static let shared = Transliteration()
    
    private let vowelMap: [String: String] = [
        "అ": "a",
        "ఆ": "ā",
        "ఇ": "i",
        "ఈ": "ī",
        "ఉ": "u",
        "ఊ": "ū",
        "ఋ": "ṛ",
        "ఎ": "e",
        "ఏ": "ē",
        "ఐ": "ai",
        "ఒ": "o",
        "ఓ": "ō",
        "ఔ": "au"
    ]
    
    private let consonantMap: [String: String] = [
        "క": "ka", "ఖ": "kha", "గ": "ga", "ఘ": "gha",
        "చ": "ca", "ఛ": "cha", "జ": "ja", "ఝ": "jha",
        "ట": "ṭa", "ఠ": "ṭha", "డ": "ḍa", "ఢ": "ḍha",
        "త": "ta", "థ": "tha", "ద": "da", "ధ": "dha",
        "న": "na", "ప": "pa", "ఫ": "pha", "బ": "ba",
        "భ": "bha", "మ": "ma", "య": "ya", "ర": "ra",
        "ల": "la", "వ": "va", "శ": "śa", "ష": "ṣa",
        "స": "sa", "హ": "ha"
    ]
    
    private init() {}
    
    func transliterate(_ text: String) -> String {
        var result = ""
        
        for char in text {
            let charString = String(char)
            
            if let vowel = vowelMap[charString] {
                result += vowel
            } else if let consonant = consonantMap[charString] {
                result += consonant
            } else {
                result += charString
            }
        }
        
        return result
    }
}