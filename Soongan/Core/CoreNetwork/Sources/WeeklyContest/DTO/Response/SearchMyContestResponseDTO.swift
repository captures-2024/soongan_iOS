//
//  SearchMyContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchMyContestResponseDTO: Decodable {
    public let postInfo: [SearchMyContestInfoData]
    public let pageInfo: PageInfoData
}

public struct SearchMyContestInfoData: Decodable {
    public let round: Int
    public let subject: String
    public let postId: Int
    public let imageUrl: String
    public let likeCount: Int
}
