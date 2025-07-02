//
//  Config.swift
//  Soongan
//
//  Created by ParkJunHyuk on 6/17/25.
//  Copyright © 2025 Captures. All rights reserved.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let kakaoNativeAppKey = "KAKAO_NATIVE_APP_KEY"
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
    public static let kakaoNativeAppKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.kakaoNativeAppKey] as? String else {
            fatalError("⛔️KAKAO_NATIVE_APP_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
}
