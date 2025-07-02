//
//  DetailHistoryOtherPostModel.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 6/25/25.
//

import Foundation

struct DetailHistoryOtherPostModel: Identifiable, Equatable, Hashable {
    let id: Int
    let nickName: String
    let likeCount: Int
    let imageUrl: String
    let ranking: Int
}
