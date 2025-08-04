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
import Shared

import ComposableArchitecture

@Reducer
public struct HomeFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum HomePath {
        case postPicture(PostPictureFeature)
        case contestDetail(ContestDetailFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.appStorage("AuthState")) var authState: AuthType = .loggedOut
        var path = StackState<HomePath.State>()
        
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
        
        public init(
            weekTopic: String,
            startPeriod: String,
            endPeriod: String
        ) {
            self.weekTopic = weekTopic
            self.startPeriod = startPeriod
            self.endPeriod = endPeriod
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case path(StackActionOf<HomePath>)
        
        case onAppear
        case addPictureButtonTapped
        case pictureTapped(Int)
        case infoButtonTapped
        case showContest
        case dismissInfoSheet(Bool)
        
        case showNotLoginUserAlert
        case dismissAlertButtonTapped
        case dismissLoginAlert
        
        case homeInfoSuccess(SearchHomeInfoResponseDTO)
        
        case delegate(Delegate)
                
        public enum Delegate {
            case moveToContestTab
            case didRequestLogout
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let result: Result<SearchHomeInfoResponseDTO, NetworkError> = await NetworkManager.shared.request(HomeEndpoint.getHomeInfo)
                    
                    switch result {
                    case .success(let responseResult):
                        return await send(.homeInfoSuccess(responseResult))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            case .homeInfoSuccess(let result):
                let contestData = result.contestInfo
                let postData = result.postInfo
                
                state.startPeriod = contestData.startAt.toFormattedDateString()
                state.endPeriod = contestData.endAt.toFormattedDateString()
                state.weekTopic = contestData.subject
                state.isAddPostImage = postData.count == 3 ? true : false
                
                state.postImageData = postData.map {
                    PostImageModel(
                        id: $0.postId,
                        imageURL: $0.imageUrl,
                        likeCount: $0.likeCount,
                        commentCount: $0.commentCount,
                        isLiked: $0.isLiked
                    )
                }
                
                return .none
                
            case .addPictureButtonTapped:
                switch state.authState {
                case .skipped:
                    return .send(.showNotLoginUserAlert)
                case .loggedIn:
                    state.path.append(.postPicture(PostPictureFeature.State(weekTopic: state.weekTopic)))
                default:
                    break
                }
                
                return .none
                
            case .pictureTapped(let id):
                state.path.append(.contestDetail(ContestDetailFeature.State(postId: id)))
                
                return .none
                
            case .infoButtonTapped:
                state.isInfoSheetPresented = true
                return .none
                
            case .showContest:
                return .send(.delegate(.moveToContestTab))
                
            case .dismissInfoSheet(let isPresented):
                state.isInfoSheetPresented = isPresented
                return .none
                
            case .showNotLoginUserAlert:
                state.isAlertPresented = true
                return .none
                
            case .dismissAlertButtonTapped:
                state.isAlertPresented = false
                
                return .send(.delegate(.didRequestLogout))
                
            case .dismissLoginAlert:
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
