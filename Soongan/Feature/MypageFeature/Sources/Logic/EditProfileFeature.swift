//
//  EditProfileFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/22/25.
//

import SwiftUI

import CoreNetwork
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
        
        case editMyProfile
        case editMyProfileSuccess(EditMyProfileResponseDTO)
        case backButtonTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .editMyProfile:
                let dto = EditMyProfileRequestDTO(
                    nickname: state.nickname,
                    selfIntroduction: state.introduce,
                    profileImage: "",
                    isDefaultProfileImage: false
                )
                
                return .run { send in
                    let result: Result<EditMyProfileResponseDTO, NetworkError> = await NetworkManager.shared.request(MemberEndpoint.patchProfile(dto))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.editMyProfileSuccess(responseResult))
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .editMyProfileSuccess(let response):

                return .none
            
            case .backButtonTapped:
                
                return .none
                
            default:
                return .none
            }
        }
    }
}
