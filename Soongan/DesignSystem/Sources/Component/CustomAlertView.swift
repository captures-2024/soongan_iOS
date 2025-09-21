//
//  CustomAlertView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 7/2/25.
//

import SwiftUI

public protocol AlertDisplayable: Identifiable {
    var title: String { get }
    var centerButtonTitle: String { get }
}

// 기존 코드 호환성을 위한 타입 별칭
public typealias DefaultCustomAlertView = CustomAlertView<AlertType>

public struct CustomAlertView<T: AlertDisplayable>: View {
    
    private var type: T
    private var onBackgroundTap: (() -> Void)?
    private var centerButtonAction: (() -> Void)?
    private var leftButtonAction: (() -> Void)?
    private var rightButtonAction: (() -> Void)?
    
    // MARK: - Init
    
    public init(
        type: T,
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
    CustomAlertView(type: AlertType.postContestError, centerButtonAction: {  })
}

public enum AlertType: AlertDisplayable {
    case postContestError
    case backPostContest
    case backEditContest
    case showLoginView
    case deletePost
    case deletePostComplete
    case deleteContainPostToTop7
    case editContainPostToTop7
    case forceUpdate
    
    public var id: Self {
        self
    }
    
    public var title: String {
        switch self {
        case .postContestError:
            return "콘테스트가 마감됐어요."
        case .backPostContest:
            return "정말 작품 등록을\n하지 않으시겠어요?"
        case .backEditContest:
            return "정말 작품 수정을\n하지 않으시겠어요?"
        case .showLoginView:
            return "해당 기능은\n로그인이 필요한 기능입니다."
        case .deletePost:
            return "정말 작품을\n삭제하시겠습니까?"
        case .deletePostComplete:
            return "삭제가 완료되었습니다"
        case .deleteContainPostToTop7:
            return "TOP 7에 선정된 작품은\n삭제할 수 없습니다."
        case .editContainPostToTop7:
            return "TOP 7에 선정된 작품은\n수정할 수 없습니다."
        case .forceUpdate:
            return "원활한 앱 활동을 위해\n버전 업데이트가 필요합니다."
        }
    }
    
    public var centerButtonTitle: String {
        switch self {
        case .showLoginView:
            return "로그인하기"
        case .forceUpdate:
            return "업데이트 하러가기"
        default:
            return "확인"
        
        }
    }
}

public enum LoginErrorType: AlertDisplayable, Equatable {
    case socialLogin(title: String)
    case serverAuth
    case profileFetch
    case fcmTokenMissing
    
    public var id: String {
        switch self {
        case .socialLogin(let title):
            return "\(title)socialLogin"
        case .serverAuth:
            return "serverAuth"
        case .profileFetch:
            return "profileFetch"
        case .fcmTokenMissing:
            return "fcmTokenMissing"
        }
    }
    
    public var title: String {
        switch self {
        case .socialLogin(let title):
            return "\(title)에 실패했습니다."
        case .serverAuth:
            return "서버 인증에 실패했습니다.\n잠시 후 다시 시도해주세요."
        case .profileFetch:
            return "프로필 정보를 가져오는 데에 실패했습니다."
        case .fcmTokenMissing:
            return "FCM 인증에 실패했습니다. "
        }
    }
    
    public var centerButtonTitle: String {
        return "확인"
    }
}

public enum SignupErrorType: AlertDisplayable, Equatable {
    case checkNicknameFailed
    case editBrithDayFailed
    case myprofileFailed
    
    public var id: String {
        switch self {
        case .checkNicknameFailed:
            return "checkNicknameFailed"
        case .editBrithDayFailed:
            return "editBrithDayFailed"
        case .myprofileFailed:
            return "myprofileFailed"
        }
    }
    
    public var title: String {
        switch self {
        case .checkNicknameFailed:
            return "닉네임 중복체크에 실패했습니다.\n잠시 후 다시 시도해주세요."
        case .editBrithDayFailed:
            return "출생연도 입력에 실패했습니다.\n잠시 후 다시 시도해주세요."
        case .myprofileFailed:
            return "회원가입에 실패했습니다.\n잠시 후 다시 시도해주세요."
        }
    }
    
    public var centerButtonTitle: String {
        return "확인"
    }
}
