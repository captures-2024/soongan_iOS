//
//  PostLikeEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire
import Foundation

public enum PostLikeEndpoint {
    case putPostLike(PostLikeRequestDTO)
    case deletePostLike(PostLikeRequestDTO)
}

extension PostLikeEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .postLike
    }
    
    public var path: String {
        return basePath.rawValue
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .putPostLike:
            return .post
        case .deletePostLike:
            return .delete
        }
    }
    
    public var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    public var queryParameters: [URLQueryItem]? {
        return nil
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .putPostLike(let dto), .deletePostLike(let dto):
            return dto
        }
    }
}
