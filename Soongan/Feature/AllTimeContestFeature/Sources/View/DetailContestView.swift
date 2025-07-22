//
//  DetailContestView.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 6/12/25.
//

import SwiftUI

import DetailContestFeature
import DesignSystem
import Shared
import Resource

import ComposableArchitecture

struct DetailContestView: View {
    
    @Bindable var store: StoreOf<DetailContestFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<DetailContestFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            topBackButtonSection()
            
            ScrollView {
                VStack(spacing: 0) {
                    if let imageData = store.firstPostData {
                        ContestPictureView(
                            imageUrl: imageData.imageUrl,
                            nickName: imageData.nickName,
                            likeCount: imageData.likeCount
                        )
                        .frame(width: 360)
                        .padding(.top, 27)
                    }
                    
                    contestTitleSection()
                        .padding(.top, 40)
                        .padding(.bottom, 92)
                    
                    HStack(alignment: .top) {
                        LazyVStack(spacing: 8) {
                            ForEach(store.leftContestImageList) { model in
                                ContestPictureView(
                                    imageUrl: model.imageUrl,
                                    nickName: model.nickName,
                                    likeCount: model.likeCount
                                )
                                .frame(width: 184)
                                .onTapGesture {
                                    store.send(.postPictureTapped(postId: model.id))
                                }
                            }
                        }
                        
                        LazyVStack(spacing: 8) {
                            ForEach(store.rightContestImageList) { model in
                                ContestPictureView(
                                    imageUrl: model.imageUrl,
                                    nickName: model.nickName,
                                    likeCount: model.likeCount
                                )
                                .frame(width: 184)
                                .onTapGesture {
                                    store.send(.postPictureTapped(postId: model.id))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.bottom, 70)
                
                Button(action: {
                    store.send(.showPictureButtonTapped)
                }) {
                    Text("참여작품 보러 가기👀")
                        .font(.medium20)
                        .foregroundColor(DesignSystem.Color.black100)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(DesignSystem.Color.primary)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 48)
            }
            .background(DesignSystem.Color.soonganBG)
        }
        .background(InteractivePopGestureEnabler())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    func topBackButtonSection() -> some View {
        HStack {
            Button {
                store.send(.backButtonTapped)
            } label: {
                HStack(spacing: 0) {
                    Image.arrowBack
                        .padding(.trailing, 5)
                }
            }
            .padding(.top, 16)
            .padding(.leading, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(DesignSystem.Color.soonganBG)
    }
    
    func contestTitleSection() -> some View {
        VStack(spacing: 0) {
            Text("\(store.contestInfoData.subject) (\(store.contestInfoData.round)회차)")
                .font(.semibold20)
                .foregroundColor(DesignSystem.Color.black100)
                .padding(.bottom, 20)
            
            Text("\(store.contestInfoData.startAt) - \(store.contestInfoData.endAt)")
                .font(.semibold14)
                .foregroundColor(DesignSystem.Color.black100)
                .padding(.bottom, 8)
            
            Text("총 참여 작품 수 : \(store.contestCount ?? 0)")
                .font(.semibold14)
                .foregroundColor(DesignSystem.Color.black100)
        }
    }
}

// MARK: - Preview

//#Preview {
//    NavigationStack {
//        DetailContestView(
//            store: Store(initialState:
//                            DetailContestFeature.State()) {
//                                DetailContestFeature()
//                            }
//        )
//    }
//}
