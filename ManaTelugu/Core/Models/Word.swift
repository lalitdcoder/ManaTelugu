import Foundation

struct Word: Identifiable, Codable, Hashable {
    let id: String
    let telugu: String
    let transliteration: String
    let english: String
    let imageName: String
    let audioFile: String
    let theme: String
}
