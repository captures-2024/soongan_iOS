//
//  DetailContestView.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 6/12/25.
//

import SwiftUI

import DesignSystem
import Shared
import Resource

import ComposableArchitecture

struct DetailContestView: View {
    
    let imageModels1 = [
        ContestImageModel(imageName: "dumy2", contestImage: ResourceAsset.Image.dumy2.swiftUIImage),
        ContestImageModel(imageName: "dumy1", contestImage: ResourceAsset.Image.dumy1.swiftUIImage)
    ]
    
    let imageModels2 = [
        ContestImageModel(imageName: "dumy7", contestImage: ResourceAsset.Image.dumy7.swiftUIImage),
        ContestImageModel(imageName: "dumy6", contestImage: ResourceAsset.Image.dumy6.swiftUIImage)
    ]
    
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
                    
                    Image.dumy6
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 360)
                        .padding(.top, 27)
                    
                    contestTitleSection()
                        .padding(.top, 40)
                        .padding(.bottom, 92)
                    
                    HStack(alignment: .top) {
                        LazyVStack(spacing: 8) {
                            ForEach(imageModels1) { model in
                                model.contestImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onAppear {
                                        print("1열", model.imageName)
                                    }
                                    .onTapGesture {
                                        //                                    onImageTap(model) // ✅ 콜백 호출
                                    }
                            }
                        }
                        
                        LazyVStack(spacing: 8) {
                            ForEach(imageModels2) { model in
                                model.contestImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onAppear {
                                        print("2열", model.imageName)
                                    }
                                    .onTapGesture {
                                        //                                    onImageTap(model) // ✅ 콜백 호출
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.bottom, 70)
                
                Button(action: {
                    
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
            .padding(.leading, 25)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(DesignSystem.Color.soonganBG)
    }
    
    func contestTitleSection() -> some View {
        VStack(spacing: 0) {
            Text("평화 (1회차)")
                .font(.semibold20)
                .foregroundColor(DesignSystem.Color.black100)
                .padding(.bottom, 20)
            
            Text("2025.01.17 - 2025.01.20")
                .font(.semibold14)
                .foregroundColor(DesignSystem.Color.black100)
                .padding(.bottom, 8)
            
            
            Text("총 참여작품 수 : 30")
                .font(.semibold14)
                .foregroundColor(DesignSystem.Color.black100)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DetailContestView(
            store: Store(initialState:
                            DetailContestFeature.State()) {
                                DetailContestFeature()
                            }
        )
    }
}
