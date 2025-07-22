//
//  CustomBottomButton.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/2/25.
//

import SwiftUI

import Resource

public struct CustomBottomButton: View {
    
    // MARK: - Property
    
    @Binding private var isEnable: Bool
    
    private let type: BottomButtonType
    private let action: () -> Void
    
    // MARK: - Init
    
    public init(
        type: BottomButtonType,
        isEnable: Binding<Bool>? = nil,
        action: @escaping () -> Void
    ) {
        self.type = type
        self._isEnable = isEnable ?? .constant(true)
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: action) {
            Text(type.title)
                .font(type.font)
                .foregroundStyle(
                    type == .report ?
                        (isEnable ? DesignSystem.Color.black100 : type.textColor) :
                        type.textColor
                )
                .frame(height: type.height)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isEnable ? type.backgroundColor : .disableButton)
                )
        }
        .disabled(!isEnable)
    }
}

// MARK: - Preview

#Preview {
    CustomBottomButton(type: .next, action: {})
        .padding(.horizontal, 40)
    
    CustomBottomButton(type: .next, isEnable: .constant(false), action: {})
        .padding(.horizontal, 40)
    
    CustomBottomButton(type: .comfirm, action: {})
        .padding(.horizontal, 20)
    
    CustomBottomButton(type: .complete, action: {})
        .padding(.horizontal, 20)
    
    CustomBottomButton(type: .logout, action: {})
        .padding(.horizontal, 20)
    
    CustomBottomButton(type: .report, action: {})
        .padding(.horizontal, 20)
    
    CustomBottomButton(type: .submit, action: {})
        .padding(.horizontal, 20)
}
