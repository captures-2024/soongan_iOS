//
//  HomeView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import DetailContestFeature
import DesignSystem

import ComposableArchitecture
import Kingfisher

public struct HomeView: View {
    
    @Bindable var store: StoreOf<HomeFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<HomeFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ZStack {
                DesignSystem.Color.soonganBG.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    topheaderView()
                        .padding(.horizontal, 36)
                        .padding(.bottom, 60)
                    
                    switch store.homeState {
                    case .loading:
                        VStack {
                            Spacer()
                            
                            ProgressView()
                                .scaleEffect(1.5)
                            
                            Spacer()
                        }
                    case .inProgress:
                        inProgressMainSection()
                    case .endTopic:
                        endTopicMainSection()
                    }
                }
                .padding(.top, 69)
                .padding(.bottom, 40)
                .animation(.easeInOut, value: store.homeState)
                .toolbar(.hidden, for: .tabBar)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Color.clear.frame(height: 50)
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(isPresented: $store.isInfoSheetPresented) {
                CustomSheetView<NeverOption>(type: .contestInfo) { }
            }
            .background(alertHostingView)
        } destination: { store in
            switch store.case {
            case .postPicture(let store):
                PostPictureView(store: store)
            case .contestDetail(let store):
                ContestDetailView(store: store)
            }
        }
    }
}

// MARK: - Private Extension View

private extension HomeView {
    func topheaderView() -> some View {
        HStack(spacing: 0) {
            weekTopicTopHeader()
            
            Spacer()
            
            Image.soonganLogo
                .resizable()
                .frame(width: 33, height: 50)
        }
    }
    
    func weekTopicTopHeader() -> some View {
        ZStack(alignment: .topLeading) {
            Circle()
                .fill(DesignSystem.Color.primary)
                .frame(width: 40, height: 40)
                .offset(x: -20, y: -20)
            
            Text(store.weekTopic)
                .font(store.homeState == .inProgress ? DesignSystem.Font.bold42 : DesignSystem.Font.bold24, lineHeight: 40)
                .foregroundStyle(DesignSystem.Color.black100)
        }
    }

    func inProgressMainSection() -> some View {
        VStack(spacing: 0) {
            if store.postImageData.isEmpty {
                Button(action: {
                    store.send(.uiAction(.addPictureButtonTapped))
                }) {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 257, height: 257)
                            .shadow(
                                color: Color.black.opacity(0.25),
                                radius: 5, x: 0, y: 4)
                        
                        VStack(spacing: 16) {
                            Image.addPlus
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("출품하기")
                                .font(DesignSystem.Font.regular14, lineHeight: 16)
                                .foregroundStyle(Color.black100)
                        }
                    }
                }
            } else {
                postImageSection(postImageList: store.postImageData)
            }
            
            Spacer(minLength: 76)

            periodSection(startPeriod: store.startPeriod, endPeriod: store.endPeriod)
                .padding(.bottom, 32)
            
            HStack(spacing: 0) {
                CircleButton(type: .info) {
                    store.send(.uiAction(.infoButtonTapped))
                }
                
                Spacer()
                
                CircleButton(type: .rightArrow) {
                    store.send(.uiAction(.showContestButtonTapped))
                }
            }
            .padding(.horizontal, 32)
        }
    }
    
    func endTopicMainSection() -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 0) {
                Text("회차가 끝나고\n잠시 쉬어가는 중이에요\n\n어떤 작품들이 나왔는지 보러가고 싶다면")
                    .multilineTextAlignment(.center)
            }
            .font(DesignSystem.Font.regular15)
            .foregroundStyle(DesignSystem.Color.black100)
            .padding(.bottom, 50)
            
            Button(action: {
                store.send(.uiAction(.showContestButtonTapped))
            }) {
                Text("보러가기")
                    .font(DesignSystem.Font.regular15)
                    .foregroundStyle(DesignSystem.Color.black100)
                    .underline(color: DesignSystem.Color.black100)
            }
            .padding(.bottom, 100)
            
            Spacer()
        }
    }
    
    func postImageSection(postImageList: [PostImageModel]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                Button(action: {
                    store.send(.uiAction(.addPictureButtonTapped))
                }) {
                    ZStack(alignment: .bottom) {
                        ZStack {
                            if store.isAddPostImage {
                                Rectangle()
                                    .fill(store.isAddPostImage ? DesignSystem.Color.black40 : Color.white)
                                    .frame(width: 60, height: 257)
                                    .overlay(
                                        Rectangle()
                                        // 그림자 색상과 두께를 가진 테두리를 생성
                                            .stroke(Color.black.opacity(0.3), lineWidth: 4)
                                        // 테두리를 부드럽게 번지게 하여 그림자처럼 만듦
                                            .blur(radius: 4)
                                        // 그림자에 방향성을 주기 위해 약간 이동
                                            .offset(x: 2, y: 2)
                                        // 번진 효과가 사각형 밖으로 나가지 않도록 마스킹
                                            .mask(Rectangle())
                                    )
                            } else {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 257)
                                    .shadow(
                                        color: Color.black.opacity(0.25),
                                        radius: 5, x: 0, y: 4
                                    )
                            }
                            
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(store.isAddPostImage ? .white : DesignSystem.Color.black100)
                                .frame(width: 20, height: 20)
                        }

                        Text("\(postImageList.count)/3")
                            .font(DesignSystem.Font.regular14)
                            .foregroundStyle(store.isAddPostImage ? .white : DesignSystem.Color.black100)
                            .padding(.bottom, 24)
                    }
                }
                .disabled(store.isAddPostImage)
                
                if !postImageList.isEmpty {
                    ForEach(postImageList) { image in
                        if let url = URL(string: image.imageURL) {
                            VStack(spacing: 12) {
                                KFImage(url)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 257)
                                    .shadow(
                                        color: Color.black.opacity(0.25),
                                        radius: 5, x: 0, y: 4)
                                    .onTapGesture {
                                        store.send(.uiAction(.pictureTapped(image.id)))
                                    }
                                
                                HStack(spacing: 16) {
                                    HStack(spacing: 4) {
                                        (image.isLiked ? Image.selectLike : Image.notSelectLike)
                                            .resizable()
                                            .frame(width: 12, height: 12)
                                        
                                        Text("\(image.likeCount)")
                                    }
                                    
                                    HStack(spacing: 4) {
                                        Image.commentIcon
                                            .resizable()
                                            .frame(width: 12, height: 12)
                                        
                                        Text("\(image.commentCount)")
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.leading, 4)
                                .font(DesignSystem.Font.medium12)
                                .foregroundStyle(DesignSystem.Color.black100)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding(.leading, 20)
        }
    }
    
    func periodSection(startPeriod: String, endPeriod: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("시작일")
                
                Text("|")
                    
                Text(startPeriod)
            }
            
            HStack(spacing: 4) {
                Text("마감일")
                
                Text("|")
                    
                Text(endPeriod)
            }
        }
        .font(DesignSystem.Font.medium14)
        .foregroundStyle(DesignSystem.Color.black100)
    }
    
    @ViewBuilder
    var alertHostingView: some View {
        Color.clear.fullScreenCover(isPresented: $store.isAlertPresented) {
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
    HomeView(
        store: Store(initialState:
            HomeFeature.State()) {
                HomeFeature()
            }
    )
}
