//
//  AuthEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire
import Foundation

public enum AuthEndpoint {
    case postLogin(LoginRequestDTO)
    case postLogout
    case patchRefresh(RefreshRequestDTO)
    case postWithdraw
}

extension AuthEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .auth
    }
    
    public var path: String {
        switch self {
        case .postLogin:
            return basePath.rawValue + "/login"
        case .postLogout:
            return basePath.rawValue + "/logout"
        case .patchRefresh:
            return basePath.rawValue + "/refresh"
        case .postWithdraw:
            return basePath.rawValue + "/withdraw"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .postLogin, .postLogout, .postWithdraw:
            return .post
        case .patchRefresh:
            return .patch
        }
    }
    
    public var headerType: HeaderType {
        switch self {
        case .postLogin:
            return .userAgentHeader
        case .patchRefresh:
            return .defaultHeader
        case .postLogout, .postWithdraw:
            return .accessTokenHeader
        }
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var queryParameters: [URLQueryItem]? {
        return nil
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .postLogin(let dto):
            return dto
        case .patchRefresh(let dto):
            return dto
        default:
            return nil
        }
    }
}
