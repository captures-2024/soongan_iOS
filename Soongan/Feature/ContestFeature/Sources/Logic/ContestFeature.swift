//
//  ContestFeature.swift
//  ContestFeature
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI

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
        
        var contestOptions = ["1회차 평화", "2회차 자연", "3회차 풍경", "4회차 주제", "5회차 주제"]
        var contestIndex: String = "1회차"
        var weekTopic: String = "평화"
        
        var selectedContestIndex: Int = 0
        
        var isContestSheetPresented: Bool = false
        
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
    
        case presentSheet
        case chagneContestIndex
        case dismissContestSheet(Bool)
        case contestDetailImageTapped(String)
        case sortContestContentTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
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
            
            case .contestDetailImageTapped:
                state.path.append(.contestDetail(ContestDetailFeature.State()))
                return .none
                
            case .sortContestContentTapped:
                return .none
                
            case .presentSheet:
                state.isContestSheetPresented = true
                return .none
                
            case .chagneContestIndex:
                let contest = state.contestOptions[state.selectedContestIndex]
                
                let splitResult = spiltIndexTitle(contest: contest)
                state.contestIndex = splitResult.index
                state.weekTopic = splitResult.contest
                
                state.isContestSheetPresented = false
                
                return .none
                
            case .dismissContestSheet:
                state.isContestSheetPresented = false
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    func spiltIndexTitle(contest: String) -> (index: String, contest: String){
        
        let splitContest = contest.split(separator: " ").map{ String($0) }
        return (splitContest[0], splitContest[1])
    }
}
