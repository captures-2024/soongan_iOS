//
//  MainTabFeature.swift
//  Soongan
//
//  Created by ParkJunHyuk on 5/14/25.
//  Copyright © 2025 Captures. All rights reserved.
//

import SwiftUI

import HomeFeature
import ContestFeature
import AllTimeContestFeature
import MypageFeature
import Shared

import ComposableArchitecture

@Reducer
public struct MainTabFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab = .home
        var home: HomeFeature.State = .init(weekTopic: "평화", startPeriod: "2024.05.10 09:00:00", endPeriod: "2024.05.16 23:59:59")
        var contest: ContestFeature.State = .init()
        var allTimeContest: AllTimeContestFeature.State = .init()
        var mypage: MypageFeature.State = .init()
        
        public enum Tab {
           case home, contest, allTimeContest, myPage
        }
        
        var isTabBarVisible: Bool {
            switch selectedTab {
            case .home:
                return home.isTabBarVisible
            case .contest:
                return contest.isTabBarVisible
            case .allTimeContest:
                return allTimeContest.isTabBarVisible
            case .myPage:
                return mypage.isTabBarVisible
            }
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action {
        case selectTab(State.Tab)
        case home(HomeFeature.Action)
        case contest(ContestFeature.Action)
        case allTimeContest(AllTimeContestFeature.Action)
        case mypage(MypageFeature.Action)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Scope(state: \.contest, action: \.contest) {
            ContestFeature()
        }
        
        Scope(state: \.allTimeContest, action: \.allTimeContest) {
            AllTimeContestFeature()
        }
        
        Scope(state: \.mypage, action: \.mypage) {
            MypageFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .selectTab(let tab):
                state.selectedTab = tab
                return .none
                
            case .home(let homeAction):
                switch homeAction {
                case .delegate(.moveToContestTab):
                    state.selectedTab = .contest
                    return .none
                default:
                    return .none
                }
                
            case .contest:
                return .none
                
            case .allTimeContest(let allTimeAction):
                switch allTimeAction {
                case .delegate(.moveToContestTab):
                    state.selectedTab = .contest
                    return .none
                    
                default:
                    return .none
                }

            case .mypage(let mypageAction):
                switch mypageAction {
                case .delegate(.moveToJoinContest):
                    state.selectedTab = .home
                    return .none
                    
                default:
                    return .none
                }
            }
        }
    }
}
