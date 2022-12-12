import XCTest
@testable import MovieQuiz

final class MovieQuizControllerProtocolMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func imageBorderAppearence(isCorrect: Bool) {
        
    }
    
    func buttonEnable() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        let viewContollerMock = MovieQuizControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewContollerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
