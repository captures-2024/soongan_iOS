//
//  Endpoint.swift
//  Core
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

import CoreKeyChain

import Alamofire

public enum RequestBodyType {
    case json           // raw JSON
    case formData      // multipart/form-data
}

/// 각 API에 따라 공통된 Path 값 (존재하지 않는 경우 빈 String 값)
public enum BasePath: String {
    case auth = "/auth"
    case weeklyContest = "/weekly/contests"
    case comment = "/comments"
    case member = "/members"
    case report = "/report"
    case postLike = "/posts"
    case commentLike = "/comments/like"
    case notification = "/notifications"
    case fcmController = "/fcm"
    case home = "/home"
}

public protocol APIEndpoint {
    var basePath: BasePath { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var requestBodyType: RequestBodyType { get }
    var headerType: HeaderType { get }
    var queryParameters: [URLQueryItem]? { get }
    var body: Encodable? { get }
}

extension APIEndpoint {
    public var baseURL: URL {
        guard let baseURL = URL(string: Config.baseURL) else {
            fatalError("⛔️ Base URL이 없습니다 ⛔️")
        }
        return baseURL
    }

    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    /// 각 케이스에 맞는 HTTPHeaders 반환
    public var headers: HTTPHeaders {
        return headerType.headers
    }
}
