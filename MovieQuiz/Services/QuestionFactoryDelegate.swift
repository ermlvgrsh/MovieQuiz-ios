import Foundation
    // создаем протокол, который используем в фабрике как делегат и объявляем метод, который должен быть у делегата фабрики
protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)

}
