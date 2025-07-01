//
//  NetworkManager.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Alamofire
import Foundation

public struct EmptyResponseDTO: Decodable {}

public struct APIRouter: URLRequestConvertible {
    public let endpoint: APIEndpoint

    public init(endpoint: APIEndpoint) {
        self.endpoint = endpoint
    }
    
    public func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path))
        urlRequest.method = endpoint.method
        urlRequest.headers = endpoint.headerType.headers

        // Body
        if let body = endpoint.body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }

        // QueryParameters
        if let queryParameters = endpoint.queryParameters, !queryParameters.isEmpty {
            var components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)!
            components.queryItems = queryParameters
            urlRequest.url = components.url
        }

        return urlRequest
    }
}

public final actor NetworkManager {
    
    public static let shared = NetworkManager()
    
    private let session: Session
    
    private init() {
        let interceptor = AuthInterceptor()
        self.session = Session(interceptor: interceptor, eventMonitors: [NetworkLogger()])
    }
    
    public func request<T: Decodable>(_ endpoint: APIEndpoint) async -> Result<T, NetworkError> {
        let dataTask = session.request(APIRouter(endpoint: endpoint))
            .validate(statusCode: 200..<300)
            .serializingDecodable(APIResponse<T>.self)
        
        print("🚀 \(T.self) API 호출 ==========================")
        let response = await dataTask.response
        
        switch response.result {
        case .success(let decodedResponse):
            // EmptyResponseDTO 인 경우 처리
            if T.self == EmptyResponseDTO.self {
                return .success(EmptyResponseDTO() as! T)
            } else {
                return .success(decodedResponse.responseData)
            }
            
        case .failure(let error):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 401:
                    print("⚠️ \(T.self) API unAuthorizedError 에러 발생 ==========================")
                    return .failure(.unAuthorizedError)
                case 400..<500, 500..<600:
                    print("⚠️ \(T.self) API httpResponseNotOK 에러 발생 ==========================")
                    return .failure(.httpResponseNotOK(statusCode: statusCode))
                default:
                    break
                }
            }
            
            print("❌ \(T.self) API 에러 발생 ==========================")
            print(error.localizedDescription)
            return .failure(.requestFailed(description: error.localizedDescription))
        }
    }
}
