//
//  LoginRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct LoginRequestDTO: Encodable {
    let provider: String
    let idToken: String
    let fcmToken: String
    
    public init(provider: String, idToken: String, fcmToken: String) {
        self.provider = provider
        self.idToken = idToken
        self.fcmToken = fcmToken
    }
}
