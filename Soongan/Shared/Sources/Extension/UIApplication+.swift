//
//  UIApplication+.swift
//  Shared
//
//  Created by ParkJunHyuk on 5/7/25.
//

import SwiftUI

public extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
