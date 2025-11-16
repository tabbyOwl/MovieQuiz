//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Svetlana on 2025/10/31.
//
import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    // MARK: - Private properties
    private var movies: [MostPopularMovie] = []
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoadingProtocol
    
    // MARK: - Init
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: - public methods
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadImage(with: error)
                }
                return
            }
            
            guard let questionData = self.makeRatingQuestion(for: movie) else { return }
            let question = QuizQuestion(image: imageData,
                                        text: questionData.text,
                                        correctAnswer: questionData.correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    // MARK: - private methods
    private func makeRatingQuestion(for movie: MostPopularMovie) -> (text: String, correctAnswer: Bool)? {
        guard let rating = Float(movie.rating) else {
            return nil
        }
        let isGreater = Bool.random()
        let text: String
        let correctAnswer: Bool
        
        let delta = Float.random(in: -1.0...1.0)
        let threshold = min(max(rating + delta, 7), 9.5)
        
        
        if isGreater {
            text = "Рейтинг этого фильма больше, чем \(round(threshold * 10) / 10)?"
            correctAnswer = rating > threshold
        } else {
            text = "Рейтинг этого фильма меньше, чем \(round(threshold * 10) / 10)?"
            correctAnswer = rating < threshold
        }
        return (text, correctAnswer)
    }
}
