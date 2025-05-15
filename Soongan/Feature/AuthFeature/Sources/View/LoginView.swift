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
                            .font(.title80)
                            .padding(.bottom, 58)
                        
                        Text("간")
                            .font(.title80)
                            .padding(.top, 58)
                            .padding(.leading, -9)
                    }
                    .padding(.top, 171)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        CustomSocialLoginButton(type: .apple) {
                            store.send(.appleButtonTapped)
                        }
                        
                        CustomSocialLoginButton(type: .kakao) {
                            store.send(.kakaoButtonTapped)
                        }
                        
                        Group {
                            Text("계속하시면 ") +
                            Text("이용약관").underline() +
                            Text(" 및 ") +
                            Text("개인보호 정책").underline() +
                            Text("에 동의하시게 됩니다.")
                        }
                        .font(.medium12)
                    }
                    
                    Button(action: {
                        store.send(.skippLoginButtonTapped)
                    }) {
                        Text("둘러보기")
                            .font(.semibold14)
                            .foregroundStyle(Color.black100)
                            .padding([.top, .bottom], 24)
                    }
                }
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
