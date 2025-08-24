//
//  CustomAlertView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 7/2/25.
//

import SwiftUI

public struct CustomAlertView: View {
    
    private var type: AlertType
    private var onBackgroundTap: (() -> Void)?
    private var centerButtonAction: (() -> Void)?
    private var leftButtonAction: (() -> Void)?
    private var rightButtonAction: (() -> Void)?
    
    // MARK: - Init
    
    public init(
        type: AlertType,
        onBackgroundTap: (() -> Void)? = nil,
        centerButtonAction: (() -> Void)? = nil,
        leftButtonAction: (() -> Void)? = nil,
        rightButtonAction: (() -> Void)? = nil
    ) {
        self.type = type
        self.onBackgroundTap = onBackgroundTap
        self.centerButtonAction = centerButtonAction
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            DesignSystem.Color.black100
                .opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onBackgroundTap?()
                }
            
            VStack {
                Image.soonganLogo
                    .padding(.top, 11)
                    .padding(.bottom, 35)
                
                Text(type.title)
                    .font(DesignSystem.Font.semibold16, lineHeight: 24)
                    .foregroundStyle(Color.black100)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 35)
                
                bottomButtonSection(isCenterButton: centerButtonAction == nil ? false : true)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 13)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
            )
            .padding(.horizontal, 60)
        }
    }
    
    func bottomButtonSection(isCenterButton: Bool) -> some View {
        HStack(spacing: 21) {
            if isCenterButton {
                Button(action: {
                    centerButtonAction?()
                }) {
                    Text(type.centerButtonTitle)
                        .font(DesignSystem.Font.semibold14)
                        .foregroundStyle(Color.black100)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(DesignSystem.Color.primary)
                        )
                }
            } else {
                Button(action: {
                    leftButtonAction?()
                }) {
                    Text("아니요")
                        .font(DesignSystem.Font.semibold14)
                        .foregroundStyle(Color.black100)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.clear)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                
                Button(action: {
                    rightButtonAction?()
                }) {
                    Text("네")
                        .font(DesignSystem.Font.semibold14)
                        .foregroundStyle(Color.black100)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(DesignSystem.Color.primary)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CustomAlertView(type: .postContestError, centerButtonAction: {  })
}

public enum AlertType: Identifiable {
    case postContestError
    case backPostContest
    case showLoginView
    case deletePost
    case deletePostComplete
    case forceUpdate
    
    public var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .postContestError:
            return "콘테스트가 마감됐어요."
        case .backPostContest:
            return "정말 작품 등록을\n하지 않으시겠어요?"
        case .showLoginView:
            return "해당 기능은\n로그인이 필요한 기능입니다."
        case .deletePost:
            return "정말 작품을\n삭제하시겠습니까?"
        case .deletePostComplete:
            return "삭제가 완료되었습니다"
        case .forceUpdate:
            return "원활한 앱 활동을 위해\n버전 업데이트가 필요합니다."
        }
    }
    
    var centerButtonTitle: String {
        switch self {
        case .forceUpdate:
            return "업데이트 하러가기"
        default:
            return "확인"
        
        }
    }
}
