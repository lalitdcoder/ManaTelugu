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
        
        // Test navigation to Home tab
        app.tabBars.buttons["Home"].tap()
        XCTAssertTrue(app.navigationBars["Home"].exists, "Should navigate to Home view")
        
        // Test navigation to Alphabet tab
        app.tabBars.buttons["Alphabet"].tap()
        XCTAssertTrue(app.navigationBars["Alphabet"].exists, "Should navigate to Alphabet view")
        
        // Test navigation to Lessons tab
        app.tabBars.buttons["Lessons"].tap()
        XCTAssertTrue(app.navigationBars["Lessons"].exists, "Should navigate to Lessons view")
        
        // Test navigation to Stories tab
        app.tabBars.buttons["Stories"].tap()
        XCTAssertTrue(app.navigationBars["Stories"].exists, "Should navigate to Stories view")
        
        // Test navigation to Games tab
        app.tabBars.buttons["Games"].tap()
        XCTAssertTrue(app.navigationBars["Games"].exists, "Should navigate to Games view")
        
        // Test navigation to More tab
        app.tabBars.buttons["More"].tap()
        XCTAssertTrue(app.navigationBars["More"].exists, "Should navigate to More view")
    }
}