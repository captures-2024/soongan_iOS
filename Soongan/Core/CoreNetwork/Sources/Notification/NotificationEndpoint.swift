//
//  NotificationEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Alamofire
import Foundation

public enum NotificationEndpoint {
    case postReadNotification(ReadNotificationsRequestDTO)
    case getNotificationSetting
    case patchNotificationsSetting(NotificationsSettingRequestDTO)
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
        case .getNotificationSetting, .patchNotificationsSetting:
            return basePath.rawValue + "/settings"
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
        case .getNotificationSetting, .getNotifications, .getUnreadNotificationCount:
            return .get
        case .deleteNotification:
            return .delete
        case .patchNotificationsSetting:
            return .patch
        }
    }
    
    public var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var queryParameters: [URLQueryItem]? {
        switch self {
        case .postReadNotification(let dto):
            return dto.toQueryItems()
        case .getNotifications(let dto):
            return dto.toQueryItems()
        default:
            return nil
        }
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .patchNotificationsSetting(let dto):
            return dto
        default:
            return nil
        }
    }
}
