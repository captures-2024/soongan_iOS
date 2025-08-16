//
//  ContestIndexModel.swift
//  Shared
//
//  Created by ParkJunHyuk on 8/14/25.
//

import Foundation

public struct ContestIndexModel: Identifiable, Equatable {
    public var id: Int
    public var round: Int
    public var subject: String
    
    public init(id: Int, round: Int, subject: String) {
        self.id = id
        self.round = round
        self.subject = subject
    }
}
