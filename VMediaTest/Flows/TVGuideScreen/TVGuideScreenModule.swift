//
//  TVGuideScreenModule.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation
import UIKit

final class TVGuideScreenModule: ModuleInitializable {
    // MARK: - Properties
    private let view: TVGuideScreenViewController
    private let presenter: TVGuideScreenPresenterProtocol
    
    init() {
        view = UIStoryboard.loadView(storyboard: "TVGuide")
        presenter = TVGuideScreenPresenter(with: view, router: view)
        view.presenter = presenter
    }
    
    convenience init(programs: [ProgramItem]) {
        self.init()
        presenter.setPrograms(programs)
    }
    
    func viewController() -> UIViewController {
        return view
    }
}
