//
//  UserDefaultsManaging.swift
//  CoreUserDefault
//
//  Created by ParkJunHyuk on 7/6/25.
//

import Foundation

public protocol UserDefaultsManaging {
    // Codable을 다루는 메서드들
    func set<T: Codable>(_ value: T, forKey key: String) async
    func get<T: Codable>(forKey key: String) async -> T?
    
    // Data를 다루는 메서드들
    func setData(_ data: Data, forKey key: String) async
    func getData(forKey key: String) async -> Data?
    
    func remove(forKey key: String) async
}
