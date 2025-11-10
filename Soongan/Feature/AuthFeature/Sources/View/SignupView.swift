//
//  SignupView.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/2/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

public struct SignupView: View {
    
    @Bindable public var store: StoreOf<SignupFeature>
    
    @FocusState private var isNicknameFieldFocused: Bool
    @FocusState private var isBirthdayFocused: Bool
    
    // MARK: - Init
    
    public init(
        store: StoreOf<SignupFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            DesignSystem.Color.soonganBG
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.dismissKeyboard()
                }
            
            VStack(spacing: 0) {
                CustomNavigationBarView(navigationCase: .signup) {
                    store.send(.backButtonTapped)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    CustomTextFieldView(
                        type: .nickname,
                        text: $store.nickname,
                        isFocused: $isNicknameFieldFocused,
                        state: $store.nicknameState
                    )
                    .offset(y: store.signupState == .inputBirthday ? -20 : 0)
                    .animation(.easeInOut, value: store.signupState)
                    
                    if store.signupState == .inputBirthday {
                        CustomTextFieldView(
                            type: .birthday,
                            text: $store.birthday,
                            isFocused: $isBirthdayFocused,
                            state: $store.birthdayState
                        )
                        .onAppear {
                            isBirthdayFocused = true
                        }
                        .keyboardType(.numberPad)
                        .padding(.top, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    Text("다음이 마지막 단계입니다!")
                        .font(DesignSystem.Font.medium12, lineHeight: 16)
                        .foregroundStyle(Color.black60)
                        .padding(.bottom, 12)
                    
                    CustomBottomButton(
                        type: .next,
                        isEnable: $store.isButtonEnabled
                    ) {
                        store.send(.nextButtonTapped)
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 40)
            }
            .animation(.easeInOut, value: store.signupState)
        }
        .onAppear {
            isNicknameFieldFocused = true
        }
        .navigationBarBackButtonHidden(true)
        .background(alertHostingView)
        .background(InteractivePopGestureEnabler())
    }
    
    @ViewBuilder
    var alertHostingView: some View {
        Color.clear .fullScreenCover(item: $store.signupErrorAlert) { alertType in
            CustomAlertView<SignupErrorType>(
                type: alertType,
                centerButtonAction: {
                    store.send(.dismissAlert)
                }
            ).presentationBackground(.clear)
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
}

// MARK: - Preview

#Preview {
    SignupView(
        store: Store(initialState: SignupFeature.State()) {
            SignupFeature()
        }
    )
}
