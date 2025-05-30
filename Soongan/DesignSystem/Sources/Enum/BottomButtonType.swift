//
//  BottomButtonType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/2/25.
//

import SwiftUI

public enum BottomButtonType: Equatable {
    case next
    case comfirm
    case complete
    case logout
    case report
    case submit
    case editComplete
    
    var title: String {
        switch self {
        case .next:
            return "다음"
        case .comfirm:
            return "확인"
        case .complete:
            return "완료"
        case .logout:
            return "로그아웃"
        case .report:
            return "신고제출"
        case .submit:
            return "제출하기"
        case .editComplete:
            return "수정완료"
        }
    }
    
    var textColor: Color {
        switch self {
        case .next, .editComplete:
            return .white
        default:
            return .black100
        }
    }
    
    var font: Font {
        switch self {
        case .next:
            return .semibold18
        default:
            return .body15
        }
    }
    
    var backgroundColor: Color {
        return .primary
    }
    
    var height: CGFloat {
        return 48
    }
}
