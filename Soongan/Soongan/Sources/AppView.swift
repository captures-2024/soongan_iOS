//
//  AppView.swift
//  Soongan
//
//  Created by ParkJunHyuk on 5/7/25.
//  Copyright © 2025 Captures. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import AuthFeature
import SplashFeature

public struct AppView: View {
    
    @Bindable var store: StoreOf<AppFeature>
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            if let store = store.scope(state: \.splash, action: \.splash) {
                SplashView(store: store)
                    .transition(.opacity)
            } else {
                switch store.authState {
                case .loggedIn, .skipped:
                    // mainTab 상태가 nil이 아닐 때만 MainTabView를 렌더링
                    IfLetStore(
                        self.store.scope(state: \.mainTab, action: \.mainTab)
                    ) { mainTabStore in
                        MainTabView(store: mainTabStore)
                    }
                    
                case .loggedOut:
                    // login 상태가 nil이 아닐 때만 LoginView를 렌더링
                    IfLetStore(
                        self.store.scope(state: \.login, action: \.login)
                    ) { loginStore in
                        LoginView(store: loginStore)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: store.splash == nil)
    }
}

// MARK: - Preview

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
