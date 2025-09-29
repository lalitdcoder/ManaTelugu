import SwiftUI

struct TeluguLesson {
    let id: Int
    let title: String
    let letters: [TeluguLetterData]
    let isUnlocked: Bool
    let isCompleted: Bool
}

struct TeluguLetterData {
    let character: String
    let romanization: String
    let description: String
}

enum LessonActivityType {
    case intro
    case reading
    case listening
    case writing
    case review
}

struct TeluguLessonActivity {
    let type: LessonActivityType
    let letter: TeluguLetterData?
    let question: String
    let options: [String]
    let correctAnswer: String
}

// MARK: - Lesson Data
let teluguLessons: [TeluguLesson] = [
    TeluguLesson(id: 1, title: "Lesson 1", letters: [
        TeluguLetterData(character: "అ", romanization: "a", description: "This is అ (a)"),
        TeluguLetterData(character: "ఆ", romanization: "aa", description: "This is ఆ (aa)"),
        TeluguLetterData(character: "ఇ", romanization: "i", description: "This is ఇ (i)"),
        TeluguLetterData(character: "ఈ", romanization: "ee", description: "This is ఈ (ee)")
    ], isUnlocked: true, isCompleted: false),
    
    TeluguLesson(id: 2, title: "Lesson 2", letters: [
        TeluguLetterData(character: "ఉ", romanization: "u", description: "This is ఉ (u)"),
        TeluguLetterData(character: "ఊ", romanization: "oo", description: "This is ఊ (oo)"),
        TeluguLetterData(character: "ఋ", romanization: "ru", description: "This is ఋ (ru)"),
        TeluguLetterData(character: "ఎ", romanization: "e", description: "This is ఎ (e)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 3, title: "Lesson 3", letters: [
        TeluguLetterData(character: "ఏ", romanization: "ae", description: "This is ఏ (ae)"),
        TeluguLetterData(character: "ఐ", romanization: "ai", description: "This is ఐ (ai)"),
        TeluguLetterData(character: "ఒ", romanization: "o", description: "This is ఒ (o)"),
        TeluguLetterData(character: "ఓ", romanization: "oa", description: "This is ఓ (oa)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 4, title: "Lesson 4", letters: [
        TeluguLetterData(character: "ఔ", romanization: "au", description: "This is ఔ (au)"),
        TeluguLetterData(character: "అం", romanization: "am", description: "This is అం (am)"),
        TeluguLetterData(character: "అః", romanization: "ah", description: "This is అః (ah)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 5, title: "Lesson 5", letters: [
        TeluguLetterData(character: "క", romanization: "ka", description: "This is క (ka)"),
        TeluguLetterData(character: "ఖ", romanization: "kha", description: "This is ఖ (kha)"),
        TeluguLetterData(character: "గ", romanization: "ga", description: "This is గ (ga)"),
        TeluguLetterData(character: "ఘ", romanization: "gha", description: "This is ఘ (gha)"),
        TeluguLetterData(character: "ఙ", romanization: "nga", description: "This is ఙ (nga)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 6, title: "Lesson 6", letters: [
        TeluguLetterData(character: "చ", romanization: "cha", description: "This is చ (cha)"),
        TeluguLetterData(character: "ఛ", romanization: "chha", description: "This is ఛ (chha)"),
        TeluguLetterData(character: "జ", romanization: "ja", description: "This is జ (ja)"),
        TeluguLetterData(character: "ఝ", romanization: "jha", description: "This is ఝ (jha)"),
        TeluguLetterData(character: "ఞ", romanization: "nja", description: "This is ఞ (nja)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 7, title: "Lesson 7", letters: [
        TeluguLetterData(character: "ట", romanization: "ta", description: "This is ట (ta)"),
        TeluguLetterData(character: "ఠ", romanization: "tha", description: "This is ఠ (tha)"),
        TeluguLetterData(character: "డ", romanization: "da", description: "This is డ (da)"),
        TeluguLetterData(character: "ఢ", romanization: "dha", description: "This is ఢ (dha)"),
        TeluguLetterData(character: "ణ", romanization: "na", description: "This is ణ (na)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 8, title: "Lesson 8", letters: [
        TeluguLetterData(character: "త", romanization: "tha", description: "This is త (tha)"),
        TeluguLetterData(character: "థ", romanization: "thha", description: "This is థ (thha)"),
        TeluguLetterData(character: "ద", romanization: "dha", description: "This is ద (dha)"),
        TeluguLetterData(character: "ధ", romanization: "dhha", description: "This is ధ (dhha)"),
        TeluguLetterData(character: "న", romanization: "na", description: "This is న (na)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 9, title: "Lesson 9", letters: [
        TeluguLetterData(character: "ప", romanization: "pa", description: "This is ప (pa)"),
        TeluguLetterData(character: "ఫ", romanization: "pha", description: "This is ఫ (pha)"),
        TeluguLetterData(character: "బ", romanization: "ba", description: "This is బ (ba)"),
        TeluguLetterData(character: "భ", romanization: "bha", description: "This is భ (bha)"),
        TeluguLetterData(character: "మ", romanization: "ma", description: "This is మ (ma)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 10, title: "Lesson 10", letters: [
        TeluguLetterData(character: "య", romanization: "ya", description: "This is య (ya)"),
        TeluguLetterData(character: "ర", romanization: "ra", description: "This is ర (ra)"),
        TeluguLetterData(character: "ల", romanization: "la", description: "This is ల (la)"),
        TeluguLetterData(character: "వ", romanization: "va", description: "This is వ (va)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 11, title: "Lesson 11", letters: [
        TeluguLetterData(character: "శ", romanization: "sha", description: "This is శ (sha)"),
        TeluguLetterData(character: "ష", romanization: "shha", description: "This is ష (shha)"),
        TeluguLetterData(character: "స", romanization: "sa", description: "This is స (sa)"),
        TeluguLetterData(character: "హ", romanization: "ha", description: "This is హ (ha)")
    ], isUnlocked: false, isCompleted: false),
    
    TeluguLesson(id: 12, title: "Lesson 12", letters: [
        TeluguLetterData(character: "ళ", romanization: "la", description: "This is ళ (la)"),
        TeluguLetterData(character: "క్ష", romanization: "ksha", description: "This is క్ష (ksha)"),
        TeluguLetterData(character: "ఱ", romanization: "rra", description: "This is ఱ (rra)")
    ], isUnlocked: false, isCompleted: false)
]
