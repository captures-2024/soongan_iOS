//
//  MainTabFeature.swift
//  Soongan
//
//  Created by ParkJunHyuk on 5/14/25.
//  Copyright © 2025 Captures. All rights reserved.
//

import SwiftUI

import HomeFeature
import Shared

import ComposableArchitecture

@Reducer
public struct MainTabFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab = .home
        var home: HomeFeature.State = .init(weekTopic: "평화", startPeriod: "2024.05.10 09:00:00", endPeriod: "2024.05.16 23:59:59")
        
        public enum Tab {
           case home, pictureFeed, myPage
        }
        
        var isTabBarVisible: Bool {
            switch selectedTab {
            case .home:
                return home.isTabBarVisible
                
            case .pictureFeed, .myPage:
                return true
            }
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action {
        case selectTab(State.Tab)
        case home(HomeFeature.Action)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .selectTab(let tab):
                state.selectedTab = tab
                return .none
            case .home:
                return .none
            }
        }
    }
}
