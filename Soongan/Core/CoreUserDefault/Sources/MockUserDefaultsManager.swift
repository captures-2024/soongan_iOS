//
//  MockUserDefaultsManager.swift
//  CoreUserDefault
//
//  Created by ParkJunHyuk on 7/6/25.
//

import Foundation

public final class MockUserDefaultsManager: UserDefaultsManaging {
    public func setData(_ data: Data, forKey key: String) async {
        storage[key] = data
    }
    
    public func getData(forKey key: String) async -> Data? {
        return storage[key] as? Data
    }
    
    private var storage: [String: Any] = [:]

    public init() {}

    public func set<T: Codable>(_ value: T, forKey key: String) {
        storage[key] = value
    }

    public func get<T: Codable>(forKey key: String) -> T? {
        return storage[key] as? T
    }

    public func remove(forKey key: String) {
        storage.removeValue(forKey: key)
    }
}
