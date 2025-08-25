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
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
                return granted
            } catch {
                print("Failed to request notification authorization: \(error.localizedDescription)")
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
