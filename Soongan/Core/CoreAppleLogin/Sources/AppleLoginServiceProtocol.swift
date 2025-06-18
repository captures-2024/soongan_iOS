//
//  AppleLoginServiceProtocol.swift
//  CoreAppleLogin
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Foundation

public protocol AppleLoginServiceProtocol {
    func login() async throws -> String
}
