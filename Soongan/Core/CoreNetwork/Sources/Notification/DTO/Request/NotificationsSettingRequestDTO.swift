//
//  NotificationsSettingRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 11/10/25.
//

import Foundation

public struct NotificationsSettingRequestDTO: Encodable, QueryParameterConvertible {
    public let contestPush: Bool
    public let activityPush: Bool
    public let noticePush: Bool
    
    public init(contestPush: Bool, activityPush: Bool, noticePush: Bool) {
        self.contestPush = contestPush
        self.activityPush = activityPush
        self.noticePush = noticePush
    }
}
