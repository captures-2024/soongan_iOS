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
import ExplainFeature
import Shared

import ComposableArchitecture

@Reducer
public struct ContestFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum ContestPath {
        case contestDetail(ContestDetailFeature)
        case editPost(PostPictureFeature)
        case explain(ExplainFeature)
        case completeExplain(CompleteExplainFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<ContestPath.State>()
        
        var reportHistories = [Int]()
        var allPosts = [ContestImageModel]()
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
        case showExplain(reportId: Int, targetType: String)
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
            case getMyProfileSuccess(SearchMyProfileResponseDTO)
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
            case hideInitialLoading
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    async let contestListResult: Result<SearchContestListResponseDTO, NetworkError> = NetworkManager.shared.request(WeeklyContestEndpoint.getContestList)
                    async let myProfileResult: Result<SearchMyProfileResponseDTO, NetworkError> = NetworkManager.shared.request(MemberEndpoint.getMembers)

                    let (contestResponse, myProfileResponse) = await (contestListResult, myProfileResult)

                    switch contestResponse {
                    case .success(let response):
                        await send(.networkAction(.getContestListSuccess(response)))
                    case .failure(let error):
                        print(error.localizedDescription) // TODO: Error Handling
                    }

                    switch myProfileResponse {
                    case .success(let response):
                        await send(.networkAction(.getMyProfileSuccess(response)))
                    case .failure(let error):
                        print(error.localizedDescription) // TODO: Error Handling
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
                
            case .showExplain(let reportId, let targetType):
                state.path.append(.explain(ExplainFeature.State(reportId: reportId, targetType: targetType)))
                return .none
                
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
                
            case .networkAction(.getContestSuccess(let response)):
                // 페이지 정보 업데이트
                state.contestIndex = response.round
                state.weekTopic = response.subject
                state.currentPageNum = response.pageInfo.page
                state.hasNextPage = response.pageInfo.hasNext

                // 첫 페이지거나 새로고침이면 마스터 리스트를 비웁니다.
                if state.currentPageNum == 0 {
                    state.allPosts.removeAll()
                }

                // 신고된 게시물을 필터링하고, 마스터 리스트에 새로운 게시물을 추가
                let reportedIDs = Set(state.reportHistories)
                let newPosts = response.posts
                    .filter { !reportedIDs.contains($0.postId) }
                    .map { ContestImageModel(id: $0.postId, imageUrl: $0.imageUrl, nickname: $0.nickname) }
                
                state.allPosts.append(contentsOf: newPosts)

                let (tempLeftList, tempRightList) = rebuildColumnLists(from: state.allPosts)
                
                // 마지막에 한 번만 상태를 업데이트하여 View 리렌더링을 최소화
                state.leftContestImageList = tempLeftList
                state.rightContestImageList = tempRightList
                
                return .run { send in
                    try await Task.sleep(for: .seconds(0.7))
                    await send(.view(.hideInitialLoading))
                }
                
            case .networkAction(.getMyProfileSuccess(let response)):
                state.reportHistories = response.reportHistories.compactMap { $0?.targetId }
                
                return .none
                
            case let .path(.element(id: _, action: action)):
                switch action {
                case .contestDetail(.delegate(.backConfirmed)):
                    state.path.removeLast()
                    return .none
                case .contestDetail(.delegate(.didRequestLogout)):
                    return .send(.delegate(.logoutRequested))
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
                    state.path.append(.editPost(editState))
                    return .none
                    
                case .contestDetail(.delegate(.reportCompleted(let postId))):
                    state.path.removeLast()
                    state.reportHistories.append(postId)
                    state.allPosts.removeAll { $0.id == postId }

                    // 임시 배열을 사용하여 마스터 리스트를 기준으로 두 개의 컬럼 리스트를 새로 만듦
                    let (tempLeftList, tempRightList) = rebuildColumnLists(from: state.allPosts)
                    
                    // 마지막에 한 번만 상태를 업데이트하여 View 리렌더링을 최소화
                    state.leftContestImageList = tempLeftList
                    state.rightContestImageList = tempRightList
                    return .none
                    
                case .editPost(.delegate(.editCompleted)):
                    state.path.removeLast()
                    return .send(.networkAction(.refreshTriggered)) // 수정 완료 후 새로고침
                case .editPost(.delegate(.backConfirmed)):
                    state.path.removeLast()
                    return .none
                    
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
                
            case .view(.hideInitialLoading):
                state.initPageLoading = false
                state.isNextPageLoading = false
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


private extension ContestFeature {
    func rebuildColumnLists(from allPosts: [ContestImageModel]) -> (left: [ContestImageModel], right: [ContestImageModel]) {
        var tempLeftList = [ContestImageModel]()
        var tempRightList = [ContestImageModel]()
        for (index, post) in allPosts.enumerated() {
            if index % 2 == 0 {
                tempLeftList.append(post)
            } else {
                tempRightList.append(post)
            }
        }
        return (tempLeftList, tempRightList)
    }
}
