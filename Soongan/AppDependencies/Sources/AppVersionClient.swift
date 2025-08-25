//
//  AppVersionClient.swift
//  AppDependencies
//
//  Created by ParkJunHyuk on 8/24/25.
//

import Foundation
import Dependencies

// MARK: - AppVersionClient

public struct AppVersionClient {
    public var getCurrentVersion: () -> String?
}

// MARK: - Dependency (Live)

extension AppVersionClient: DependencyKey {
    public static let liveValue = Self(
        getCurrentVersion: {
            guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
                return nil
            }
            return version
        }
    )
}

extension DependencyValues {
    public var appVersionClient: AppVersionClient {
        get { self[AppVersionClient.self] }
        set { self[AppVersionClient.self] = newValue }
    }
}
