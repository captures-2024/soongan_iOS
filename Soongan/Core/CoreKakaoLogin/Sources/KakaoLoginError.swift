//
//  KakaoLoginError.swift
//  CoreKakaoLogin
//
//  Created by ParkJunHyuk on 5/26/25.
//

import Foundation

public enum KakaoLoginError: Error {
    case tokenIssueFailed
    case userInfoFailed
    case unknown
}
