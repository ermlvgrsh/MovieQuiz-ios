import Foundation
    // создаем протокол, который будет связывать наш AlertPresenter с MovieQuiz и объявляем метод, который будет показывать наш алерт 
protocol AlertProtocol  {
    func show(results: AlertModel)
}
