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
                
                if let posts = store.allPosts {
                    if posts.isEmpty {
                        notJoinContestSection()
                    } else {
                        WaterfallImageGridView(
                            posts: posts,
                            hasMorePages: store.hasNextPage,
                            isLoading: store.isNextPageLoading,
                            isInitialLoading: false, // 로딩 완료
                            onRefresh: {
                                store.send(.refreshTriggered)
                            },
                            onLoadMore: {
                                store.send(.updateMoreNextPage(true))
                            },
                            onImageTap: { id in
                                store.send(.contestDetailImageTapped(id))
                            },
                            onScrollPositionChange: { offsetY in
                                store.send(.updateTopButtonVisibility(offsetY))
                            }
                        )
                    }
                } else {
                    // 상태 1: 초기 로딩 중 (nil)
                    WaterfallImageGridView(
                        posts: [], // 로딩 중에는 빈 배열 전달
                        hasMorePages: false,
                        isLoading: false,
                        isInitialLoading: true,
                        onRefresh: {
                            store.send(.refreshTriggered)
                        },
                        onLoadMore: {
                            // 필요시 로직 추가
                        },
                        onImageTap: { _ in
                            // 로딩 중에는 탭 동작 없음
                        },
                        onScrollPositionChange: { _ in
                            // 필요시 로직 추가
                        }
                    )
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
                switch sheetType {
                case .alarmSetting:
                    let notificationStates: [AlaramSettingOptionType: Bool] = [
                        .allAlarm: store.contestPush && store.activityPush && store.noticePush,
                        .contestAlarm: store.contestPush,
                        .activeAlarm: store.activityPush,
                        .noticeAlarm: store.noticePush
                    ]
                    
                    CustomSheetView<AlaramSettingOptionType>(
                        type: sheetType,
                        notificationStates: notificationStates
                    ) { settingType, isEnabled in
                        store.send(.notification(.updateNotificationSetting(settingType, isEnabled)))
                    }
                    
                default:
                    CustomSheetView<MyprofileOptionType>(type: sheetType) { optionType in
                        store.send(.profileOptionTapped(optionType))
                    }
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
}

// MARK: - Private Extension View

private extension MypageView {
    func rightButtonsSection() -> some View {
        HStack(spacing: 28) {
            Button(action: {
                store.send(.uiAction(.alarmButtonTapped))
            }){
                (store.isUnReadNotification ? Image.alarmIcon : Image.noneAlarmIcon)
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
            CustomAlertView<AlertType>(
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
