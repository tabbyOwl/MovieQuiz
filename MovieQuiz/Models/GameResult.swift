//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Svetlana on 2025/11/3.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
