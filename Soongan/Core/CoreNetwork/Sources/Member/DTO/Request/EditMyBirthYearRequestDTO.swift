//
//  EditMyBirthYearRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct EditMyBirthYearRequestDTO: Encodable {
    let birthYear: Int
    
    public init(birthYear: Int) {
        self.birthYear = birthYear
    }
}
