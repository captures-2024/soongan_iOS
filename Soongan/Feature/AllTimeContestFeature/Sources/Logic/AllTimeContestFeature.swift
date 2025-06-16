//
//  AllTimeContestFeature.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI

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
        
        var allTimeContestListData = [AllTimeContestModel(title: "평화", backgroundImageURL: ""), AllTimeContestModel(title: "평화2", backgroundImageURL: ""), AllTimeContestModel(title: "평화3", backgroundImageURL: "")]
        
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
    
        
        case contestListTapped
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
                
            case let .path(.element(id: _, action: action)):
                switch action {
                case .detailContest(.backButtonTapped):
                    state.path.removeLast()
                    return .none
                default:
                    return .none
                }
                
            case .contestListTapped:
                state.path.append(.detailContest(DetailContestFeature.State()))
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
