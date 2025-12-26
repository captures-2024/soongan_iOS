//
//  ContestIndexSheetView.swift
//  ContestFeature
//
//  Created by ParkJunHyuk on 12/24/25.
//

import SwiftUI

import DesignSystem

import ComposableArchitecture

struct ContestIndexSheetView: View {
    @Bindable var store: StoreOf<ContestFeature>
    @State private var selection: Int

    init(store: StoreOf<ContestFeature>) {
        self.store = store
        self._selection = State(initialValue: store.state.selectedContestIndex)
    }

    var body: some View {
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
                    store.send(.view(.changeContestIndex(to: selection)))
                }) {
                    Text("확인")
                        .font(DesignSystem.Font.semibold16, lineHeight: 19)
                }
            }
            .padding(.top, 28)
            .padding(.horizontal, 32)
            .foregroundStyle(DesignSystem.Color.black100)

            Picker("", selection: $selection) {
                ForEach(0..<store.contestOptions.count, id: \.self) { index in
                    let contest = store.contestOptions[index]
                    Text("\(contest.round)회차 \(contest.subject)")
                        .tag(index)
                }
            }
            .pickerStyle(.inline)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
