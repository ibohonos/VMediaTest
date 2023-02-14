//
//  UIStoryboard.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func loadView<T: UIViewController>(storyboard: String = "Main") -> T {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: T.stringValue) as! T
    }
}
