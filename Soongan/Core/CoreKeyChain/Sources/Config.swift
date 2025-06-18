//
//  Config.swift
//  CoreKeyChain
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Foundation

public enum Config {
    enum Keys {
        enum Keychain: String {
            case accessToken = "ACCESS_TOKEN_KEY"
            case refreshToken = "REFRESH_TOKEN_KEY"
            case fcmToken = "FCM_TOKEN_KEY"
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
    static let accessTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.accessToken.rawValue] as? String else {
            fatalError("⛔️accessToken is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let refreshTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.refreshToken.rawValue] as? String else {
            fatalError("⛔️refreshToken is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let fcmTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.fcmToken.rawValue] as? String else {
            fatalError("⛔️fcmToken is not set in plist for this configuration⛔️")
        }
        return key
    }()
}
