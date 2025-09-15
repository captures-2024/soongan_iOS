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
import PostPictureFeature
import ExplainFeature

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
                    contestImageSection()
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
            case .postPicture(let store):
                PostPictureView(store: store)
            case .explain(let store):
                ExplainView(store: store)
            case .completeExplain(let store):
                CompleteExplainView(store: store)
            }
        }
    }
    
    func contestImageSection() -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    HStack(alignment: .top, spacing: 8) {
                        imageGridSection(imageList: store.leftContestImageList, geometry: geometry, direction: .left)
                        imageGridSection(imageList: store.rightContestImageList, geometry: geometry, direction: .right)
                    }
                    .padding(.horizontal, 8)
                    .scrollTargetLayout()
                }
                .scrollPosition($store.scrollPosition, anchor: .bottom)
                .onScrollGeometryChange(for: CGFloat.self,
                    of: { geometry in
                        return geometry.bounds.origin.y
                    },
                    action: { oldValue, newValue in
                        withAnimation {
                            store.scrollOffset = newValue
                        }
                    }
                )
                
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
                .opacity(store.scrollOffset > 200 ? 1 : 0)
                .allowsHitTesting(store.scrollOffset > 200)
                .animation(.easeInOut, value: store.scrollOffset > 200)
            }
            .padding(.bottom, 50)
        }
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
                            store.send(.updateLeftImageModel(modelId, calculatedHeight))
                        case .right:
                            store.send(.updateRightImageModel(modelId, calculatedHeight))
                        }
                    },
                    onTapAction: { modelId in
                        store.send(.contestDetailImageTapped(modelId))
                    }
                )
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
