//
//  KeyboardAware.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 7/29/25.
//

import SwiftUI

struct KeyboardAware: ViewModifier {
    var minDistance: CGFloat
    @ObservedObject private var keyboard = KeyboardInfo.shared
    
    func body(content: Content) -> some View {
        content
            .safeAreaPadding(.bottom, keyboard.height > 0 ? minDistance : 0)
    }
}

public class KeyboardInfo: ObservableObject {
    public static var shared = KeyboardInfo()
    
    @Published public var height: CGFloat = 0
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardChanged(notification: Notification) {
        if notification.name == UIApplication.keyboardWillHideNotification {
            self.height = 0
        } else {
            self.height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
        }
    }
}
