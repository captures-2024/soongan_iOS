//
//  DetailContestModel.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 6/25/25.
//

import Foundation

struct DetailContestInfoModel: Equatable, Hashable {
    let id: Int
    let round: Int
    let subject: String
    let startAt: String
    let endAt: String
}
