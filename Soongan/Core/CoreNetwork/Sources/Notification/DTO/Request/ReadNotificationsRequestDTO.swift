//
//  ReadNotificationsRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/18/25.
//

import Foundation

public struct ReadNotificationsRequestDTO: Encodable, QueryParameterConvertible {
    let notificationId: Int
    
    public init(notificationId: Int) {
        self.notificationId = notificationId
    }
}
