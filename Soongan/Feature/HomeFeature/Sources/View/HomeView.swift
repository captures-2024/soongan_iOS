//
//  HomeView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import DesignSystem

import ComposableArchitecture

public struct HomeView: View {
    
    @Bindable var store: StoreOf<HomeFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<HomeFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ZStack {
                Image.mainBackground
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack(spacing: 207) {
                        ZStack(alignment: .top) {
                            Circle()
                                .fill(DesignSystem.Color.primary)
                                .frame(width: 40, height: 40)
                                .offset(x: -35, y: -16)
                            
                            Text(store.weekTopic)
                                .font(.bold42)
                                .foregroundStyle(Color.black100)
                        }
                        
                        Image.soonganLogo
                            .resizable()
                            .frame(width: 33, height: 50)
                    }
                    .padding(.top, 74)
                    .padding(.bottom, 63)
                    
                    Button(action: {
                        store.send(.addPictureButtonTapped)
                    }) {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 257, height: 257)
                                .shadow(
                                    color: Color.black.opacity(0.25),
                                    radius: 5, x: 0, y: 4)
                            
                            VStack(spacing: 16) {
                                Image.addPlus
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                Text("출품하기")
                                    .font(.regualr14)
                                    .foregroundStyle(Color.black100)
                            }
                        }
                    }
                    .padding(.bottom, 100)
                    
                    periodSection(startPeriod: store.startPeriod, endPeriod: store.endPeriod)
                        .padding(.bottom, 32)
                    
                    HStack(spacing: 233) {
                        CircleButton(type: .info) {
                            store.send(.infoButtonTapped)
                        }
                        
                        CircleButton(type: .rightArrow) {
                            
                        }
                    }
                    .padding(.horizontal, 28)
                }
                .padding(.bottom, 99)
            }
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(
                isPresented: $store.isInfoSheetPresented.sending(\.dismissInfoSheet)
            ) {
                CustomSheetView(type: .contestInfo)
            }
        } destination: { store in
            switch store.case {
            case .postPicture(let store):
                PostPictureView(store: store)
            }
        }
    }
}

// MARK: - Private Extension View

private extension HomeView {
    private func periodSection(startPeriod: String, endPeriod: String) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text("시작일")
                
                Text("|")
                    
                Text(startPeriod)
            }
            .font(.medium14)
            
            HStack(spacing: 4) {
                Text("마감일")
                
                Text("|")
                    
                Text(endPeriod)
            }
            .font(.medium14)
            .foregroundStyle(Color.black100)
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView(
        store: Store(initialState:
            HomeFeature.State(weekTopic: "평화", startPeriod: "2024.05.10 09:00:00", endPeriod: "2024.05.16 23:59:59")) {
                HomeFeature()
            }
    )
}
