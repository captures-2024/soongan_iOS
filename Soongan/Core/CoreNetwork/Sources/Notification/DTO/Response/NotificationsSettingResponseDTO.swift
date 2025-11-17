//
//  NotificationsSettingResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 11/17/25.
//

import Foundation

public struct NotificationsSettingResponseDTO: Decodable {
    public let contestPush: Bool
    public let activityPush: Bool
    public let noticePush: Bool
    
    public init(contestPush: Bool, activityPush: Bool, noticePush: Bool) {
        self.contestPush = contestPush
        self.activityPush = activityPush
        self.noticePush = noticePush
    }
}
