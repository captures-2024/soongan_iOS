//
//  PostImageModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 7/24/25.
//

import Foundation

struct PostImageModel: Identifiable, Equatable {
    var id: Int
    let imageURL: String
    let likeCount: Int
    let commentCount: Int
    let isLiked: Bool
}
