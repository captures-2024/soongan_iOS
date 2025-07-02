//
//  AuthInterceptor.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Foundation

import CoreKeyChain

import Alamofire

final class AuthInterceptor: RequestInterceptor {
    
    private let retryLimit = 1
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var urlRequest = urlRequest
        
        if let headerType = urlRequest.value(forHTTPHeaderField: "X-Header-Type") {
            if headerType == "accessToken" {
                if let token = KeychainManager.shared.load(key: .accessToken) {
                    urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
            }
        }
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }

        if let response = request.task?.response as? HTTPURLResponse,
           response.statusCode == 401 {

            print("🔄 토큰 만료 → refresh 시도")

            Task {
                let isSuccess = await self.refreshAccessToken()
                if isSuccess {
                    print("✅ 토큰 재발급 성공 → 재시도")
                    completion(.retry)
                } else {
                    print("❌ 토큰 재발급 실패 → 중단")
                    completion(.doNotRetry)
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
}

private extension AuthInterceptor {
    func refreshAccessToken() async -> Bool {
        print("🚀 토큰 재발급 API 호출 ==========================")
        
        guard let refreshToken = KeychainManager.shared.load(key: .refreshToken),
              let accessToken = KeychainManager.shared.load(key: .accessToken) else {
            print("❌ refreshToken 없음 → 재발급 불가")
            return false
        }
        
        let endpoint = AuthEndpoint.patchRefresh(RefreshRequestDTO(accessToken: accessToken, refreshToken: refreshToken))

        let dataTask = Session.default.request(APIRouter(endpoint: endpoint))
           .validate(statusCode: 200..<300)
           .serializingDecodable(APIResponse<AuthedResponseDTO>.self)
        
        let response = await dataTask.response

        print("➡️ StatusCode: \(String(describing: response.response?.statusCode))")
        
        switch response.result {
        case .success(let apiResponse):
            let refreshResult = apiResponse.responseData
            
            KeychainManager.shared.save(key: .accessToken, value: refreshResult.accessToken)
            KeychainManager.shared.save(key: .refreshToken, value: refreshResult.refreshToken)
            
            return true

        case .failure(let error):
            print("4️⃣ Refresh API 에러 발생 ==========================")
            print("\(error)")
            return false
        }
    }
}
