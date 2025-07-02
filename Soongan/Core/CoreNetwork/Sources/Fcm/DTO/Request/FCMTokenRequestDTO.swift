//
//  FCMTokenRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/18/25.
//

import Foundation

public struct FCMTokenRequestDTO: Encodable, QueryParameterConvertible {
    let fcmToken: String
}
