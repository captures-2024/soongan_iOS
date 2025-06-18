//
//  ReportRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct ReportRequestDTO: Encodable {
    let targetId: Int
    let targetType: String
    let reportType: String
    let reason: String
}
