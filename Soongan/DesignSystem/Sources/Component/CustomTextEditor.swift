//
//  CustomTextEditor.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 7/24/25.
//

import SwiftUI

public struct CustomTextEditor: View {
    
    let placeholder: String
    let characterLimit: Int
    
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool

    // MARK: - Init
    
    public init(
        text: Binding<String>,
        placeholder: String,
        characterLimit: Int,
        isFocused: FocusState<Bool>.Binding
    ) {
        self._text = text
        self.placeholder = placeholder
        self.characterLimit = characterLimit
        self._isFocused = isFocused
    }
    
    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(DesignSystem.Font.regular16, lineHeight: 20)
                .scrollContentBackground(.hidden)
                .background(DesignSystem.Color.soonganBG)
                .padding(10)
                .focused($isFocused)
                .onChange(of: text) { _, newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                    }
                }
                .padding(.bottom, 15)

            if text.isEmpty {
                Text(placeholder)
                    .font(DesignSystem.Font.regular16)
                    .foregroundColor(DesignSystem.Color.black60)
                    .padding(18)
                    .allowsHitTesting(false)
            }
            
            Text("\(text.count) / \(characterLimit)")
                .font(DesignSystem.Font.regular12)
                .foregroundColor(DesignSystem.Color.black100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 12)
                .padding(.bottom, 12)
                .allowsHitTesting(false)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(DesignSystem.Color.black100, lineWidth: 1)
        )
    }
}
