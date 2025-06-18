//
//  SearchWeeklyContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchWeeklyContestResponseDTO: Decodable {
    let round: Int
    let subject: String
    let posts: [PostInfoData]
    let pageInfo: PageInfoData
}

public struct PostInfoData: Decodable {
    let nickname: String
    let profileImageUrl: String
    let postId: Int
    let imageUrl: String
}

public struct PageInfoData: Decodable {
    let page: Int
    let size: Int
    let hasNext: Bool
}
