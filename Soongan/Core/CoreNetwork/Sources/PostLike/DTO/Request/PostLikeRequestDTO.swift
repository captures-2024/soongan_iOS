//
//  PostLikeRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct PostLikeRequestDTO: Encodable {
    let postId: String
    let contestType: String
    
    public init(postId: String, contestType: String) {
        self.postId = postId
        self.contestType = contestType
    }
}
