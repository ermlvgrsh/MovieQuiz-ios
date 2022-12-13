import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let questionsAmount: Int = 10 //переменная отвечающая за количество вопросов в квизе
    private var currentQuestionIndex : Int = 0 //переменная отвечающая за индекс вопроса
    private var currentQuestion: QuizQuestion? //переменная отвечающая за настоящий вопрос
    private var correctAnswers: Int = 0 //переменная отвечающая за количество правильных ответов
    private var questionFactory: QuestionFactoryProtocol? // инъектируем протокола QuestionFactory
    var alert: AlertProtocol?
    private var statisticService : StatisticService!
    private weak var viewController: MovieQuizViewControllerProtocol? // инъектируем вьюконтроллер
    init(viewController: MovieQuizViewControllerProtocol){
        self.viewController = viewController
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MovieLoader())
        questionFactory?.loadData()
        statisticService = StatisticServiceImplementation()
    }
    
    //MARK: Функции
    //переносим конвертирующий метод из вьюконтроллера
    func convert(model:QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber:"\(currentQuestionIndex + 1 )/\(questionsAmount)")
        
    }
    func yesButtonClicked() {           // метод нажатия кнопки да
        didAnswer(isYes: true)
    }
    func noButtonClicked() {            // метод нажатия кнопки нет
        didAnswer(isYes: false)
    }
    private func switchQuestionIndex() {     // метод переключения индекса вопрос
        currentQuestionIndex += 1
    }
    private func resetQuestionIndex() {      // метод сброса индекса вопроса
        currentQuestionIndex = 0
    }
    private func isLastQuestion() -> Bool {     // метод проверяющий является ли вопрос последний
        currentQuestionIndex == questionsAmount - 1
    }
    private func didAnswer(isYes: Bool) {    //вынесли повторяющийся метод ответа в общий                                                             метод ответа на вопрос
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    private func restartGame() {
        resetQuestionIndex()
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    //MARK: QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {  //вынесли метод делегата по                                                                 получению вопроса
        guard let question = question else  {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }

    //метод показывающий следующий вопрос или результат через алерт
    func proceedToTheQuestionOrResults() {
        if self.isLastQuestion() {
            showAlertResult()
        } else {
            self.switchQuestionIndex()
            questionFactory?.requestNextQuestion()
            
        }
    }
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        self.showNetworkError(message: message)
    }
    //метод определяющий правильность ответа на вопрос
    private func proceedWithAnswer(isCorrect: Bool) {
        self.didAnswer(isCorrectAnswer: isCorrect)
        viewController?.imageBorderAppearence(isCorrect: isCorrect)
        viewController?.buttonEnable()
    }
    // метод, который показывает ошибку при загрузке данных
    func showNetworkError(message: String) {
        let title = "Ошибка!"
        let buttonText = "Попробовать еще раз"
        let errorAlert = AlertModel(title: title,
                                    buttonText: buttonText,
                                    completion: { [weak self] in
            guard let self = self else { return }
            self.restartGame()
        }
        )
        alert?.show(results: errorAlert)
    }
    func showAlertResult() {
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
            self.restartGame()
        }
        )
        
        alert?.show(results: alertModel)
        
    }
}

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showLoadingIndicator()
    
    func imageBorderAppearence(isCorrect: Bool)
    
    func buttonEnable()
    func hideLoadingIndicator()
}
