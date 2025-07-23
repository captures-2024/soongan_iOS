//
//  ContestPictureView.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 7/21/25.
//

import SwiftUI

import DesignSystem

import Kingfisher

struct ContestPictureView: View {
    
    // MARK: - Property
    
    let isFirstPost: Bool
    let contestStatus: PostStatus
    let imageUrl: String
    let nickName: String
    let likeCount: Int
    
    // MARK: - Init
    
    init(
        isFirstPost: Bool,
        contestStatus: PostStatus,
        imageUrl: String,
        nickName: String,
        likeCount: Int
    ) {
        self.isFirstPost = isFirstPost
        self.contestStatus = contestStatus
        self.imageUrl = imageUrl
        self.nickName = nickName
        self.likeCount = likeCount
    }
    
    // MARK: - Body
    
    var body: some View {
        if contestStatus == .active {
            actviePostContestImageSection()
        } else {
            postContestImageSection(status: contestStatus)
        }
    }
    
    private func actviePostContestImageSection() -> some View {
        ZStack(alignment: .bottom) {
            KFImage(URL(string: imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            HStack(spacing: 0) {
                ContestPictureTextView(title: "@\(nickName)")
                
                Spacer()
                
                ContestPictureTextView(title: "\(likeCount)")
                    .padding(.bottom, 8)
            }
            .padding(.horizontal, 8)
        }
    }
    
    private func postContestImageSection(status: PostStatus) -> some View {
        VStack {
            Image.soonganLogo
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 56)
                .padding(.top, 48)
            
            Spacer()
            
            Text(isFirstPost == true ? status.firstPostTitle : status.otherPostTitle)
                .font(isFirstPost == true ? DesignSystem.Font.semibold14 : DesignSystem.Font.semibold12, lineHeight: 20)
                .foregroundStyle(DesignSystem.Color.black100)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 15)
            
            Spacer()
        }
        .background {
            Rectangle()
                .stroke(DesignSystem.Color.black40, lineWidth: 0.5)
        }
        .frame(height: isFirstPost == true ? 240 : 258)
    }
}

// MARK: - Preview

#Preview {
    ContestPictureView(
        isFirstPost: true, contestStatus: .deleteByAdmin,
        imageUrl: "https://storage.googleapis.com/soongan-dev-test2/28/weekly/2/ 테스트_contest-1753077740628.jpg",
        nickName: "",
        likeCount: 0
    )
    
    ContestPictureView(
        isFirstPost: false, contestStatus: .deleteByAdmin,
        imageUrl: "https://storage.googleapis.com/soongan-dev-test2/28/weekly/2/ 테스트_contest-1753077740628.jpg",
        nickName: "",
        likeCount: 0
    )
    .frame(width: 184)
}
