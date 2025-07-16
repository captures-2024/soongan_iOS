//
//  ContestFeature.swift
//  ContestFeature
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct ContestFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum ContestPath {
        case contestDetail(ContestDetailFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<ContestPath.State>()
        
        var contestOptions = [ContestIndexModel]()
        var contestIndex: Int = 0
        var weekTopic: String = ""
        
        var leftContestImageList = [ContestImageModel]()
        var rightContestImageList = [ContestImageModel]()
        
        var selectedContestIndex: Int = 0
        
        var isLoading = false
        var isNext = false
        var isContestSheetPresented: Bool = false
        var isSortSheetPresented: Bool = false
        var sortSelectType: SortContestDataType = .newest
        
        // CustomTabBar 가시성
        public var isTabBarVisible: Bool {
            path.isEmpty
        }
        
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case path(StackActionOf<ContestPath>)
        
        case binding(BindingAction<State>)
    
        case onAppear
        case fetchContestPosts
        case getContestSuccess(SearchWeeklyContestResponseDTO)
        case getContestListSuccess(SearchContestListResponseDTO)
        
        case presentSheet
        case chagneContestIndex
        case dismissContestSheet(Bool)
        case dismissSortContestSheet(Bool)
        case contestDetailImageTapped(String)
        case sortContestContentTapped
        case changeSortContestType(SortContestDataType)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading.toggle()
                
                return .run { send in
                    let result: Result<SearchContestListResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.getContestList)
                    
                    switch result {
                    case .success(let response):
                        await send(.getContestListSuccess(response))
                    case .failure(let error):
                        print(error.localizedDescription)
                        // 필요하다면 isLoading 토글 등 에러 처리
                    }
                }
              
            // 콘테스트 목록을 성공적으로 가져온 후, '게시물'을 가져오는 새 액션을 보냅니다.
            case .getContestListSuccess(let response):
                state.contestOptions = response.contests.map {
                    ContestIndexModel(id: $0.id, round: $0.round, subject: $0.subject)
                }
                
                state.contestIndex = state.contestOptions.last?.round ?? 1
                state.weekTopic = state.contestOptions.last?.subject ?? ""
                
                return .send(.fetchContestPosts)
                
            // fetchContestPosts 액션을 받아 올바른 contestIndex로 게시물을 요청합니다.
            case .fetchContestPosts:
                let order = state.sortSelectType.rawValue
                let dto = SearchWeeklyContestRequestDTO(
                    round: state.contestIndex,
                    orderCriteria: order,
                    page: 0,
                    pageSize: 50
                )
                
                return .run { send in
                    let result: Result<SearchWeeklyContestResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.getContest(dto))
                    
                    switch result {
                    case .success(let response):
                        await send(.getContestSuccess(response))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            // 게시물 데이터를 성공적으로 받으면 상태를 업데이트합니다.
            case .getContestSuccess(let response):
                state.contestIndex = response.round
                state.weekTopic = response.subject
                
                state.leftContestImageList.removeAll()
                state.rightContestImageList.removeAll()
                
                for (index, item) in response.posts.enumerated() {
                    let model = ContestImageModel(id: String(item.postId), imageUrl: item.imageUrl, nickname: item.nickname)
                    if index % 2 == 0 {
                        state.leftContestImageList.append(model)
                    } else {
                        state.rightContestImageList.append(model)
                    }
                }
                
                state.isNext = response.pageInfo.hasNext
                state.weekTopic = response.subject
                
                state.isLoading.toggle()
                return .none

                
            case let .path(.element(id: _, action: action)):
                switch action {
                case .contestDetail(.backButtonTapped):
                    state.path.removeLast()
                    return .none
                default:
                    return .none
                }
                
            case .binding(_):
                return .none
            
            case .contestDetailImageTapped(let postId):
                state.path.append(.contestDetail(ContestDetailFeature.State(postId: postId)))
                return .none
                
            case .sortContestContentTapped:
                state.isSortSheetPresented = true
                return .none
                
            case .presentSheet:
                state.isContestSheetPresented = true
                return .none
                
            case .chagneContestIndex:
                let contest = state.contestOptions[state.selectedContestIndex]
                
                state.contestIndex = contest.round
                state.weekTopic = contest.subject
                
                state.isContestSheetPresented = false
                
                return .none
                
            case .dismissContestSheet:
                state.isContestSheetPresented = false
                return .none
                
            case .dismissSortContestSheet:
                state.isSortSheetPresented = false
                return .none
                
            case .changeSortContestType(let type):
                state.sortSelectType = type
                state.isSortSheetPresented = false
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
