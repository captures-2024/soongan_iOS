//
//  SplashView.swift
//  SplashFeature
//
//  Created by ParkJunHyuk on 8/23/25.
//

import SwiftUI

import DesignSystem

import ComposableArchitecture

public struct SplashView: View {
    
    @Bindable var store: StoreOf<SplashFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<SplashFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .topTrailing) {
                    HStack(alignment: .top, spacing: 0) {
                        Text("순")
                            .padding(.bottom, 58)
                        
                        Text("간")
                            .padding(.top, 58)
                            .padding(.leading, -9)
                    }
                    .font(DesignSystem.Font.title80, lineHeight: 112)
                    
                    Image.soonganLogo
                        .padding(.top, 18)
                        .padding(.trailing, 12)
                }
                .padding(.top, geometry.size.height * 0.251) // 214 / 852 ≈ 0.251
                
                Spacer()
                    .frame(height: geometry.size.height * 0.548) // 467 / 852 ≈ 0.548
            }
            .frame(maxWidth: .infinity) 
        }
        .onAppear {
            store.send(.onAppear)
        }
        .fullScreenCover(isPresented: $store.isUpdateAlertPresented) {
            CustomAlertView<AlertType>(
                type: .forceUpdate,
                centerButtonAction: {
                    store.send(.updateButtonTapped)
                }
            )
            .presentationBackground(.clear)
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
}

// MARK: - Preview

#Preview {
    SplashView(
        store: Store(initialState: SplashFeature.State()) {
            SplashFeature()
        }
    )
}
