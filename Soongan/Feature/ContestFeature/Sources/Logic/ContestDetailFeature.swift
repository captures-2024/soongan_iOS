//
//  ContestDetailFeature.swift
//  ContestFeature
//
//  Created by ParkJunHyuk on 6/1/25.
//

import SwiftUI

import AppDependencies
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
        var myNickname: String?
        
        var contestTitle: String?
        var imageUrl: String?
        var contestAuthor: String?
        var isLiked: Bool?
        var likeCount: String?
        
        var isContestOptionSheetPresented: Bool = false
        var isReportOptionSheetPresented: Bool = false
        
        var activeSheet: SheetContentType?
        
        var isWriter: Bool {
            return myNickname == contestAuthor
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Dependency
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
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
        case userDataLoaded(String?)
        
        case backButtonTapped
        
        case onAppearSuccess(SearchDetailContestResponseDTO)
        case likeButtonTappedSuccess(PostLikeResponseDTO)
        case deleteActionResult(Bool)
        
        case contestDetailError(Error)
        
        case delegate(DelegateAction)

        public enum DelegateAction {
            case backConfirmed
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let postId = state.postId
                
                return .run { send in
                    async let loadedNickname = userDefaultsClient.getString(forKey: UserDefaultKeys.User.username.rawValue)

                    async let postResult: Result<SearchDetailContestResponseDTO,NetworkError> = NetworkManager.shared.request(WeeklyContestEndpoint.getDetailContest(postId: postId))
                    
                    let (myNicknameResult, contestResult) = await (loadedNickname, postResult)
                    
                    await send(.userDataLoaded(myNicknameResult))
                    
                    switch contestResult {
                    case .success(let responseResult):
                        await send(.onAppearSuccess(responseResult))
                    case .failure(let error):
                        await send(.contestDetailError(error))
                    }
                }
                
            case .onAppearSuccess(let response):
                state.contestTitle = response.title
                state.contestAuthor = response.nickname
                state.imageUrl = response.imageUrl
                state.isLiked = response.isLiked
                state.likeCount = formatLikeCount(response.likeCount)
                
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
                state.likeCount = formatLikeCount(response.likeCount)
                
                return .none
                
            case .deleteButtonTapped:
                let postId = state.postId
                return .run { send in
                    let result: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.deleteContest(postId: postId))
                    
                    switch result {
                    case .success:
                        await send(.deleteActionResult(true))
                    case .failure(let error):
                        print(error)
                        await send(.deleteActionResult(false))
                    }
                }
                
            case .deleteActionResult(let result):
                if result {
                    return .send(.delegate(.backConfirmed))
                } else {
                    return .none
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
                
            case .userDataLoaded(let nickname):
                print("로드된 아이디", nickname)
                state.myNickname = nickname
                return .none
                
            default:
                return .none
            }
        }
    }
}

private extension ContestDetailFeature {
    func formatLikeCount(_ count: Int) -> String {
        let thousand = 1_000
        let million = 1_000_000

        switch count {
        case 0..<thousand:
            return "\(count)"
        case thousand..<million:
            let formatted = Double(count) / Double(thousand)
            return String(format: formatted.truncatingRemainder(dividingBy: 1) == 0 ? "%.0fk" : "%.2fk", formatted)
        default:
            let formatted = Double(count) / Double(million)
            return String(format: formatted.truncatingRemainder(dividingBy: 1) == 0 ? "%.0fm" : "%.2fm", formatted)
        }
    }
}
