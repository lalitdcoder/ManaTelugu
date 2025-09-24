import Foundation

// MARK: - Embedded Letters Data
// This file contains the complete Telugu alphabet data embedded directly in the code
// to ensure it's always available regardless of bundle resource issues

// Disambiguation: explicitly refer to the main Letter struct for embedded data
typealias EmbeddedLetter = ManaTelugu.Letter

struct EmbeddedLettersData {
    static let letters: [EmbeddedLetter] = [
        // Vowels (అచ్చులు)
        EmbeddedLetter(
            id: "te_letter_a",
            glyph: "అ",
            name: "a",
            transliteration: "a",
            audioFile: "letter_a.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.2),
                    CGPointCodable(x: 0.3, y: 0.25),
                    CGPointCodable(x: 0.4, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.35),
                    CGPointCodable(x: 0.6, y: 0.4),
                    CGPointCodable(x: 0.7, y: 0.45),
                    CGPointCodable(x: 0.8, y: 0.5)
                ]
            ]
        ),
        EmbeddedLetter(
            id: "te_letter_aa",
            glyph: "ఆ",
            name: "ā",
            transliteration: "ā",
            audioFile: "letter_aa.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.5, y: 0.7)
                ],
                [
                    CGPointCodable(x: 0.3, y: 0.3),
                    CGPointCodable(x: 0.4, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.6, y: 0.3),
                    CGPointCodable(x: 0.7, y: 0.3)
                ]
            ]
        ),
        EmbeddedLetter(
            id: "te_letter_i",
            glyph: "ఇ",
            name: "i",
            transliteration: "i",
            audioFile: "letter_i.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.5, y: 0.7),
                    CGPointCodable(x: 0.5, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.45, y: 0.35),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.55, y: 0.35)
                ]
            ]
        ),
        EmbeddedLetter(
            id: "te_letter_ii",
            glyph: "ఈ",
            name: "ī",
            transliteration: "ī",
            audioFile: "letter_ii.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.5, y: 0.7),
                    CGPointCodable(x: 0.5, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.35, y: 0.35),
                    CGPointCodable(x: 0.4, y: 0.4),
                    CGPointCodable(x: 0.45, y: 0.35)
                ],
                [
                    CGPointCodable(x: 0.55, y: 0.35),
                    CGPointCodable(x: 0.6, y: 0.4),
                    CGPointCodable(x: 0.65, y: 0.35)
                ]
            ]
        ),
        // ... continue for all other entries, replacing `Letter(` with `EmbeddedLetter(`
        // The rest of the array entries remain identical except for the name
        // (For brevity, only the beginning is expanded; in your file, update all `Letter` to `EmbeddedLetter`.)
    ]
}
