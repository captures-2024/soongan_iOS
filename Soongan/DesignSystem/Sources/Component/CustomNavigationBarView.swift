//
//  CustomNavigationBarView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 11/5/25.
//

import SwiftUI

public struct CustomNavigationBarView: View {
    
    // MARK: - Properties
    
    private let navigationCase: NavigationCase
    private let backAction: () -> Void
    
    // MARK: - Init
    
    public init(
        navigationCase: NavigationCase,
        backAction: @escaping () -> Void
    ) {
        self.navigationCase = navigationCase
        self.backAction = backAction
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // 배경과 뒤로가기 버튼
            HStack {
                Button(action: backAction) {
                    HStack(spacing: 0) {
                        Image.arrowBack
                        
                        if case .signup = navigationCase {
                            Text("회원가입")
                                .font(DesignSystem.Font.medium24, lineHeight: 32)
                                .foregroundStyle(DesignSystem.Color.black100)
                        }
                    }
                }
                .padding(.leading, 20)
                
                Spacer()
            }
            
            // 중앙에 위치한 타이틀
            switch navigationCase {
            case .postImage(let round, let weekTopic):
                HStack(spacing: 8) {
                    Text("\(round)회차")
                    
                    Text("|")
                        .font(DesignSystem.Font.medium20)
                    
                    Text(weekTopic)
                }
                .font(DesignSystem.Font.bold20, lineHeight: 20)
                .foregroundStyle(DesignSystem.Color.black100)
                
            case .title(let titleString):
                if let titleFont = navigationCase.titleFont {
                    Text(titleString)
                        .font(titleFont, lineHeight: 20)
                        .foregroundStyle(DesignSystem.Color.black100)
                }
                
            case .backButton, .signup:
                EmptyView()
            }
        }
        .frame(height: 54)
        .background(DesignSystem.Color.soonganBG)
    }
}

//#Preview {
//    VStack(spacing: 20) {
//        CustomNavigationBarView(title: "프로필 수정") {
//            print("Back button tapped")
//        }
//        
//        CustomNavigationBarView(title: nil) {
//            print("Back button tapped")
//        }
//    }
//}
