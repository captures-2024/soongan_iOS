//
//  HomeFeature.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import CoreNetwork
import DetailContestFeature
import DesignSystem
import PostPictureFeature
import ExplainFeature
import Shared

import ComposableArchitecture

@Reducer
public struct HomeFeature {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum HomePath {
        case postPicture(PostPictureFeature)
        case contestDetail(ContestDetailFeature)
        case explain(ExplainFeature)
        case completeExplain(CompleteExplainFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.appStorage("AuthState")) var authState: AuthType = .loggedOut
        var path = StackState<HomePath.State>()
        
        var homeState: HomeStateType = .loading
        
        var postImageData = [PostImageModel]()
        var weekTopic: String = ""
        var startPeriod: String = ""
        var endPeriod: String = ""
        var isInfoSheetPresented: Bool = false
        var isAlertPresented: Bool = false
        var isAddPostImage: Bool = false
        
        // CustomTabBar 가시성
        public var isTabBarVisible: Bool {
            path.isEmpty
        }
        
        public init() { }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case path(StackActionOf<HomePath>)
        
        case alertAction(AlertAction)
        case networkAction(NetworkAction)
        case uiAction(UIAction)
        
        case onAppear
        case showExplain(reportId: Int, targetType: String)
        case delegate(Delegate)
                
        public enum Delegate {
            case moveToContestTab
            case didRequestLogout
        }
    }
    
    public enum AlertAction {
        case showNotLoginUserAlert
        case dismissLoginAlert
        case dismissAlertButtonTapped
    }
    
    public enum NetworkAction {
        case homeInfoSuccess(SearchHomeInfoResponseDTO)
        case homeInfoFailure(NetworkError)
    }
    
    public enum UIAction {
        case infoButtonTapped
        case showContestButtonTapped
        case addPictureButtonTapped
        case pictureTapped(Int)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.weekTopic.isEmpty {
                    state.homeState = .loading
                }
                
                return .run { send in
                    let result: Result<SearchHomeInfoResponseDTO, NetworkError> = await NetworkManager.shared.request(HomeEndpoint.getHomeInfo)
                    
                    switch result {
                    case .success(let responseResult):
                        return await send(.networkAction(.homeInfoSuccess(responseResult)))
                    case .failure(let error):
                        return await send(.networkAction(.homeInfoFailure(error)))
                    }
                }

            case .networkAction(.homeInfoSuccess(let result)):
                let contestData = result.contestInfo
                let postData = result.postInfo
                state.isAddPostImage = postData.count == 3

                // status에 따른 HomeStateType 변환
                switch contestData.status {
                case "IN_PROGRESS":
                    state.homeState = .inProgress
                    state.weekTopic = contestData.subject
                    state.startPeriod = contestData.startAt
                    state.endPeriod = contestData.endAt
                    
                    state.postImageData = postData.map {
                        PostImageModel(
                            id: $0.postId,
                            imageURL: $0.imageUrl,
                            likeCount: $0.likeCount,
                            commentCount: $0.commentCount,
                            isLiked: $0.isLiked
                        )
                    }
                    
                case "CLOSED", "UPCOMING":
                    state.homeState = .endTopic
                    state.weekTopic = "-회차 종료-"
                    
                default:
                    state.homeState = .error
                    state.weekTopic = "-알수 없음-"
                }

                return .none
                
            case .networkAction(.homeInfoFailure(_)):
                state.homeState = .error
                state.weekTopic = "-알수 없음-"
                
                return .none
                
            case .showExplain(let reportId, let targetType):
                state.path.append(.explain(ExplainFeature.State(reportId: reportId, targetType: targetType)))
                return .none
                
            case .uiAction(let type):
                switch type {
                case .pictureTapped(let id):
                    state.path.append(.contestDetail(ContestDetailFeature.State(postId: id, weekTopic: state.weekTopic)))
                    
                case .infoButtonTapped:
                    state.isInfoSheetPresented = true
                    
                case .showContestButtonTapped:
                    return .send(.delegate(.moveToContestTab))
                    
                case .addPictureButtonTapped:
                    switch state.authState {
                    case .skipped:
                        return .send(.alertAction(.showNotLoginUserAlert))
                    case .loggedIn:
                        state.path.append(.postPicture(PostPictureFeature.State(mode: .create(weekTopic: state.weekTopic))))
                    default:
                        break
                    }
                }
                
                return .none
                    
            case .alertAction(.showNotLoginUserAlert):
                state.isAlertPresented = true
                return .none
                
            case .alertAction(.dismissAlertButtonTapped):
                state.isAlertPresented = false
                
                return .send(.delegate(.didRequestLogout))
                
            case .alertAction(.dismissLoginAlert):
                state.isAlertPresented = false
                
                return .none
                
            case .path(.popFrom(id: let id)):
                print("Popping from path, id: \(id), isTabBarVisible: \(state.isTabBarVisible)")
                return .none
                
            case let .path(.element(id: _, action: action)):
                switch action {
                case .postPicture(.delegate(.backConfirmed)):
                    state.path.removeLast()
                    return .none
                case .contestDetail(.delegate(.backConfirmed)):
                    state.path.removeLast()
                    return .none
                case .contestDetail(.delegate(.editRequested(let contestId, let round, let title, let imageURL, let weekTopic))):
                    let editState = PostPictureFeature.State(
                        mode: .edit(
                            contestId: contestId,
                            weekRound: round,
                            weekTopic: weekTopic,
                            existingTitle: title,
                            imageURL: imageURL
                        )
                    )
                    state.path.append(.postPicture(editState))
                    return .none
                case .postPicture(.delegate(.editCompleted)):
                    state.path.removeLast()
                    return .send(.onAppear) // 수정 완료 후 새로고침
                case .explain(.delegate(.backConfirmed)):
                    state.path.removeLast()
                    return .none
                    
                case .explain(.delegate(.dismissExplain)):
                    state.path.removeLast()
                    return .none
                    
                case .explain(.delegate(.showCompleteExplain(let completeState))):
                    state.path.append(.completeExplain(completeState))
                    return .none
                    
                case .completeExplain(.delegate(.dismissCompleteExplain)):
                    state.path.removeLast(2)
                    return .none
                    
                default:
                    return .none
                }

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
