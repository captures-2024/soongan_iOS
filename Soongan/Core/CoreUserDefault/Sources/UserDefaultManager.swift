//
//  UserDefaultsManager.swift
//  CoreUserDefault
//
//  Created by ParkJunHyuk on 7/6/25.
//

import Foundation

public actor UserDefaultsManager: UserDefaultsManaging, Sendable {
    private let userDefaults: UserDefaults

    public init(suiteName: String? = nil) {
        self.userDefaults = suiteName != nil ? UserDefaults(suiteName: suiteName!) ?? .standard : .standard
    }

    public func set<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            userDefaults.set(data, forKey: key)
        }
    }

    public func get<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return decoded
    }
    
    public func setData(_ data: Data, forKey key: String) {
        userDefaults.set(data, forKey: key)
    }

    public func getData(forKey key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
    
    public func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
