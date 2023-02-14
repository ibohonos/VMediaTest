//
//  BaseRequest.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation
import Alamofire

protocol BaseRequest: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var params: Parameters { get }
    var headers: HTTPHeaders { get }
}

extension BaseRequest {
    var encoding: ParameterEncoding {
        var encoding: ParameterEncoding

        switch method {
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
    
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkManager.baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        for (headerField, headerValue) in headers.dictionary {
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }

        return try encoding.encode(urlRequest, with: params)
    }
}
