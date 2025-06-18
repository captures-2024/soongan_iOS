//
//  SearchMyContestRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct SearchMyContestRequestDTO: Encodable {
    let page: Int
    let pageSize: Int
    
    public init(
        page: Int = 0,
        pageSize: Int = 50
    ) {
        self.page = page
        self.pageSize = pageSize
    }
}
