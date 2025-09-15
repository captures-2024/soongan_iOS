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
import SplashFeature
import Shared

@Reducer
public struct AppFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.appStorage("AuthState")) var authState: AuthType = .loggedOut
        
        var splash: SplashFeature.State?
        var login: LoginFeature.State?
        var mainTab: MainTabFeature.State?
        
        public init()  {
            self.splash = SplashFeature.State()
        }
    }
    
    // MARK: - Action
    
    public enum Action {
        case splash(SplashFeature.Action)
        case login(LoginFeature.Action)
        case mainTab(MainTabFeature.Action)
        case pushNotificationTapped(reportId: Int, targetType: String)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .splash(.delegate(.versionCheckCompleted)):
                state.splash = nil
                if state.authState == .loggedOut {
                    state.login = LoginFeature.State()
                } else {
                    state.mainTab = MainTabFeature.State(selectedTab: .home)
                }
                return .none
                
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
                
            case .pushNotificationTapped(let reportId, let targetType):
                // 로그인된 상태에서만 처리
                if state.mainTab != nil {
                    return .send(.mainTab(.handlePushNotification(reportId: reportId, targetType: targetType)))
                }
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.splash, action: \.splash) {
            SplashFeature()
        }
        .ifLet(\.login, action: \.login) {
            LoginFeature()
        }
        .ifLet(\.mainTab, action: \.mainTab) {
            MainTabFeature()
        }
    }
}
