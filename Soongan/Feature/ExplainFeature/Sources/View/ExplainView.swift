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
    @State private var paddingBottomButton: CGFloat = 0
    
    // MARK: - Init
    
    public init(
        store: StoreOf<ExplainFeature>
    ) {
        self.store = store
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = UIColor(DesignSystem.Color.soonganBG)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            KFImage(store.imageUrl.flatMap(URL.init(string:)))
                                .placeholder { 
                                    SkeletonView()
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 109)
                                .padding(.bottom, geometry.size.height * 40 / 852)
                                .onTapGesture {
                                    store.send(.contestImageTapped)
                                }
                            
                            explainTitleSection(title: store.contestTitle ?? "")
                                .padding(.bottom, geometry.size.height * 40 / 852)
                            
                            CustomTextEditor(
                                text: $store.inputTextEditor,
                                placeholder: store.textEditorPlaceHolder,
                                characterLimit: 1000,
                                isFocused: $isFocused
                            )
                            .frame(height: 200)
                            .id("textEditor")
                            
                            // 스크롤 콘텐츠가 하단 버튼에 가려지지 않도록 여백 추가
                            Color.clear.frame(height: 100)
                        }
                        .padding(.horizontal, 20)
                        .scrollIndicators(.hidden)
                        .background(InteractivePopGestureEnabler())
                    }
                    .defaultScrollAnchor(.bottom)
                    .dismissKeyboardOnTap()
                    // isFocused 상태가 변경될 때 스크롤 동작 실행
                    .onChange(of: isFocused) { _, isNowFocused in
                        store.send(.textEditorFocusChanged(isNowFocused))
                        
                        if isNowFocused {
                            // 키보드가 올라오는 시간을 고려하여 딜레이 후 스크롤
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                withAnimation {
                                    proxy.scrollTo("textEditor", anchor: .center)
                                    paddingBottomButton = 10
                                }
                            }
                        } else {
                            paddingBottomButton = 0
                        }
                    }
                }
                
                CustomBottomButton(
                    type: .submit,
                    isEnable: $store.isButtonEnable,
                    action: {
                        store.send(.bottomButtonTapped)
                    }
                )
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, paddingBottomButton)
                .background(DesignSystem.Color.soonganBG)
            }
            .padding(.top, 10)
            .background(DesignSystem.Color.soonganBG)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            store.send(.onAppear)
        }
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
        .fullScreenCover(
            isPresented: $store.isFullSizeImageSheetPresented.sending(\.dismissFullSizeImageSheet)
        ) {
            ZoomableImageView(url: store.imageUrl)
        }
    }
}

// MARK: - Private Extension

private extension ExplainView {
    func explainTitleSection(title: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("'\(title)'은")
                .font(DesignSystem.Font.regular12, lineHeight: 20)
            Text("도용, 초상권 or 저작권 침해 등 타인의 권리 침해로")
                .font(DesignSystem.Font.bold12, lineHeight: 20)
            Text("신고가 접수됐습니다.")
                .font(DesignSystem.Font.regular12, lineHeight: 20)
            Text("이에 따라 소명이 필요한 상황이기에 소명해 주실 것을 요청드립니다.\n")
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
        ExplainView(store: Store(initialState: ExplainFeature.State(reportId: 0, targetType: "")) {
            ExplainFeature()
        }
        )
    }
}
