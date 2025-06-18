//
//  MemberEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire

public enum MemberEndpoint {
    case patchProfile
    case patchBirthYear(EditMyBirthYearRequestDTO)
    case getMembers
    case getCheckNickname(CheckNickNameRequestDTO)
}

extension MemberEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .member
    }
    
    public var path: String {
        switch self {
        case .patchProfile:
            return basePath.rawValue + "/profile"
        case .patchBirthYear:
            return basePath.rawValue + "/birth-year"
        case .getMembers:
            return basePath.rawValue
        case .getCheckNickname:
            return basePath.rawValue + "/check-nickname"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .patchProfile, .patchBirthYear:
            return .patch
        case .getMembers, .getCheckNickname:
            return .get
        }
    }
    
    public var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    public var parameters: (any Encodable)? {
        switch self {
        case .getCheckNickname(let dto):
            return dto
        case .patchBirthYear(let dto):
            return dto
        default:
            return nil
        }
    }
}
