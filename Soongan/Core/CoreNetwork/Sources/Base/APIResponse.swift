//
//  APIResponse.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Foundation

public struct APIResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String
    let responseData: T
}

public struct APIErrorResponse: Decodable {
    let status: Int
    let message: String
    let detailMessage: String
}
