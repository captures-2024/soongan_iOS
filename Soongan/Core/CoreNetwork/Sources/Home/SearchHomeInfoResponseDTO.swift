//
//  SearchHomeInfoResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchHomeInfoResponseDTO: Decodable {
    let contestInfo: ContestInfoData
    let postInfo: [HomePostInfoData]
}

public struct ContestInfoData: Decodable {
    let contestType: String
    let subject: String
    let startAt: String
    let endAt: String
}

public struct HomePostInfoData: Decodable {
    let postId: Int
    let imageUrl: String
    let likeCount: Int
    let commentCount: Int
}
