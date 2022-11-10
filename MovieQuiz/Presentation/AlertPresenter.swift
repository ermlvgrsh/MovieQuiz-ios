import Foundation
import UIKit

struct AlertPresenter: AlertProtocol {
    
    weak var viewController: UIViewController?
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
      func show(results: AlertModel) {
        let alert = UIAlertController(title: results.title,
                                      message: results.buttonText,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: results.buttonText,
                                   style: .default,
                                   handler: {_ in
            results.completion()
                    }
        )
          
          
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
  
    
}
    
    
    
 
