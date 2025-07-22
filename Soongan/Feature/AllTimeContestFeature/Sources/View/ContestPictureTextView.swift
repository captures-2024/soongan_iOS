//
//  ContestPictureTextView.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 7/21/25.
//

import SwiftUI

import DesignSystem
import Shared

struct ContestPictureTextView: View {
    
    // MARK: - Property
    
    let title: String
    
    // MARK: - Init
    
    public init(
        title: String
    ) {
        self.title = title
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(DesignSystem.Color.black100.opacity(0.5))
                .frame(width: 60, height: 20)
            
            Text(title)
                .font(.semibold11)
                .foregroundStyle(Color.white)
        }
    }
}

// MARK: - Preview

#Preview {
    ContestPictureTextView(title: "")
}
