//
//  ReportEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire
import Foundation

public enum ReportEndpoint {
    case postReport(ReportRequestDTO)
}

extension ReportEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .report
    }
    
    public var path: String {
        return basePath.rawValue
    }
    
    public var method: Alamofire.HTTPMethod {
        return .post
    }
    
    public var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var queryParameters: [URLQueryItem]? {
        return nil
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .postReport(let dto):
            return dto
        }
    }
}
