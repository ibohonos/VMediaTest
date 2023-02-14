//
//  NetworkErrorMessage.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation

// MARK: - NetworkErrorMessage
struct NetworkErrorMessage: Codable, Error {
    var message: String?
    var code: Int?
    var errorsArray: [String]?
    var errors: String? {
        get {
            var messageString = ""
            if let message = message {
                messageString = message
            }
            guard let errors = errorsArray else { return messageString }
            if let result = executeStrings(fromArray: errors) {
                messageString = messageString + "\n" + result
            }
            return messageString
        }
    }
    
    init(dictionary dict: NSDictionary) {
        message = dict["message"] as? String
        code = dict["code"] as? Int
        errorsArray = executeErrors(dict)
    }
}

// MARK: - Private
private extension NetworkErrorMessage {
    func executeErrors(_ dict: NSDictionary) -> [String]? {
        guard let errors = dict["errors"] as? [String: [String]] else {
            return nil
        }
        var stringErrors: [String] = []
        for (_, value) in errors {
            guard let str = executeStrings(fromArray: value) else { continue }
            stringErrors.append(str)
        }
        return stringErrors.isEmpty ? nil : stringErrors
    }
    
    func executeStrings(fromArray arr: [String]) -> String? {
        var resultString = ""
        for i in 0..<arr.count {
            if i == arr.count - 1 {
                resultString += "\(arr[i])"
                continue
            }
            resultString += "\(arr[i])\n"
        }
        return resultString.isEmpty ? nil : resultString
    }
}
