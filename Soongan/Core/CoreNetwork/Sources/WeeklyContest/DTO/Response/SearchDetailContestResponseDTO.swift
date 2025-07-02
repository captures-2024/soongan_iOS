//
//  SearchDetailContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/25/25.
//

import Foundation

public struct SearchDetailContestResponseDTO: Decodable {
    public let memberId: Int
    public let postId: Int
    public let title: String
    public let imageurl: String
    public let nickname: String
    public let likeCount: Int
    public let isLiked: Bool
    public let commentCount: Int
}
