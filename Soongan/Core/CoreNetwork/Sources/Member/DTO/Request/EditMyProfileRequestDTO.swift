//
//  EditMyProfileRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct EditMyProfileRequestDTO: Encodable {
    let nickname: String
    let selfIntroduction: String
    let profileImage: String
    let isDefaultProfileImage: Bool
}
