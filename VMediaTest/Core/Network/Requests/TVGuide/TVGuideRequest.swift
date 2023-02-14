//
//  TVGuideRequest.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation
import Alamofire

enum TVGuideRequest: BaseRequest {
    case getChannels
    case getProgramItems

    var method: HTTPMethod {
        switch self {
            case .getChannels, .getProgramItems:
                return .get
        }
    }

    var path: String {
        switch self {
            case .getChannels:
                return "/json/Channels"
            case .getProgramItems:
                return "/json/ProgramItems"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
            default:
                return .default
        }
    }
    
    var params: Parameters {
        switch self {
            default:
                return [:]
        }
    }
}
