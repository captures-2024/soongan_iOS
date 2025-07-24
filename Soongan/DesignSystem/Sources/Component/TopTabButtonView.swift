//
//  TopTabButtonView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/29/25.
//

import SwiftUI

public struct TopTabButtonView: View {
    
    // MARK: - Properties
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - Init
    
    public init(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Button(action: action) {
                Text(title)
                    .foregroundColor(isSelected ? DesignSystem.Color.black100 : .gray)
                    .font(isSelected ? DesignSystem.Font.bold12 : DesignSystem.Font.regular12)
            }
            .frame(width: 100, height: 24)
            .padding(.bottom, 12)
            
            if isSelected {
                Divider()
                    .frame(width: 100, height: 2)
                    .background(DesignSystem.Color.black100)
            }
        }
    }
}
