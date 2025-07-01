//
//  SearchNotificationsRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchNotificationsRequestDTO: Encodable, QueryParameterConvertible {
    let type: String
    
    public init(type: String) {
        self.type = type
    }
}
