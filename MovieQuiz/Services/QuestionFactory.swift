import Foundation



class QuestionFactory: QuestionFactoryProtocol { // создаем класс фабрики вопросов и через наследование наследуем протокол
   
    weak var delegate: QuestionFactoryDelegate? // создаем свойство, реализующее QuestionFactoryDelegate через инъекцию зависимостей через свойство
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate

    }

    func requestNextQuestion() { // функция протокола QuestionFactoryProtocol, которая запрашивает случайный вопрос и вызываем метод нашего делегата
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didRecieveNextQuestion(question: nil)
        return
        }
        let question = questions[safe: index]
        delegate?.didRecieveNextQuestion(question: question)
    }
   
        // через переменную создаем список вопросов квиза
    private let questions : [QuizQuestion] = [
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
   
}
