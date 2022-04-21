//
//  SplashUITests.swift
//  PhotoboothUITests
//
//  Created by Jonathan Solorzano on 20/4/22.
//

import XCTest
@testable import Photobooth

class SplashUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    // Splash
    // 1. There's an image
    // 2. There's a title text label
    // 3. There's a description text label
    // 4. There's an action button
    func test_splash() throws {
        
        let image = app.images[Constants.splashImageIdentifier]
        let title = app.staticTexts[Constants.splashTitleIdentifier]
        let description = app.staticTexts[Constants.splashDescriptionIdentifier]

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(image.waitForExistence(timeout: 3))
        XCTAssertTrue(title.waitForExistence(timeout: 3))
        XCTAssertTrue(description.waitForExistence(timeout: 3))
    }
}
