//
//  ManaTeluguUITests.swift
//  ManaTeluguUITests
//
//  Created by Dusanapudi on 28/08/2025.
//

import XCTest

final class ManaTeluguUITests: XCTestCase {

    func testAppLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Test that the app launches and shows the main content
        XCTAssertTrue(app.staticTexts["Welcome to Mana Telugu!"].exists, "Welcome text should be visible")
    }
    
    func testTabNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Test navigation to Alphabet tab
        app.tabBars.buttons["Alphabet"].tap()
        XCTAssertTrue(app.navigationBars["Alphabet"].exists, "Should navigate to Alphabet view")
        
        // Test navigation to Vocabulary tab
        app.tabBars.buttons["Vocabulary"].tap()
        XCTAssertTrue(app.navigationBars["Vocabulary"].exists, "Should navigate to Vocabulary view")
        
        // Test navigation to Games tab
        app.tabBars.buttons["Play"].tap()
        XCTAssertTrue(app.navigationBars["Play"].exists, "Should navigate to Games view")
        
        // Test navigation to Settings tab
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].exists, "Should navigate to Settings view")
    }
}