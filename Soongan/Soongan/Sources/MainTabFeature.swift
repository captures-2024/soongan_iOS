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
        var selectedTab: Tab
        var home: HomeFeature.State = .init()
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
        
        case delegate(Delegate)
                
        public enum Delegate {
            case logoutCompleted
        }
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
                    
                case .delegate(.didRequestLogout):
                    return .send(.delegate(.logoutCompleted))
                    
                default:
                    return .none
                }
                
            case .contest(let contestAction):
                switch contestAction {
                case .delegate(.logoutRequested):
                    return .send(.delegate(.logoutCompleted))
                default:
                    return .none
                }
                
            case .allTimeContest(let allTimeAction):
                switch allTimeAction {
                case .delegate(.moveToContestTab):
                    state.selectedTab = .contest
                    return .none
                    
                case .delegate(.logoutRequested):
                    return .send(.delegate(.logoutCompleted))
                    
                default:
                    return .none
                }

            case .mypage(let mypageAction):
                switch mypageAction {
                case .delegate(.moveToJoinContest):
                    state.selectedTab = .home
                    return .none
                    
                case .delegate(.didRequestLogout):
                    return .send(.delegate(.logoutCompleted))
                    
                default:
                    return .none
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
