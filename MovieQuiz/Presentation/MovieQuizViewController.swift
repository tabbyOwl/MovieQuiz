import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    // MARK: - Private properties
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false)
    ]
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        let firstQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
    }
    
    // MARK: - Private methods
    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
    private func updateBorder(isCorrect: Bool) {
        let borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderColor = borderColor
        imageView.layer.borderWidth = 8
    }
    
    private func removeBorder() {
        imageView.layer.borderWidth = 0
    }
    
    private func disableAnswerButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func enableAnswerButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return quizStepViewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        updateBorder(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            removeBorder()
            show(quiz: viewModel)
        }
        enableAnswerButtons()
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.removeBorder()
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - @IBAction
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableAnswerButtons()
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableAnswerButtons()
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    // MARK: - Models
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
}
