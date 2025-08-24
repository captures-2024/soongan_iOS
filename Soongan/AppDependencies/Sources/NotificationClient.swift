//
//  NotificationClient.swift
//  AppDependencies
//
//  Created by ParkJunHyuk on 8/24/25.
//

import UIKit
import UserNotifications
import Dependencies

// MARK: - NotificationClient

public struct NotificationClient {
    public var requestAuthorization: @Sendable () async -> Bool
}

// MARK: - Dependency (Live)

extension NotificationClient: DependencyKey {
    public static let liveValue = Self(
        requestAuthorization: {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            do {
                let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                return granted
            } catch {
                // 실제로는 에러 처리를 하는 것이 좋습니다.
                return false
            }
        }
    )
}

extension DependencyValues {
    public var notificationClient: NotificationClient {
        get { self[NotificationClient.self] }
        set { self[NotificationClient.self] = newValue }
    }
}
