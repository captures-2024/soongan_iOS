//
//  TextFieldError.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/3/25.
//

import Foundation

/// `TextFieldError` 열거형은 텍스트 입력 필드에서 발생할 수 있는 오류 상태를 표현하기 위한 타입입니다.
/// 이 타입은 사용자 입력 검증 과정에서 오류를 식별하고, 사용자에게 적절한 피드백 메시지를 제공하는 데 사용됩니다.
///
/// 이 열거형은 텍스트 입력의 유효성 검사에서 발생하는 다양한 오류를 정의하며, 각 오류는 사용자 인터페이스에서 특정 오류 메시지와 연결됩니다.
///
/// ## 열거형의 각 케이스
/// - `duplication`: 입력된 값(예: 아이디)이 이미 사용 중이거나 중복된 경우를 나타냅니다.
///                  주로 서버 또는 데이터베이스에서 중복 여부를 확인한 후 발생합니다.
/// - `specialCharacter`: 입력에 특수문자가 포함된 경우를 나타냅니다.
///                      사용자가 허용되지 않는 문자를 입력했을 때 발생합니다.
/// - `condition(type: TextFieldType)`: 특정 입력 필드(예: 닉네임, 생년월일))의 조건을 만족하지 않는 경우를 나타냅니다.
///                                    연관 값으로 `TextFieldType`을 받아 조건의 세부 유형을 지정합니다.
/// - `onlyConsonantsOrVowels`: 입력이 자음 또는 모음만으로 구성된 경우를 나타냅니다.
///                             주로 한글 입력에서 의미 없는 문자열을 방지하기 위해 사용됩니다.
///
/// ## 사용 예시
/// ```swift
/// let error: TextFieldError = .duplication
/// Text(error.message) // "아이디가 중복되었습니다." 표시
/// ```
/// - 뷰에서 `TextFieldError`의 `message` 속성을 사용하여 사용자에게 오류 메시지를 표시합니다.
/// - 입력 검증 로직에서 `TextFieldError`를 반환하여 오류 상태를 관리합니다.
///
/// ## 주의사항
/// - 이 열거형은 `Equatable`을 채택하여 오류 상태 비교가 가능합니다.
/// - `message` 속성은 각 케이스에 따라 적절한 사용자 피드백을 제공하도록 설계되었습니다.
/// - `condition` 케이스의 `TextFieldType`은 추가적인 컨텍스트를 제공하므로, 이를 처리하는 로직에서 타입에 맞는 조건을 확인해야 합니다.
///
/// - Note: `TextFieldError`는 사용자 입력의 유효성 검사와 UI 피드백을 연결하는 핵심 역할을 하며,
///          입력 폼의 사용자 경험을 개선하기 위해 설계되었습니다.
public enum TextFieldError: Equatable {
    
    /// 입력된 값이 중복된 경우를 나타냅니다.
    case duplication
    
    /// 입력에 특수문자가 포함된 경우를 나타냅니다.
    case specialCharacter
    
    /// 입력이 특정 조건을 만족하지 않는 경우를 나타냅니다.
    /// - Parameter type: 조건이 적용되는 입력 필드의 유형(예: .nickname , .birthday).
    case condition(type: TextFieldType)
    
    /// 입력이 자음 또는 모음만으로 구성된 경우를 나타냅니다.
    case onlyConsonantsOrVowels
    
    /// 각 오류 케이스에 대한 사용자 피드백 메시지를 반환합니다.
    var message: String {
        switch self {
        case .duplication:
            return "아이디가 중복되었습니다."
        case .specialCharacter:
            return "특수문자는 제거해주세요."
        case .condition(let type):
            return type == .birthday ? "1950-2009이내의 기간을 입력해주세요." : ""
        case .onlyConsonantsOrVowels:
            return "자음, 모음을 제거해주세요."
        }
    }
}
