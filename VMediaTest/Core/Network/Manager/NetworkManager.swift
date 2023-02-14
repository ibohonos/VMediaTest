//
//  NetworkManager.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    // MARK: - Properties
    private let session: Session
    static let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BaseUrl") as! String
    private let reachabilityManager = NetworkReachabilityManager(host: baseUrl)
    
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager(session: Session())
        return networkManager
    }()
    
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    // MARK: - Init
    private init(session: Session) {
        self.session = session
    }
    
    // MARK: - Data request performer
    @discardableResult
    func perform<T: Codable>(request: BaseRequest, baseUrl: String = NetworkManager.baseUrl,
                             of type: T.Type,
                             completion: @escaping ((T?, NetworkErrorMessage?) -> Void)) -> Request {
        print("REQUEST: \(String(describing: try? request.asURLRequest())) \n\(String(describing: request.params)) \n\(request.headers)")
        
        return session.request(request)
            .responseDecodable(of: type) { [weak self] response in
                print(response.response?.statusCode ?? -1)
                switch response.result {
                    case let .success(result):
                        // Success completion
                        completion(result, nil)
                    case let .failure(error):
                        print(#function, String(data: response.data ?? .init(), encoding: .utf8) ?? "nil")
                        if let data = response.data,
                           let networkError = try? JSONDecoder().decode(NetworkErrorMessage.self, from: data) {
                            completion(nil, networkError)
                        } else if let networkError = self?.handleFailureResponse(error: error) {
                            completion(nil, networkError)
                        }
                }
            }
    }
}

// MARK: - Private
private extension NetworkManager {
    func getEncoding(request: BaseRequest) -> ParameterEncoding {
        var encoding: ParameterEncoding

        switch request.method {
            case .get:
                encoding = URLEncoding.default
            case .put:
                encoding = JSONEncoding.default
            case .post:
                encoding = JSONEncoding.default
            case .patch:
                encoding = JSONEncoding.prettyPrinted
            default:
                encoding = URLEncoding.default
        }

        return encoding
    }
    
    func isNetworkReachable() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    func handleFailureResponse(error: Error) -> NetworkErrorMessage {
        let networkErrors: NetworkErrorMessage
        if !isNetworkReachable() {
            networkErrors = .init(dictionary: ["message": "No internet connection"])
        } else {
            networkErrors = .init(dictionary: ["message": error.localizedDescription])
        }
        return networkErrors
    }
}
