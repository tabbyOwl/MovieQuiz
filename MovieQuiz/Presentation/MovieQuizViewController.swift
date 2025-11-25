import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var textLabel: UILabel!
    
    // MARK: - Private properties
    private let alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        setupImageView()
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        let borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderColor = borderColor
        imageView.layer.borderWidth = 8
    }
    
    func removeBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func show(quiz step: QuizStepViewModel) {
        enableAnswerButtons()
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Alerts
    func showAlert(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText,
                                    accessabilityId: "Game result") { [weak self] in
            guard let self else { return }
            presenter?.restartGame()
        }
        alertPresenter.show(viewController: self, model: alertModel)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(title: "Что-то пошло не так(",
                                    message: message,
                                    buttonText: "Попробовать еще раз",
                                    accessabilityId: "NetworkError") { [weak self] in
            self?.showLoadingIndicator()
            self?.presenter?.restartGame()
        }
        alertPresenter.show(viewController: self, model: alertModel)
    }
    
    func showImageLoadError(message: String) {
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Повторить",
                                    accessabilityId: "ImageLoadError") { [weak self] in
            guard let self else { return }
            self.presenter?.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.show(viewController: self, model: alertModel)
    }
    
    // MARK: - Private methods
    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    private func disableAnswerButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func enableAnswerButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    // MARK: - @IBAction
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableAnswerButtons()
        presenter?.noButtonClicked(sender)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableAnswerButtons()
        presenter?.yesButtonClicked(sender)
    }
    
}
