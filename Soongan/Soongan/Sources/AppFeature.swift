//
//  AppFeature.swift
//  Soongan
//
//  Created by ParkJunHyuk on 5/7/25.
//  Copyright © 2025 Captures. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

import AuthFeature
import Shared

@Reducer
public struct AppFeature {
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.appStorage("AuthState")) var authState: AuthType = .loggedOut
        
        var login: LoginFeature.State?
        var mainTab: MainTabFeature.State?
        
        public init() {
            // 앱 시작 시 authState에 따라 초기 상태를 설정
            if authState == .loggedOut {
                self.login = LoginFeature.State()
                self.mainTab = nil
            } else {
                self.login = nil
                self.mainTab = MainTabFeature.State(selectedTab: .home)
            }
        }
    }
    
    public enum Action {
        case login(LoginFeature.Action)
        case mainTab(MainTabFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .login(.delegate(let delegateAction)):
                switch delegateAction {
                case .loginSuccess:
                    state.$authState.withLock { $0 = .loggedIn }
                    state.mainTab = MainTabFeature.State(selectedTab: .home)
                    state.login = nil
                    
                case .skippAuth:
                    state.$authState.withLock { $0 = .skipped }
                    state.mainTab = MainTabFeature.State(selectedTab: .home)
                    state.login = nil
                }
                
                return .none
                
            case .mainTab(.delegate(.logoutCompleted)):
                state.$authState.withLock { $0 = .loggedOut }
                state.login = LoginFeature.State()
                state.mainTab = nil
                
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.login, action: \.login) {
            LoginFeature()
        }
        .ifLet(\.mainTab, action: \.mainTab) {
            MainTabFeature()
        }
    }
}
