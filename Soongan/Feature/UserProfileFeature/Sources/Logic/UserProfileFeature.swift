//
//  UserProfileFeature.swift
//  UserProfileFeature
//
//  Created by ParkJunHyuk on 7/17/25.
//

import SwiftUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct UserProfileFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum MypagePath {
        
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var userName: String?
        var userIntroduction: String?
        var userProfileImageUrl: String?
        
        var leftContestImageList = [ContestImageModel]()
        var rightContestImageList = [ContestImageModel]()
        
        public init() {}
        
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}

