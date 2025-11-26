//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Svetlana on 2025/11/17.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    // MARK: - Tests

    func testYesButton() {
        // Given
        sleep(8)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        // When
        app.buttons["Yes"].tap()
        sleep(3)
        
        // Then
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        // Given
        sleep(8)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        // When
        app.buttons["No"].tap()
        sleep(3)
        
        // Then
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertAppears() {
        // Given
        sleep(8)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        // When
        let alert = app.alerts["Game result"]
       // let sheet = app.sheets["Game result"]

       // let dialog = alert.exists ? alert : sheet
        
        // Then
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        // Given
        sleep(8)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(5)
        }
        
        let alert = app.alerts["Game result"]
       // let sheet = app.sheets["Game result"]

       // let dialog = alert.exists ? alert : sheet
        
        // When
        sleep(3)
        alert.buttons.firstMatch.tap()
        sleep(5)
        
        // Then
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
