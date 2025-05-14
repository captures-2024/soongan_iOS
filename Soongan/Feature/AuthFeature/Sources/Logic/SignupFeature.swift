//
//  SignupFeature.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/4/25.
//

import SwiftUI

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
        
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
        case showSignupView
        case backButtonTapped
        
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
                    state.signupState = .inputBirthday
                    state.isButtonEnabled = false
                    
                case .inputBirthday:
                    if birthdayValidationState(state.birthday) {
                        // TODO: - 다음화면으로 진행
                        print("SignupFeature 로 데이터 옴")
                        return .send(.delegate(.didCompleteSignup(nickname: state.nickname)))
                        
                    } else {
                        // TODO: - 잘못된 기입
                        state.birthdayState = .error(message: .condition(type: .birthday))
                    }
                }
                
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
