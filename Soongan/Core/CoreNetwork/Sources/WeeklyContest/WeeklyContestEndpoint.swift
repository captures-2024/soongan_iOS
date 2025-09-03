//
//  WeeklyContestEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire
import Foundation

public enum WeeklyContestEndpoint {
    case getContest(SearchWeeklyContestRequestDTO)
    case postContest(PostWeeklyContestRequestDTO)
    case getDetailContest(postId: Int)
    case deleteContest(postId: Int)
    case patchContest(postId: Int, PutWeeklyContestRequestDTO)
    case getContestList
    case getMyContest(SearchMyContestRequestDTO)
}

extension WeeklyContestEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .weeklyContest
    }
    
    public var path: String {
        switch self {
        case .getContest, .postContest:
            return basePath.rawValue + "/posts"
        case .getDetailContest(let postId), .deleteContest(let postId), .patchContest(let postId, _):
            return basePath.rawValue + "/posts/\(postId)"
        case .getContestList:
            return basePath.rawValue
        case .getMyContest:
            return basePath.rawValue + "/posts/my-history"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .getContest, .getDetailContest, .getContestList, .getMyContest:
            return .get
        case .postContest:
            return .post
        case .deleteContest:
            return .delete
        case .patchContest:
            return .patch
        }
    }
    
    public var headerType: HeaderType {
        switch self {
        case .postContest, .getDetailContest, .deleteContest, .patchContest, .getMyContest:
            return .accessTokenHeader
        case .getContestList, .getContest:
            return .defaultHeader
        }
    }
    
    public var requestBodyType: RequestBodyType {
        switch self {
        case .postContest:
            return .formData
        default:
            return .json
        }
    }
    
    public var queryParameters: [URLQueryItem]? {
        switch self {
        case .getContest(let dto):
            return dto.toQueryItems()
        case .getMyContest(let dto):
            return dto.toQueryItems()
        default:
            return nil
        }
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .postContest(let dto):
            return dto
        case .patchContest(_, let dto):
            return dto
        default:
            return nil
        }
    }
}
