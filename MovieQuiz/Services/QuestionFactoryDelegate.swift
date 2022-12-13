import Foundation
// создаем протокол, который используем в фабрике как делегат и объявляем метод, который должен быть у делегата фабрики
protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузки с сервера
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
