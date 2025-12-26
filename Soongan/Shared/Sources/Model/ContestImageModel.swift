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
    public let reportCount: Int
    public let ratio: Double
    
    public init(
        id: Int,
        imageUrl: String,
        nickname: String?,
        reportCount: Int,
        ratio: Double
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.nickname = nickname
        self.reportCount = reportCount
        self.ratio = ratio
    }
}
