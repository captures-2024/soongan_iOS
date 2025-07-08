//
//  PostLikeResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct PostLikeResponseDTO: Decodable {
    public let postId: Int
    public let likeCount: Int
}
