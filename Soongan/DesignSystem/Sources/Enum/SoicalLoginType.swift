//
//  SoicalLoginType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/2/25.
//

import SwiftUI

public enum SocialLoginType {
    case kakao
    case apple

    var title: String {
        switch self {
        case .kakao:
            return "Kakao로 로그인"
        case .apple:
            return "Apple로 로그인"
        }
    }

    var iconName: String {
        switch self {
        case .kakao:
            return "KakaoLogo"
        case .apple:
            return "AppleLogo"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .kakao:
            return Color.kakaoBackground
        case .apple:
            return Color.white
        }
    }

    var textColor: Color {
        return Color.black100
    }
}
