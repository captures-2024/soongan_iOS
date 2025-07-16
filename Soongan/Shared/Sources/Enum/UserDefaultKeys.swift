//
//  UserDefaultKeys.swift
//  Shared
//
//  Created by ParkJunHyuk on 7/6/25.
//

import Foundation

public enum UserDefaultKeys {
    public enum User: String {
        case username = "USERNAME_KEY"
        case userID = "USER_ID_KEY"
    }
    
    public enum Settings: String {
        case isNotificationEnabled = "SETTINGS_NOTIFICATION_ENABLED_KEY"
    }
}
