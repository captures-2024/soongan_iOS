//
//  ReportResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct ReportResponseDTO: Decodable {
    let id: Int
    let reportMemberId: Int
    let targetMemberId: Int
    let targetId: Int
    let targetType: String
    let reportType: String
    let reason: String?
    let reportHistories: [ReportHistoryData]
}
