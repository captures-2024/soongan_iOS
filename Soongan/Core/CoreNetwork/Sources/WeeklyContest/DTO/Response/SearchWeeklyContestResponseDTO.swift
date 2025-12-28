//
//  SearchWeeklyContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchWeeklyContestResponseDTO: Decodable {
    public let round: Int
    public let subject: String
    public let posts: [PostInfoData]
    public let pageInfo: PageInfoData
}

public struct PostInfoData: Decodable {
    public let nickname: String
    public let profileImageUrl: String
    public let postId: Int
    public let imageUrl: String
    public let reportCount: Int
    public let ratio: Double
}

public struct PageInfoData: Decodable {
    public let page: Int
    public let size: Int
    public let hasNext: Bool
}
