//
//  MovieQuizPresenterTests.swift
//  MovieQuiz
//
//  Created by Svetlana on 2025/11/25.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func highlightImageBorder(isCorrect: Bool) {}
    
    func removeBorder() {}
    
    func showImageLoadError(message: String) {}
    
    func show(quiz step: QuizStepViewModel) {}
    
    func showAlert(quiz result: QuizResultsViewModel) {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func showNetworkError(message: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
