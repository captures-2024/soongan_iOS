//
//  CustomSocialLoginButton.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/2/25.
//

import SwiftUI

import Resource

public struct CustomSocialLoginButton: View {
    
    // MARK: - Property
    
    private let type: SocialLoginType
    private let action: () -> Void

    // MARK: - Init
    
    public init(
        type: SocialLoginType,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: action) {
            ZStack(alignment: .center) {
                Text(type.title)
                    .font(.semibold18)
                    .foregroundStyle(type.textColor)

                HStack {
                    (type == .apple ? Image.appleLogo : Image.kakaoLogo)
                        .resizable()
                        .frame(width: type == .apple ? 20 : 16, height: type == .apple ? 20 : 16)
                        .padding(.leading, 32)

                    Spacer()
                }
            }
            .frame(width: 361, height: 56)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(type.backgroundColor)
            )
        }
    }
}

// MARK: - Preview

#Preview {
    CustomSocialLoginButton(type: .kakao, action: {})
}
