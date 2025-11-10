//
//  EditProfileView.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/22/25.
//

import SwiftUI
import PhotosUI

import DesignSystem
import Shared

import ComposableArchitecture
import Kingfisher

public struct EditProfileView: View {
    
    @Bindable var store: StoreOf<EditProfileFeature>
    
    @FocusState private var isNicknameFieldFocused: Bool
    @FocusState private var isIntroductionFocused: Bool
    
    // MARK: - Init
    
    public init(
        store: StoreOf<EditProfileFeature>
    ) {
        self.store = store
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(DesignSystem.Color.soonganBG)
        appearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            DesignSystem.Color.soonganBG
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.dismissKeyboard()
                }
            
            VStack {
                CustomNavigationBarView(navigationCase: .backButton) {
                    store.send(.backButtonTapped)
                }
                
                profileImageSection()
                    .padding(.top, 42)
                    .padding(.bottom, 40)
                
                inputFieldsSection()
                    .padding(.horizontal, 20)
                
                Spacer()
                
                CustomBottomButton(type: .editComplete, isEnable: $store.editButtonState) {
                    store.send(.editMyProfileButtonTapped)
                }
                .padding(.horizontal, 136)
                .padding(.bottom, 93)
            }
            .frame(maxHeight: .infinity)
        }
        .background(InteractivePopGestureEnabler())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            store.send(.onAppear)
        }
        .photosPicker(
            isPresented: $store.isPhotosPickerPresented,
            selection: $store.selectedItem,
            matching: .images
        )
        .sheet(
            isPresented: $store.isProfileSheetPresented.sending(\.dismissProfileSheet)
        ) {
            CustomSheetView<EditProfileType>(type: .selectProfile(isBaseProfile: (store.imageData == nil && store.baseProfileImageUrl == nil))) {
                option in
                switch option {
                case .baseProfile:
                    store.send(.baseProfileOptionTapped)
                case .selectImage:
                    store.send(.selectImageOptionTapped)
                }
            }
        }
    }
}

// MARK: - Private Extension View

private extension EditProfileView {
    func profileImageSection() -> some View {
        VStack {
            Button(action: {
                store.send(.showProfileSheet)
            }) {
                if let imageUrl = store.baseProfileImageUrl {
                    ZStack(alignment: .bottomTrailing) {
                        KFImage(URL(string: imageUrl)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                        
                        Image.addProfile
                    }
                } else if let image = store.selectedImage {
                    ZStack(alignment: .bottomTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                        
                        Image.addProfile
                    }
                } else {
                    ZStack(alignment: .bottomTrailing) {
                        Image.editProfile
                        Image.addProfile
                    }
                }
            }
        }
    }
    
    func inputFieldsSection() -> some View {
        VStack(spacing: 0) {
            CustomTextFieldView(
                type: .changeNickname,
                text: $store.nickname,
                isFocused: $isNicknameFieldFocused,
                state: $store.nicknameState
            )
            .padding(.bottom, 36)
            
            CustomTextFieldView(
                type: .introduce,
                text: $store.introduce,
                isFocused: $isIntroductionFocused,
                state: $store.introduceState
            )
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(store: Store(initialState: EditProfileFeature.State(baseNickname: "", baseIntroduce: "", baseProfileImageUrl: nil)) {
                EditProfileFeature()
            }
        )
    }
}
