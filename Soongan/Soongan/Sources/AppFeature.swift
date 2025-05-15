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
        @Shared(.appStorage("AuthState")) var authState: AuthType = .loggedIn
        var login: LoginFeature.State = LoginFeature.State()
        var mainTab: MainTabFeature.State = MainTabFeature.State()
    }
    
    public enum Action {
        case login(LoginFeature.Action)
        case mainTab(MainTabFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.login, action: \.login) {
            LoginFeature()
        }
        
        Scope(state: \.mainTab, action: \.mainTab) {
            MainTabFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .login(.delegate(.loginSuccess)):
                state.$authState.withLock { $0 = .loggedIn }
                
                return .none
                
            case .login(.delegate(.skippAuth)):
                state.$authState.withLock { $0 = .skipped }
                return .none
            
            case .mainTab:
                return .none
                
            default:
                return .none
            }
        }
    }
}
