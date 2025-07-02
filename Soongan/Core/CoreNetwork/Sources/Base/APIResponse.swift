//
//  APIResponse.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/17/25.
//

import Foundation

public struct APIResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let responseData: T
    let detailMessage: String?
}

public struct APIErrorResponse: Decodable {
    let statusCode: Int
    let message: String
    let detailMessage: String
}
