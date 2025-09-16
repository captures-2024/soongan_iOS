//
//  PostPictureFeature.swift
//  PostPictureFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI
import PhotosUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture
import Kingfisher

public enum PostPictureMode: Equatable {
    case create(weekTopic: String)
    case edit(contestId: Int, weekRound: Int, weekTopic: String, existingTitle: String, imageURL: String)
}

@Reducer
public struct PostPictureFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        let mode: PostPictureMode
        var round: Int = 1
        var textCount: Int = 0
        var postPictureName: String = ""
        
        var selectedItem: PhotosPickerItem? = nil
        var selectedImage: UIImage? = nil
        var imageData: Data? = nil
        
        var isUpdatePicture: Bool = false
        var isButtonEnabled: Bool = false
        var isPostSheetPresented: Bool = false
        var isAlertPresented: Bool = false
        var alertPresentedType: AlertType?
        
        // Computed properties
        var weekTopic: String {
            switch mode {
            case .create(let topic):
                return topic
            case .edit(_, _, let topic, _, _):
                return topic
            }
        }
        
        var isEditMode: Bool {
            switch mode {
            case .create:
                return false
            case .edit:
                return true
            }
        }
        
        var contestId: Int? {
            switch mode {
            case .create:
                return nil
            case .edit(let id, _, _, _, _):
                return id
            }
        }
        
        public init(mode: PostPictureMode) {
            self.mode = mode
            
            switch mode {
            case .create:
                break
            case .edit(_, let round, _, let title, _):
                self.round = round
                self.postPictureName = title
                self.textCount = title.count
                self.isButtonEnabled = (self.textCount > 0) && (self.textCount < 16)
            }
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case loadExistingImageSuccess(UIImage, Data)
        case postButtonTapped
        case postButtonTappedInSheet
        case postSuccess(PostWeeklyContestResponseDTO)
        case postFailure(NetworkError)
        case editSuccess(PutWeeklyContestResponseDTO)
        case editFailure(NetworkError)
        case addPictureButtonTapped
        case dismissPostSheet(Bool)
        case backButtonTapped
        
        case dismissAlertButtonTapped
        case alertConfirmButtonTapped
        
        case delegate(DelegateAction)

        public enum DelegateAction {
            case backConfirmed
            case editCompleted
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
                // Edit 모드일 때 기존 이미지 로드
                if case .edit(_, _, _, _, let imageURL) = state.mode {
                    return .run { send in
                        guard let url = URL(string: imageURL) else { return }
                        
                        await withCheckedContinuation { continuation in
                            KingfisherManager.shared.retrieveImage(with: url) { result in
                                switch result {
                                case .success(let value):
                                    let image = value.image
                                    let data = image.jpegData(compressionQuality: 0.8) ?? Data()
                                    DispatchQueue.main.async {
                                        send(.loadExistingImageSuccess(image, data))
                                        continuation.resume()
                                    }
                                case .failure(let error):
                                    print("이미지 로드 실패:", error)
                                    continuation.resume()
                                }
                            }
                        }
                    }
                }
                
                return .none
                
            case .loadExistingImageSuccess(let image, let data):
                state.selectedImage = image
                state.imageData = data
                state.isButtonEnabled = (state.textCount > 0) && (state.textCount < 16)
                return .none
            
            case .addPictureButtonTapped:
                return .none
                
            case .postButtonTapped:
                switch state.mode {
                case .create:
                    state.isPostSheetPresented = true
                    return .none
                    
                case .edit(let contestId, _, _, _, _):
                    // 수정 요청
                    let dto = PutWeeklyContestRequestDTO(
                        title: state.postPictureName
                    )
                    
                    return .run { send in
                        let result: Result<PutWeeklyContestResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.patchContest(postId: contestId, dto))
                        
                        switch result {
                        case .success(let responseResult):
                            await send(.editSuccess(responseResult))
                        case .failure(let error):
                            await send(.editFailure(error))
                        }
                    }
                    
                }
            
            case .postButtonTappedInSheet:
                guard let data = state.selectedImage else { return .none }
                guard let compressData = data.jpegData(compressionQuality: 0.7) else { return .none }
                
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
                        await send(.postFailure(error))
                    }
                }

            case .postSuccess(_):
                state.isPostSheetPresented = false
                return .send(.delegate(.backConfirmed))
                
            case .editSuccess(_):
                state.isPostSheetPresented = false
                return .send(.delegate(.editCompleted))
                
            case .postFailure(let error):
                state.isPostSheetPresented = false
                switch error {
                case .periodExpired:
                    state.alertPresentedType = .postContestError
                    state.isAlertPresented = true
                default:
                    break
                }
                return .none
                
            case .editFailure(let error):
                state.isPostSheetPresented = false
                // 수정 실패 처리
                return .none
            
            case .backButtonTapped:
                if state.postPictureName.count != 0 || (state.selectedImage != nil) {
                    switch state.mode {
                    case .create:
                        state.alertPresentedType = .backPostContest
                    case .edit:
                        state.alertPresentedType = .backEditContest
                    }
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
