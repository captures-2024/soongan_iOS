//
//  ContestReportReasonType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 6/1/25.
//

import Foundation

public enum ContestReportReasonType: CaseIterable {
    case inappropriateContent      // 부적절한 사진 게시 및 언행
    case hateSpeech                // 욕설, 혐오, 비하 등이 포함된 표현
    case infringement              // 도용, 초상권, 저작권 등 타인의 권리 침해
    case spam                      // 도배
    case promotion                 // 홍보용 사진 혹은 댓글 게시
    case other                     // 기타
    
    var title: String {
        switch self {
        case .inappropriateContent:
            return "부적절한 사진 게시 및 언행"
        case .hateSpeech:
            return "욕설, 혐오, 비하 등이 포함된 표현"
        case .infringement:
            return "도용, 초상권, 저작권 등 타인의 권리 침해"
        case .spam:
            return "도배"
        case .promotion:
            return "홍보용 사진 혹은 댓글 게시"
        case .other:
            return "기타"
        }
    }
    
    public var typeTitle: String {
        switch self {
        case .inappropriateContent:
            return "INAPPROPRIATE_PHOTO_OR_BEHAVIOR"
        case .hateSpeech:
            return "PROFANITY_HATE_SPEECH"
        case .infringement:
            return "COPYRIGHT_OR_PRIVACY_VIOLATION"
        case .spam:
            return "SPAM"
        case .promotion:
            return "PROMOTIONAL_CONTENT"
        case .other:
            return "OTHER"
        }
    }
}
