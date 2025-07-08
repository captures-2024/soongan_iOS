//
//  FCMEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire
import Foundation

public enum FCMEndpoint {
    case postFcmToken(RegisterFCMTokenRequestDTO)
    case getFcmTest(FCMTokenRequestDTO)
}

extension FCMEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .fcmController
    }
    
    public var path: String {
        switch self {
        case .postFcmToken:
            return basePath.rawValue
        case .getFcmTest:
            return basePath.rawValue + "/test"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .postFcmToken:
            return .post
        case .getFcmTest:
            return .get
        }
    }
    
    public var headerType: HeaderType {
        switch self {
        case .postFcmToken:
            return .userAgentHeader
        case .getFcmTest:
            return .defaultHeader
        }
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var queryParameters: [URLQueryItem]? {
        switch self {
        case .getFcmTest(let dto):
            return dto.toQueryItems()
        default:
            return nil
        }
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .postFcmToken(let dto):
            return dto
        default:
            return nil
        }
    }
}
