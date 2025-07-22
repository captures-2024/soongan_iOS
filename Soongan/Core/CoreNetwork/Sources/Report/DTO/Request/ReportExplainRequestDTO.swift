//
//  ReportExplainRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 7/17/25.
//

import Foundation

public struct ReportExplainRequestDTO: Encodable {
    let targetId: Int
    let targetType: String
    let explain: String
    
    public init(targetId: Int, targetType: String, explain: String) {
        self.targetId = targetId
        self.targetType = targetType
        self.explain = explain
    }
}
