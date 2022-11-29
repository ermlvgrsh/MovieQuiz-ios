import Foundation



class QuestionFactory: QuestionFactoryProtocol { // создаем класс фабрики вопросов и через наследование наследуем протокол
    private let moviesLoader : MovieLoading // добавляем наш загрузчик файлов как зависимость через свойство, тип протокол, потому что нам нужна только функция загрузки данных
    private var movies: [MostPopularMovie] = []                     //в этой переменной будем складывать фильмы                                                                                      загруженные с сервера
   private weak var delegate: QuestionFactoryDelegate? // создаем свойство, реализующее QuestionFactoryDelegate через инъекцию зависимостей через свойство
    init(delegate: QuestionFactoryDelegate, moviesLoader: MovieLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    func requestNextQuestion() { // функция протокола QuestionFactoryProtocol, которая запрашивает случайный вопрос и вызываем метод нашего делегата
        //запускаем код в отдельном потоке, чтобы работа с изображением и с сетью шла не только ассинхронно, но и в отдельных потоках, то есть не блокировала основной поток приложения своими задачами
        DispatchQueue.global().async { [weak self] in
            // выбираем произвольный элемент из массива чтобы показать его
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            //создаем данные из URL
            var imageData = Data()              //по умолчанию у нас будут просто пустые данные
            
            do {                                //создаем данные из URL 
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {                                   // обрабатываем ошибку
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0                  //превращаем строку в число
            
            let text = "Рейтинг этого фильма больше чем 7?"        //создаем вопрос
            let correctAnswer = rating > 7                         //определяем корректность вопроса
            
            let question = QuizQuestion(image: imageData,          //создаем модель вопроса
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in               //возвращаемся в главный поток
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question) // возвращаем вопрос через делегат
                
            }
        }
    }
    //загружаем данные о фильмах, воспользовавшись moviesLoader
    func loadData() {
        moviesLoader.loadMovies { result in
            DispatchQueue.main.async { [weak self] in           //переходим в главный поток используя конструкцию
                guard let self = self else { return }
                switch result {
            case .success(let mostPopularMovies):
                self.movies = mostPopularMovies.items // сохраняем фильм в новую переменную
                self.delegate?.didLoadDataFromServer() // сообщаем что данные загрузились
            case .failure(let error):
                self.delegate?.didFailToLoadData(with: error) //сообщаем об ошибке нашему MovieQuizController
            }
                
            }
        }
    }
    
    
}

  
  
   
        // через переменную создаем список вопросов квиза
//    private let questions : [QuizQuestion] = [
//        QuizQuestion(image: "The Godfather",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "The Dark Knight",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "Kill Bill",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "The Avengers",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "Deadpool",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "The Green Knight",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "Old",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: false),
//        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: false),
//        QuizQuestion(image: "Tesla",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: false),
//        QuizQuestion(image: "Vivarium",
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: false)
//    ]
   

