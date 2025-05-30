//
//  MainTabView.swift
//  Soongan
//
//  Created by ParkJunHyuk on 5/14/25.
//  Copyright © 2025 Captures. All rights reserved.
//

import SwiftUI

import HomeFeature
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
                
                EmptyView()
                    .tag(MainTabFeature.State.Tab.pictureFeed)
                
                MypageView(store: store.scope(state: \.mypage, action: \.mypage))
                    .tag(MainTabFeature.State.Tab.myPage)
            }
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
            Spacer()
            
            Button(action: {
                store.send(.selectTab(.home))
            }) {
                store.selectedTab == .home ? Image.selectHomeIcon : Image.notSelectHomeIcon
            }
            
            Spacer()
            
            Button(action: {
                store.send(.selectTab(.pictureFeed))
            }) {
                store.selectedTab == .pictureFeed ? Image.selectPictureIcon : Image.notSelectPictureIcon
            }

            Spacer()
            
            Button(action: {
                store.send(.selectTab(.myPage))
            }) {
                store.selectedTab == .myPage ? Image.selectMypageIcon : Image.notSelectMypageIcon
            }
            
            Spacer()
        }
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
        Store(initialState: MainTabFeature.State()) {
            MainTabFeature()
        }
    )
}
