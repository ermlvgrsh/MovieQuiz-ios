import Foundation
// создаем протокол для загрузчика файлов
protocol MovieLoading {
    func loadMovies (handler: @escaping (Result <MostPopularMovies, Error>) -> Void)
}

// создаем структуру загрузчик, реализующую протокол загрузки файлов
struct MovieLoader: MovieLoading {
    //MARK: создаем переменную отвечающую за создание запросов в API IMDb
    private let networkClient = NetworkClient()
    
    //MARK: создаем переменную которая будет хранить в себе URL на который мы будем производить запрос
    private var mostPopularMoviesURL: URL {
        //Если мы не смогли преобразовать строку в URL, то приложение упадет с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_0p5qt20v") else {
            preconditionFailure("Unable to construct mostPopularMoviesURL")
        }
        return url
    }

    //создаем функции по загрузке фильмов из сети
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        //        Используйте переменные networkClient и mostPopularMoviesUrl.
        //        В замыкании обработайте ошибочное состояние и передайте его дальше в handler.
        //        Преобразуйте данные в MostPopularMovies, используя JSONDecoder.
        //        Верните их, используя handler.
        let decoder = JSONDecoder()
        //  берем переменную networkClient, вызываем у нее метод и передаем mostPopularMoviesURl
        //в handler передаем замыкание в котором обрабатываем возможные успешные и ошибочные состояния
        networkClient.fetch(url: mostPopularMoviesURL, handler: { result in
            switch result {
            case .success(let data): guard let movies = try? decoder.decode(MostPopularMovies.self, from: data) else { return }
                handler(.success(movies))
            case .failure(let error): print("Failed to decode: \(error)")
                handler(.failure(error))
                
            }
            
        }
        )
        
    }
    
}
