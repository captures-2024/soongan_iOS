//
//  EditProfileView.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/22/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

public struct EditProfileView: View {
    
    @Bindable var store: StoreOf<EditProfileFeature>
    
    @FocusState private var isNicknameFieldFocused: Bool
    @FocusState private var isIntroductionFocused: Bool
    
    // MARK: - Init
    
    public init(
        store: StoreOf<EditProfileFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.dismissKeyboard()
                }
            
            VStack {
                Button(action: {
                    
                }) {
                    ZStack(alignment: .bottomTrailing) {
                        Image.editProfile
                        
                        Image.addProfile
                    }
                }
                .padding(.top, 42)
                .padding(.bottom, 40)
                
                VStack {
                    CustomTextFieldView(
                        type: .changeNickname,
                        text: $store.nickname,
                        isFocused: $isNicknameFieldFocused,
                        state: $store.nicknameState
                    )
                    .padding(.bottom, 48)
                    
                    CustomTextFieldView(
                        type: .introduce,
                        text: $store.introduce,
                        isFocused: $isIntroductionFocused,
                        state: $store.introduceState
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                CustomBottomButton(type: .editComplete, isEnable: $store.editButtonState) {
                    
                }
                .padding(.horizontal, 136)
                .padding(.bottom, 93)
            }
            .frame(maxHeight: .infinity)
            .background(DesignSystem.Color.soonganBG)
            .background(InteractivePopGestureEnabler())
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
                .padding(.top, 16)
            }
        }
    }
}

#Preview {
    EditProfileView(store: Store(initialState: EditProfileFeature.State()) {
            EditProfileFeature()
        }
    )
}
