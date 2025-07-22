//
//  ContestDetailView.swift
//  DetailContestFeature
//
//  Created by ParkJunHyuk on 6/1/25.
//

import SwiftUI

import DesignSystem
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
            .onAppear {
                store.send(.onAppear)
            }
            .ignoresSafeArea(edges: .bottom)
            .background(DesignSystem.Color.soonganBG)
            .background(InteractivePopGestureEnabler())
            .fullScreenCover(isPresented: $store.isDeleteAlertPresented) {
                CustomAlertView(
                    type: .deletePost,
                    leftButtonAction: {
                        store.send(.dismissDeleteAlert)
                    },
                    rightButtonAction: {
                        store.send(.deleteButtonTapped)
                    }
                ).presentationBackground(.clear)
            }
            .fullScreenCover(isPresented: $store.isDeleteCompleteAlertPresented) {
                CustomAlertView(
                    type: .deletePostComplete,
                    centerButtonAction: {
                        store.send(.deleteCompletedButtonTapped)
                    }
                ).presentationBackground(.clear)
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
            .sheet(isPresented: $store.isContestOptionSheetPresented.sending(\.dismissOptionSheet)
            ) {
                CustomSheetView<DetailContestOptionType>(type: .detailContestOption(isWriter: store.isWriter)) { type in
                    switch type {
                    case .edit:
                        break
                    case .delete:
                        store.send(.deleteOptionButtonTapped)
                    case .report:
                        store.send(.reportSheetIsPresented)
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
                    
                    switch type {
                    case .inappropriateContent:
                        store.isReportInputReasonSheetPresented = true
                    case .hateSpeech:
                        break
                    case .infringement:
                        break
                    case .spam:
                        break
                    case .promotion:
                        break
                    case .other:
                        store.isReportInputReasonSheetPresented = true
                    }
                }
            }
            .sheet(
                isPresented: $store.isReportInputReasonSheetPresented.sending(\.dismissReportOptionSheet)
            ) {
                if let type = store.reportReasonSheet {
                    CustomSheetView<NeverOption>(type: type) { reportType, reasonText in
                        store.send(.reportReasonButtonTapped(type: reportType, reason: reasonText))
                    }
                }
            }
            .fullScreenCover(
                isPresented: $store.isFullSizeImageSheetPresented.sending(\.dismissFullSizeImageSheet)
            ) {
                ZoomableImageView(url: store.imageUrl)
            }
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
                    KFImage(URL(string: url)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 360, maxHeight: 460, alignment: .center)
                        .onTapGesture {
                            store.send(.contestImageTapped)
                        }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(store.contestTitle ?? "정보없음")
                        .font(.bold20)
                    
                    Text("@" + (store.contestAuthor ?? "정보없음"))
                        .font(.medium14)
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
                store.send(.optionButtonTapped)
            }) {
                Image.dotOption
            }
            .padding(.leading, 16)
            
            Spacer()
            
            HStack(spacing: 0) {
                Button(action: {
                    store.send(.likeButtonTapped)
                }) {
                    if isLiked {
                        Image.selectLike
                    } else {
                        Image.notSelectLike
                    }
                }
                .padding(.trailing, 8)
                
                Text(likeCount)
                    .font(.info12)
                    .foregroundColor(DesignSystem.Color.black100)
                    .padding(.trailing, 32)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 43)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ContestDetailView(
            store: Store(initialState:
                            ContestDetailFeature.State(postId: String(10))) {
                                ContestDetailFeature()
                            }
        )
    }
}
