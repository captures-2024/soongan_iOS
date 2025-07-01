//
//  SearchWeeklyContestRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchWeeklyContestRequestDTO: Encodable, QueryParameterConvertible {
    let round: Int
    let orderCriteria: String
    let page: Int
    let pageSize: Int
    
    public init(round: Int, orderCriteria: String, page: Int, pageSize: Int) {
        self.round = round
        self.orderCriteria = orderCriteria
        self.page = page
        self.pageSize = pageSize
    }
}
