//
//  CustomSheetView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import Shared

import ComposableArchitecture

public struct CustomSheetView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    private let type: SheetContentType
    private var action: (() -> Void)? = nil
    private var optionAction: ((MyprofileOptionType) -> Void)? = nil
    
    @State private var inputText = ""
    
    // MARK: - Init
    
    public init(
        type: SheetContentType,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.action = action
    }
    
    public init(
        type: SheetContentType,
        optionAction: @escaping (MyprofileOptionType) -> Void
    ) {
        self.type = type
        self.optionAction = optionAction
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            titleSection(type)
            
            switch type {
            case .contestInfo:
                contestInfoContentSection(action: {})
                    .padding(.top, 40)
                
            case .postPicture(let name):
                postPictureContetnSection(name: name, action: {})
                    .padding(.top, 40)
                
            case .logout:
                logoutContentSection(action: {})
                    .padding(.top, 40)
            
            case .withdraw:
                withDrawContentSection(action: {})
                    .padding(.top, 40)
                
            case .myprofileOption:
                mypageOptionContentSection(action: { optionType in
                    guard let optionAction else { return }
                    optionAction(optionType)
                })
                .padding(.top, 30)
                
            case .alarmSetting:
                pushAlarmSettingContentSection()
                
            case .completeWithdraw:
                withDrawContentSection(action: {})
                    .padding(.top, 40)
                
            case .contestReport:
                contestReportContentSection(action: { _ in })
                    .padding(.top, 12)
                
            case .spam:
                reportContentSection(reportType: .spam, action: {})
                
            case .reportComplete:
                reportCompleteContentSection(action: {})
                    .padding(.top, 40)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .presentationDetents(type.height)
        .presentationBackground(Color.white)
        .presentationCornerRadius(20)
    }
}

// MARK: - Mypage Section Private Extension View

private extension CustomSheetView {
    func titleSection(_ type: SheetContentType) -> some View {
        VStack(spacing: 12) {
            Capsule()
                .fill(Color.black100)
                .frame(width: 40, height: 4)
                .padding(.top, 16)
            
            if type != .myprofileOption {
                Text(type.title)
                    .font(.bold16)
                    .foregroundStyle(Color.black100)
            }
        }
    }
    
    func contestInfoContentSection(action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("규칙")
                .font(.semibold16)
                .padding(.bottom, 2)
            
            Text("작품 총 3개 출품 가능")
                .font(.regualr16)
                .padding(.bottom, 10)
                .padding(.leading, 16)
            
            Text("선정 방식")
                .font(.semibold16)
                .padding(.bottom, 4)
            
            Text("투표: 좋아요 개수로 TOP 7 선정")
                .font(.regualr16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("기간 : 1달")
                .font(.regualr16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("매달 1일 오전 9시 ~ 다음 달 1일 00시")
                .font(.regualr16)
                .padding(.bottom, 8)
                .padding(.leading, 16)
            
            Text("동점자 처리 방식")
                .font(.semibold16)
                .padding(.bottom, 4)
            
            Text("1. 직전 회차 참가자")
                .font(.regualr16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("2. 업로드 시간을 비교해 더 일찍 참가한 작품")
                .font(.regualr16)
                .padding(.bottom, 8)
                .padding(.leading, 16)
            
            Text("리워드")
                .font(.semibold16)
                .padding(.bottom, 4)
            
            Text("최종 1위한 작품은\n앱 접속 시 나오는 화면에 배경 사진으로 사용")
                .font(.regualr16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("(차기 콘테스트 종료 시까지)")
                .font(.regualr16)
                .padding(.leading, 16)
            
            CustomBottomButton(
                type: .comfirm,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 40)
            .padding(.horizontal, -2)
        }
        .foregroundStyle(Color.black)
        .padding(.horizontal, 38)
    }
    
    func postPictureContetnSection(name: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text("<\(name)>")
                Text("(으)로 작품을 제출할까요?")
            }
            .padding(.horizontal, 20)
            
            CustomBottomButton(
                type: .complete,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 40)
        }
        .font(.regualr16)
        .foregroundStyle(Color.black)
        .padding(.horizontal, 20)
    }
    
    func mypageOptionContentSection(action: @escaping (MyprofileOptionType) -> Void) -> some View {
        VStack(spacing: 0) {
            ForEach(MyprofileOptionType.allCases, id: \.self) { option in
                VStack(spacing: 0) {
                    Button(action: {
                        action(option)
                    }) {
                        HStack(alignment: .center) {
                            Text(option.title)
                                .font(.semibold16)
                                .foregroundStyle(Color.black100)
                            
                            Spacer()
                            
                            option.image
                        }
                        .frame(height: 60)
                        .padding(.horizontal, 40)
                    }
                    
                    if option != MyprofileOptionType.allCases.last {
                        Rectangle()
                            .fill(Color(red: 187/255, green: 187/255, blue: 187/255))
                            .frame(maxWidth: .infinity)
                            .frame(height: 0.7)
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
    
    func withDrawContentSection(action: @escaping () -> Void) -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("정말 회원탈퇴를 하실 건가요?")
                    .font(.regualr16)
                    .foregroundStyle(Color.black100)
                
                Text("회원탈퇴를 위해 아래 입력창에\n'회원탈퇴'를 입력해주세요")
                    .font(.regualr16)
                    .foregroundStyle(Color.black100)
                
                TextField("", text: $inputText,
                          prompt: Text("텍스트를 입력해주세요.").foregroundColor(Color.init(red: 187/255, green: 187/255, blue: 187/255)))
                    .font(.regualr18)
                    .padding()
                    .frame(height: 48)
                    .tint(.black100)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .stroke(Color.black100)
                    )
                    .padding(.top, 32)
            }
            .padding(.horizontal, 20)
            
            CustomBottomButton(
                type: .complete,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 40)
        }
        .foregroundStyle(Color.black100)
        .padding(.horizontal, 20)
    }
    
    func logoutContentSection(action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("정말 로그아웃 하실 건가요?")
                .font(.regualr16)
                .foregroundStyle(Color.black100)
                .padding(.horizontal, 20)
            
            CustomBottomButton(
                type: .logout,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 64)
        }
        .padding(.horizontal, 20)
    }
    
    func pushAlarmSettingContentSection() -> some View {
        @State var toggle1On = false
        
        return VStack {
            ForEach(AlaramSettingOptionType.allCases, id: \.self) { option in
                VStack(spacing: 0) {
                    Toggle(isOn: $toggle1On) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(option.title)
                                .font(.semibold16)
                                .foregroundStyle(Color.black100)
                            
                            if !option.subTitle.isEmpty {
                                Text(option.subTitle)
                                    .font(.regualr12)
                                    .foregroundStyle(Color.black100)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.leading, 40)
                    .padding(.trailing, 24)
                    .tint(.primary)
                    
                    if option != AlaramSettingOptionType.allCases.last {
                        Rectangle()
                            .fill(Color(red: 187/255, green: 187/255, blue: 187/255))
                            .frame(maxWidth: .infinity)
                            .frame(height: 0.7)
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}


// MARK: - Contest Section Private Extension View

private extension CustomSheetView {
    func contestReportContentSection(action: @escaping (ContestReportReasonType) -> Void) -> some View {
        VStack(spacing: 0) {
            ForEach(ContestReportReasonType.allCases, id: \.self) { option in
                VStack(spacing: 0) {
                    Text(option.title)
                        .font(.semibold16)
                        .foregroundStyle(Color.black100)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if option != ContestReportReasonType.allCases.last {
                        Rectangle()
                            .fill(Color(red: 187/255, green: 187/255, blue: 187/255))
                            .frame(maxWidth: .infinity)
                            .frame(height: 0.7)
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
    
    func reportContentSection(reportType: ContestReportReasonType, action: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("이 댓글을")
                    .font(.regualr16)
                
                HStack(spacing: 0) {
                    Text(reportType.title)
                        .font(.bold16)
                    
                    Text("(으)로")
                        .font(.regualr16)
                }
                
                Text("정말 신고하겠습니까?")
                    .font(.regualr16)
            }
            .padding(.horizontal, 4)
            .foregroundStyle(Color.black100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
            
            CustomBottomButton(
                type: .comfirm,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 45)
        }
        .padding(.horizontal, 36)
    }
    
    func reportCompleteContentSection(action: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("신고가 완료됐습니다.\n\n해당 게시물은 숨김처리되었습니다.\n\n3일 이내로 검토 후 조치가 이뤄질 예정입니다. 결과가 나오면 알림으로 알려드리겠습니다.")
                    .padding(.bottom, 20)
                
                Text("신고 내용의 구체적인 확인이 더 필요한 경우\n이메일로 연락드릴 예정입니다.")
                Text("감사합니다")
                
            }
            .font(.regualr16)
            .foregroundStyle(Color.black100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
            
            CustomBottomButton(
                type: .comfirm,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 45)
        }
        .padding(.horizontal, 36)
    }
}

// MARK: - Preview

#Preview {
    CustomSheetView(type: .contestReport, action: {})
}
