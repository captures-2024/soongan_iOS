//
//  QuestionsListView.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

struct QuestionsListView: View {
    
    @Bindable var store: StoreOf<QuestionsListFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<QuestionsListFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 18) {
                TopTabButtonView(
                    title: "기본",
                    isSelected: store.selectedTab == .nomal,
                    action: { store.send(.topMenuButtonTapped(.nomal)) }
                )
                
                TopTabButtonView(
                    title: "대회 안내",
                    isSelected: store.selectedTab == .contestInfo,
                    action: { store.send(.topMenuButtonTapped(.contestInfo)) }
                )

                TopTabButtonView(
                    title: "저작권",
                    isSelected: store.selectedTab == .copyright,
                    action: { store.send(.topMenuButtonTapped(.copyright)) }
                )
            }
            .padding(.bottom, 8)
            .padding(.top, 26)
            .background(DesignSystem.Color.soonganBG)
            
            Spacer()
            
            VStack(spacing: 12) {
                Text("추가적인 문의가 있으신가요 ?")
                
                Button(action: {
                    
                }) {
                    VStack(spacing: 2) {
                        Text("문의하기")
                        
                        Divider()
                            .frame(width: 46, height: 1)
                            .background(DesignSystem.Color.black100)
                    }
                }
            }
            .padding(.bottom, 77)
            .font(.bold12)
            .foregroundStyle(DesignSystem.Color.gray55)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.Color.soonganBG)
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
            
            ToolbarItem(placement: .principal) {
                Text("FAQ")
                    .font(.bold16)
                    .foregroundColor(DesignSystem.Color.black100)
                    .padding(.top, 16)
            }
        }
    }
}

#Preview {
    QuestionsListView(store: Store(initialState: QuestionsListFeature.State()) {
            QuestionsListFeature()
        }
    )
}
