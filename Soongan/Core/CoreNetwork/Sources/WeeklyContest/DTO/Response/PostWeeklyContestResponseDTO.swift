//
//  PostWeeklyContestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct PostWeeklyContestResponseDTO: Decodable {
    let postId: Int
    let title: String
    let imageUrl: String
    let registerNickname: String
}
