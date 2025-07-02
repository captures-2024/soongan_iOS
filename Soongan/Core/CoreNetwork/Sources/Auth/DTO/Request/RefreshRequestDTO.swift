//
//  RefreshRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct RefreshRequestDTO: Encodable {
    let accessToken: String
    let refreshToken: String
}
