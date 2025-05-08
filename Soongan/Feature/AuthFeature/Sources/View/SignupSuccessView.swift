//
//  SingupSuccessView.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/7/25.
//

import SwiftUI

import DesignSystem

import ComposableArchitecture

public struct SignupSuccessView: View {
    
    public let store: StoreOf<SignupSuccessFeature>
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            Image.loginBackground
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .offset(x: -50)
            
            Rectangle()
                .fill(Color.black100)
                .opacity(0.84)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("환영합니다")
                    .padding(.bottom, 44)
                
                Text("\(store.nickname)님!")
            }
            .font(.semibold36)
            .foregroundStyle(Color.textFieldBackground)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview

#Preview {
    SignupSuccessView(
        store: Store(initialState: SignupSuccessFeature.State(nickname: "")) {
            SignupSuccessFeature()
        }
    )
}
