import Foundation
import UIKit
// создаем структуру, которая реализует протокол AlertProtocol
struct AlertPresenter: AlertProtocol {

    weak var viewController: UIViewController?              //создаем экземпляр вьюконтроллера
    
    init(viewController: UIViewController?) {               //инъектируем вьюконтроллер через свойство
        self.viewController = viewController
        
    }
    //создаем метод для показа алертмодели в конце квиза
      func show(results: AlertModel) {
          let alert = UIAlertController(title: results.title,
                                        message: results.message,
                                        preferredStyle: .alert)
        
        let action = UIAlertAction(title: results.buttonText,
                                   style: .default,
                                   handler: {_ in
            results.completion()
            
        }
        )
          
          alert.view.accessibilityIdentifier = "Alert Result"
          alert.addAction(action) // добавляем 
        viewController?.present(alert, animated: true, completion: nil)
          
      }


//    func restart() {
//        let questionProtocol : QuestionFactoryProtocol = viewController as! QuestionFactoryProtocol
//        questionProtocol.requestNextQuestion()
//    }
}
    
    
    
 
