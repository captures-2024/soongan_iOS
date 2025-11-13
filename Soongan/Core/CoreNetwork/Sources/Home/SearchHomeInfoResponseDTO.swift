//
//  SearchHomeInfoResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchHomeInfoResponseDTO: Decodable {
    public let contestInfo: ContestInfoData
    public let postInfo: [HomePostInfoData]
}

public struct ContestInfoData: Decodable {
    public let status: String
    public let contestType: String
    public let subject: String
    public let startAt: String
    public let endAt: String
}

public struct HomePostInfoData: Decodable {
    public let postId: Int
    public let imageUrl: String
    public let likeCount: Int
    public let commentCount: Int
    public let isLiked: Bool
}
