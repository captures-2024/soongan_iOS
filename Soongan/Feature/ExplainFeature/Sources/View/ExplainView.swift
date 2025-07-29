//
//  ExplainView.swift
//  ExplainFeature
//
//  Created by ParkJunHyuk on 7/24/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture
import Kingfisher

public struct ExplainView: View {
    
    @Bindable var store: StoreOf<ExplainFeature>
    @FocusState private var isFocused: Bool
    
    private enum Field: Hashable {
        case myTextEditor
    }
    
    // MARK: - Init
    
    public init(
        store: StoreOf<ExplainFeature>
    ) {
        self.store = store
        
        // UINavigationBar의 외형을 담당하는 객체를 생성합니다.
        let appearance = UINavigationBarAppearance()
        
        // 1. 배경을 불투명하게 설정하고 구분선을 없애는 핵심 코드입니다.
        appearance.shadowColor = .clear // 하단 선 제거
        
        // 2. 원하는 배경색을 설정합니다.
        appearance.backgroundColor = UIColor(DesignSystem.Color.soonganBG)
        
        // 3. 네비게이션 바의 표준 모양과 스크롤 될 때의 모양을 모두 설정합니다.
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // MARK: - Body
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {
                    DesignSystem.Color.soonganBG
                        .ignoresSafeArea()
                        .onTapGesture {
                            UIApplication.shared.dismissKeyboard()
                        }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Image.dumy1
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 114, height: 114)
                            .padding(.bottom, 40)
                        
                        explainTitleSection(title: "테스트")
                            .padding(.bottom, 40)
                        
                        CustomTextEditor(
                            text: $store.inputTextEditor,
                            placeholder: store.textEditorPlaceHolder,
                            characterLimit: 1000,
                            isFocused: $isFocused
                        )
                        .frame(height: 234)
                        .padding(.bottom, 40)
                        
                        CustomBottomButton(
                            type: .submit,
                            isEnable: $store.isButtonEnable,
                            action: {
                                store.send(.bottomButtonTapped)
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
                .background(DesignSystem.Color.soonganBG)
                .background(InteractivePopGestureEnabler())
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                    })
            .scrollToMinDistance(minDisntance: 32)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    HStack(spacing: 0) {
                        Image.arrowBack
                            .padding(.trailing, 5)
                    }
                }
                .padding(.top, 10)
            }
            
            ToolbarItem(placement: .principal) {
                Text("소명하기")
                    .font(DesignSystem.Font.bold16, lineHeight: 24)
                    .foregroundColor(DesignSystem.Color.black100)
                    .padding(.top, 10)
            }
        }
    }
}

// MARK: - Private Extension

private extension ExplainView {
    func topBackButtonSection() -> some View {
        HStack {
            Button {
                store.send(.backButtonTapped)
            } label: {
                HStack(spacing: 0) {
                    Image.arrowBack
                        .padding(.trailing, 5)
                }
            }
            .padding(.top, 16)
            .padding(.leading, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(DesignSystem.Color.soonganBG)
    }
    
    func explainTitleSection(title: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("'\(title)'은")
                .font(DesignSystem.Font.regular12, lineHeight: 20)
            Text("도용, 초상권 or 저작권 침해 등 타인의 권리 침해로")
                .font(DesignSystem.Font.bold12, lineHeight: 20)
            Text("신고가 접수됐습니다.")
                .font(DesignSystem.Font.regular12, lineHeight: 20)
            Text("이에 따라 소명이 필요한 상황이기에 소명해 주실 것을 요청드립니다.\n\n")
                .font(DesignSystem.Font.regular12, lineHeight: 20)
            
            Text("이는 단순 신고가 아닌")
                .font(DesignSystem.Font.regular12, lineHeight: 20)
            Text("신고자의 설명이 납득 가능해 이런 절차가 이뤄짐을 알려드립니다.\n")
                .font(DesignSystem.Font.regular12, lineHeight: 20)
            Text("해당 사진을 언제, 어디서, 어떻게 찍었는지 자세히 설명해주세요.")
                .font(DesignSystem.Font.regular12, lineHeight: 20)
            Group {
                Text("소명이 이뤄지지 않는다면")
                Text("3일 후 해당 작품은 모든 사용자로부터 숨김처리됩니다.")
            }
            .underline()
            .font(DesignSystem.Font.regular12, lineHeight: 20)
        }
    }
}


// MARK: - Preview

#Preview {
    NavigationStack {
        ExplainView(store: Store(initialState: ExplainFeature.State(reportId: "0")) {
            ExplainFeature()
        }
        )
    }
}
