//
//  KakaoLoginError.swift
//  CoreKakaoLogin
//
//  Created by ParkJunHyuk on 5/26/25.
//

import Foundation

public enum KakaoLoginError: Error {
    case tokenIssueFailed          // 토큰 발급 실패
    case userInfoFailed           // 사용자 정보 조회 실패
    case userCancelled            // 사용자 취소
    case networkError             // 네트워크 오류
    case appNotInstalled          // 카카오톡 앱 미설치
    case unknown                  // 알 수 없는 오류
    
    public var localizedDescription: String {
        switch self {
        case .tokenIssueFailed:
            return "카카오 토큰 발급에 실패했습니다"
        case .userInfoFailed:
            return "카카오 사용자 정보 조회에 실패했습니다"
        case .userCancelled:
            return "사용자가 로그인을 취소했습니다"
        case .networkError:
            return "네트워크 연결에 문제가 있습니다"
        case .appNotInstalled:
            return "카카오톡 앱이 설치되지 않았습니다"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다"
        }
    }
}
