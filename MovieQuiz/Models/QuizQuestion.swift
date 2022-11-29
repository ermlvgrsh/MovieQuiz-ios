import Foundation

struct QuizQuestion { // создаем структуру, которую будем использовать для конвертации в вопрос и помогающую определить правильность ответа 
    let image: Data                             //изменили на Data чтобы подгружать картинку удаленно 
    let text: String
    let correctAnswer: Bool
}
