//
//  CompleteExplainView.swift
//  ExplainFeature
//
//  Created by ParkJunHyuk on 7/24/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

public struct CompleteExplainView: View {
    
    @Bindable var store: StoreOf<CompleteExplainFeature>
    
    public init(store: StoreOf<CompleteExplainFeature>) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            
            Text("소명절차가 완료됐습니다.")
                .font(DesignSystem.Font.regular16, lineHeight: 24)
            Text("운영진 검토 하에 추가 소명 요청이 있을 수 있습니다.\n")
                .font(DesignSystem.Font.regular16, lineHeight: 24)
            
            Text("추가 소명은 이메일로 진행합니다.")
                .font(DesignSystem.Font.regular16, lineHeight: 24)
            
            Spacer()
            
            CustomBottomButton(
                type: .comfirm,
                action: {
                    store.send(.bottomButtonTapped)
                }
            )
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 20)
        .background(DesignSystem.Color.soonganBG)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .gesture(
            DragGesture()
                .onChanged { _ in }
                .onEnded { _ in }
        )
        .interactiveDismissDisabled()
    }
}

// MARK: - Preview

#Preview {
    CompleteExplainView(store: Store(initialState: CompleteExplainFeature.State()) {
        CompleteExplainFeature()
    })
}
