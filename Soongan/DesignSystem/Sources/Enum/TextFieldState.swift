//
//  TextFieldState.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/3/25.
//

import SwiftUI

/// `TextFieldState` 열거형은 텍스트 입력 필드의 상태를 정의하기 위한 타입입니다.
/// 사용자의 입력 상태를 관리하고, 입력 필드의 UI(예: 테두리 색상)를 업데이트하는 데 사용됩니다.
///
/// 이 열거형은 입력 필드의 유효성 검사 결과를 반영하며, 각 상태는 사용자에게 입력의 적합성을 시각적으로 피드백합니다.
/// 상태에 따라 테두리 색상(`borderColor`)이 변경되어 사용자 경험을 개선합니다.
///
/// ## 열거형의 각 케이스
/// - `normal`: 입력 필드가 기본 상태일 때를 나타냅니다.
///             사용자가 아직 입력을 시작하지 않았거나 특별한 검증이 적용되지 않은 상태입니다.
/// - `possible`: 입력이 조건을 통과한 상태를 나타냅니다.
///               입력이 형식적으로 유효하지만, 최종 확인(예: 서버 검증)이 필요할 수 있습니다.
/// - `valid`: 입력이 최종적으로 유효한 상태를 나타냅니다.
///            모든 검증 조건을 만족하여 입력이 완료된 상태입니다.
/// - `error(message: TextFieldError)`: 입력이 조건을 통과하지 못한 상태를 나타냅니다.
///                                    연관 값으로 `TextFieldError`를 받아 오류의 세부 원인을 제공합니다.
///
/// ## 사용 예시
/// ```swift
/// @State var fieldState: TextFieldState = .normal
/// TextField("닉네임", text: $input)
///     .border(fieldState.borderColor, width: 1)
/// if case .error(let error) = fieldState {
///     Text(error.message) // 오류 메시지 표시
/// }
/// ```
/// - 뷰에서 `borderColor`를 사용하여 입력 필드의 테두리 색상을 동적으로 설정합니다.
/// - `error` 상태일 경우 `TextFieldError`의 메시지를 표시하여 사용자에게 피드백을 제공합니다.
///
/// ## 주의사항
/// - 이 열거형은 `Equatable`을 채택하여 상태 비교가 가능합니다.
/// - `error` 케이스의 연관 값 `TextFieldError`는 오류 메시지를 제공하므로, UI에서 이를 적절히 처리해야 합니다.
/// - `borderColor` 속성은 상태에 따라 색상을 반환하며, 프로젝트의 디자인 시스템에 맞는 색상(`black60`, `error`)을 사용합니다.
///
/// - Note: `TextFieldState`은 입력 필드의 상태를 시각적으로 표현하고 사용자 피드백을 강화하기 위해 설계되었으며,
///          입력 검증과 UI 업데이트를 통합적으로 관리합니다.
public enum TextFieldState: Equatable {
    
    /// 입력 필드가 기본 상태일 때를 나타냅니다(아무런 입력이나 검증이 없는 상태).
    case normal
    
    /// 입력이 조건을 통과한 상태를 나타냅니다(형식적 유효성 확인 완료).
    case possible
    
    /// 입력이 최종적으로 유효한 상태를 나타냅니다(모든 검증 조건 만족).
    case valid
    
    /// 입력이 조건을 통과하지 못한 상태를 나타냅니다.
    /// - Parameter message: 오류의 세부 원인을 제공하는 `TextFieldError`.
    case error(message: TextFieldError)
    
    /// 입력 필드의 테두리 색상을 반환합니다.
    var borderColor: Color {
        switch self {
        case .normal, .possible:
            return .black60
        case .valid:
            return .black60
        case .error(let message):
            return .error
        }
    }
}
