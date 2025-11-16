//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Svetlana on 2025/11/2.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailToLoadImage(with error: Error)
}
