//
//  FCMEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire

public enum FCMEndpoint {
    case postFcmToken
    case getFcmTest
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
            return .userAgentHeader("IOS")
        case .getFcmTest:
            return .defaultHeader
        }
    }
    
    public var parameters: (any Encodable)? {
        return nil
    }
}
