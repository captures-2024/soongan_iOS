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
                DesignSystem.Color.soonganBG.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        ZStack(alignment: .top) {
                            Circle()
                                .fill(DesignSystem.Color.primary)
                                .frame(width: 40, height: 40)
                                .offset(x: -35, y: -16)
                            
                            Text(store.weekTopic)
                                .font(.bold42)
                                .foregroundStyle(Color.black100)
                        }
                        
                        Spacer()
                        
                        Image.soonganLogo
                            .resizable()
                            .frame(width: 33, height: 50)
                    }
                    .frame(height: 65)
                    .padding(.top, 74)
                    .padding(.horizontal, 36)
                    
                    Spacer(minLength: 63)
                    
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
                                    .font(.regular14)
                                    .foregroundStyle(Color.black100)
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)

                    periodSection(startPeriod: store.startPeriod, endPeriod: store.endPeriod)
                        .padding(.bottom, 32)
                    
                    HStack {
                        CircleButton(type: .info) {
                            store.send(.infoButtonTapped)
                        }
                        
                        Spacer()
                        
                        CircleButton(type: .rightArrow) {
                            
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    Spacer(minLength: 40)
                }
                .toolbar(.hidden, for: .tabBar)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Color.clear.frame(height: 83)
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(
                isPresented: $store.isInfoSheetPresented.sending(\.dismissInfoSheet)
            ) {
                CustomSheetView<NeverOption>(type: .contestInfo) { }
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
