//
//  ContestDetailFeature.swift
//  ContestFeature
//
//  Created by ParkJunHyuk on 6/1/25.
//

import SwiftUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct ContestDetailFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var postId: String
        
        var contestTitle: String?
        var contestAuthor: String?
        var isLiked: Bool?
        var likeCount: Int?
        
        var isContestOptionSheetPresented: Bool = false
        var isReportOptionSheetPresented: Bool = false
        
        var activeSheet: SheetContentType?
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        
        case likeButtonTapped
        case optionButtonTapped
        case deleteButtonTapped
        
        case reportSheetIsPresented
        case optionSheetIsPresented(ContestReportReasonType)
        case dismissOptionSheet(Bool)
        case dismissSheet
        
        case backButtonTapped
        
        case onAppearSuccess(SearchDetailContestResponseDTO)
        case likeButtonTappedSuccess(PostLikeResponseDTO)
        
        case contestDetailError(Error)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let postId = state.postId
                
                return .run { send in
                    let result: Result<SearchDetailContestResponseDTO,NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.getDetailContest(postId: postId))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.onAppearSuccess(responseResult))
                    case .failure(let error):
                        await send(.contestDetailError(error))
                    }
                }
                
            case .onAppearSuccess(let response):
                state.contestTitle = response.title
                state.contestAuthor = response.nickname
                state.isLiked = response.isLiked
                state.likeCount = response.likeCount
                
                return .none
                
            case .reportSheetIsPresented:
                state.isContestOptionSheetPresented = false
                state.isReportOptionSheetPresented = true
                
                return .none
                
            case .optionSheetIsPresented(let tappedOption):
                state.isContestOptionSheetPresented = false
                
                switch tappedOption {
                case .inappropriateContent:
                    break
                    
                case .hateSpeech:
                    break
                    
                case .infringement:
                    break
                    
                case .spam:
                    state.activeSheet = .spam
                    
                case .promotion:
                    break
                    
                case .other:
                    break
                }
                
                return .none
                
            case .likeButtonTapped:
                let dto = PostLikeRequestDTO(postId: state.postId, contestType: "WEEKLY")
                
                let isLiked = state.isLiked ?? false
                
                return .run { send in
                    let result: Result<PostLikeResponseDTO, NetworkError> = await NetworkManager.shared.request(isLiked ? PostLikeEndpoint.deletePostLike(dto) : PostLikeEndpoint.putPostLike(dto))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.likeButtonTappedSuccess(responseResult))
                    case .failure(let error):
                        await send(.contestDetailError(error))
                    }
                }
            
            case .likeButtonTappedSuccess(let response):
                state.likeCount = Int(response.likeCount)
                
                return .none
                
            case .deleteButtonTapped:
                let postId = state.postId
                return .run { send in
                    let result: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.deleteContest(postId: postId))
                    
                    switch result {
                    case .success:
                        print("성공")
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .dismissOptionSheet:
                state.isContestOptionSheetPresented = false
                return .none
                
            case .dismissSheet:
                state.activeSheet = nil
                return .none
                
            case .optionButtonTapped:
                state.isContestOptionSheetPresented = true
                
                return .none
                
            default:
                return .none
            }
        }
    }
}
