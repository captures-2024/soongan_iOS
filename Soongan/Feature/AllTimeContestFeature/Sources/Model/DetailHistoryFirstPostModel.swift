//
//  DetailHistoryFirstPostModel.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 6/25/25.
//

import Foundation

struct DetailHistoryFirstPostModel: Identifiable, Equatable, Hashable {
    let id: Int
    let nickName: String
    let postTitle: String
    let likeCount: Int
    let imageUrl: String
    let status: PostStatus
}
