//
//  SearchContestListResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 7/3/25.
//

import Foundation

public struct SearchContestListResponseDTO: Decodable {
    public let contests: [ContestListData]
}

public struct ContestListData: Decodable {
    public let id: Int
    public let round: Int
    public let subject: String
}
