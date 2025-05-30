//
//  CustomTextFieldView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/2/25.
//

import SwiftUI

public struct CustomTextFieldView: View {
    
    // MARK: - Property Wrappers
    
    @State var textCount: Int = 0
    @Binding var state: TextFieldState
    @Binding var text: String
    
    // MARK: - Property
    
    private let type: TextFieldType
    private let isFocused: FocusState<Bool>.Binding
    
    // MARK: - Init
    
    public init(
        type: TextFieldType,
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        state: Binding<TextFieldState>
    ) {
        self.type = type
        self._text = text
        self.isFocused = isFocused
        self._state = state
    }
    
    // MARK: - Body
    
    public var body: some View {
        let backgroundShape = RoundedRectangle(cornerRadius: 8)
            .fill(Color.textFieldBackground)

        let strokeColor = (type == .birthday || type == .nickname)
            ? (isFocused.wrappedValue ? state.borderColor : .clear)
            : DesignSystem.Color.black100
        
        let titleFont: Font = (type == .birthday || type == .nickname) ? .regualr16 : .regualr8
        
        VStack(alignment: .leading, spacing: 0) {
            Text(type.title)
                .font(titleFont)
                .foregroundColor(.black100)
                .padding(.leading, 12)
                .padding(.bottom, 8)
            
            TextField("", text: $text, prompt: Text(type.placeholder).foregroundColor(.black60))
                .focused(isFocused)
                .font(.regualr18)
                .padding()
                .tint(.black100)
                .background(
                    backgroundShape
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(strokeColor, lineWidth: 1)
                        )
                )
                .foregroundColor(.black100)
                .overlay(
                    Group {
                        Button(action: {
                            
                        }) {
                            switch state {
                            case .normal:
                                Image.checkCircle
                                
                            case .possible:
                                Image.completeCheckCircle
                                
                            case .valid:
                                Image.checkCircle
                                
                            case .error:
                                Image.errorDeleteCircle
                            }
                        }
                        .padding(.trailing, 12)
                    },
                    alignment: .trailing
                )
            
            if isFocused.wrappedValue == true {
                HStack(spacing: 0) {
                    switch state {
                    case .error(let errorMessage):
                        Text(errorMessage.message)
                            .font(.medium12)
                            .foregroundColor(.error)
                        
                    case .normal, .valid, .possible:
                        Text(type.subTitle)
                            .font(.medium12)
                            .foregroundColor(.black60)
                    }
                    
                    Spacer()
                    
                    if type == .nickname {
                        Text("\(textCount)/10")
                            .font(.medium12)
                            .foregroundColor(.black60)
                            .padding(.trailing, 12)
                    }
                }
                .padding(.top, 12)
                .padding(.leading, 12)
                .onChange(of: text) {
                    textCount = text.count
                }
            }
        }
    }
}

//#Preview {
//    @State var name = ""
//    @FocusState var isFocused: Bool = true
//    
//    CustomTextFieldView(
//        title: "닉네임",
//        subtitle: "3-10자리 숫자, 영문, 한글로 기입해주세요",
//        placeholder: "사용자명을 입력해주세요.",
//        text: $name,
//        state: .normal
//    )
//}
