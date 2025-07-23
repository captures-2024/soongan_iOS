//
//  UserProfileHeaderView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 7/17/25.
//

import SwiftUI

public struct ProfileHeaderView<ProfileImage: View>: View {
    
    // ViewBuilder를 통해 외부에서 프로필 이미지 뷰를 주입받습니다.
    private let profileImage: ProfileImage
    
    private let userName: String
    private let userIntroduction: String
    
    // MARK: - Init
    
    public init(
        userName: String,
        userIntroduction: String,
        @ViewBuilder profileImage: () -> ProfileImage
    ) {
        self.userName = userName
        self.userIntroduction = userIntroduction
        self.profileImage = profileImage()
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(alignment: .center, spacing: 18) {
            profileImage
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            profileHeaderSection()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Private Extension View

private extension ProfileHeaderView {
    func profileHeaderSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(userName)
                .font(DesignSystem.Font.medium16, lineHeight: 20)
            
            Text(userIntroduction)
                .font(DesignSystem.Font.regular12)
        }
        .foregroundStyle(DesignSystem.Color.black100)
    }
}

//#Preview {
//    UserProfileHeaderView()
//}
