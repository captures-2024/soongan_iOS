//
//  ContestFeature.swift
//  ContestFeature
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI

import CoreNetwork
import DetailContestFeature
import DesignSystem
import PostPictureFeature
import Shared

import ComposableArchitecture

@Reducer
public struct ContestFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum ContestPath {
        case contestDetail(ContestDetailFeature)
        case editPost(PostPictureFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<ContestPath.State>()
        
        var contestOptions = [ContestIndexModel]()
        var scrollPosition: ScrollPosition = ScrollPosition(idType: ContestImageModel.ID.self)
        
        var isTopButtonVisibility: Bool = false
        
        var contestIndex: Int = 0
        var weekTopic: String = ""
        
        var leftContestImageList = [ContestImageModel]()
        var rightContestImageList = [ContestImageModel]()
        
        var selectedContestIndex: Int = 0 {
            didSet {
                print("selectedContestIndex", selectedContestIndex)
            }
        }
        
        var initPageLoading: Bool = false
        var isNextPageLoading: Bool = false
        
        var isContestSheetPresented: Bool = false
        var isSortSheetPresented: Bool = false
        var sortSelectType: SortContestDataType = .newest
        
        // CustomTabBar 가시성
        public var isTabBarVisible: Bool {
            path.isEmpty
        }
        
        var currentPageNum: Int = 0
        var hasNextPage: Bool = false
        
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case path(StackActionOf<ContestPath>)
        
        case binding(BindingAction<State>)
    
        case onAppear
        case networkAction(NetworkAction)
        case uiAction(UIAction)
        case view(ViewAction)
        case sheet(SheetAction)
 
        case delegate(DelegateAction)
        
        public enum DelegateAction {
            case logoutRequested
        }
        
        public enum NetworkAction {
            case fetchContestPosts
            case getContestSuccess(SearchWeeklyContestResponseDTO)
            case getContestListSuccess(SearchContestListResponseDTO)
            case loadMoreContestsPosts
            case updateContestPageInfo(PageInfoData)
            case refreshTriggered
        }
        
        public enum UIAction {
            case contestDetailImageTapped(Int)
            case sortContestContentTapped
        }
        
        @CasePathable
        public enum SheetAction {
            case present
            case dismissContest(Bool)
            case dismissSortContest(Bool)
        }
        
        // 뷰 상태나 레이아웃 관련
        public enum ViewAction {
            case changeContestIndex
            case changeSortContestType(SortContestDataType)
            case updateTopButtonVisibility(CGFloat)
            case updateLeftImageModel(Int, CGFloat)
            case updateRightImageModel(Int, CGFloat)
            case updateMoreNextPage(Bool)
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let result: Result<SearchContestListResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.getContestList)
                    
                    switch result {
                    case .success(let response):
                        await send(.networkAction(.getContestListSuccess(response)))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
              
            // 콘테스트 목록을 성공적으로 가져온 후, '게시물'을 가져오는 새 액션을 보냅니다.
            case .networkAction(.getContestListSuccess(let response)):
                state.contestOptions = response.contests.map {
                    ContestIndexModel(id: $0.id, round: $0.round, subject: $0.subject)
                }
                
                state.contestIndex = state.contestOptions.last?.round ?? 0
                state.weekTopic = state.contestOptions.last?.subject ?? "정보없음"
                state.selectedContestIndex = state.contestOptions.count - 1
                
                return .send(.networkAction(.fetchContestPosts))
                
            // fetchContestPosts 액션을 받아 올바른 contestIndex로 게시물을 요청합니다.
            case .networkAction(.fetchContestPosts), .networkAction(.refreshTriggered):
                switch action {
                case .networkAction(.fetchContestPosts):
                    state.initPageLoading = true
                default:
                    break
                }
                
                state.scrollPosition.scrollTo(edge: .top)
                state.currentPageNum = 0
                
                let order = state.sortSelectType.rawValue
                let dto = SearchWeeklyContestRequestDTO(
                    round: state.contestIndex,
                    orderCriteria: order,
                    page: 0,
                    pageSize: 20
                )
                
                return .run { send in
                    let result: Result<SearchWeeklyContestResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.getContest(dto))
                    
                    switch result {
                    case .success(let response):
                        await send(.networkAction(.getContestSuccess(response)))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            
            // 다음 페이지가 존재할때 게시물을 요청합니다.
            case .networkAction(.loadMoreContestsPosts):
                state.isNextPageLoading = true
                state.currentPageNum += 1
                
                let dto = SearchWeeklyContestRequestDTO(
                    round: state.contestIndex,
                    orderCriteria: state.sortSelectType.rawValue,
                    page: state.currentPageNum,
                    pageSize: 20
                )
                
                return .run { send in
                    try await Task.sleep(nanoseconds: 1000_000_000)
                    
                    let result: Result<SearchWeeklyContestResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.getContest(dto))
                    
                    switch result {
                    case .success(let response):
                        await send(.networkAction(.getContestSuccess(response)))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            // 게시물 데이터를 성공적으로 받으면 상태를 업데이트합니다.
            case .networkAction(.getContestSuccess(let response)):
                state.contestIndex = response.round
                state.weekTopic = response.subject
                
                state.currentPageNum = response.pageInfo.page
                state.hasNextPage = response.pageInfo.hasNext
                
                if state.currentPageNum == 0 {
                    state.leftContestImageList.removeAll()
                    state.rightContestImageList.removeAll()
                }
                
                let totalCount = state.leftContestImageList.count + state.rightContestImageList.count
                
                var tempLeftConestImageData = [ContestImageModel]()
                var tempRightConestImageData = [ContestImageModel]()
                
                for (index, item) in response.posts.enumerated() {
                    let model = ContestImageModel(id: item.postId, imageUrl: item.imageUrl, nickname: item.nickname)
                    
                    if (totalCount + index) % 2 == 0 {
                        tempLeftConestImageData.append(model)
                    } else {
                        tempRightConestImageData.append(model)
                    }
                }
                
                state.leftContestImageList += tempLeftConestImageData
                state.rightContestImageList += tempRightConestImageData
                
                state.hasNextPage = response.pageInfo.hasNext
                state.weekTopic = response.subject
                
                state.isNextPageLoading = false
                state.initPageLoading = false
                
                return .none

                
            case let .path(.element(id: _, action: action)):
                switch action {
                case .contestDetail(.delegate(.backConfirmed)):
                    state.path.removeLast()
                    return .none
                case .contestDetail(.delegate(.didRequestLogout)):
                    return .send(.delegate(.logoutRequested))
                case .contestDetail(.delegate(.editRequested(let contestId, let title, let imageURL, let weekTopic))):
                    let editState = PostPictureFeature.State(
                        mode: .edit(
                            contestId: contestId,
                            weekTopic: weekTopic,
                            existingTitle: title,
                            imageURL: imageURL
                        )
                    )
                    state.path.append(.editPost(editState))
                    return .none
                case .editPost(.delegate(.editCompleted)):
                    state.path.removeLast()
                    return .send(.networkAction(.refreshTriggered)) // 수정 완료 후 새로고침
                case .editPost(.delegate(.backConfirmed)):
                    state.path.removeLast()
                    return .none
                default:
                    return .none
                }
                
            case .binding(_):
                return .none
            
            case .uiAction(.contestDetailImageTapped(let postId)):
                state.path.append(.contestDetail(ContestDetailFeature.State(postId: postId, weekTopic: state.weekTopic)))
                return .none
                
            case .uiAction(.sortContestContentTapped):
                state.isSortSheetPresented = true
                return .none
                
            case .sheet(let action):
                switch action {
                case .present:
                    state.isContestSheetPresented = true
                
                case .dismissContest:
                    state.isContestSheetPresented = false
                    
                case .dismissSortContest:
                    state.isSortSheetPresented = false
                }
                
                return .none
                
            case .view(.changeContestIndex):
                let contest = state.contestOptions[state.selectedContestIndex]
                
                state.contestIndex = contest.round
                state.weekTopic = contest.subject
                
                state.isContestSheetPresented = false
                
                return .send(.networkAction(.fetchContestPosts))
                
            case .view(.changeSortContestType(let type)):
                state.sortSelectType = type
                state.isSortSheetPresented = false
                
                return .send(.networkAction(.fetchContestPosts))
                
            case .view(.updateLeftImageModel(let modelId, let imageRatio)):
                if let index = state.leftContestImageList.firstIndex(where: { $0.id == modelId }) {
                    state.leftContestImageList[index].height = imageRatio
                }
                
                return .none
                
            case .view(.updateRightImageModel(let modelId, let imageRatio)):
                if let index = state.rightContestImageList.firstIndex(where: { $0.id == modelId }) {
                    state.rightContestImageList[index].height = imageRatio
                }
                
                return .none
                
            case .view(.updateTopButtonVisibility(let scrollOffset)):
                state.isTopButtonVisibility = scrollOffset > 200

                return .none
                
            case .view(.updateMoreNextPage(let isloading)):
                if state.hasNextPage {
                    state.isNextPageLoading = isloading
                    return .send(.networkAction(.loadMoreContestsPosts))
                }
                
                return .none
                
            case .delegate:
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
