//
//  MovieQuizViewControllerMock.swift
//  MovieQuiz
//
//  Created by Svetlana on 2025/11/26.
//

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
