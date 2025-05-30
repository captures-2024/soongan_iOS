//
//  QuestionsListFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

public enum QuestionsTab: Equatable {
    case nomal, contestInfo, copyright
}

@Reducer
public struct QuestionsListFeature {
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: QuestionsTab = .nomal
        var editButtonState: Bool = false
        
        public init() {}
    }

    // MARK: - Init

    init() {}

    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case topMenuButtonTapped(QuestionsTab)
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
