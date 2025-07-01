//
//  MypageView.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/15/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

public struct MypageView: View {
    
    @Bindable var store: StoreOf<MypageFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<MypageFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 18) {
                    Image.myprofile
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                    
                    profileHeaderSection()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    rightButtonsSection()
                        .padding(.bottom, 9)
                }
                .padding(EdgeInsets(top: 21, leading: 18, bottom: 26, trailing: 28))
                
                ImageGridView(onImageTap: { _ in })
            }
            .frame(maxHeight: .infinity)
            .toolbar(.hidden, for: .tabBar)
            .background(DesignSystem.Color.soonganBG)
            .sheet(
                isPresented: $store.isOptionSheetPresented.sending(\.dismissOptionSheet)
            ) {
                CustomSheetView(type: .myprofileOption) { optionType in
                    store.send(.optionSheetIsPresented(optionType))
                }
            }
            .sheet(item: $store.activeSheet) { sheetType in
                CustomSheetView<MyprofileOptionType>(type: sheetType) { optionType in
//                    if let optionType = optionType as? MyprofileOptionType {
//                        store.send(.optionSelected(optionType))
//                    }
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        } destination: { store in
            switch store.case {
            case .editProfile(let store):
                EditProfileView(store: store)
            case .alarmList(let store):
                AlarmListView(store: store)
            case .questionsList(let store):
                QuestionsListView(store: store)
            }
        }
    }
}

// MARK: - Private Extension View

private extension MypageView {
    func profileHeaderSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(store.userName)
                .font(.medium16)
            
            Text(store.userIntroduce)
                .font(.regular12)
        }
        .foregroundStyle(Color.black100)
    }
    
    func rightButtonsSection() -> some View {
        HStack(spacing: 28) {
            Button(action: {
                store.send(.alarmButtonTapped)
            }){
                Image.alarmIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            
            Button(action: {
                store.send(.optionButtonTapped)
            }){
                Image.optionIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MypageView(store: Store(initialState: MypageFeature.State()) {
            MypageFeature()
        }
    )
}
