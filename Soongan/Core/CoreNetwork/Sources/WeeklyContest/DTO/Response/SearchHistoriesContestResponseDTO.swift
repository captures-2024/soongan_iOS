//
//  SearchHistoriesContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchHistoriesContestResponseDTO: Decodable {
    public let contests: [SearchHistoriesContestData]
}

public struct SearchHistoriesContestData: Decodable, Equatable, Hashable {
    public let id: Int
    public let round: Int
    public let subject: String
    public let startAt: String
    public let endAt: String
    public let announcedAt: String
    public let thumbnailImageUrl: String
}
