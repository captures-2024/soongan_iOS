//
//  ReportEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire

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
    
    public var parameters: (any Encodable)? {
        switch self {
        case .postReport(let dto):
            return dto
        }
    }
}
