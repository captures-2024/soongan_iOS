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
                    
                    if store.initPageLoading {
                        VStack {
                            Spacer()
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(2.0)
                            
                            Spacer()
                        }
                    } else {
                        ZStack(alignment: .bottomTrailing) {
                            ZStack(alignment: .bottom) {
                                ScrollView {
                                    HStack(alignment: .top, spacing: 8) {
                                        imageGridSection(imageList: store.leftContestImageList, geometry: geometry, direction: .left)
                                        imageGridSection(imageList: store.rightContestImageList, geometry: geometry, direction: .right)
                                    }
                                    .padding(.horizontal, 8)
                                    .scrollTargetLayout()
                                    .padding(.bottom, store.isNextPageLoading && store.hasNextPage ? 60 : 0)  // 로딩 공간 확보
                                }
                                
                                // 하단에 고정된 로딩 인디케이터
                                if store.isNextPageLoading && store.hasNextPage {
                                    VStack {
                                        ProgressView()
                                            .padding(.vertical, 20)
                                            .frame(maxWidth: .infinity)
                                            .transition(.move(edge: .bottom))
                                    }
                                    .ignoresSafeArea(.container, edges: .bottom)
                                }
                            }
                            .animation(.easeOut(duration: 0.1), value: store.isNextPageLoading)
                            .scrollPosition($store.scrollPosition, anchor: .bottom)
                            .refreshable {
                                try? await Task.sleep(nanoseconds: 1000_000_000)
                                store.send(.networkAction(.refreshTriggered))
                            }
                            .onScrollGeometryChange(for: ScrollPositionState.self) { geometry in
                                let offsetY = geometry.bounds.origin.y
                                let reachedBottom = geometry.visibleRect.maxY >= geometry.contentSize.height + 100
                                return ScrollPositionState(offsetY: offsetY, reachedBottom: reachedBottom)
                            } action: { oldValue, newValue in
                                // ScrollView 스크롤 위치가 bottom 에 위치하는지
                                if oldValue.reachedBottom != newValue.reachedBottom, newValue.reachedBottom {
                                    if !store.isNextPageLoading {
                                        store.send(.view(.updateMoreNextPage(newValue.reachedBottom)))
                                    }
                                }
                                
                                // ScrollView 스크롤 위치를 top 으로 변경
                                store.send(.view(.updateTopButtonVisibility(newValue.offsetY)))
                            }
                            
                            Button {
                                withAnimation(.easeInOut) {
                                    store.scrollPosition.scrollTo(edge: .top)
                                }
                            } label: {
                                Image(systemName: "arrow.up")
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(DesignSystem.Color.black100)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                                    .padding()
                            }
                            .opacity(store.isTopButtonVisibility ? 1 : 0)
                            .allowsHitTesting(store.isTopButtonVisibility)
                            .animation(.easeInOut, value: store.isTopButtonVisibility)
                        }
                    }
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
                changeContestIndexSheet()
                    .presentationDetents([.height(280)])
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
            }
        }
    }
    
    func navigationTitle(contestIndex: Int, weekTopic: String) -> some View {
        ZStack(alignment: .trailing) {
            ZStack(alignment: .leading) {
                HStack{
                    Text("\(contestIndex)회차")
                    
                    Text("|")
                    
                    Text(weekTopic)
                }
                .frame(width: 150)
                
                Button(action: {
                    store.send(.sheet(.present))
                }) {
                    Image.downArrow
                        .scaleEffect(x: 1, y: store.isContestSheetPresented ? -1 : 1)
                }
            }
            .frame(maxWidth: .infinity)
            
            Button {
                store.send(.uiAction(.sortContestContentTapped))
            } label: {
                Image.sortOption
                    .padding(.trailing, 14)
            }
        }
        .font(DesignSystem.Font.bold20)
        .foregroundStyle(Color.black100)
        .padding(.vertical, 14)
        .background(DesignSystem.Color.soonganBG)
    }
    
    func imageGridSection(imageList: [ContestImageModel], geometry: GeometryProxy, direction: Direction) -> some View {
        LazyVStack(spacing: 8) {
            ForEach(imageList) { model in
                ContestImageView(
                    model: model,
                    geometry: geometry,
                    onSuccessAction: { modelId, calculatedHeight in
                        switch direction {
                        case .left:
                            store.send(.view(.updateLeftImageModel(modelId, calculatedHeight)))
                        case .right:
                            store.send(.view(.updateRightImageModel(modelId, calculatedHeight)))
                        }
                    },
                    onTapAction: { modelId in
                        store.send(.uiAction(.contestDetailImageTapped(modelId)))
                    }
                )
                .id(model.id)
            }
        }
    }
}

private extension ContestView {
    func changeContestIndexSheet() -> some View {
        VStack {
            HStack {
                Button(action: {
                    store.send(.sheet(.dismissContest(false)))
                }) {
                    Text("취소")
                        .font(DesignSystem.Font.semibold16, lineHeight: 19)
                }
                
                Spacer()
                
                Text("회차 선택")
                    .font(DesignSystem.Font.semibold20)
                
                Spacer()
                
                Button(action: {
                    store.send(.view(.changeContestIndex))
                }) {
                    Text("확인")
                        .font(DesignSystem.Font.semibold16, lineHeight: 19)
                }
            }
            .padding(.top, 28)
            .padding(.horizontal, 32)
            .foregroundStyle(DesignSystem.Color.black100)

            Picker("", selection: $store.selectedContestIndex) {
                ForEach(0..<store.contestOptions.count, id: \.self) { index in
                    let contest = store.contestOptions[index]
                    Text("\(contest.round)회차 \(contest.subject)")
                        .tag(index)
                }
            }
            .pickerStyle(.wheel)
        }
        .frame(maxHeight: .infinity, alignment: .top)
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
