//
//  SearchMyProfileResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchMyProfileResponseDTO: Decodable {
    let email: String
    let nickname: String
    let birthYear: Int
    let profileImageUrl: String
    let selfIntroduction: String
    let reportHistories: [ReportHistoryData]
}

public struct ReportHistoryData: Decodable {
    let id: Int
    let targetId: Int
    let targetType: String
}
