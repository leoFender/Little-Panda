import Foundation
import UIKit

extension UIViewController {
    
    func showEmergencyAlert(_ message: String,
                            isActive: Bool,
                            activateAction: ((UIAlertAction) -> Void)? = nil,
                            viewController: UIViewController) {
        let alert = UIAlertController(title: "Emergency Generator",
                                      message: "\n\(message)\n",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Activate",
                                     style: .default,
                                     handler: activateAction)
        
        let cancelAction = UIAlertAction(title: "Close",
                                         style: .cancel,
                                         handler: { _ in
                                            viewController.dismiss(animated: true, completion: nil)
        })
        
        if isActive {
            alert.addAction(okAction)
        }
        alert.addAction(cancelAction)
        alert.view.tintColor = UIColor.systemPurple
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
