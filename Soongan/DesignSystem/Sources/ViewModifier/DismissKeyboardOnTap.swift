//
//  DismissKeyboardOnTap.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/7/25.
//

import SwiftUI

import Shared

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        UIApplication.shared.dismissKeyboard()
                    }
            )
    }
}
