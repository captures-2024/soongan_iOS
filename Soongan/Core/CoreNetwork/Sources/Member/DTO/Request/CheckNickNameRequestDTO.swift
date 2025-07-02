//
//  CheckNickNameRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct CheckNickNameRequestDTO: Encodable, QueryParameterConvertible {
    let nickname: String
    
    public init(nickname: String) {
        self.nickname = nickname
    }
}
