import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

// отвечает за загрузку данных URL
struct NetworkClient: NetworkRouting {
    // создали свою реализацию протокола Error, чтобы обозначить на тот случай если произойдет ошибка
    private enum NetworkError: Error {
        case codeError
    }
        // функция которая будет загружать что-то по заранее заданному URL, нужен только адрес
    func fetch (url: URL, handler: @escaping (Result<Data, Error> ) -> Void ) { //функция отдает результат асинхронно через замыкание handler   /|\ означает что на результат нам может придти либо успех, либо ошибка, т.к. это энум у которого два кейса
        
        let request = URLRequest(url: url) // создали запрос из URL
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // проверяем пришла ли ошибка
                // т.к. все ответы(data, response, error) приходят в опционале, мы распаковываем каждый из вариантов
            if let error = error {
                handler(.failure(error)) // тоже самое что и Result.failure(error)
                return // дальше продолжать не имеет смысла, поэтому заканчиваем выполнение кода
            }
            //если дошли досюда - значит сервер прислал ответ узнаем, каков он по коду ответа
            // проверяем пришел ли нам успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 && response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            } // возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
                
            }
      
        task.resume()
      
    }
}
