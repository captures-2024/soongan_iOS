//
//  AllTimeContestView.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 6/12/25.
//

import SwiftUI
import PhotosUI

import DesignSystem

import ComposableArchitecture

public struct AllTimeContestView: View {

    @Bindable var store: StoreOf<AllTimeContestFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<AllTimeContestFeature>
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
                    Text("역대 콘테스트")
                        .font(.bold20)
                        .foregroundStyle(Color.black100)
                        .padding(.vertical, 28)
                    
                    if !(store.allTimeContestListData.isEmpty) {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(store.allTimeContestListData, id: \.self) { contestData in
                                    contestListView(data: contestData) {
                                        store.send(.contestListTapped)
                                    }
                                }
                            }
                        }
                    } else {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            Text("첫 회차가 진행되고 있습니다.")
                            
                            Text("회차가 끝나면 역대 콘테스트가 생깁니다.")
                        }
                        .font(.bold20)
                        .foregroundStyle(Color.black100)
                        
                        Spacer(minLength: 350)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
        } destination: { store in
            switch store.case {
            case .detailContest(let store):
                DetailContestView(store: store)
            }
        }
    }
}

// MARK: - Private View Extension

private extension AllTimeContestView {
    func contestListView(data: AllTimeContestModel, onTap: @escaping () -> Void) -> some View {
        ZStack {
            Image.dumy5
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 126)
                .clipped()
            
            // 블러 처리용 배경 뷰
            Rectangle()
                .fill(Color.black100.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(data.title)
                .font(.bold20)
                .foregroundStyle(Color.white)
        }
        .padding(.horizontal, 16)
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Preview

#Preview {
    AllTimeContestView(
        store: Store(initialState:
            AllTimeContestFeature.State()) {
                AllTimeContestFeature()
        }
    )
}
