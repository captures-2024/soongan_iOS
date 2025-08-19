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
                
                if let endDate = Self.dateFormatter.date(from: contestData.endAt) {
                    if endDate < Date() {
                        state.weekTopic = "-회차 종료-"
                        state.homeState = .endTopic
                    } else {
                        state.startPeriod = contestData.startAt.toFormattedDateString()
                        state.endPeriod = contestData.endAt.toFormattedDateString()
                        
                        state.postImageData = postData.map {
                            PostImageModel(
                                id: $0.postId,
                                imageURL: $0.imageUrl,
                                likeCount: $0.likeCount,
                                commentCount: $0.commentCount,
                                isLiked: $0.isLiked
                            )
                        }
                        
                        state.homeState = .inProgress
                        state.weekTopic = contestData.subject
                    }
                } else {
                    state.weekTopic = "-회차 종료-"
                    state.homeState = .endTopic
                }

                return .none
                
            case .networkAction(.homeInfoFailure(let error)):
                print(error)
                return .none
                
            case .uiAction(let type):
                switch type {
                case .pictureTapped(let id):
                    state.path.append(.contestDetail(ContestDetailFeature.State(postId: id)))
                    
                case .infoButtonTapped:
                    state.isInfoSheetPresented = true
                    
                case .showContestButtonTapped:
                    return .send(.delegate(.moveToContestTab))
                    
                case .addPictureButtonTapped:
                    switch state.authState {
                    case .skipped:
                        return .send(.alertAction(.showNotLoginUserAlert))
                    case .loggedIn:
                        state.path.append(.postPicture(PostPictureFeature.State(weekTopic: state.weekTopic)))
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
