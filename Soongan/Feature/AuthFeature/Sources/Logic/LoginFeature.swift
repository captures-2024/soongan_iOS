//
//  LoginFeature.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/2/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct LoginFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum LoginPath {
        case signup(SignupFeature)
        case signupSuccess(SignupSuccessFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<LoginPath.State>()
        
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case path(StackActionOf<LoginPath>)
        
        case binding(BindingAction<State>)
        case kakaoButtonTapped
        case appleButtonTapped
        case skippLoginButtonTapped
        case termsOfUseButtonTapped
        
        // Delegate - LoginFeature -> AppFeature 
        case delegate(Delegate)
        
        public enum Delegate {
            case loginSuccess
            case skippAuth
        }
        
//        case successSignup(SignupFeature.Action)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .appleButtonTapped:
                state.path.append(.signup(SignupFeature.State()))
                return .none
                
            case .kakaoButtonTapped:
                state.path.append(.signup(SignupFeature.State()))
                return .none
                
            case .termsOfUseButtonTapped:
                // TODO: - 이용 약관 웹 페이지
                return .none
                
            case .skippLoginButtonTapped:
                // TODO: - 메인 화면
                return .none
                
            case .delegate(_):
                return .none
   
            case .path(.element(id: _, action: .signup(.delegate(.didCompleteSignup(let nickname))))):
                state.path.append(.signupSuccess(SignupSuccessFeature.State(nickname: nickname)))
                return .none
                
            case .path(.element(id: _, action: .signup(.showSignupView))):
                state.path.append(.signup(SignupFeature.State()))
                return .none
                
            case .path(.element(id: _, action: .signup(.backButtonTapped))):
                state.path.removeLast()
                return .none

            case .path:
                return .none

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
