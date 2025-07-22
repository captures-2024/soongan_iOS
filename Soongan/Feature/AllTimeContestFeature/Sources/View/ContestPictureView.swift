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
    
    let imageUrl: String
    let nickName: String
    let likeCount: Int
    
    // MARK: - Init
    
    init(imageUrl: String, nickName: String, likeCount: Int) {
        self.imageUrl = imageUrl
        self.nickName = nickName
        self.likeCount = likeCount
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            KFImage(URL(string: imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            HStack(spacing: 0) {
                ContestPictureTextView(title: "@\(nickName)")
                
                Spacer()
                
                ContestPictureTextView(title: "\(likeCount)")
            }
            .padding(.horizontal, 8)
        }
    }
}

// MARK: - Preview

#Preview {
    ContestPictureView(
        imageUrl: "",
        nickName: "",
        likeCount: 0
    )
}
