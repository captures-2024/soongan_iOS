//
//  ContestImageModel.swift
//  Shared
//
//  Created by ParkJunHyuk on 8/15/25.
//

import Foundation

public struct ContestImageModel: Identifiable, Hashable {
    public var id: Int
    public let imageUrl: String
    public let nickname: String?
    public var height: CGFloat?
    
    public init(
        id: Int,
        imageUrl: String,
        nickname: String? = nil,
        height: CGFloat? = nil
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.nickname = nickname
        self.height = height
    }
}
