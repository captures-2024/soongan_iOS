//
//  UserDefaultsClient.swift
//  CoreUserDefault
//
//  Created by ParkJunHyuk on 7/6/25.
//

import Foundation

import CoreUserDefault

import Dependencies

public struct UserDefaultsClient {
    public var setData: @Sendable (Data, String) async -> Void
    public var getData: @Sendable (String) async -> Data?
    public var remove: @Sendable (String) async -> Void
}

public extension UserDefaultsClient {
    
    /// String 값을 저장하는 편의 메서드
    func setString(_ value: String, forKey key: String) async {
        guard let data = value.data(using: .utf8) else { return }
        await self.setData(data, key)
    }
    
    /// String 값을 불러오는 편의 메서드
    func getString(forKey key: String) async -> String? {
        guard let data = await self.getData(key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Codable 객체를 저장하는 편의 메서드
    func set<T: Codable>(_ value: T, forKey key: String) async {
        guard let data = try? JSONEncoder().encode(value) else { return }
        await self.setData(data, key)
    }

    /// Codable 객체를 불러오는 편의 메서드
    func get<T: Codable>(forKey key: String, as type: T.Type) async -> T? {
        guard let data = await self.getData(key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    /// Bool 값을 저장하는 편의 메서드
    func setBool(_ value: Bool, forKey key: String) async {
        await self.set(value, forKey: key)
    }
    
    /// Bool 값을 불러오는 편의 메서드
    func bool(forKey key: String) async -> Bool {
        await self.get(forKey: key, as: Bool.self) ?? false
    }
}

extension UserDefaultsClient: DependencyKey {
    public static let liveValue: Self = {
        // CoreUserDefault 모듈의 실제 구현체를 생성합니다.
        let manager = UserDefaultsManager()
        
        return Self(
            setData: { data, key in await manager.setData(data, forKey: key) },
            getData: { key in await manager.getData(forKey: key) },
            remove: { key in await manager.remove(forKey: key) }
        )
    }() // 즉시 실행 클로저로 생성
}

// 3. @Dependency(\.userDefaultsClient) 형태로 쉽게 사용할 수 있도록 등록
public extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
