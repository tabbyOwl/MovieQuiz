//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Svetlana on 2025/11/3.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct: Int, total: Int)
}
