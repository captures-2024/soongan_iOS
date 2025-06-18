//
//  HomeEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire

public enum HomeEndpoint {
    case getHomeInfo
}

extension HomeEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .home
    }
    
    public var path: String {
        return basePath.rawValue
    }
    
    public var method: Alamofire.HTTPMethod {
        return .get
    }
    
    public var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    public var parameters: (any Encodable)? {
        return nil
    }
}
