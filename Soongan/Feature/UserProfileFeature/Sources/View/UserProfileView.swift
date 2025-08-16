//
//  UserProfileView.swift
//  UserProfileFeature
//
//  Created by ParkJunHyuk on 5/15/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture
import Kingfisher

public struct UserProfileView: View {
    
    @Bindable var store: StoreOf<UserProfileFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<UserProfileFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            ProfileHeaderView(
                userName: store.userName ?? "정보없음",
                userIntroduction: store.userIntroduction ?? "정보없음",
            ) {
                if let url = store.userProfileImageUrl {
                    KFImage(URL(string: url)!)
                        .resizable()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                }
            }
            
            if store.leftContestImageList.isEmpty {
                EmptyView()
            } else {
//                ImageGridView(
//                    leftImageList: store.leftContestImageList,
//                    rightImageList: store.rightContestImageList,
//                    onImageTap: { _ in
//                        
//                })
//                .padding(.bottom, 50)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
