//
//  CircleButton.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

public struct CircleButton: View {
    
    // MARK: - Property
    
    private let type: CircleButtonType
    private let action: () -> Void
    
    // MARK: - Init
    
    public init(
        type: CircleButtonType,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                action()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 44, height: 44)
                    
                    type.image
//                        .resizable()
                        .frame(width: type.size.width, height: type.size.height)
                }
            }
            
            Text(type.title)
                .font(.regular12)
                .foregroundStyle(Color.black100)
        }
    }
}

// MARK: - Preview

#Preview {
    CircleButton(type: .rightArrow, action: {})
}
