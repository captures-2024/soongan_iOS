//
//  NotificationEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire

public enum NotificationEndpoint {
    case postReadNotification(notificationId: Int)
    case getNotifications(SearchNotificationsRequestDTO)
    case getUnreadNotificationCount
    case deleteNotification(notificationId: Int)
}

extension NotificationEndpoint: APIEndpoint {
    public var basePath: BasePath {
        return .notification
    }
    
    public var path: String {
        switch self {
        case .postReadNotification(let notificationId):
            return basePath.rawValue + "/\(notificationId)/read"
        case .getNotifications:
            return basePath.rawValue
        case .getUnreadNotificationCount:
            return basePath.rawValue + "/unread-count"
        case .deleteNotification(let notificationId):
            return basePath.rawValue + "/\(notificationId)"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .postReadNotification:
            return .post
        case .getNotifications, .getUnreadNotificationCount:
            return .get
        case .deleteNotification:
            return .delete
        }
    }
    
    public var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    public var parameters: (any Encodable)? {
        switch self {
        case .getNotifications(let dto):
            return dto
        default:
            return nil
        }
    }
}
