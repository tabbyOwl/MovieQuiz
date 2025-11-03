//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Svetlana on 2025/11/3.
//

import Foundation

final class StatisticService {
    // MARK: - Private properties
    private let storage: UserDefaults = .standard
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            let totalCorrectAnswers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
            let newTotalCorrectAnswers = totalCorrectAnswers + newValue
            storage.set(newTotalCorrectAnswers, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            let totalQuestionsAsked = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
            let newTotalQuestionsAsked = totalQuestionsAsked + newValue
            storage.set(newTotalQuestionsAsked, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    // MARK: - Keys
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
}

// MARK: - StatisticServiceProtocol
extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            let currentGamesCount = storage.integer(forKey: Keys.gamesCount.rawValue)
            let newGamesCount = currentGamesCount + 1
            storage.set(newGamesCount, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue)
            return GameResult(correct: correct, total: total, date: date as? Date ?? Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100
    }
    
    func store(correct: Int, total: Int) {
        gamesCount += 1
        totalCorrectAnswers = correct
        totalQuestionsAsked = total
        
        let currentGameResult = GameResult(correct: correct, total: total, date: Date())
        if currentGameResult.isBetterThan(bestGame) {
            bestGame = currentGameResult
        }
    }
}
