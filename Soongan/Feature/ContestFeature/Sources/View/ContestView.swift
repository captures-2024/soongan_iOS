//
//  ContestView.swift
//  ContestFeature
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI
import PhotosUI

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
                
                ImageGridView(onImageTap: { tappedImage in
                    store.send(.contestDetailImageTapped(""))
                })
            }
            .background(DesignSystem.Color.soonganBG)
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(
                isPresented: $store.isContestSheetPresented.sending(\.dismissContestSheet)
            ) {
                chnageContestIndexSheet()
                    .presentationDetents([.height(280)])
            }
        } destination: { store in
            switch store.case {
            case .contestDetail(let store):
                ContestDetailView(store: store)
            }
        }
    }
    
    func navigationTitle(contestIndex: String, weekTopic: String) -> some View {
        ZStack(alignment: .trailing) {
            ZStack(alignment: .leading) {
                HStack{
                    Text(contestIndex)
                    
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
        .font(.bold20)
        .foregroundStyle(Color.black100)
        .padding(.vertical, 14)
        .background(DesignSystem.Color.soonganBG)
    }
}

private extension ContestView {
    func chnageContestIndexSheet() -> some View {
        VStack {
            HStack {
                Button(action: {
                    store.send(.dismissContestSheet(false))
                }) {
                    Text("취소")
                        .font(.semibold16)
                }
                
                Spacer()
                
                Text("회차 선택")
                    .font(.semibold20)
                
                Spacer()
                
                Button(action: {
                    store.send(.chagneContestIndex)
                }) {
                    Text("확인")
                        .font(.semibold16)
                }
            }
            .padding(.top, 28)
            .padding(.horizontal, 32)
            .foregroundStyle(DesignSystem.Color.black100)

            Picker("", selection: $store.selectedContestIndex) {
                ForEach(0..<store.contestOptions.count, id: \.self) { index in
                    Text(store.contestOptions[index])
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
