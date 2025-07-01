//
//  UnreadNotificationsResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/26/25.
//

import Foundation

public struct UnreadNotificationsResponseDTO: Decodable {
    public let count: Int
    public let type: String
}
