//
//  AlarmListFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

public enum AlarmTab {
    case home, search, profile
}

@Reducer
public struct AlarmListFeature {
    
    @ObservableState
    public struct State: Equatable {

        var selectedTab: AlarmTab = .home
        
        public init() {}
    }

    // MARK: - Init

    public init() {}

    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case topMenuButtonTapped(AlarmTab)
        case backButtonTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .backButtonTapped:
                return .none
                
            case .topMenuButtonTapped(let type):
                state.selectedTab = type
                
                return .none
            }
        }
    }
}
