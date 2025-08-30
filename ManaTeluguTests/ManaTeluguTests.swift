//
//  ManaTeluguTests.swift
//  ManaTeluguTests
//
//  Created by Dusanapudi on 28/08/2025.
//

import XCTest
@testable import ManaTelugu

final class ManaTeluguTests: XCTestCase {
    
    func testLetterDecoding() throws {
        let repository = DataRepository.shared
        let letters = repository.letters()
        
        XCTAssertFalse(letters.isEmpty, "Letters should not be empty")
        XCTAssertEqual(letters.count, 12, "Should have 12 letters")
        
        let firstLetter = letters[0]
        XCTAssertEqual(firstLetter.id, "te_letter_a", "First letter ID should match")
        XCTAssertEqual(firstLetter.glyph, "అ", "First letter glyph should match")
        XCTAssertEqual(firstLetter.name, "a", "First letter name should match")
        XCTAssertEqual(firstLetter.transliteration, "a", "First letter transliteration should match")
    }
    
    func testWordDecoding() throws {
        let repository = DataRepository.shared
        let words = repository.words()
        
        XCTAssertFalse(words.isEmpty, "Words should not be empty")
        XCTAssertEqual(words.count, 30, "Should have 30 words")
        
        let firstWord = words[0]
        XCTAssertEqual(firstWord.id, "w_apple", "First word ID should match")
        XCTAssertEqual(firstWord.telugu, "ఆపిల్", "First word Telugu should match")
        XCTAssertEqual(firstWord.english, "Apple", "First word English should match")
        XCTAssertEqual(firstWord.theme, "Food", "First word theme should match")
    }
    
    func testLessonDecoding() throws {
        let repository = DataRepository.shared
        let lessons = repository.lessons()
        
        XCTAssertFalse(lessons.isEmpty, "Lessons should not be empty")
        XCTAssertEqual(lessons.count, 6, "Should have 6 lessons")
        
        let firstLesson = lessons[0]
        XCTAssertEqual(firstLesson.id, "lesson_basic_vowels", "First lesson ID should match")
        XCTAssertEqual(firstLesson.title, "Basic Vowels", "First lesson title should match")
    }
    
    func testBadgeDecoding() throws {
        let repository = DataRepository.shared
        let badges = repository.badges()
        
        XCTAssertFalse(badges.isEmpty, "Badges should not be empty")
        XCTAssertEqual(badges.count, 5, "Should have 5 badges")
        
        let firstBadge = badges[0]
        XCTAssertEqual(firstBadge.id, "badge_streak_3", "First badge ID should match")
        XCTAssertEqual(firstBadge.name, "3-Day Streak", "First badge name should match")
    }
}