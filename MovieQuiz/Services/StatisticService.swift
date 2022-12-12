import Foundation

// создаем протокол для связи MQC с классом SSI
protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}
// создаем класс для хранения данных о результатах игр, используя протокол через наследование 
final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String { // создаем энум с ключами для более удобной работы с userDefaults
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var correct: Int {
        get { // устанавливаем переменную correct, отвечающую за общее количество правильных ответов
            let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
            //считываем в userDefaults значение всех правильных ответов по ключу энума
            return correctAnswers // возвращаем считанное значение
        }
        set { // сохраняем новое значение correct в userDefaults
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    private(set) var total: Int { // устанавливаем переменную total, отвечающую за общее количество вопросов
        get { //считываем в userDefaults значение общего количества вопросов
            let totalCorrectAnswers = userDefaults.integer(forKey: Keys.total.rawValue)
            return totalCorrectAnswers // возвращаем считанное значение
            
        }
        set { // сохраняем новое значение общего количества вопросов в userDefaults
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    private(set) var gamesCount: Int { // устанавливаем переменную, отвечающую за количество сыгранных игр
        get { // считываем в userDefaults значение общего количества сыгранных игр
              let gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
              return gamesCount // возвращаем считанное значение
          }
        set { // сохраняем новое значение в userDefaults
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
        
      }
    
    
    var totalAccuracy: Double { // устанавливаем переменную, вычисляющую среднюю точность правильных ответов
        get { // берем переменную из данного класса через self высчитываем и возвращаем
            return (Double(self.correct)/Double(self.total)) * 100
        }
        
    }
    
    private(set) var bestGame: GameRecord { // создаем переменную отвечающую за лучшую игру
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set { // с помощью JSONEncoder преобразуем структуру GameRecord которая хранится в переменной newValue в тип Data переменной data
            guard let data = try? JSONEncoder().encode(newValue) else {
            print("Невозможно сохранить результат!")
                return
                
        } // сохраняем переменную data в userDefaults
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)

        }
        
    }
    // создаем функцию, которая позволит хранить результаты каждого пройденного раунда
    func store(correct count: Int, total amount: Int) {
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        let counter = GameRecord(correct: count, total: amount, date: Date()) //экземпляр результата текущей игры
        if bestGame.compare(count:counter) {                // если результат текущей игры больше лучшего результата, то лучшему результату присваивается текущая игра со всеми параметрами
            bestGame = counter
        }
    
    }
    
    
}// создаем структуру, которая отвечает за лучший результат
struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    //создаем метод, который будет сравнивать лучший результат с результатом завершившегося раундом
    func compare (count: GameRecord) -> Bool {
        if count.correct > self.correct {
            return true
        } else {
            return false
        }

    }
    
}
