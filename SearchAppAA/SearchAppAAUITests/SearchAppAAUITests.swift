//
//  SearchAppAAUITests.swift
//  SearchAppAAUITests
//
//  Created by Maryam on 7/4/25.
//

import XCTest

final class SearchAppAAUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        
        XCUIDevice.shared.orientation = .portrait
    }
    
    func test_flowToDetailsAndComeback() throws {
        let searchField = app.textFields["searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        
        searchField.tap()
        searchField.typeText("inception")
        
        let firstRow = app.buttons["movieRow_0"]
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5))

        firstRow.tap()
        
        let backButton = app.buttons["detailBackButton"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 2))
        
        backButton.tap()
        
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
    }
}
