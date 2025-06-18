//
//  SearchHistoriesContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchHistoriesContestResponseDTO: Decodable {
    let contests: [SearchHistoriesContestData]
}

public struct SearchHistoriesContestData: Decodable {
    let id: Int
    let round: Int
    let subject: String
    let startAt: String
    let endAt: String
    let announcedAt: String
    let thumbnailImageUrl: String
}
