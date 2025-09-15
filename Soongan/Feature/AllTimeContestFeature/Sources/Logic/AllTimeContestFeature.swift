//
//  AllTimeContestFeature.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI

import CoreNetwork
import DetailContestFeature
import DesignSystem
import ExplainFeature
import Shared

import ComposableArchitecture

@Reducer
public struct AllTimeContestFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum AllTimeContestPath {
        case detailContest(DetailContestFeature)
        case contestDetail(ContestDetailFeature)
        case explain(ExplainFeature)
        case completeExplain(CompleteExplainFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<AllTimeContestPath.State>()
        
        var allTimeDictionaryData = [Int: SearchAwardContestData]()
        var allTimeContestListData = [AllTimeContestModel]()
        
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
        case path(StackActionOf<AllTimeContestPath>)
        
        case binding(BindingAction<State>)
    
        case onAppear
        case refreshTriggered
        case historyContestSuccessResponse(SearchAwardContestResponseDTO)
        case contestListTapped(id: Int)
        case showExplain(reportId: Int, targetType: String)
        
        case delegate(Delegate)
                
        public enum Delegate {
            case moveToContestTab
            case logoutRequested
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .onAppear, .refreshTriggered:
                return .run { send in
                    let result: Result<SearchAwardContestResponseDTO, NetworkError> = await NetworkManager.shared.request(AwardEndpoint.getAwardContest)

                    switch result {
                    case .success(let responseResult):
                        return await send(.historyContestSuccessResponse(responseResult))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .cancellable(id: "refresh-task")
                
            case .showExplain(let reportId, let targetType):
                state.path.append(.explain(ExplainFeature.State(reportId: reportId, targetType: targetType)))
                return .none
                
            case .historyContestSuccessResponse(let response):
                response.contests.forEach {
                    state.allTimeDictionaryData[$0.id] = $0
                }
                
                state.allTimeContestListData = convertAllTimeContestModel(response)
                
                return .none
                
            case let .path(.element(id: _, action: action)):
                switch action {
                case .detailContest(.backButtonTapped):
                    state.path.removeLast()
                    return .none
                
                case .contestDetail(.backButtonTapped):
                    state.path.removeLast()
                    return .none
                    
                case .contestDetail(.delegate(.didRequestLogout)):
                    return .send(.delegate(.logoutRequested))
                    
                case .detailContest(.delegate(.showContestDetail(let postId))):
                    state.path.append(.contestDetail(ContestDetailFeature.State(postId: postId, weekTopic: "")))
                    return .none
                    
                case .detailContest(.delegate(.moveToContestTab)):
                    state.path.removeLast()
                    return .send(.delegate(.moveToContestTab))
                    
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
                
            case .contestListTapped(let id):
                if let data = state.allTimeDictionaryData[id] {
                    let contestInfo = DetailContestInfoModel(
                        id: id,
                        round: data.round,
                        subject: data.subject,
                        startAt: data.startAt.toFormattedDateString(showTime: false),
                        endAt: data.endAt.toFormattedDateString(showTime: false)
                    )
                    
                    state.path.append(.detailContest(DetailContestFeature.State(contestInfoData: contestInfo)))
                }
                
                return .none
                
//            case let .path(.element(id: _, action: action)):
//                switch action {
//                case .contestDetail(.backButtonTapped):
//                    state.path.removeLast()
//                    return .none
//                default:
//                    return .none
//                }
//                
//            case .binding(_):
//                return .none
//            
//            case .contestDetailImageTapped:
//                state.path.append(.contestDetail(ContestDetailFeature.State()))
//                return .none
//                
//            case .sortContestContentTapped:
//                return .none
//                
//            case .presentSheet:
////                state.isContestSheetPresented = true
//                return .none
//                
//            case .chagneContestIndex:
//                let contest = state.contestOptions[state.selectedContestIndex]
//                
//                let splitResult = spiltIndexTitle(contest: contest)
//                state.contestIndex = splitResult.index
//                state.weekTopic = splitResult.contest
//                
//                state.isContestSheetPresented = false
//                
//                return .none
//                
//            case .dismissContestSheet:
//                state.isContestSheetPresented = false
//                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}


private extension AllTimeContestFeature {
    func convertAllTimeContestModel(_ data: SearchAwardContestResponseDTO) -> [AllTimeContestModel] {
        return data.contests.map {
            AllTimeContestModel(id: $0.id, title: $0.subject, backgroundImageURL: $0.thumbnailImageUrl)
        }
    }
}
