//
//  EditMyProfileResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 7/1/25.
//

import Foundation

public struct EditMyProfileResponseDTO: Decodable {
    public let nickname: String?
    public let selfIntroduction: String?
    public let profileImageUrl: String?
}
