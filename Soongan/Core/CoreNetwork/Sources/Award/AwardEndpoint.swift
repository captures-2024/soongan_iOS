//
//  AwardEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 7/3/25.
//

import Alamofire
import Foundation

public enum AwardEndpoint {
    case getAwardContest
    case getDetailAwardContest(contestId: Int)
}

extension AwardEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .award
    }
    
    public var path: String {
        switch self {
        case .getAwardContest:
            return basePath.rawValue
        case .getDetailAwardContest(let contestId):
            return basePath.rawValue + "/\(contestId)"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .getAwardContest, .getDetailAwardContest:
            return .get
        }
    }
    
    public var headerType: HeaderType {
        return .defaultHeader
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var queryParameters: [URLQueryItem]? {
        return nil
    }
    
    public var body: (any Encodable)? {
        return nil
    }
}
