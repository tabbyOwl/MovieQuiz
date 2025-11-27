//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Svetlana on 2025/11/25.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showAlert(quiz result: QuizResultsViewModel)
    
    func removeBorder()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func highlightImageBorder(isCorrect: Bool)
    
    func showNetworkError(message: String)
    func showImageLoadError(message: String)
}
