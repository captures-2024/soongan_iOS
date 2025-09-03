//
//  PutWeeklyContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 5/14/25.
//

import Foundation

public struct PutWeeklyContestResponseDTO: Codable {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}