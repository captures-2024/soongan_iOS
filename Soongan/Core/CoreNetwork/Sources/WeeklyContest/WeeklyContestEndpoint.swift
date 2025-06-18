//
//  WeeklyContestEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire

public enum WeeklyContestEndpoint {
    case getContest(SearchWeeklyContestRequestDTO)
    case postContest(PostWeeklyContestRequestDTO)
    case getDetailContest(postId: String)
    case deleteContest(postId: String)
    case patchContest(postId: String)
    case getMyContest(SearchMyContestRequestDTO)
    case getHistoriesContest
    case getDetailHistoriesContest(contestId: String)
}

extension WeeklyContestEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .weeklyContest
    }
    
    public var path: String {
        switch self {
        case .getContest, .postContest:
            return basePath.rawValue + "/posts"
        case .getDetailContest(let postId), .deleteContest(let postId), .patchContest(let postId):
            return basePath.rawValue + "/posts/\(postId)"
        case .getMyContest:
            return basePath.rawValue + "/posts/my-hisotry"
        case .getHistoriesContest:
            return basePath.rawValue + "/histories"
        case .getDetailHistoriesContest(let contestId):
            return basePath.rawValue + "/histories/\(contestId)"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .getContest, .getDetailContest, .getMyContest, .getHistoriesContest, .getDetailHistoriesContest:
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
        case .getContest, .getHistoriesContest, .getDetailHistoriesContest:
            return .defaultHeader
        }
    }
    
    public var parameters: (any Encodable)? {
        switch self {
        case .getContest(let dto):
            return dto
        case .postContest(let dto):
            return dto
        case .getMyContest(let dto):
            return dto
        default:
            return nil
        }
    }
}
