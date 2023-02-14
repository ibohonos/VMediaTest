//
//  UIView.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation
import UIKit

public extension UIView {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result
    }
    
    func snapshot(of rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        let drawRect = CGRect(x: -rect.origin.x,
                              y: -rect.origin.y,
                              width: bounds.size.width,
                              height: bounds.size.height)
        drawHierarchy(in: drawRect, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
