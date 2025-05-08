//
//  SignupStateType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/8/25.
//

import Foundation

/// `SignupStateType` 열거형은 회원가입 화면에서 텍스트 입력 필드의 상태를 정의하기 위한 타입입니다.
/// 닉네임과 생년월일 입력 필드의 표시 여부를 관리하며, 사용자 입력의 순차적 흐름을 제어합니다.
///
/// 회원가입 화면에는 두 개의 텍스트 필드(닉네임, 생년월일)가 있으며, 닉네임 입력이 완료되고 검증을 통과해야
/// 생년월일 입력 필드가 표시됩니다. 이 열거형은 현재 어떤 입력 단계에 있는지를 나타냅니다.
///
/// ## 열거형의 각 케이스
/// - `inputNickname`: 닉네임 입력 단계입니다.
///                    이 상태에서는 닉네임 텍스트 필드만 표시되며, 사용자가 닉네임을 입력하고
///                    검증(예: 중복, 형식)을 통과해야 다음 단계로 전환됩니다.
/// - `inputBirthday`: 생년월일 입력 단계입니다.
///                    닉네임 입력이 완료된 후 이 상태로 전환되며, 생년월일 텍스트 필드가 표시됩니다.
///
/// ## 사용 예시
/// ```swift
/// @State var signupState: SignupStateType = .inputNickname
/// if signupState == .inputNickname {
///     TextField("닉네임", text: $nickname)
/// } else {
///     TextField("생년월일", text: $birthday)
/// }
/// ```
/// - 뷰에서 `signupState`를 확인하여 표시할 텍스트 필드를 결정합니다.
/// - 입력 검증 로직에서 상태 전환(예: `.inputNickname` → `.inputBirthday`)을 수행합니다.
///
/// ## 주의사항
/// - 이 열거형은 `Equatable`을 암시적으로 채택하여 상태 비교가 가능합니다.
/// - 상태 전환은 닉네임 입력의 검증 결과에 따라 결정되므로, 검증 로직과 긴밀히 연동해야 합니다.
/// - `inputBirthday` 상태로 전환되기 전에 닉네임의 유효성을 반드시 확인해야 UI 흐름이 올바르게 유지됩니다.
///
/// - Note: `SignupStateType`은 회원가입 과정의 단계적 입력 흐름을 관리하기 위해 설계되었으며,
///          사용자 경험을 개선하기 위해 텍스트 필드의 표시 순서를 제어합니다.
public enum SignupStateType {
    
    /// 닉네임 입력 단계를 나타냅니다. 이 상태에서는 닉네임 텍스트 필드만 표시됩니다.
    case inputNickname
    
    /// 생년월일 입력 단계를 나타냅니다. 닉네임 입력 완료 후 생년월일 텍스트 필드가 표시됩니다.
    case inputBirthday
}
