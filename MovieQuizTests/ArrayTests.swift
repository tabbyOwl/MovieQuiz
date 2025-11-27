//
//  ArrayTests.swift
//  ArrayTests
//
//  Created by Svetlana on 2025/11/26.
//
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testSafeSubscriptReturnsValueWhenIndexIsValid() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testSafeSubscriptReturnsNilWhenIndexIsOutOfRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
}
