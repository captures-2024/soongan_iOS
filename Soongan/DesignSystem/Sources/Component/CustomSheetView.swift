//
//  CustomSheetView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import Shared

//import ComposableArchitecture

public enum NeverOption: Equatable, CaseIterable { }

public struct CustomSheetView<T: Equatable & CaseIterable>: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    private let type: SheetContentType
    private var action: (() -> Void)? = nil
    private var optionAction: ((T) -> Void)? = nil
    private var isSelectType: SortContestDataType?
    
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
        optionAction: @escaping (T) -> Void
    ) {
        self.type = type
        self.optionAction = optionAction
    }
    
    public init(
        type: SheetContentType,
        isSelectType: SortContestDataType,
        optionAction: @escaping (T) -> Void
    ) {
        self.type = type
        self.isSelectType = isSelectType
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
                PostPictureContentSectionView(name: name, action: action ?? {})
                       .padding(.top, 26)
                
            case .logout:
                logoutContentSection(action: { optionType in
                    guard let optionAction else { return }
                    optionAction(optionType as! T)
                })
                    .padding(.top, 40)
                
            case .logoutSuccess:
                logoutSuccessContentSection(action: { optionType in
                    guard let optionAction else { return }
                    optionAction(optionType as! T)
                })
                    .padding(.top, 40)
                
            case .withdraw:
                WithdrawContentSection(action: { optionType in
                    guard let optionAction else { return }
                    optionAction(optionType as! T)
                })
                    .padding(.top, 40)
                
            case .withdrawSuccess:
                withDrawSuccessContentSection(action: { optionType in
                    guard let optionAction else { return }
                    optionAction(optionType as! T)
                })
                    .padding(.top, 40)
                
            case .myprofileOption:
                mypageOptionContentSection(action: { optionType in
                    guard let optionAction else { return }
                    optionAction(optionType as! T)
                })
                .padding(.top, 30)
                
            case .alarmSetting:
                pushAlarmSettingContentSection()
                
            case .contestReport:
                contestReportContentSection(action: { _ in })
                    .padding(.top, 12)
                
            case .spam:
                reportContentSection(reportType: .spam, action: {})
                
            case .reportComplete:
                reportCompleteContentSection(action: {})
                    .padding(.top, 40)
                
            case .detailContestOption(let isWriter):
                detailContestOptionSection(isWriter: isWriter, action: { optionType in
                    guard let optionAction else { return }
                    optionAction(optionType as! T)

                })
//                .padding(.top, 30)
                
            case .sortContest:
                if let isSelectType {
                    sortPostContestSection(selectedType: isSelectType, action: { optionType in
                        guard let optionAction else { return }
                        optionAction(optionType as! T)
                    })
                }
                
            case .selectProfile(let isBaseProfile):
                selectProfileContestSection(isBaseProfile: isBaseProfile, action: { optionType in
                    guard let optionAction else { return }
                    optionAction(optionType as! T)
                })
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
                .font(.regular16)
                .padding(.bottom, 10)
                .padding(.leading, 16)
            
            Text("선정 방식")
                .font(.semibold16)
                .padding(.bottom, 4)
            
            Text("투표: 좋아요 개수로 TOP 7 선정")
                .font(.regular16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("기간 : 1달")
                .font(.regular16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("매달 1일 오전 9시 ~ 다음 달 1일 00시")
                .font(.regular16)
                .padding(.bottom, 8)
                .padding(.leading, 16)
            
            Text("동점자 처리 방식")
                .font(.semibold16)
                .padding(.bottom, 4)
            
            Text("1. 직전 회차 참가자")
                .font(.regular16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("2. 업로드 시간을 비교해 더 일찍 참가한 작품")
                .font(.regular16)
                .padding(.bottom, 8)
                .padding(.leading, 16)
            
            Text("리워드")
                .font(.semibold16)
                .padding(.bottom, 4)
            
            Text("최종 1위한 작품은\n앱 접속 시 나오는 화면에 배경 사진으로 사용")
                .font(.regular16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("(차기 콘테스트 종료 시까지)")
                .font(.regular16)
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
    
    func postPictureContentSection(name: String, action: @escaping () -> Void) -> some View {
        @State var isChecked = false
        
        return VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 5) {
                Text("<\(name)>")
                Text("(으)로 작품을 제출할까요?")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)
            
            HStack(spacing: 0) {
                Button(action: {
                    isChecked.toggle()
                    print("버튼 눌림", isChecked)
                }) {
                    ZStack {
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                            .fill(isChecked ? Color.black : Color.clear)
                            .frame(width: 24, height: 24)

                        if isChecked {
                            Image.checkIcon
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                .padding(.trailing, 16)

                HStack(alignment: .top, spacing: 4) {
                    Text("*")
                        .foregroundStyle(DesignSystem.Color.primary)
                        .offset(y: 2)

                    Text("등록된 순간은 약관에 따라 관리되며,\nTOP 7에 선정된 순간은 역대 콘테스트에 기록됩니다")
                        .foregroundStyle(DesignSystem.Color.black100)
                }
                .font(.regular12)
            }
            .padding(.horizontal, 20)
            
            CustomBottomButton(
                type: .complete,
                isEnable: $isChecked,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 16)
        }
        .font(.regular16)
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
    
    func withDrawSuccessContentSection(action: @escaping (MypageSuccessSheetType) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 10) {
                Text("회원탈퇴가 완료되었습니다.")
                
                Text("또 만나길 바랄게요!")
            }
            .font(.regular16)
            .foregroundStyle(Color.black100)
            .padding(.horizontal, 20)
            
            CustomBottomButton(
                type: .comfirm,
                action: {
                    action(.withdraw)
                    dismiss()
                }
            )
            .padding(.top, 40)
        }
        .padding(.horizontal, 20)
    }
    
    func logoutContentSection(action: @escaping (MyprofileOptionType) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("정말 로그아웃 하실 건가요?")
                .font(.regular16)
                .foregroundStyle(Color.black100)
                .padding(.horizontal, 20)
            
            CustomBottomButton(
                type: .logout,
                action: {
                    action(.logout)
                    dismiss()
                }
            )
            .padding(.top, 64)
        }
        .padding(.horizontal, 20)
    }
    
    func logoutSuccessContentSection(action: @escaping (MypageSuccessSheetType) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 10) {
                Text("로그아웃이 완료되었습니다.")
                
                Text("또 만나길 바랄게요!")
            }
            .font(.regular16)
            .foregroundStyle(Color.black100)
            .padding(.horizontal, 20)
            
            CustomBottomButton(
                type: .comfirm,
                action: {
                    action(.logout)
                    dismiss()
                }
            )
            .padding(.top, 40)
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
                                    .font(.regular12)
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
    
    func detailContestOptionSection(isWriter: Bool, action: @escaping (DetailContestOptionType) -> Void) -> some View {
        VStack(spacing: 0) {
            ForEach(DetailContestOptionType.allCases, id: \.self) { option in
                VStack(spacing: 0) {
                    Button(action: {
                        action(option)
                    }) {
                        HStack(alignment: .center) {
                            Text(option.title)
                                .font(.semibold16)
                                .foregroundStyle(
                                    !option.isEnabled(forWriter: isWriter)
                                    ? Color.black100.opacity(0.3)
                                    : (isWriter ? Color.black100 : (option == .report ? Color.error : Color.black100))
                                )
                            
                            Spacer()
                            
                            option.rightImage(isWriter: isWriter)
                        }
                        .frame(height: 56)
                        .padding(.horizontal, 40)
                    }
                    .disabled(!option.isEnabled(forWriter: isWriter))
                    
                    if option != DetailContestOptionType.allCases.last {
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
    func sortPostContestSection(selectedType: SortContestDataType, action: @escaping (SortContestDataType) -> Void) -> some View {
        VStack(spacing: 0) {
            ForEach(SortContestDataType.allCases, id: \.self) { option in
                VStack(spacing: 0) {
                    Button(action: {
                        action(option)
                    }) {
                        HStack(alignment: .center) {
                            Text(option.title)
                                .font(.semibold16)
                                .foregroundStyle(option == selectedType ? Color.black100 : Color.black100.opacity(0.5))
                            
                            Spacer()
                            
                            option.rightImage(isSelected: option == selectedType)
                        }
                        .frame(height: 56)
                        .padding(.horizontal, 40)
                    }
                    
                    if option != SortContestDataType.allCases.last {
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
                    .font(.regular16)
                
                HStack(spacing: 0) {
                    Text(reportType.title)
                        .font(.bold16)
                    
                    Text("(으)로")
                        .font(.regular16)
                }
                
                Text("정말 신고하겠습니까?")
                    .font(.regular16)
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
            .font(.regular16)
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
    
    func selectProfileContestSection(isBaseProfile: Bool, action: @escaping (EditProfileType) -> Void) -> some View {
        VStack(spacing: 0) {
            ForEach(EditProfileType.allCases, id: \.self) { option in
                VStack(spacing: 0) {
                    Button(action: {
                        action(option)
                    }) {
                        HStack(alignment: .center) {
                            Text(option.title)
                                .font(.semibold16)
                                .foregroundStyle(isBaseProfile && option == .baseProfile ? Color.black100.opacity(0.5) : Color.black100)
                            
                            Spacer()
                        }
                        .frame(height: 56)
                        .padding(.horizontal, 40)
                    }
                    .disabled(isBaseProfile && option == .baseProfile)
                    
                    if option != EditProfileType.allCases.last {
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

// MARK: - Preview

//#Preview {
//    CustomSheetView(type: .postPicture(name: "테스트"), action: {})
//}


struct PostPictureContentSectionView: View {
    let name: String
    @Environment(\.dismiss) private var dismiss
    @State var isChecked: Bool = false
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 5) {
                Text("<\(name)>")
                Text("(으)로 작품을 제출할까요?")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)
            
            HStack(spacing: 0) {
                Button(action: {
                    isChecked.toggle()
                    print("버튼 눌림", isChecked)
                }) {
                    ZStack {
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                            .fill(isChecked ? Color.black : Color.clear)
                            .frame(width: 20, height: 20)

                        if isChecked {
                            Image.checkIcon
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                .padding(.trailing, 16)

                HStack(alignment: .top, spacing: 4) {
                    Text("*")
                        .foregroundStyle(DesignSystem.Color.primary)

                    Text("등록된 순간은 약관에 따라 관리되며,\nTOP 7에 선정된 순간은 역대 콘테스트에 기록됩니다")
                        .foregroundStyle(DesignSystem.Color.black100)
                }
                .font(.regular12)
            }
            .padding(.horizontal, 20)
            
            CustomBottomButton(
                type: .complete,
                isEnable: $isChecked,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 16)
        }
        .font(.regular16)
        .foregroundStyle(Color.black)
        .padding(.horizontal, 20)
    }
}

struct WithdrawContentSection: View {
    var action: (MyprofileOptionType) -> Void

    @State var inputText: String = ""
    @State private var isButtonEnable = false
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle()) // <- 터치 영역 활성화
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false // 포커스 해제 → 키보드 내려감
                }
            
            VStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text("정말 회원탈퇴를 하실 건가요?")
                        .font(.regular16)
                        .foregroundStyle(Color.black100)
                    
                    Text("회원탈퇴를 위해 아래 입력창에\n'회원탈퇴'를 입력해주세요")
                        .font(.regular16)
                        .foregroundStyle(Color.black100)
                    
                    TextField("", text: $inputText,
                              prompt: Text("텍스트를 입력해주세요.")
                        .foregroundColor(Color(red: 187/255, green: 187/255, blue: 187/255)))
                    .focused($isFocused)
                    .font(.regular18)
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
                    isEnable: $isButtonEnable,
                    action: {
                        action(.withdraw)
                        dismiss()
                    }
                )
                .padding(.top, 40)
            }
            .onAppear {
                isFocused = true
            }
        }
        .onChange(of: inputText) { _, newValue in
            isButtonEnable = (newValue == "회원탈퇴")
        }
        .foregroundStyle(Color.black100)
        .padding(.horizontal, 20)
    }
}
