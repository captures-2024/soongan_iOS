//
//  AppleLoginError.swift
//  CoreAppleLogin
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public enum AppleLoginError: Error {
    case noCredential              // 인증 정보 없음
    case userCancelled             // 사용자 취소
    case invalidResponse           // 잘못된 응답
    case networkError              // 네트워크 오류
    case unknown                   // 알 수 없는 오류
    
    public var localizedDescription: String {
        switch self {
        case .noCredential:
            return "인증 정보를 가져올 수 없습니다"
        case .userCancelled:
            return "사용자가 로그인을 취소했습니다"
        case .invalidResponse:
            return "잘못된 응답을 받았습니다"
        case .networkError:
            return "네트워크 연결에 문제가 있습니다"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다"
        }
    }
}
