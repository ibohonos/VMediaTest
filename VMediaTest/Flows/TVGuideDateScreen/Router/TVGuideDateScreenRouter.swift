//
//  TVGuideDateScreenRouter.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 14.02.2023.
//

import Foundation

protocol TVGuideDateScreenRouter: AnyObject {
    func showTVGuide(programs: [ProgramItem])
}

extension TVGuideDateScreenViewController: TVGuideDateScreenRouter, BaseView {
    func showTVGuide(programs: [ProgramItem]) {
        push(module: TVGuideScreenModule(programs: programs))
    }
}
