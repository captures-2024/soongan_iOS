//
//  AllTimeContestFeature.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct AllTimeContestFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum AllTimeContestPath {
        case detailContest(DetailContestFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<AllTimeContestPath.State>()
        
        var allTimeDictionaryData = [Int: SearchHistoriesContestData]()
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
        case historyContestSuccessResponse(SearchHistoriesContestResponseDTO)
        
        case contestListTapped(id: Int)
//        case presentSheet
//        case chagneContestIndex
//        case dismissContestSheet(Bool)
//        case contestDetailImageTapped(String)
//        case sortContestContentTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .run { send in
                    let result: Result<SearchHistoriesContestResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.getHistoriesContest)
                    
                    switch result {
                    case .success(let responseResult):
                        return await send(.historyContestSuccessResponse(responseResult))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
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
                default:
                    return .none
                }
                
            case .contestListTapped(let id):
                if let data = state.allTimeDictionaryData[id] {
                    let contestInfo = DetailContestInfoModel(
                        id: id,
                        round: data.round,
                        subject: data.subject,
                        startAt: data.startAt,
                        endAt: data.endAt
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
    func convertAllTimeContestModel(_ data: SearchHistoriesContestResponseDTO) -> [AllTimeContestModel] {
        return data.contests.map {
            AllTimeContestModel(id: $0.id, title: $0.subject, backgroundImageURL: $0.thumbnailImageUrl)
        }
    }
}
