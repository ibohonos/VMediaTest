//
//  TVGuideDateScreenEntity.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 14.02.2023.
//

import Foundation

struct RecentAirTime: Codable, Identifiable, Hashable {
    let id: Int
    let channelID: Int
}

struct ProgramItem: Codable, Identifiable, Hashable {
    var id: Int {
        recentAirTime.id
    }
    
    let name: String
    let length: Double
    let startTime: String
    let recentAirTime: RecentAirTime
}
