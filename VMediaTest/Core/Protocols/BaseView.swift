//
//  BaseView.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import UIKit

public protocol BaseView: AnyObject {
    func presentModal(module: BaseModule)
    func openAsRoot(module: BaseModule)
    func openAsRootNavigation(module: BaseModule)
    func push(module: BaseModule)
    func present(module: BaseModule)
    func presentAsRootNavigation(module: BaseModule)
}

public extension BaseView where Self: UIViewController {
    func presentModal(module: BaseModule) {
        let viewController = module.viewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true, completion: nil)
    }
    
    func openAsRoot(module: BaseModule) {
        let window: UIWindow? = UIApplication.shared.keyWindow
        window?.replaceRootViewController(with: module.viewController(), animated: true, completion: nil)
    }
    
    func openAsRootNavigation(module: BaseModule) {
        let window: UIWindow? = UIApplication.shared.keyWindow
        let navigationViewController = UINavigationController(rootViewController: module.viewController())
        window?.replaceRootViewController(with: navigationViewController, animated: true, completion: nil)
    }
    
    func push(module: BaseModule) {
        navigationController?.pushViewController(module.viewController(), animated: true)
    }
    
    func present(module: BaseModule) {
        navigationController?.present(module.viewController(), animated: true, completion: nil)
    }
    
    func presentAsRootNavigation(module: BaseModule) {
        let viewController = module.viewController().wrapped
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .coverVertical
        navigationController?.present(viewController, animated: true, completion: nil)
    }
}

