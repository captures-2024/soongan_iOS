//
//  DetailContestFeature.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 6/12/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct DetailContestFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        
        
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case backButtonTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
     
            default:
                return .none
            }
        }
    }
}
