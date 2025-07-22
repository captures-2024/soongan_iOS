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
    case logoutSuccess
    case withdraw
    case withdrawSuccess
    case myprofileOption
    case alarmSetting
    case contestReport
    case spam
    case infringement
    case inappropriateContent
    case hateSpeech
    case promotion
    case other
    case reportComplete(type: ContestReportReasonType)
    case detailContestOption(isWriter: Bool)
    case sortContest
    case selectProfile(isBaseProfile: Bool)
    
    public var id: String {
        switch self {
        case .contestInfo: return "contestInfo"
        case .postPicture(let name): return "postPicture_\(name)"
        case .logout: return "logout"
        case .logoutSuccess: return "logoutSuccess"
        case .withdraw: return "withdraw"
        case .withdrawSuccess: return "withdrawSuccess"
        case .myprofileOption: return "myprofileOption"
        case .alarmSetting: return "alarmSetting"
        case .contestReport: return "contestReport"
        case .spam: return "spam"
        case .infringement: return "infringement"
        case .inappropriateContent: return "inappropriateContent"
        case .hateSpeech: return "hateSpeech"
        case .promotion: return "promotion"
        case .other: return "other"
        case .reportComplete: return "reportComplete"
        case .detailContestOption: return "detailContestOption"
        case .sortContest: return "sortContest"
        case .selectProfile: return "selectProfile"
        }
    }
    
    var title: String {
        switch self {
        case .contestInfo: return "대회정보"
        case .postPicture: return "제목 확인"
        case .logout, .logoutSuccess: return "로그아웃"
        case .withdraw, .withdrawSuccess: return "회원탈퇴"
        case .myprofileOption, .detailContestOption, .sortContest, .selectProfile: return ""
        case .alarmSetting: return "푸시 알림 설정"
        case .contestReport, .reportComplete, .spam, .infringement, .inappropriateContent, .hateSpeech, .promotion, .other: return "신고"
        }
    }
    
    var height: Set<PresentationDetent> {
        switch self {
        case .contestInfo: return [.fraction(0.75)]
        case .postPicture: return [.fraction(0.31)]
        case .logout, .logoutSuccess: return [.height(264)]
        case .withdraw: return [.height(392)]
        case .withdrawSuccess: return [.height(264)]
        case .myprofileOption: return [.height(420)]
        case .alarmSetting: return [.height(380)]
        case .contestReport: return [.height(432)]
        case .spam, .inappropriateContent, .hateSpeech, .promotion: return [.height(288)]
        case .infringement, .other: return [.height(404)]
        case .reportComplete: return [.height(456)]
        case .detailContestOption, .sortContest: return [.height(240)]
        case .selectProfile: return [.height(165)]
        }
    }
}


public enum MyprofileOptionType: Equatable, CaseIterable {
    case editMyProfile
//    case license
    case pushAlarmSetting
    case terms
    case faq
    case withdraw
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
            
        case .withdraw:
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
            
        case .withdraw:
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

public enum DetailContestOptionType: Equatable, CaseIterable {
    case edit
    case delete
    case report
    
    var title: String {
        switch self {
        case .edit: return "수정하기"
        case .delete: return "삭제하기"
        case .report: return "신고하기"
        }
    }
    
    func rightImage(isWriter: Bool) -> Image {
        switch self {
        case .edit: return isWriter ? .selectEditIcon : .notSelectEditIcon
        case .delete: return isWriter ? .selectDeleteIcon : .notSelectDeleteIcon
        case .report: return isWriter ? .notSelectReportIcon : .selectReportIcon
        }
    }
}

extension DetailContestOptionType {
    func isEnabled(forWriter isWriter: Bool) -> Bool {
        if isWriter {
            return self == .report
        } else {
            return self != .report
        }
    }
}

public enum SortContestDataType: String, CaseIterable, Equatable {
    case like = "MOST_LIKED"
    case oldest = "OLDEST"
    case newest = "LATEST"

    var title: String {
        switch self {
        case .like: return "좋아요 순"
        case .oldest: return "오래된 순"
        case .newest: return "최신 등록 순"
        }
    }

    func rightImage(isSelected: Bool) -> Image {
        switch self {
        case .like:
            return isSelected ? .selectSortLikeIcon : .notSelectSortLikeIcon
        case .oldest:
            return isSelected ? .selectSortOldestIcon : .notSelectSortOldestIcon
        case .newest:
            return isSelected ? .selectSortNewestIcon : .notSelectSortNewestIcon
        }
    }
}

public enum MypageSuccessSheetType: Equatable, CaseIterable {
    case logout
    case withdraw
    
    public var id: String {
        switch self {
        case .logout: return "logoutComplete"
        case .withdraw: return "withdraw"
        }
    }
}

public enum EditProfileType: Equatable, CaseIterable {
    case selectImage
    case baseProfile
    
    var title: String {
        switch self {
        case .selectImage: return "갤러리에서 사진 선택"
        case .baseProfile: return "기본 프로필로 돌아가기"
        }
    }
}
