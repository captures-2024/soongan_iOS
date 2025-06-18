//
//  KakaoLoginServiceProtocol.swift
//  CoreKakaoLogin
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Foundation

public protocol KakaoLoginServiceProtocol {
    func login() async throws -> String
}
