//
//  ModuleInitializable.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import UIKit

public protocol BaseModule {
    func viewController() -> UIViewController
}

typealias ModuleInitializable = BaseModule & Initializable

protocol Initializable {
    init()
}

extension Initializable {
    static var stringValue: String {
        return String(describing: self)
    }
}
