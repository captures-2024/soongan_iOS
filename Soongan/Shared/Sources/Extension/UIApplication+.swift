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

public struct InteractivePopGestureEnabler: UIViewControllerRepresentable {
    
    public init() {}
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            controller.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
