//
//  TextFieldType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/3/25.
//

import Foundation

/// `TextFieldType` 열거형은 텍스트 입력 필드의 유형을 정의하기 위한 타입입니다.
/// 사용자 입력 폼에서 각 필드의 역할(예: 닉네임, 생년월일)을 구분하고,
/// 해당 필드에 적합한 UI 요소(제목, 부제목, 플레이스홀더)를 제공하는 데 사용됩니다.
///
/// 이 열거형은 입력 폼의 사용자 경험을 개선하기 위해 필드별로 적절한 안내 텍스트를 제공하며,
/// 입력 검증 로직에서 필드 유형에 따라 다른 조건을 적용할 때도 활용됩니다.
///
/// ## 열거형의 각 케이스
/// - `nickname`: 사용자의 닉네임을 입력받는 필드를 나타냅니다.
///              닉네임은 숫자, 영문, 한글로 구성되며, 3~10자 길이 제한이 적용됩니다.
/// - `birthday`: 사용자의 생년월일을 입력받는 필드를 나타냅니다.
///              4자리 숫자(YYYY 형식)로 입력되며, 사용자의 출생 연도를 나타냅니다.
///
/// ## 사용 예시
/// ```swift
/// let fieldType: TextFieldType = .nickname
/// Text(fieldType.title) // "닉네임" 표시
/// TextField(fieldType.placeholder, text: $input) // "사용자명을 입력해주세요." 플레이스홀더
/// ```
/// - 뷰에서 `title`, `subTitle`, `placeholder` 속성을 사용하여 필드의 UI를 구성합니다.
/// - 입력 검증 로직에서 `TextFieldType`을 참조하여 필드별 조건을 확인합니다.
///
/// ## 주의사항
/// - 이 열거형은 `Equatable`을 채택하여 필드 유형 비교가 가능합니다.
/// - `birthday` 케이스는 생년월일을 나타내며, 4자리 연도(예: 1990)를 입력받도록 설계되었습니다.
/// - 각 속성(`title`, `subTitle`, `placeholder`)는 필드 유형에 맞는 사용자 안내 텍스트를 제공하므로,
///   UI 구성 시 일관성을 유지해야 합니다.
///
/// - Note: `TextFieldType`은 입력 폼의 사용자 인터페이스와 검증 로직을 통합적으로 관리하기 위해 설계되었으며,
///          필드별로 명확한 안내를 제공하여 사용자 경험을 향상시킵니다.
public enum TextFieldType: Equatable {
    
    /// 사용자의 닉네임을 입력받는 필드를 나타냅니다.
    case nickname
    
    // 사용자의 생년월일을 입력받는 필드를 나타냅니다(4자리 연도, YYYY 형식).
    case birthday
    
    /// 입력 필드 상단의 제목을 반환합니다.
    var title: String {
        switch self {
        case .nickname:
            return "닉네임"
        case .birthday:
            return "출생연도"
        }
    }
    
    /// 입력 필드 하단의 부제목(안내 텍스트)을 반환합니다.
    var subTitle: String {
        switch self {
        case .nickname:
            return "3-10자리 숫자, 영문, 한글로 기입해주세요"
        case .birthday:
            return "출생연도 숫자 4자리를 기입해주세요."
        }
    }
    
    /// 입력 필드의 플레이스홀더 텍스트를 반환합니다.
    var placeholder: String {
        switch self {
        case .nickname:
            return "사용자명을 입력해주세요."
        case .birthday:
            return "YYYY"
        }
    }
}
