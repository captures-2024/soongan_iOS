//
//  SearchWeeklyContestRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchWeeklyContestRequestDTO: Encodable {
    let round: Int
    let orderCriteria: String
    let page: Int
    let pageSize: Int
}
