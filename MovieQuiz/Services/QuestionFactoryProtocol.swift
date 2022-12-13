import Foundation
// создаем протокол, который будет запрашивать следующий вопрос и используем его в фабрике
protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
}
