//
//  UIViewController.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import UIKit

extension UIViewController {
    var wrapped: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    static var stringValue: String {
        return String(describing: self)
    }
    
    func presentError(message: String?, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
    
    func presentAlert(title: String, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
