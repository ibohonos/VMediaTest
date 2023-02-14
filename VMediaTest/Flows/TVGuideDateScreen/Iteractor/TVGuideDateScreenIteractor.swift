//
//  TVGuideDateScreenIteractor.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 14.02.2023.
//

import Foundation

protocol TVGuideDateScreenIteractorDelegate: AnyObject {
    func didGetError(message: String?)
    func didGetPrograms(response: [ProgramItem])
}

final class TVGuideDateScreenIteractor {
    // MARK: - Properties
    private let delegate: TVGuideDateScreenIteractorDelegate?
    
    init(delegate: TVGuideDateScreenIteractorDelegate) {
        self.delegate = delegate
    }
    
    func loadProgramList() {
        let request = TVGuideRequest.getProgramItems
        
        NetworkManager.shared().perform(request: request, of: [ProgramItem].self) { [weak self] response, error in
            // Checking for errors
            if let error {
                let message = error.errors ?? error.message
                self?.delegate?.didGetError(message: message)
                return
            }
            // Unwrapping data
            guard let response else {
                self?.delegate?.didGetError(message: "Data object is missing")
                return
            }
            
            self?.delegate?.didGetPrograms(response: response)
        }
    }
}
