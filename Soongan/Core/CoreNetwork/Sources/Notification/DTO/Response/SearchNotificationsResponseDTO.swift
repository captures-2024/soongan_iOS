//
//  SearchNotificationsResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchNotificationsResponseDTO: Decodable {
    let type: String
    let notifications: NotificationsInfoData
}

public struct NotificationsInfoData: Decodable {
    let id: Int
    let title: String
    let body: String
    let subType: String
    let isRead: Bool
    let redirectUrl: String
    let createdAt: String
}
