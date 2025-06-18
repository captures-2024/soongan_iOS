//
//  RegisterFCMTokenResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Foundation

public struct RegisterFCMTokenResponseDTO: Encodable {
    let id: Int
    let token: String
    let deviceId: String
    let deviceType: String
}
