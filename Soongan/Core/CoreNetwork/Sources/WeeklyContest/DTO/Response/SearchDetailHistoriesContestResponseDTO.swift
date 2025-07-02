//
//  SearchDetailHistoriesContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/25/25.
//

import Foundation

public struct SearchDetailHistoriesContestResponseDTO: Decodable {
    public let postCount: Int
    public let firstPrizePost: FirstPostInfo
    public let otherTop7Posts: [OtherPosts]
}

public struct FirstPostInfo: Decodable {
    public let postId: Int
    public let title: String
    public let imageUrl: String
    public let nickname: String
    public let score: Int
}

public struct OtherPosts: Decodable {
    public let postId: Int
    public let title: String
    public let imageUrl: String
    public let nickname: String
    public let ranking: Int
    public let score: Int
}
