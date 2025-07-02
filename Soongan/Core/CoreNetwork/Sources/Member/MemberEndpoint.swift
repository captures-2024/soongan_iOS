//
//  MemberEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire
import Foundation

public enum MemberEndpoint {
    case patchProfile(EditMyProfileRequestDTO)
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
    
    public var queryParameters: [URLQueryItem]? {
        switch self {
        case .patchBirthYear(let dto):
            return dto.toQueryItems()
        case .getCheckNickname(let dto):
            return dto.toQueryItems()
        default:
            return nil
        }
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .patchProfile(let dto):
            return dto
        default:
            return nil
        }
    }
}
