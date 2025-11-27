//
//  MoviesLoaderTests.swift
//  MovieQuiz
//
//  Created by Svetlana on 2025/11/16.
//

import XCTest
@testable import MovieQuiz


final class MoviesLoaderTests: XCTestCase {
    
    private var sut: MoviesLoader!
    private var networkMock: StubNetworkClientMock!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        networkMock = nil
        super.tearDown()
    }
    
    private func makeSUT(emulateError: Bool) {
        networkMock = StubNetworkClientMock(emulateError: emulateError)
        sut = MoviesLoader(networkClient: networkMock)
    }
    
    func testSuccessLoading() {
        // Given
        makeSUT(emulateError: false)
        let expectation = expectation(description: "Movies successfully loaded")
        
        // When
        sut.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
            case .failure:
                XCTFail("Unexpected failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() {
        // Given
        makeSUT(emulateError: true)
        let expectation = expectation(description: "Movies loading failed")
        
        // When
        sut.loadMovies { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                XCTFail("Unexpected success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}
