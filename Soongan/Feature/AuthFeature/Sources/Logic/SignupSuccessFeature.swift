//
//  SignupSuccessFeature.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/8/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct SignupSuccessFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        let nickname: String
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action {
        case onAppear
        
        case delegate(Delegate)
        
        public enum Delegate {
            case showMainTab
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await Task.sleep(for: .seconds(1))
                    print("SignupSuccessFeature 로 데이터 옴")
                    await send(.delegate(.showMainTab))
                }

            case .delegate(_):
                return .none
            }
        }
    }
}
