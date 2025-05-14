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
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print("Appear")
                return .none
            }
        }
    }
}
