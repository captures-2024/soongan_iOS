//
//  SearchDetailAwardContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 7/3/25.
//

import Foundation

public struct SearchDetailAwardContestResponseDTO: Decodable {
    public let subject: String
    public let round: Int
    public let startAt: String
    public let endAt: String
    public let postsCount: Int
    public let firstPrizePost: FirstPostInfo
    public let otherTop7Posts: [OtherPosts]
}

public struct FirstPostInfo: Decodable {
    public let postId: Int
    public let title: String
    public let imageUrl: String
    public let nickname: String
    public let score: Int
    public let status: String
}

public struct OtherPosts: Decodable {
    public let postId: Int
    public let imageUrl: String
    public let nickname: String
    public let ranking: Int
    public let score: Int
    public let status: String
}
