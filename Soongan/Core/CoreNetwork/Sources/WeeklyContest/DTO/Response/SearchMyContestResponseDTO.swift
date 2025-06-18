//
//  SearchMyContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchMyContestResponseDTO: Decodable {
    let postInfo: [SearchMYContestInfoData]
    let pageInfo: PageInfoData
}

public struct SearchMYContestInfoData: Decodable {
    let round: Int
    let subject: String
    let postId: Int
    let imageUrl: String
    let likeCount: Int
}
