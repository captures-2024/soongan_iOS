//
//  SheetContentType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/15/25.
//

import SwiftUI

public enum SheetContentType: Identifiable, Equatable {
    case contestInfo
    case postPicture(name: String)
    case logout
    case withdraw
    case completeWithdraw
    case myprofileOption
    case alarmSetting
    
    public var id: String {
        switch self {
        case .contestInfo: return "contestInfo"
        case .postPicture(let name): return "postPicture_\(name)"
        case .logout: return "logout"
        case .withdraw: return "withdraw"
        case .completeWithdraw: return "completeWithdraw"
        case .myprofileOption: return "myprofileOption"
        case .alarmSetting: return "alarmSetting"
        }
    }
    
    var title: String {
        switch self {
        case .contestInfo: return "대회정보"
        case .postPicture: return "제목확인"
        case .logout: return "로그아웃"
        case .withdraw, .completeWithdraw: return "회원탈퇴"
        case .myprofileOption: return ""
        case .alarmSetting: return "푸시 알림 설정"
        }
    }
    
    var height: Set<PresentationDetent> {
        switch self {
        case .contestInfo: return [.fraction(0.75)]
        case .postPicture: return [.fraction(0.31)]
        case .logout: return [.height(264)]
        case .withdraw: return [.height(392)]
        case .completeWithdraw: return [.height(264)]
        case .myprofileOption: return [.height(420)]
        case .alarmSetting: return [.height(380)]
        }
    }
}


public enum MyprofileOptionType: Equatable, CaseIterable {
    case editMyProfile
//    case license
    case pushAlarmSetting
    case terms
    case faq
    case withDraw
    case logout
    
    var title: String {
        switch self {
        case .editMyProfile:
            return "프로필 편집"

        case .pushAlarmSetting:
            return "푸시 알림 설정"
            
        case .terms:
            return "약관 및 정책"
            
        case .faq:
            return "FAQ"
            
        case .withDraw:
            return "회원탈퇴"
            
        case .logout:
            return "로그아웃"
        }
    }
    
    var image: Image {
        switch self {
        case .editMyProfile:
            return .personIcon

        case .pushAlarmSetting:
            return .settingIcon
            
        case .terms:
            return .boardIcon
            
        case .faq:
            return .questionIcon
            
        case .withDraw:
            return .drawIcon
            
        case .logout:
            return .exitIcon
        }
    }
}


public enum AlaramSettingOptionType: Equatable, CaseIterable {
    case allAlarm
    case contestAlarm
    case activeAlarm
    case noticeAlarm
    
    var title: String {
        switch self {
            
        case .allAlarm: return "전체 알림"
        case .contestAlarm: return "대회 알림"
        case .activeAlarm: return "활동 알림"
        case .noticeAlarm: return "공지 알림"
        }
    }
    
    var subTitle: String {
        switch self {
        case .allAlarm: return ""
        case .contestAlarm: return "대회 시작, 최종 투표 시작, 결과 발표 등"
        case .activeAlarm: return "(대)댓글 작성, 신고 접수 및 결과 안내 등"
        case .noticeAlarm: return "공지사항 알림"
        }
    }
}
