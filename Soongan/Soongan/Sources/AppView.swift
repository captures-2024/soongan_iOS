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

public struct AppView: View {
    
    @Bindable var store: StoreOf<AppFeature>
    
    public var body: some View {
        
        switch store.authState {
        case .loggedIn, .skipped:
            MainTabView(store: store.scope(state: \.mainTab, action: \.mainTab))
            
        case .loggedOut:
            LoginView(store: store.scope(state: \.login, action: \.login))
        }
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
