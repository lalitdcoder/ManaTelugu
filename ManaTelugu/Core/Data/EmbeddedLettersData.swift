import Foundation

// MARK: - Embedded Letters Data
// This file contains the complete Telugu alphabet data embedded directly in the code
// to ensure it's always available regardless of bundle resource issues

struct EmbeddedLettersData {
    static let letters: [Letter] = [
        // Vowels (అచ్చులు)
        Letter(
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
        Letter(
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
        Letter(
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
        Letter(
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
        Letter(
            id: "te_letter_u",
            glyph: "ఉ",
            name: "u",
            transliteration: "u",
            audioFile: "ఉ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.5, y: 0.7),
                    CGPointCodable(x: 0.5, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.5, y: 0.35),
                    CGPointCodable(x: 0.55, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.45)
                ]
            ]
        ),
        Letter(
            id: "te_letter_uu",
            glyph: "ఊ",
            name: "ū",
            transliteration: "ū",
            audioFile: "ఊ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.5, y: 0.7),
                    CGPointCodable(x: 0.5, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.4, y: 0.35),
                    CGPointCodable(x: 0.45, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.45)
                ],
                [
                    CGPointCodable(x: 0.6, y: 0.35),
                    CGPointCodable(x: 0.65, y: 0.4),
                    CGPointCodable(x: 0.6, y: 0.45)
                ]
            ]
        ),
        Letter(
            id: "te_letter_e",
            glyph: "ఎ",
            name: "e",
            transliteration: "e",
            audioFile: "ఎ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ee",
            glyph: "ఏ",
            name: "ē",
            transliteration: "ē",
            audioFile: "ఏ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5)
                ]
            ]
        ),
        Letter(
            id: "te_letter_rr",
            glyph: "ఋ",
            name: "ṛ",
            transliteration: "ṛ",
            audioFile: "ఋ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5)
                ]
            ]
        ),
        Letter(
            id: "te_letter_rr_long",
            glyph: "ౠ",
            name: "ṝ",
            transliteration: "ṝ",
            audioFile: "ౠ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ai",
            glyph: "ఐ",
            name: "ai",
            transliteration: "ai",
            audioFile: "ఐ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5)
                ]
            ]
        ),
        Letter(
            id: "te_letter_o",
            glyph: "ఒ",
            name: "o",
            transliteration: "o",
            audioFile: "ఒ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_oo",
            glyph: "ఓ",
            name: "ō",
            transliteration: "ō",
            audioFile: "ఓ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5)
                ]
            ]
        ),
        Letter(
            id: "te_letter_au",
            glyph: "ఔ",
            name: "au",
            transliteration: "au",
            audioFile: "ఔ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5)
                ]
            ]
        ),
        Letter(
            id: "te_letter_am",
            glyph: "అం",
            name: "aṁ",
            transliteration: "aṁ",
            audioFile: "అం.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ah",
            glyph: "అః",
            name: "aḥ",
            transliteration: "aḥ",
            audioFile: "అః.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ],
                [
                    CGPointCodable(x: 0.5, y: 0.3),
                    CGPointCodable(x: 0.5, y: 0.4),
                    CGPointCodable(x: 0.5, y: 0.5)
                ]
            ]
        ),
        
        // Consonants (హల్లులు) - First row (క-ఙ)
        Letter(
            id: "te_letter_k",
            glyph: "క",
            name: "ka",
            transliteration: "ka",
            audioFile: "క.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_kha",
            glyph: "ఖ",
            name: "kha",
            transliteration: "kha",
            audioFile: "ఖ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_g",
            glyph: "గ",
            name: "ga",
            transliteration: "ga",
            audioFile: "గ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_gha",
            glyph: "ఘ",
            name: "gha",
            transliteration: "gha",
            audioFile: "ఘ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_nga",
            glyph: "ఙ",
            name: "ṅa",
            transliteration: "ṅa",
            audioFile: "ఙ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        
        // Second row (చ-ఞ)
        Letter(
            id: "te_letter_c",
            glyph: "చ",
            name: "ca",
            transliteration: "ca",
            audioFile: "చ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_cha_asp",
            glyph: "ఛ",
            name: "cha",
            transliteration: "cha",
            audioFile: "ఛ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_j",
            glyph: "జ",
            name: "ja",
            transliteration: "ja",
            audioFile: "జ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_jha",
            glyph: "ఝ",
            name: "jha",
            transliteration: "jha",
            audioFile: "ఝ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_nya",
            glyph: "ఞ",
            name: "ña",
            transliteration: "ña",
            audioFile: "ఞ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        
        // Third row (ట-ణ)
        Letter(
            id: "te_letter_tta",
            glyph: "ట",
            name: "ṭa",
            transliteration: "ṭa",
            audioFile: "ట.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ttha",
            glyph: "ఠ",
            name: "ṭha",
            transliteration: "ṭha",
            audioFile: "ఠ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_dda",
            glyph: "డ",
            name: "ḍa",
            transliteration: "ḍa",
            audioFile: "డ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ddha",
            glyph: "ఢ",
            name: "ḍha",
            transliteration: "ḍha",
            audioFile: "ఢ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_nna",
            glyph: "ణ",
            name: "ṇa",
            transliteration: "ṇa",
            audioFile: "ణ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        
        // Fourth row (త-న)
        Letter(
            id: "te_letter_ta",
            glyph: "త",
            name: "ta",
            transliteration: "ta",
            audioFile: "త.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_tha",
            glyph: "థ",
            name: "tha",
            transliteration: "tha",
            audioFile: "థ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_da",
            glyph: "ద",
            name: "da",
            transliteration: "da",
            audioFile: "ద.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_dha",
            glyph: "ధ",
            name: "dha",
            transliteration: "dha",
            audioFile: "ధ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_na",
            glyph: "న",
            name: "na",
            transliteration: "na",
            audioFile: "న.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        
        // Fifth row (ప-మ)
        Letter(
            id: "te_letter_pa",
            glyph: "ప",
            name: "pa",
            transliteration: "pa",
            audioFile: "ప.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_pha",
            glyph: "ఫ",
            name: "pha",
            transliteration: "pha",
            audioFile: "ఫ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ba",
            glyph: "బ",
            name: "ba",
            transliteration: "ba",
            audioFile: "బ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_bha",
            glyph: "భ",
            name: "bha",
            transliteration: "bha",
            audioFile: "భ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ma",
            glyph: "మ",
            name: "ma",
            transliteration: "ma",
            audioFile: "మ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        
        // Sixth row (య-హ)
        Letter(
            id: "te_letter_ya",
            glyph: "య",
            name: "ya",
            transliteration: "ya",
            audioFile: "య.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ra",
            glyph: "ర",
            name: "ra",
            transliteration: "ra",
            audioFile: "ర.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_la",
            glyph: "ల",
            name: "la",
            transliteration: "la",
            audioFile: "ల.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_va",
            glyph: "వ",
            name: "va",
            transliteration: "va",
            audioFile: "వ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_sha",
            glyph: "శ",
            name: "śa",
            transliteration: "śa",
            audioFile: "శ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ssa",
            glyph: "ష",
            name: "ṣa",
            transliteration: "ṣa",
            audioFile: "ష.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_sa",
            glyph: "స",
            name: "sa",
            transliteration: "sa",
            audioFile: "స.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ha",
            glyph: "హ",
            name: "ha",
            transliteration: "ha",
            audioFile: "హ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        
        // Additional letters
        Letter(
            id: "te_letter_lla",
            glyph: "ళ",
            name: "ḷa",
            transliteration: "ḷa",
            audioFile: "ళ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_ksha",
            glyph: "క్ష",
            name: "kṣa",
            transliteration: "kṣa",
            audioFile: "క్ష.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        ),
        Letter(
            id: "te_letter_rra",
            glyph: "ఱ",
            name: "ṟa",
            transliteration: "ṟa",
            audioFile: "ఱ.mp3",
            strokePathPoints: [
                [
                    CGPointCodable(x: 0.2, y: 0.3),
                    CGPointCodable(x: 0.3, y: 0.4),
                    CGPointCodable(x: 0.4, y: 0.5),
                    CGPointCodable(x: 0.5, y: 0.6),
                    CGPointCodable(x: 0.6, y: 0.7),
                    CGPointCodable(x: 0.7, y: 0.8)
                ]
            ]
        )
    ]
}
