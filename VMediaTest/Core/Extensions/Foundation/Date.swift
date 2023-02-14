//
//  Date.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 13.02.2023.
//

import Foundation

extension Date {
    var timeIntervalFromStartOfDay: TimeInterval {
        return timeIntervalSince(startOfDay)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var getDateComponents: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
    }
    
    var stingWithoutTime: String {
        return stringFormated(format: "dd.MM.yyyy")
    }
    
    var stingWithoutDate: String {
        return stringFormated(format: "HH:mm")
    }
    
    func stringFormated(format: String) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format

        return dateFormatter.string(from: self)
    }
}
