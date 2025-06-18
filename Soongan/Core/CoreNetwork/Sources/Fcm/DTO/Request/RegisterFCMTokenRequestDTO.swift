//
//  RegisterFCMTokenRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Foundation

public struct RegisterFCMTokenRequestDTO: Encodable {
    let token: String
    let deviceId: String
}
