//
//  UIWindow.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation
import UIKit

public extension UIWindow {
    func replaceRootViewController(with replacementController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Swift.Void)?) {
        let snapshotImageView = UIImageView(image: snapshot())
        addSubview(snapshotImageView)
        
        // dismiss all modal view controllers
        let dismissCompletion: (() -> Swift.Void) = { [weak self] in
            self?.rootViewController = replacementController
            self?.bringSubviewToFront(snapshotImageView)
            if animated {
                UIView.animate(withDuration: 0.4, animations: {
                    snapshotImageView.alpha = 0.0
                }, completion: { _ in
                    snapshotImageView.removeFromSuperview()
                    completion?()
                })
            } else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        
        guard let _ = rootViewController?.presentedViewController else {
            dismissCompletion()
            return
        }
        
        rootViewController?.dismiss(animated: false, completion: dismissCompletion)
    }
    
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(rootViewController)
    }

    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}
