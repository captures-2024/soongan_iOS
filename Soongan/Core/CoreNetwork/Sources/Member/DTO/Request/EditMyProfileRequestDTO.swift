//
//  EditMyProfileRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/16/25.
//

import Foundation

// Multipart 요청 바디를 위한 새로운 프로토콜
// 이 프로토콜을 통해 텍스트와 파일을 구분합니다.
public protocol MultipartRequestable {
    var textParts: [String: Any] { get }
    var fileParts: [String: MultipartFormDataFile]? { get }
}

public struct EditMyProfileRequestDTO: Encodable {
    let nickname: String?
    let selfIntroduction: String?
    let profileImage: Data?
    let isDefaultProfileImage: Bool
    
    public init(
        nickname: String?,
        selfIntroduction: String? = nil,
        profileImage: Data? = nil,
        isDefaultProfileImage: Bool
    ) {
        self.nickname = nickname
        self.selfIntroduction = selfIntroduction
        self.profileImage = profileImage
        self.isDefaultProfileImage = isDefaultProfileImage
    }
}

// DTO가 MultipartRequestable 프로토콜을 채택
extension EditMyProfileRequestDTO: MultipartRequestable {
    // 텍스트 파라미터를 딕셔너리로 반환
    public var textParts: [String: Any] {
        var parts: [String: Any] = [
            "isDefaultProfileImage": isDefaultProfileImage
        ]
        if let nickname {
            parts["nickname"] = nickname
        }
        if let selfIntroduction {
            parts["selfIntroduction"] = selfIntroduction
        }
        return parts
    }
    
    // 파일 파라미터를 딕셔너리로 반환
    public var fileParts: [String: MultipartFormDataFile]? {
        guard let imageData = profileImage, let name = nickname else {
            return nil
        }
        
        return [
            "profileImage": MultipartFormDataFile(data: imageData, filename: "\(name)_profile.jpg", mimeType: "image/jpeg")
        ]
    }
}
