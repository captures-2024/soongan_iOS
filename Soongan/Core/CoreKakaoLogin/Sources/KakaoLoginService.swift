//
//  KakaoLoginService.swift
//  Core
//
//  Created by ParkJunHyuk on 5/26/25.
//

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

public final class KakaoLoginService: NSObject, KakaoLoginServiceProtocol {
    public static let shared = KakaoLoginService()
    
    private override init() {}

    public func login() async throws -> String {
        let oauthToken = try await loginWithKakaoAppOrWeb()
        
        return oauthToken.accessToken
    }
}

private extension KakaoLoginService {
    @MainActor
    func loginWithKakaoAppOrWeb() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            
            print("✅ KakaoTalk 설치 여부: \(UserApi.isKakaoTalkLoginAvailable())")
            // 앱으로 로그인 시도
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { token, error in
                    if let token = token {
                        continuation.resume(returning: token)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: KakaoLoginError.tokenIssueFailed)
                    }
                }
            } else {
                // 웹으로 로그인
                UserApi.shared.loginWithKakaoAccount { token, error in
                    if let token = token {
                        continuation.resume(returning: token)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: KakaoLoginError.tokenIssueFailed)
                    }
                }
            }
        }
    }

    func fetchUserInfo() async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let user = user {
                    continuation.resume(returning: user)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: KakaoLoginError.userInfoFailed)
                }
            }
        }
    }
}
