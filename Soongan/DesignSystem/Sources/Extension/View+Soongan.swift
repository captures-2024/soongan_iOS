//
//  View+Soongan.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/7/25.
//

import SwiftUI

public extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardOnTap())
    }
}

public extension View {
    /// FontStyle과 커스텀 행간을 적용합니다.
    /// - Parameters:
    ///   - style: 적용할 FontStyle (예: DesignSystemFont.semibold16)
    ///   - lineHeight: 적용할 행간 (옵션)
    @ViewBuilder
    func font(_ style: FontStyle, lineHeight: CGFloat? = nil) -> some View {
        if let lineHeight = lineHeight {
            self.modifier(
                FontWithLineHeight(font: style.uiFont, lineHeight: lineHeight)
            )
        } else {
            self.font(style.swiftUIFont)
        }
    }
    
    func scrollToMinDistance(minDistance: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAware(minDistance: minDistance))
    }
}
