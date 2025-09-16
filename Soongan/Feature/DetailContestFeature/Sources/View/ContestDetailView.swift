//
//  ContestDetailView.swift
//  DetailContestFeature
//
//  Created by ParkJunHyuk on 6/1/25.
//

import SwiftUI

import DesignSystem
import PostPictureFeature
import Shared

import ComposableArchitecture
import Kingfisher

public struct ContestDetailView: View {
    
    @Bindable var store: StoreOf<ContestDetailFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<ContestDetailFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        baseView
            .ignoresSafeArea(edges: .bottom)
            .background(DesignSystem.Color.soonganBG)
            .background(InteractivePopGestureEnabler())
            .fullScreenCover(item: $store.alertSheet) { alertType in
                CustomAlertView(
                    type: alertType,
                    leftButtonAction: {
                        store.send(.alertAction(.dismissAlert))
                    },
                    rightButtonAction: {
                        switch alertType {
                        case .deletePost:
                            store.send(.deleteButtonTapped)
                        case .deletePostComplete:
                            store.send(.deleteCompletedButtonTapped)
                        default:
                            break
                        }
                    }
                ).presentationBackground(.clear)
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
            .sheet(
                isPresented: $store.isContestOptionSheetPresented.sending(\.dismissOptionSheet),
                onDismiss: { store.send(.sheetAction(.optionSheetDismissed)) }
            ) {
                CustomSheetView<DetailContestOptionType>(type: .detailContestOption(isWriter: store.isWriter)) { type in
                    switch type {
                    case .edit:
                        store.send(.sheetAction(.editButtonTapped))
                    case .delete:
                        store.send(.sheetAction(.deleteOptionButtonTapped))
                    case .report:
                        if store.authState == .skipped {
                            store.send(.alertAction(.notAuthUserAlert))
                        } else {
                            store.send(.sheetAction(.reportSheetIsPresented))
                        }
                    }
                }
            }
            .sheet(
                isPresented: $store.isReportOptionSheetPresented.sending(\.dismissReportOptionSheet)
            ) {
                CustomSheetView<ContestReportReasonType>(type: .contestReport) { type in
                    store.send(.optionSheetIsPresented(type))
                }
            }
            .sheet(item: $store.activeSheet) { sheetType in
                CustomSheetView<ContestReportReasonType>(type: sheetType) { type, reportReason in
                    store.send(.networkAction(.postReport(type: type)))
                }
            }
            .sheet(item: $store.reportReasonSheet) { sheetType in
                CustomSheetView<NeverOption>(type: sheetType) { reportType, reasonText in
                    store.send(.sheetAction(.reportReasonButtonTapped(type: reportType, reason: reasonText)))
                }
            }
            .sheet(item : $store.completeReportSheet) { sheetType in
                CustomSheetView<ContestReportReasonType>(type: sheetType) { _ in }
            }
            .fullScreenCover(
                isPresented: $store.isFullSizeImageSheetPresented.sending(\.dismissFullSizeImageSheet)
            ) {
                ZoomableImageView(url: store.imageUrl)
            }
            .background(alertHostingView)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.send(.backButtonTapped)
                    } label: {
                        HStack(spacing: 0) {
                            Image.arrowBack
                                .padding(.trailing, 5)
                        }
                    }
                    .padding(.top, 16)
                }
            }
    }
    
    @ViewBuilder
    private var baseView: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                
                if let url = store.imageUrl {
                    KFImage(URL(string: url))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 360, maxHeight: 460, alignment: .center)
                        .onTapGesture {
                            store.send(.uiAction(.contestImageTapped))
                        }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(store.contestTitle ?? "정보없음")
                        .font(DesignSystem.Font.bold20, lineHeight: 24)
                    
                    Text("@" + (store.contestAuthor ?? "정보없음"))
                        .font(DesignSystem.Font.medium14, lineHeight: 16)
                }
                .padding(.horizontal, 36)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 83)
            
            bottomOptionMenuBar(isLiked: store.isLiked ?? false, likeCount: store.likeCount ?? "0")
        }
        .onAppear {
            store.send(.onAppear)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(DesignSystem.Color.soonganBG)
        .background(InteractivePopGestureEnabler())
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
    
    func bottomOptionMenuBar(isLiked: Bool, likeCount: String) -> some View {
        HStack(alignment: .top) {
            Button(action: {
                store.send(.uiAction(.optionButtonTapped))
            }) {
                Image.dotOption
            }
            .padding(.leading, 16)
            
            Spacer()
            
            HStack(spacing: 0) {
                Button(action: {
                    store.send(.uiAction(.likeButtonTapped))
                }) {
                    if isLiked {
                        Image.selectLike
                    } else {
                        Image.notSelectLike
                    }
                }
                .padding(.trailing, 8)
                
                Text(likeCount)
                    .font(DesignSystem.Font.info12)
                    .foregroundColor(DesignSystem.Color.black100)
                    .padding(.trailing, 32)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 43)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
    
    @ViewBuilder
    var alertHostingView: some View {
        Color.clear.fullScreenCover(isPresented: $store.isLoginAlertPresented) {
            CustomAlertView(
                type: .showLoginView,
                onBackgroundTap: {
                    store.send(.alertAction(.dismissLoginAlert))
                },
                centerButtonAction: {
                    store.send(.alertAction(.dismissAlertButtonTapped))
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
    NavigationStack {
        ContestDetailView(
            store: Store(initialState:
                            ContestDetailFeature.State(postId: 10, weekTopic: "")) {
                                ContestDetailFeature()
                            }
        )
    }
}
