//
//  PostStatus.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 7/22/25.
//

import Foundation

enum PostStatus: String {
    case active = "ACTIVE"
    case blind = "BLINDED"
    case deleteByAdmin = "DELETED_BY_ADMIN"
    case deleteByCreator = "DELETED_BY_CREATOR"
    
    var firstPostTitle: String {
        switch self {
        case .active:
            return ""
        case .blind:
            return "이 순간은 운영 정책에 따라 삭제되었습니다."
        case .deleteByAdmin:
            return "신고 누적으로 일시적으로 숨김처리 되었습니다.\n운영진의 판단을 기다려주세요."
        case .deleteByCreator:
            return "이 순간은 사용자가 차단한 순간입니다."
        }
    }
    
    var otherPostTitle: String {
        switch self {
        case .active:
            return ""
        case .blind:
            return "이 순간은 운영 정책에 따라 삭제되었습니다."
        case .deleteByAdmin:
            return "신고 누적으로\n일시적으로 숨김처리 되었습니다.\n운영진의 판단을 기다려주세요."
        case .deleteByCreator:
            return "이 순간은 사용자가 차단한\n순간입니다."
        }
    }
}
