import Foundation
import CoreGraphics

struct CGPointCodable: Codable, Hashable {
    let x: CGFloat
    let y: CGFloat
}

struct Letter: Identifiable, Codable, Hashable {
    let id: String
    let glyph: String
    let name: String
    let transliteration: String
    let audioFile: String
    let strokePathPoints: [[CGPointCodable]]
}