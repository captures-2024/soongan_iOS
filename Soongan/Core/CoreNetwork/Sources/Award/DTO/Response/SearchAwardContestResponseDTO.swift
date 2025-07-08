//
//  SearchAwardContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 7/3/25.
//

import Foundation

public struct SearchAwardContestResponseDTO: Decodable {
    public let contests: [SearchAwardContestData]
}

public struct SearchAwardContestData: Decodable, Equatable, Hashable {
    public let id: Int
    public let round: Int
    public let subject: String
    public let startAt: String
    public let endAt: String
    public let announcedAt: String
    public let thumbnailImageUrl: String
}
