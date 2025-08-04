//
//  MypageView.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/15/25.
//

import SwiftUI

import DetailContestFeature
import DesignSystem
import Shared

import ComposableArchitecture
import Kingfisher

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
            VStack {
                HStack(alignment: .center, spacing: 18) {
                    ProfileHeaderView(
                        userName: store.userName,
                        userIntroduction: store.userIntroduce
                    ) {
                        if let url = store.userProfileImageUrl {
                            KFImage(URL(string: url)!)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Image.myprofile
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    
                    rightButtonsSection()
                        .padding(.bottom, 9)
                }
                .padding(EdgeInsets(top: 21, leading: 18, bottom: 26, trailing: 28))
                
                if store.leftContestImageList.isEmpty {
                    notJoinContestSection()
                } else {
                    ImageGridView(
                        leftImageList: store.leftContestImageList,
                        rightImageList: store.rightContestImageList,
                        onImageTap: { tappedImage in
                            store.send(.contestDetailImageTapped(tappedImage.id))
                    })
                    .padding(.bottom, 50)
                }
            }
            .frame(maxHeight: .infinity)
            .toolbar(.hidden, for: .tabBar)
            .background(DesignSystem.Color.soonganBG)
            .background(alertHostingView)
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(
                isPresented: $store.isOptionSheetPresented.sending(\.dismissOptionSheet)
            ) {
                CustomSheetView<MyprofileOptionType>(type: .myprofileOption) { optionType in
                    store.send(.optionSheetIsPresented(optionType))
                }
            }
            .sheet(item: $store.activeSheet) { sheetType in
                CustomSheetView<MyprofileOptionType>(type: sheetType) { optionType in
                    store.send(.profileOptionTapped(optionType))
                }
            }
            .sheet(item: $store.successSheet) { sheetType in
                CustomSheetView<MypageSuccessSheetType>(type: sheetType) { successType in
                    store.successSheet = nil
                    store.send(.deleteMyInfomation)
                }
            }
        } destination: { store in
            switch store.case {
            case .editProfile(let store):
                EditProfileView(store: store)
            case .alarmList(let store):
                AlarmListView(store: store)
            case .questionsList(let store):
                QuestionsListView(store: store)
            case .contestDetail(let store):
                ContestDetailView(store: store)
            }
        }
    }
}

// MARK: - Private Extension View

private extension MypageView {
    func rightButtonsSection() -> some View {
        HStack(spacing: 28) {
            Button(action: {
                store.send(.uiAction(.alarmButtonTapped))
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
    
    func notJoinContestSection() -> some View {
        VStack {
            Spacer()
                
            Text("아직 참가한 내역이 없어요.")
                .font(DesignSystem.Font.regular12)
                .padding(.bottom, 12)
            
            Button(action: {
                store.send(.uiAction(.joinToContestButtonTapped))
            }) {
                VStack(spacing: 4) {
                    Text("참가하러 가기")
                        .font(DesignSystem.Font.bold12)
                        
                    Divider()
                        .frame(width: 66, height: 2)
                        .background(Color.black100)
                }
            }
            
            Spacer(minLength: 370)
        }
        .foregroundStyle(Color.black100)
    }
    
    @ViewBuilder
    var alertHostingView: some View {
        Color.clear.fullScreenCover(isPresented: $store.isLoginAlertPresented) {
            CustomAlertView(
                type: .showLoginView,
                onBackgroundTap: {
                    store.send(.dismissLoginAlert)
                },
                centerButtonAction: {
                    store.send(.dismissAlertButtonTapped)
                }
            )
            .presentationBackground(.clear)
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
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
