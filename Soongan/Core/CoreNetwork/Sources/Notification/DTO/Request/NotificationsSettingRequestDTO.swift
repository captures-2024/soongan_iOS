//
//  NotificationsSettingRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 11/10/25.
//

import Foundation

public struct NotificationsSettingRequestDTO: Encodable, QueryParameterConvertible {
    let contestPush: Bool
    let activityPush: Bool
    let noticePush: Bool
    
    public init(contestPush: Bool, activityPush: Bool, noticePush: Bool) {
        self.contestPush = contestPush
        self.activityPush = activityPush
        self.noticePush = noticePush
    }
}
