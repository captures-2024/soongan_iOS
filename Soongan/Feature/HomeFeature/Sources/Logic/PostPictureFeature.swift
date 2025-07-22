//
//  PostPictureFeature.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI
import PhotosUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct PostPictureFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var round: Int = 1
        var textCount: Int = 0
        var weekTopic: String
        var postPictureName: String = ""
        
        var selectedItem: PhotosPickerItem? = nil
        var selectedImage: UIImage? = nil
        var imageData: Data? = nil
        
        var isUpdatePicture: Bool = false
        var isButtonEnabled: Bool = false
        var isPostSheetPresented: Bool = false
        var isAlertPresented: Bool = false
        var alertPresentedType: AlertType?
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case postButtonTapped
        case postButtonTappedInSheet
        case postSuccess(PostWeeklyContestResponseDTO)
        case addPictureButtonTapped
        case dismissPostSheet(Bool)
        case backButtonTapped
        
        case dismissAlertButtonTapped
        case alertConfirmButtonTapped
        
        case delegate(DelegateAction)

        public enum DelegateAction {
            case backConfirmed
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.postPictureName), .binding(\.selectedImage):
                if state.postPictureName.count > 15 {
                    state.postPictureName = String(state.postPictureName.prefix(15))
                }
                
                state.textCount = state.postPictureName.count
                state.isButtonEnabled = (state.textCount > 0) && (state.textCount < 16) && (state.selectedImage != nil)

                return .none
                
            case .onAppear:
                print("PostPicture Appear")
                return .none
            
            case .addPictureButtonTapped:
                
                return .none
                
            case .postButtonTapped:
                state.isPostSheetPresented = true
                return .none
            
            case .postButtonTappedInSheet:
                guard let data = state.selectedImage else { return .none }
                guard let compressData = data.jpegData(compressionQuality: 0.5) else { return .none }
                
                print("압축한 데이타", compressData)
                
                let dto = PostWeeklyContestRequestDTO(
                    title: state.postPictureName,
                    imageFile: compressData
                )
                
                return .run { send in
                    let result: Result<PostWeeklyContestResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.postContest(dto))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.postSuccess(responseResult))
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .postSuccess(_):
                state.isPostSheetPresented = false
                return .send(.delegate(.backConfirmed))
            
            case .backButtonTapped:
                if state.postPictureName.count != 0 || (state.selectedImage != nil) {
                    state.alertPresentedType = .backPostContest
                    state.isAlertPresented = true
                    
                    return .none
                } else {
                    return .send(.delegate(.backConfirmed))
                }
                
            case .alertConfirmButtonTapped:
                state.isAlertPresented = false
                return .send(.delegate(.backConfirmed))
                
            case .dismissAlertButtonTapped:
                state.isAlertPresented = false
                state.alertPresentedType = nil
                
                return .none
                
            case .binding(_):
                return .none
                
            case .dismissPostSheet(_):
                state.isPostSheetPresented = false
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
