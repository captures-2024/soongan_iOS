//
//  PostWeeklyContestRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

public struct PostWeeklyContestRequestDTO: Encodable {
    let title: String
    let imageFile: Data
    
    public init(title: String, imageFile: Data) {
        self.title = title
        self.imageFile = imageFile
    }
}

extension PostWeeklyContestRequestDTO: MultipartRequestable {
    public var textParts: [String : Any] {
        let parts: [String: Any] = [
            "title": title
        ]
        
        return parts
    }
    
    public var fileParts: [String : MultipartFormDataFile]? {
        return [
            "imageFile": MultipartFormDataFile(data: imageFile, filename: "\(title)_contest.jpg", mimeType: "image/jpeg")
        ]
    }
}
