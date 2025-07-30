//
//  CompleteExplainView.swift
//  ExplainFeature
//
//  Created by ParkJunHyuk on 7/24/25.
//

import SwiftUI

import DesignSystem
import Shared

struct CompleteExplainView: View {
    
    // MARK: - Body
    
    var body: some View {
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
                action: {}
            )
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview

#Preview {
    CompleteExplainView()
}
