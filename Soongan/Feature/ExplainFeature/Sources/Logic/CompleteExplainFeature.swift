//
//  CompleteExplainFeature.swift
//  ExplainFeature
//
//  Created by ParkJunHyuk on 9/5/25.
//  Copyright © 2025 soongan. All rights reserved.
//

import ComposableArchitecture


@Reducer
public struct CompleteExplainFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action {
        case bottomButtonTapped
        
        case delegate(Delegate)
    }
    
    public enum Delegate {
        case dismissCompleteExplain
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case .bottomButtonTapped:
                return .send(.delegate(.dismissCompleteExplain))
                
            case .delegate(_):
                return .none
            }
        }
    }
}
