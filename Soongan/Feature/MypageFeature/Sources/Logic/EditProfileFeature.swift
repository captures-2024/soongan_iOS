//
//  EditProfileFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/22/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct EditProfileFeature {
    
    @ObservableState
    public struct State: Equatable {

        var editButtonState: Bool = false
        var nickname: String = ""
        var introduce: String = ""
        
        var nicknameState: TextFieldState = .normal
        var introduceState: TextFieldState = .normal
        
        public init() {}
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
        BindingReducer()
        
    }
}
