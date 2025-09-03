//
//  PutWeeklyContestRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/1/25.
//

import Foundation

public struct PutWeeklyContestRequestDTO: Codable {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}
