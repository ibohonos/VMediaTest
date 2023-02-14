//
//  TVGuideDateScreenModule.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 14.02.2023.
//

import Foundation
import UIKit

final class TVGuideDateScreenModule: ModuleInitializable {
    // MARK: - Properties
    private let view: TVGuideDateScreenViewController
    private let presenter: TVGuideDateScreenPresenterProtocol
    
    init() {
        view = UIStoryboard.loadView(storyboard: "TVGuide")
        presenter = TVGuideDateScreenPresenter(with: view, router: view)
        view.presenter = presenter
    }
    
    func viewController() -> UIViewController {
        return view
    }
}
