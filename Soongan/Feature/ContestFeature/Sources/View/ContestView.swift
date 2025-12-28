//
//  ContestView.swift
//  ContestFeature
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI
import PhotosUI

import DetailContestFeature
import DesignSystem
import PostPictureFeature
import ExplainFeature
import Shared

import ComposableArchitecture
import Kingfisher

public struct ContestView: View {

    @Bindable var store: StoreOf<ContestFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<ContestFeature>
    ) {
        self.store = store
    }

    // MARK: - Body
    
    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    navigationTitle(contestIndex: store.contestIndex, weekTopic: store.weekTopic)
                    
                    WaterfallImageGridView(
                        posts: store.allPosts,
                        hasMorePages: store.hasNextPage,
                        isLoading: store.isNextPageLoading,
                        isInitialLoading: store.initPageLoading,
                        onRefresh: {
                            store.send(.networkAction(.refreshTriggered))
                        },
                        onLoadMore: {
                            store.send(.view(.updateMoreNextPage(true)))
                        },
                        onImageTap: { id in
                            store.send(.uiAction(.contestDetailImageTapped(id)))
                        },
                        onScrollPositionChange: { offsetY in
                            store.send(.view(.updateTopButtonVisibility(offsetY)))
                        }
                    )
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear.frame(height: 50)
            }
            .background(DesignSystem.Color.soonganBG)
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                if store.contestOptions.isEmpty {
                    store.send(.onAppear)
                }
            }
            .sheet(
                isPresented: $store.isContestSheetPresented.sending(\.sheet.dismissContest)
            ) {
                ContestIndexSheetView(store: self.store)
                    .presentationDetents([.height(280)])
                    .presentationBackground(DesignSystem.Color.soonganBG)
            }
            .sheet(isPresented: $store.isSortSheetPresented.sending(\.sheet.dismissSortContest)) {
                CustomSheetView<SortContestDataType>(type: .sortContest, isSelectType: store.sortSelectType) { optionType in
                    store.send(.view(.changeSortContestType(optionType)))
                }
            }
        } destination: { store in
            switch store.case {
            case .contestDetail(let store):
                ContestDetailView(store: store)
            case .editPost(let store):
                PostPictureView(store: store)
            case .explain(let store):
                ExplainView(store: store)
            case .completeExplain(let store):
                CompleteExplainView(store: store)
            }
        }
    }
    
    func navigationTitle(contestIndex: Int, weekTopic: String) -> some View {
        ZStack {
            HStack(spacing: 8) {
                Button(action: {
                    store.send(.sheet(.present))
                }) {
                    Image.downArrow
                        .scaleEffect(x: 1, y: store.isContestSheetPresented ? -1 : 1)
                }
                
                HStack(spacing: 4) {
                    Text("\(contestIndex)회차")
                    Text("|")
                    Text(weekTopic)
                }
                
                // 왼쪽 버튼과 동일한 공간을 차지하는 보이지 않는 뷰 (균형 유지용)
                Image.downArrow
                    .hidden()
            }

            HStack {
                Spacer()
                Button {
                    store.send(.uiAction(.sortContestContentTapped))
                } label: {
                    Image.sortOption
                }
            }
            .padding(.trailing, 14)
        }
        .font(DesignSystem.Font.bold20)
        .foregroundStyle(DesignSystem.Color.black100)
        .padding(.vertical, 14)
        .background(DesignSystem.Color.soonganBG)
    }
    
}

// MARK: - Preview

#Preview {
    ContestView(
        store: Store(initialState:
            ContestFeature.State()) {
                ContestFeature()
        }
    )
}
