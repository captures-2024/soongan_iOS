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
        
        print("🚀 \(T.self) API 호출 ==========================")
        
        // requestBodyType에 따라 분기
       switch endpoint.requestBodyType {
       case .json:
           let dataTask = session.request(APIRouter(endpoint: endpoint))
               .validate(statusCode: 200..<300)
               .serializingDecodable(APIResponse<T>.self)
           
           let response = await dataTask.response
           return handleResponse(response)

       case .formData:
           guard let multipartBody = endpoint.body as? MultipartRequestable else {
               return .failure(.requestFailed(description: "Multipart body is not configured correctly."))
           }
           
           let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
           
           let dataTask = session.upload(
               multipartFormData: { formData in
                   // 텍스트 파트 추가
                   for (key, value) in multipartBody.textParts {
                       formData.append("\(value)".data(using: .utf8)!, withName: key)
                   }
                   
                   // 파일 파트 추가
                   if let fileParts = multipartBody.fileParts {
                       for (key, file) in fileParts {
                           formData.append(file.data, withName: key, fileName: file.filename, mimeType: file.mimeType)
                       }
                   }
               },
               to: url,
               method: endpoint.method,
               headers: endpoint.headers
           )
           .validate(statusCode: 200..<300)
           .serializingDecodable(APIResponse<T>.self)
           
           let response = await dataTask.response
           return handleResponse(response)
       }
    }
    
    private func handleResponse<T: Decodable>(_ response: DataResponse<APIResponse<T>, AFError>) -> Result<T, NetworkError> {
        switch response.result {
        case .success(let decodedResponse):
            if T.self == EmptyResponseDTO.self {
                return .success(EmptyResponseDTO() as! T)
            } else {
                return .success(decodedResponse.responseData)
            }
        case .failure(let error):
            return .failure(.requestFailed(description: error.localizedDescription))
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
