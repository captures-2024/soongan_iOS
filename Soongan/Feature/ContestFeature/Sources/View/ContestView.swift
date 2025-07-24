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

import ComposableArchitecture

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
            VStack(spacing: 0) {
                navigationTitle(contestIndex: store.contestIndex, weekTopic: store.weekTopic)
                
                ImageGridView(
                    leftImageList: store.leftContestImageList,
                    rightImageList: store.rightContestImageList,
                    onImageTap: { tappedImage in
                        store.send(.contestDetailImageTapped(tappedImage.id))
                })
                .padding(.bottom, 50)
                .refreshable {
                    try? await Task.sleep(nanoseconds: 1000_000_000)
                    store.send(.refreshTriggered)
                }
            }
            .background(DesignSystem.Color.soonganBG)
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                if store.contestOptions.isEmpty {
                    store.send(.onAppear)
                }
            }
            .sheet(
                isPresented: $store.isContestSheetPresented.sending(\.dismissContestSheet)
            ) {
                changeContestIndexSheet()
                    .presentationDetents([.height(280)])
            }
            .sheet(isPresented: $store.isSortSheetPresented.sending(\.dismissSortContestSheet)) {
                CustomSheetView<SortContestDataType>(type: .sortContest, isSelectType: store.sortSelectType) { optionType in
                    store.send(.changeSortContestType(optionType))
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
                    store.send(.presentSheet)
                }) {
                    Image.downArrow
                        .scaleEffect(x: 1, y: store.isContestSheetPresented ? -1 : 1)
                }
            }
            .frame(maxWidth: .infinity)
            
            Button {
                store.send(.sortContestContentTapped)
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
}

private extension ContestView {
    func changeContestIndexSheet() -> some View {
        VStack {
            HStack {
                Button(action: {
                    store.send(.dismissContestSheet(false))
                }) {
                    Text("취소")
                        .font(DesignSystem.Font.semibold16, lineHeight: 19)
                }
                
                Spacer()
                
                Text("회차 선택")
                    .font(DesignSystem.Font.semibold20)
                
                Spacer()
                
                Button(action: {
                    store.send(.chagneContestIndex)
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
