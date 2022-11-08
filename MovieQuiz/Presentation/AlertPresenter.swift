import Foundation
import UIKit

struct AlertPresenter: AlertProtocol {
    
    weak var viewController: UIViewController?
    
    func show(results: AlertModel) {
        let alert = UIAlertController(title: results.title,
                                      message: results.buttonText,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: results.buttonText,
                                   style: .default)
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
  
    
}
    
    
    
 
