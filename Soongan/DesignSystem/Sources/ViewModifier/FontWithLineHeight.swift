//
//  FontWithLineHeight.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 7/23/25.
//

import SwiftUI

struct FontWithLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(Font(font))
            // 1. 목표 행간(lineHeight)과 폰트의 기본 행간(font.lineHeight)의 차이만큼 자간을 추가합니다.
            .lineSpacing(lineHeight - font.lineHeight)
            // 2. 추가된 자간의 절반만큼 상하 패딩을 주어 텍스트가 수직 중앙에 오도록 보정합니다.
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}
