//
//  MainTabView.swift
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

import ComposableArchitecture

public struct MainTabView: View {
    
    // MARK: - Properties
    
    @State var store: StoreOf<MainTabFeature>

    // MARK: - Init
    
    public init(store: StoreOf<MainTabFeature>) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $store.selectedTab.sending(\.selectTab)) {
                HomeView(store: store.scope(state: \.home, action: \.home))
                    .tag(MainTabFeature.State.Tab.home)
                
                ContestView(store: store.scope(state: \.contest, action: \.contest))
                    .tag(MainTabFeature.State.Tab.contest)
                
                AllTimeContestView(store: store.scope(state: \.allTimeContest, action: \.allTimeContest))
                    .tag(MainTabFeature.State.Tab.allTimeContest)
                
                MypageView(store: store.scope(state: \.mypage, action: \.mypage))
                    .tag(MainTabFeature.State.Tab.myPage)
            }
            .sensoryFeedback(.impact(weight: .light), trigger: store.selectedTab)
            .toolbar(.hidden, for: .tabBar)
            
            VStack {
                if store.isTabBarVisible {
                    customTabBar
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.05), value: store.isTabBarVisible) // 더 빠른 반응
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    var customTabBar: some View {
        HStack(spacing: 0) {
            Button(action: {
                store.send(.selectTab(.home))
            }) {
                store.selectedTab == .home ? Image.selectHomeIcon : Image.notSelectHomeIcon
            }
            
            Spacer()
            
            Button(action: {
                store.send(.selectTab(.contest))
            }) {
                store.selectedTab == .contest ? Image.selectPictureIcon : Image.notSelectPictureIcon
            }

            Spacer()
            
            Button(action: {
                store.send(.selectTab(.allTimeContest))
            }) {
                store.selectedTab == .allTimeContest ? Image.selectAwardIcon : Image.notSelectAwardIcon
            }
            
            Spacer()
            
            Button(action: {
                store.send(.selectTab(.myPage))
            }) {
                store.selectedTab == .myPage ? Image.selectMypageIcon : Image.notSelectMypageIcon
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 43)
        .padding(.top, 16)
        .frame(height: 83)
        .background {
            Rectangle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.25), radius: 8, y: -2)
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView(store:
            Store(initialState: MainTabFeature.State(selectedTab: .home)) {
            MainTabFeature()
        }
    )
}
