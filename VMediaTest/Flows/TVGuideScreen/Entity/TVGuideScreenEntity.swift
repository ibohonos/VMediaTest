//
//  TVGuideScreenEntity.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation

struct Channel: Codable, Identifiable, Hashable {
    let id: Int
    
    let CallSign: String
    let accessNum: Int
    let orderNum: Int
}

struct ChannelSection: Hashable {
    let channel: Channel
    let programs: [ProgramItem]
}
