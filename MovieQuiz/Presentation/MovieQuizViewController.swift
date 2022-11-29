import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: Private Outlet Variables
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: Private Variables
    private var correctAnswers: Int = 0         //переменная, отвечающая за количество правильных ответов
    private let questionsAmount: Int = 10        //переменная отвечающая за количество вопросов в квизе
    private var questionFactory: QuestionFactoryProtocol? //инъекция протокола QuestionFactory через свойство
    private var currentQuestion: QuizQuestion?          //переменная отвечающая за настоящий вопрос
    private var currentQuestionIndex = 0                //переменная отвечающая за индекс вопроса
    private var alert: AlertProtocol?                   //инъекция протокола AlertProtocol через свойство
    private var statisticService: StatisticService?     //инъекция протокола StatisticService через свойство
    
    
    
    //MARK: Private Functions
    //метод определяющий правильность ответа на вопрос
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect  {                                 // если ответ правильный
            correctAnswers += 1                         // +1  к переменной правильных ответов
        }
        
        imageView.layer.masksToBounds = true        //закругление углов картинки
        imageView.layer.borderWidth = 8             //ширина доп рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor //в зависимости                                               от правильности ответов рамка цвета зеленого или красного
        imageView.layer.cornerRadius = 20                   //радиус закругления
        self.yesButton.isEnabled = false                    // кнопка да недоступна
        self.noButton.isEnabled = false                     // кнопка нет недоступна
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in //диспетчер очереди работающий через секунду после нажатия
            guard let self = self else { return }
            self.showNextQuestionOrResults()                    //метод показывающий следующий вопрос или результат
            self.noButton.isEnabled = true                     // кнопка нет доступна
            self.yesButton.isEnabled = true                     // кнопка да доступна
            self.imageView.layer.borderColor = .none             //убирается цвет рамки ответа
            self.imageView.layer.borderWidth = 0                // ширина рамки снова 0
        }
    }
        //метод показывающий вопрос в квизе
    private func show(quiz step: QuizStepViewModel ) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.layer.cornerRadius = 20                           
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        
    }
    // метод который вызывает индикатор загрузки
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    // метод который скрывает индикатор загрузки
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
 
    // метод, который показывает ошибку при загрузке данных
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let title = "Ошибка!"
        let buttonText = "Попробовать еще раз"
        let errorAlert = AlertModel(title: title,
                                    buttonText: buttonText,
                                    completion: { [weak self] in
            guard let self = self else { return }
            self.viewDidLoad()
        }
            )
        alert?.show(results: errorAlert)
    }
        //метод показывающий следующий вопрос или результат через алерт
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // сохраняем значения правильных ответов за этот раунд и количества вопросов за этот раунд
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
           
            guard let bestGame = statisticService?.bestGame else {
                return
            }
            guard let gamesCount = statisticService?.gamesCount else {
                return
            }
            guard let totalAccuracy = statisticService?.totalAccuracy else {
                return
            }
            
            let title = "Этот раунд окончен!"
            let buttonText = "Сыграть еще раз"
            let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыграных квизов: \(gamesCount) \n Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString)) \n Средняя точность: \(String(format:"%.2f", totalAccuracy))%"
            
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
            
            alert?.show(results: alertModel)
            
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            
        }
    }
    
    private func convert(model:QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber:"\(currentQuestionIndex + 1 )/\(questionsAmount)")
        
    }
    //  метод успешной загрузки с сервера
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    //метод при ошибки загрузки с сервера
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
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
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MovieLoader())
        showLoadingIndicator()
        imageView.layer.cornerRadius = 20
        questionFactory?.loadData()
        alert = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
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
