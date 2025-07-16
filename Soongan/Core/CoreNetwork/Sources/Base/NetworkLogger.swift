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

        if let bodyData = request.request?.httpBody {
            if let contentType = request.request?.value(forHTTPHeaderField: "Content-Type"),
               contentType.contains("multipart/form-data") {
                print("Body: (multipart/form-data)")
                logMultipartBody(bodyData, contentType: contentType)
            } else if let bodyString = String(data: bodyData, encoding: .utf8) {
                print("Body: \(bodyString)")
            }
        }
    }

    private func logMultipartBody(_ data: Data, contentType: String) {
        // boundary 추출
        guard let boundaryRange = contentType.range(of: "boundary=") else {
            print("⚠️ Could not find boundary in Content-Type")
            return
        }
        let boundary = "--" + contentType[boundaryRange.upperBound...]

        // Data → 문자열 변환 시 일부 이진 데이터가 깨질 수 있음
        guard let bodyString = String(data: data, encoding: .utf8) else {
            print("⚠️ Cannot decode multipart body as UTF-8")
            return
        }

        // boundary 기준으로 분리
        let parts = bodyString.components(separatedBy: boundary)

        for part in parts {
            if part.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { continue }
            print("🔹 Part ------------------------")
            print(part)
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
