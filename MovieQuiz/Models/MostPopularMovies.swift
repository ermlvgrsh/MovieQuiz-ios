import Foundation
// создаем структуру, которая дублирует компоновку JSON -  принимает два значения, errorMessage и items
// добавляем протокол Codable чтобы можно было преобразовать JSON в Swift-структуру
struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}
// структура которая будет преобразовывать JSON формат фильма в Swift
struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL : URL {
        //создаем строку из адреса
        let urlString = imageURL.absoluteString
        //обрезаем лишнюю часть и добавляем модификатор желаемого качества
        let imageURLString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        //создаем новую строку, если не получается - возвращаем старую
        guard let newURL = URL(string: imageURLString) else {
            return imageURL
            
        }
        return newURL
    }
    
    
    // берем поля из JSON и преобразуем в название нашей структуры
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}

