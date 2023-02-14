//
//  String.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 13.02.2023.
//

import Foundation

extension String {
    /// Default format = "yyyy-MM-dd'T'HH:mm:ssZ"
    var toDate: Date? {
        self.toDate()
    }
    
    /// Default format = "yyyy-MM-dd'T'HH:mm:ssZ"
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: self)

        return date
    }
}
