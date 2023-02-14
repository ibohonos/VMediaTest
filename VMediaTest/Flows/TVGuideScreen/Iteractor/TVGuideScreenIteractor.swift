//
//  TVGuideScreenIteractor.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation

protocol TVGuideScreenIteractorDelegate: AnyObject {
    func didGetError(message: String?)
    func didGetChannels(response: [Channel])
}

final class TVGuideScreenIteractor {
    // MARK: - Properties
    private let delegate: TVGuideScreenIteractorDelegate?
    
    init(delegate: TVGuideScreenIteractorDelegate) {
        self.delegate = delegate
    }
    
    func loadChannelList() {
        let request = TVGuideRequest.getChannels

        NetworkManager.shared().perform(request: request, of: [Channel].self) { [weak self] response, error in
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
            
            self?.delegate?.didGetChannels(response: response)
        }
    }
}
