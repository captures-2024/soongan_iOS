//
//  LoginView.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/2/25.
//

import SwiftUI

import DesignSystem

import ComposableArchitecture

public struct LoginView: View {
    
    @Bindable var store: StoreOf<LoginFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<LoginFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationStack (
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ZStack(alignment: .top) {
                Image.loginBackground
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .offset(x: -50)
                
                Rectangle()
                    .fill(Color.loginBackground)
                    .opacity(0.85)
                    .ignoresSafeArea()
                
                Image.soonganLogo
                    .padding(.top, 185)
                    .padding(.leading, 70)
                
                VStack {
                    HStack(alignment: .top, spacing: 0) {
                        Text("순")
                            .padding(.bottom, 58)
                        
                        Text("간")
                            .padding(.top, 58)
                            .padding(.leading, -9)
                    }
                    .font(DesignSystem.Font.title80, lineHeight: 112)
                    .padding(.top, 171)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        CustomSocialLoginButton(type: .apple) {
                            store.send(.appleButtonTapped)
                        }
                        
                        CustomSocialLoginButton(type: .kakao) {
                            store.send(.kakaoButtonTapped)
                        }
                        
                        HStack(spacing: 0) {
                            Text("계속하시면 ")
                            
                            Button(action: {
                                store.send(.termsOfUseButtonTapped)
                            }) {
                                Text("이용약관")
                                    .underline()
                            }
                            
                            Text(" 및 ")
                            
                            Button(action: {
                                store.send(.personalInformationButtonTapped)
                            }) {
                                Text("개인보호 정책")
                                    .underline()
                            }
                            
                            Text("에 동의하시게 됩니다.")
                        }
                        .font(DesignSystem.Font.medium12, lineHeight: 16)
                        .foregroundStyle(Color.black100)
                    }
                    
                    Button(action: {
                        store.send(.skippLoginButtonTapped)
                    }) {
                        Text("둘러보기")
                            .font(DesignSystem.Font.semibold14, lineHeight: 20)
                            .foregroundStyle(Color.black100)
                            .padding([.top, .bottom], 24)
                    }
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        } destination: { store in
            switch store.case {
            case .signup(let store):
                SignupView(store: store)
                
            case .signupSuccess(let store):
                SignupSuccessView(store: store)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LoginView(
        store: Store(initialState: LoginFeature.State()) {
            LoginFeature()
        }
    )
}
