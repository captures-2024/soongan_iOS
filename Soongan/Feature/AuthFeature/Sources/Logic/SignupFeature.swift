//
//  SignupFeature.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/4/25.
//

import SwiftUI

import AppDependencies
import CoreNetwork
import CoreUserDefault
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct SignupFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var nickname: String = ""
        var birthday: String = ""
        
        var nicknameState: TextFieldState = .normal
        var birthdayState: TextFieldState = .normal
        
        var signupState: SignupStateType = .inputNickname
        
        var isButtonEnabled: Bool = false
        var showSecondField: Bool = false
        var isNicknameFocused: Bool = false
        var isBirthdayFocused: Bool = false
        
        var signupErrorAlert: SignupErrorType?
        
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Dependency
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
        case showSignupView
        case backButtonTapped
        
        case checkNicknameSuccess
        case checkNicknameFailure
        
        case completeSignup
        case editBirthDayFailure
        case fetchMyprofileFailed
        
        case nickNameError
        case birhDayError
        
        case dismissAlert
        
        // Delegate - SignupFeature -> LoginFeature
        case delegate(Delegate)
        
        public enum Delegate {
            case didCompleteSignup(nickname: String)
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.nickname):
                switch state.nickname.nicknameValidationState {
                case .empty, .tooShort, .tooLong:
                    state.nicknameState = .normal
                    state.isButtonEnabled = false
                    
                case .invalidCharacters:
                    state.nicknameState = .error(message: .specialCharacter)
                    state.isButtonEnabled = false
                    
                case .valid:
                    state.nicknameState = .possible
                    state.isButtonEnabled = true
                    
                case .onlyConsonantsOrVowels:
                    state.nicknameState = .error(message: .onlyConsonantsOrVowels)
                    state.isButtonEnabled = false
                }
                
                return .none
                
            case .binding(\.birthday):
                if state.birthday.count == 4 {
                    state.birthdayState = .possible
                    state.isButtonEnabled = true
                } else {
                    state.birthdayState = .normal
                    state.isButtonEnabled = false
                }
                
                return .none
                
            case .nextButtonTapped:
                switch state.signupState {
                case .inputNickname:
                    let dto = CheckNickNameRequestDTO(nickname: state.nickname)
                    
                    return .run { send in
                        let result: Result<Bool, NetworkError> = await NetworkManager.shared.request(MemberEndpoint.getCheckNickname(dto))
                        
                        switch result {
                        case .success(let response):
                            if response { // 중복일때 false 반환
                                await send(.checkNicknameSuccess)
                            } else {
                                await send(.nickNameError)
                            }
                            
                        case .failure:
                            await send(.checkNicknameFailure)
                        }
                    }
                case .inputBirthday:
                    if birthdayValidationState(state.birthday) {
                        guard let birthdayToInt = Int(state.birthday) else {
                            return .send(.birhDayError)
                        }

                        let editMyProfileDto = EditMyProfileRequestDTO(
                            nickname: state.nickname,
                            isDefaultProfileImage: true
                        )
                        
                        let dto = EditMyBirthYearRequestDTO(birthYear: birthdayToInt)

                        return .run { send in
                            async let myBirthResult: Result<EditMyBirthYearResponseDTO, NetworkError> = await NetworkManager.shared.request(
                                MemberEndpoint.patchBirthYear(dto)
                            )
                            
                            print("입력 받은 DTO", editMyProfileDto)
                            
                            async let myprofileResult: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(
                                MemberEndpoint.patchProfile(editMyProfileDto)
                            )
                            
                            let (birthResult, profileResult) = await (myBirthResult, myprofileResult)

                            switch (birthResult, profileResult) {
                             case (.success, .success):
                                 await send(.completeSignup)
                            case (.success, .failure):
                                await send(.fetchMyprofileFailed)
                            case (.failure, .success):
                                await send(.editBirthDayFailure)
                             default:
                                 await send(.editBirthDayFailure)
                             }
                        }
                    } else {
                        return .send(.birhDayError)
                    }
                }
                
            case .checkNicknameSuccess:
                state.signupState = .inputBirthday
                state.isButtonEnabled = false
                
                return .none
                
            case .checkNicknameFailure:
                state.signupErrorAlert = .checkNicknameFailed
                return .none
                
            case .fetchMyprofileFailed:
                state.signupErrorAlert = .myprofileFailed
                return .none
                
            case .editBirthDayFailure:
                state.signupErrorAlert = .editBrithDayFailed
                return .none
                
            case .completeSignup:
                return .run { [nickname = state.nickname] send in
                    await userDefaultsClient.setString(nickname, forKey: UserDefaultKeys.User.username.rawValue)
                    await send(.delegate(.didCompleteSignup(nickname: nickname)))
                }
                
            case .nickNameError:
                state.nicknameState = .error(message: .duplication)
                state.isButtonEnabled = false
                return .none
                
            case .birhDayError:
                state.birthdayState = .error(message: .condition(type: .birthday))
                state.isButtonEnabled = false
                return .none
                
            case .dismissAlert:
                state.signupErrorAlert = nil
                return .none
                
            case .binding(_):
                
                return .none
                
            case .showSignupView:
                return .none
                
            case .backButtonTapped:
                return .none
                
            case .delegate(_):
                return .none
            }
        }
    }
}

// MARK: - Private extension

private extension SignupFeature {
    func birthdayValidationState(_ birthday: String) -> Bool {
        
        guard let birthdayToInt = Int(birthday) else { return false }
        
        if birthdayToInt >= 1950 && birthdayToInt <= 2009 {
            return true
        } else {
            return false
        }
    }
}
