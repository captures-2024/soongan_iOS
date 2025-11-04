//
//  EditProfileFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/22/25.
//

import SwiftUI
import PhotosUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct EditProfileFeature {
    
    @ObservableState
    public struct State: Equatable {
        let baseNickname: String
        let baseIntroduce: String?
        var baseProfileImageUrl: String?
        
        var editButtonState: Bool = false
        var nickname: String = ""
        var introduce: String = ""
        var userProfileData: Data?
        
        var isNicknameButtonEnabled = false
        var isIntroduceButtonEnabled = false
        
        var nicknameState: TextFieldState = .normal
        var introduceState: TextFieldState = .normal
        
        var isProfileSheetPresented: Bool = false
        var isPhotosPickerPresented: Bool = false
        
        var selectedItem: PhotosPickerItem? = nil
        var selectedImage: UIImage? = nil
        var imageData: Data? = nil
    }

    // MARK: - Init

    public init() {}

    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case isEditButtonEnabledChanged
        case editMyProfileButtonTapped
        case editMyProfileSuccess(EditMyProfileResponseDTO)
        
        case showProfileSheet
        case baseProfileOptionTapped
        case selectImageOptionTapped
        case photoSelectionLoaded(Result<Data?, Error>)
        
        case dismissProfileSheet(Bool)
        case backButtonTapped
        
        case delegate(DelegateAction)

        public enum DelegateAction {
            case backButtonTapped
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.nickname = state.baseNickname
                
                if let introduce = state.baseIntroduce {
                    state.introduce = introduce
                }
                
                validateNickname(state: &state)
                validateIntroduce(state: &state)
                
                return .send(.isEditButtonEnabledChanged)
                
            case .editMyProfileButtonTapped:
                let dto = EditMyProfileRequestDTO(
                    nickname: state.nickname,
                    selfIntroduction: state.introduce.isEmpty ? nil : state.introduce,
                    profileImage: state.imageData,
                    isDefaultProfileImage: (state.imageData != nil || state.baseProfileImageUrl != nil) ? false : true
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
                
            case .editMyProfileSuccess(_):
                return .send(.delegate(.backButtonTapped))
            
            case .baseProfileOptionTapped:
                state.selectedItem = nil
                state.selectedImage = nil
                state.imageData = nil
                state.baseProfileImageUrl = nil
                state.isProfileSheetPresented = false
                return .none
                
            case .selectImageOptionTapped:
                state.isProfileSheetPresented = false
                
                return .run { send in
                    try await Task.sleep(for: .seconds(0.5))
                    await send(.set(\.isPhotosPickerPresented, true))
                }
                
            case .showProfileSheet:
                state.isProfileSheetPresented = true
                return .none
                
            case .dismissProfileSheet(let isPresented):
                state.isProfileSheetPresented = isPresented
                return .none
                
            case .binding(\.nickname):
                validateNickname(state: &state)
                return .send(.isEditButtonEnabledChanged)
                
            case .binding(\.introduce):
                validateIntroduce(state: &state)
                return .send(.isEditButtonEnabledChanged)
                
            case .binding(\.selectedItem):
                guard let selectedItem = state.selectedItem else {
                    return .none
                }
                
                return .run { send in
                    let result = await Result {
                        try await selectedItem.loadTransferable(type: Data.self)
                    }
                    await send(.photoSelectionLoaded(result))
                }
            
            case .photoSelectionLoaded(.success(let data)):
                guard let data, let uiImage = UIImage(data: data) else {
                    return .none
                }
                
                state.selectedImage = uiImage
                state.baseProfileImageUrl = nil
                
                // 이미지 압축 로직
                if let compressedData = uiImage.jpegData(compressionQuality: 0.2) {
                    print("이미지 용량", compressedData)
                    state.imageData = compressedData
                } else {
                    state.imageData = data
                }
                
                return .none
                
            case .photoSelectionLoaded(.failure(let error)):
                print("Image Loading Failed: \(error.localizedDescription)")
                return .none
                
            case .isEditButtonEnabledChanged:
                state.editButtonState = state.isNicknameButtonEnabled
                
                return .none
                
            case .backButtonTapped:
                
                return .none
                
            default:
                return .none
            }
        }
    }
}

// MARK: - Private func Extension

private extension EditProfileFeature {
    func validateNickname(state: inout State) {
        switch state.nickname.nicknameValidationState {
        case .empty, .tooShort, .tooLong:
            state.nicknameState = .normal
            state.isNicknameButtonEnabled = false
            
        case .invalidCharacters:
            state.nicknameState = .error(message: .specialCharacter)
            state.isNicknameButtonEnabled = false
            
        case .valid:
            state.nicknameState = .possible
            state.isNicknameButtonEnabled = true
            
        case .onlyConsonantsOrVowels:
            state.nicknameState = .error(message: .onlyConsonantsOrVowels)
            state.isNicknameButtonEnabled = false
        }
    }

    func validateIntroduce(state: inout State) {
        if state.introduce.count > 0 && state.introduce.count <= 25 {
            state.introduceState = .possible
            state.isIntroduceButtonEnabled = true
        } else {
            state.introduceState = .normal
            state.isIntroduceButtonEnabled = false
        }
    }
}
