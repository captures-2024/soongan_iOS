//
//  ContestDetailView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 6/1/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

struct ContestDetailView: View {
    
    @Bindable var store: StoreOf<ContestDetailFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<ContestDetailFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                
                Image.dumy4
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 360, height: 480)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(store.contestTitle)
                        .font(.bold20)
                    
                    Text(store.contestAuthor)
                        .font(.medium14)
                        .padding(.leading, 4)
                }
                .padding(.horizontal, 36)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 83)

            bottomOptionMenuBar()
        }
        .ignoresSafeArea(edges: .bottom)
        .background(DesignSystem.Color.soonganBG)
        .background(InteractivePopGestureEnabler())
        .sheet(
            isPresented: $store.isContestOptionSheetPresented.sending(\.dismissOptionSheet)
        ) {
            CustomSheetView(type: .contestReport) { _ in
                
            }
        }
        .sheet(item: $store.activeSheet) { sheetType in
            CustomSheetView(type: sheetType) { optionType in
                
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    HStack(spacing: 0) {
                        Image.arrowBack
                            .padding(.trailing, 5)
                    }
                }
                .padding(.top, 16)
            }
        }
    }
    
    func bottomOptionMenuBar() -> some View {
        HStack(alignment: .top) {
            Button(action: {
                store.send(.optionButtonTapped)
            }) {
                Image.dotOption
            }
            .padding(.leading, 16)
            
            Spacer()
            
            HStack(spacing: 0) {
                Button(action: {
                    
                }) {
                    if store.isLiked {
                        Image.selectLike
                    } else {
                        Image.notSelectLike
                    }
                }
                .padding(.trailing, 8)
                
                Text("\(store.likeCount)")
                    .font(.info12)
                    .foregroundColor(DesignSystem.Color.black100)
                    .padding(.trailing, 32)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 43)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ContestDetailView(
            store: Store(initialState:
                            ContestDetailFeature.State()) {
                                ContestDetailFeature()
                            }
        )
    }
}
