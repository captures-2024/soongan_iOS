//
//  ContestDetailView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 6/1/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture
import Kingfisher

struct ContestDetailView: View {
    
    @Bindable var store: StoreOf<ContestDetailFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<ContestDetailFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                
                if let url = store.imageUrl {
                    KFImage(URL(string: url)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 360, maxHeight: 460, alignment: .center)
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
        .sheet(isPresented: $store.isContestOptionSheetPresented.sending(\.dismissOptionSheet)) {
            CustomSheetView<DetailContestOptionType>(type: .detailContestOption(isWriter: store.isWriter)) { type in
                switch type {
                case .edit:
                    break
                case .delete:
                    store.send(.deleteButtonTapped)
                case .report:
                    store.send(.reportSheetIsPresented)
                }
            }
        }
        .sheet(
            isPresented: $store.isReportOptionSheetPresented.sending(\.dismissOptionSheet)
        ) {
            CustomSheetView<ContestReportReasonType>(type: .contestReport) { type in
//                switch type {
//                case .
//                }
            }
        }
//        .sheet(item: $store.activeSheet) { sheetType in
//            CustomSheetView(type: sheetType) { optionType in
//                
//            }
//        }
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
