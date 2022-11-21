import Foundation
import UIKit

    // создаем структуру, которая отвечает за показ алерта в конце каждого раунда 
struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: (() -> Void)
}
