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
