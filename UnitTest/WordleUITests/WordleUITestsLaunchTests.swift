//
//  WordleUITestsLaunchTests.swift
//  WordleUITests
//
//  Created by Cosette Tabucol on 4/25/25.
//

import XCTest

final class WordleUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app
        
        // Check for Matrix (6*5)
        // Check for Light/Dark Mode Picker
        // Check for Internal Keyboard
        // Check for New Game Button
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
