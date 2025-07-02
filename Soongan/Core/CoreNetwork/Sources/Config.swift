//
//  Config.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let projectHeader = "PROJECT_KEY"
        }
        
        enum Keychain: String {
            case accessToken = "ACCESS_TOKEN_KEY"
            case refreshToken = "REFRESH_TOKEN_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found !!!")
        }
        return dict
    }()
}

extension Config {
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("⛔️BASE_URL is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let accessTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.accessToken.rawValue] as? String else {
            fatalError("⛔️ACCESS_TOKEN_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let refreshTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.refreshToken.rawValue] as? String else {
            fatalError("⛔️REFRESH_TOKEN_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let projectKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.projectHeader] as? String else {
            fatalError("⛔️PROJECT_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
}
