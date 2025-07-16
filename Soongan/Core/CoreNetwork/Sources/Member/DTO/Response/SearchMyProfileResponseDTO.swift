//
//  SearchMyProfileResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchMyProfileResponseDTO: Decodable {
    public let email: String
    public let nickname: String?
    public let birthYear: Int?
    public let profileImageUrl: String?
    public let selfIntroduction: String?
    public let reportHistories: [ReportHistoryData?]
}

public struct ReportHistoryData: Decodable {
    public let id: Int
    public let targetId: Int
    public let targetType: String
}
