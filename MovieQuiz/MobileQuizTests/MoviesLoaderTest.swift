import XCTest
@testable import MovieQuiz

//создаем тестовую версию для сетевого клиента(Стаб)
struct StubNetworkClient: NetworkRouting {
    
    enum TestError: Error {     //тестовая ошибка
        case test
    }
    let emulateError: Bool
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            handler(.success(expectedResponse))
        }
        
    }
    private var expectedResponse: Data {
        """
                {
                   "errorMessage" : "",
                   "items" : [
                      {
                         "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
                         "fullTitle" : "Prey (2022)",
                         "id" : "tt11866324",
                         "imDbRating" : "7.2",
                         "imDbRatingCount" : "93332",
                         "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
                         "rank" : "1",
                         "rankUpDown" : "+23",
                         "title" : "Prey",
                         "year" : "2022"
                      },
                      {
                         "crew" : "Anthony Russo (dir.), Ryan Gosling, Chris Evans",
                         "fullTitle" : "The Gray Man (2022)",
                         "id" : "tt1649418",
                         "imDbRating" : "6.5",
                         "imDbRatingCount" : "132890",
                         "image" : "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg",
                         "rank" : "2",
                         "rankUpDown" : "-1",
                         "title" : "The Gray Man",
                         "year" : "2022"
                      }
                    ]
                  }
                """.data(using: .utf8) ?? Data()
        
    }
    
}


final class MoviesLoaderTest: XCTestCase {
    
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false) //экземпляр, не эмулируем ошибку
        let loader = MovieLoader(networkClient: stubNetworkClient)
        
        // When
        
        // так как функция загрузки фильмов — асинхронная, нужно ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                // сравниваем данные с тем, что мы предполагали
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
       
       waitForExpectations(timeout: 1)
    }
    func testFailureLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MovieLoader(networkClient: stubNetworkClient)
        
        //When
        let expectation = expectation(description: "Failure expectation")
        
        loader.loadMovies { result in
        //Then
            switch result {
            case.success(_):
                XCTFail("Unexpected success")
            case.failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}