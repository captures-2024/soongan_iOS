//
//  SearchNotificationsResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchNotificationsResponseDTO: Decodable {
    public let type: String
    public let notifications: [NotificationsInfoData]
}

public struct NotificationsInfoData: Decodable {
    public let id: Int
    public let title: String
    public let body: String
    public let subType: String
    public let isRead: Bool
    public let redirectUrl: String
    public let createdAt: String
}
