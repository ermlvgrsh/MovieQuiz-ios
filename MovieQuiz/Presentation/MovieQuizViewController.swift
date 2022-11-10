import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{

    //MARK: Private Outlet Variables
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    
   //MARK: Private Variables
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var alertPresent : AlertProtocol?
    
    
    //MARK: Private Functions
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect  {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        self.yesButton.isEnabled = false
        self.noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.imageView.layer.borderColor = .none
            self.imageView.layer.borderWidth = 0
        }
    }
    private func show(quiz step: QuizStepViewModel ) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let title = "Этот раунд завершен!"
            let buttonText = "Сыграть еще раз"
            let text = correctAnswers == questionsAmount ?
            "Поздравляю! Вы ответили на 10 вопросов из 10!"
            : "Ваш результат \(correctAnswers) из 10, попробуйте еще раз"
            let alertModel = AlertModel(title: title,
                                        message: text,
                                        buttonText: buttonText,
                                        completion: { [weak self] in
                guard let self = self else { return }
                self.correctAnswers = 0
                self.currentQuestionIndex = 0
                self.questionFactory?.requestNextQuestion()
            }
        )
                alertPresent?.show(results: alertModel)
               
            } else {
                currentQuestionIndex += 1
                questionFactory?.requestNextQuestion()
               
            }
        }
        
    
    private func convert(model:QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber:"\(currentQuestionIndex + 1 )/\(questionsAmount)")
        
    }
    
    
    //MARK: IBActions
    @IBAction func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let answerNo = false
        showAnswerResult(isCorrect: answerNo == currentQuestion.correctAnswer)
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let answerYes = true
        showAnswerResult(isCorrect: answerYes == currentQuestion.correctAnswer)
    }
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    //MARK: QuestionFactoryDelegate
   
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else  {
          return
        }
            currentQuestion = question
            let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
}
