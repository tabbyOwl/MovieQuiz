import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - @IBOutlet
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    // MARK: - Private properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory

        self.questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
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
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            showAlert(quiz: viewModel)
        } else {
            removeBorder()
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
        enableAnswerButtons()
    }
    
    private func showAlert(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            removeBorder()
            questionFactory?.requestNextQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - @IBAction
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableAnswerButtons()
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableAnswerButtons()
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
}
