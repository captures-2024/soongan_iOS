//
//  NetworkLogger.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/18/25.
//

import Alamofire
import Foundation

public final class NetworkLogger: EventMonitor {
    
    public init(){}
    
    public let queue = DispatchQueue(label: "com.app.networklogger")

    // 요청 시작할 때
    public func requestDidResume(_ request: Request) {
        print("➡️ [REQUEST] ==========================")
        print("URL: \(request.request?.url?.absoluteString ?? "")")
        print("Method: \(request.request?.httpMethod ?? "")")
        if let headers = request.request?.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let bodyData = request.request?.httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }

    // 응답 받을 때
    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("⬅️ [RESPONSE] ==========================")
        print("➡️ Status Code: \(response.response?.statusCode ?? 0)")

        switch response.result {
        case .success(let value):
            print("✅ SUCCESS: ==========================")
            print(value)
        case .failure(let error):
            print("❌ FAILURE:")
            print(error.localizedDescription)
        }
    }
}
