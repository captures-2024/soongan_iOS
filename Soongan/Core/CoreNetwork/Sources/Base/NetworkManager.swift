//
//  NetworkManager.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Alamofire
import Foundation

struct EmptyResponseDTO: Decodable {}

public final actor NetworkManager {
    
    public static let shared = NetworkManager()
    
    private let session: Session
    
    private init() {
        let interceptor = AuthInterceptor()
        self.session = Session(interceptor: interceptor)
    }
    
    public func request<T: Decodable>(_ endpoint: APIEndpoint) async -> Result<T, NetworkError> {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        
        let parameters = try? endpoint.parameters.flatMap { encodable -> [String: Any]? in
            let data = try JSONEncoder().encode(encodable)
            return try JSONSerialization.jsonObject(with: data) as? [String: Any]
        }

        let dataTask = session.request(
            url,
            method: endpoint.method,
            parameters: parameters,
            encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default,
            headers: endpoint.headers
        )
        .validate(statusCode: 200..<300)
        .serializingData()
        
        print("🚀 \(T.self) API 호출 ==========================")
        let response = await dataTask.response
        
        print("➡️ StatusCode: \(String(describing: response.response?.statusCode))")
        
        switch response.result {
        case .success(let data):
            if T.self == EmptyResponseDTO.self {
                return .success(EmptyResponseDTO() as! T)
            } else {
                do {
                    let decoded = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                    print("➡️ \(T.self) API 결과 디코딩 성공 ==========================")
                    print(decoded.responseData)
                    
                    
                    print("✅ \(T.self) API 성공 ==========================")
                    return .success(decoded.responseData)
                } catch {
                    print("⚠️ \(T.self) API decodingFailed 에러 발생 ==========================")
                    print(error.localizedDescription)
                    return .failure(.decodingFailed(error))
                }
            }
            
        case .failure(let error):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 401:
                    print("⚠️ \(T.self) API unAuthorizedError 에러 발생 ==========================")
                    return .failure(.unAuthorizedError)
                case 400..<500, 500..<600:
                    return .failure(.httpResponseNotOK(statusCode: statusCode))
                default:
                    return .failure(.requestFailed(description: error.localizedDescription))
                }
            }
            
            print("❌ API 에러 발생: ==========================")
            print(error.localizedDescription)
            return .failure(.requestFailed(description: error.localizedDescription))
        }
    }
}
