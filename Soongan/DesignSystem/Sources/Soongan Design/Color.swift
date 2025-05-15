//
//  Color.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import Resource

public enum DesignSystem {
    public enum Color {
        public static let black100 = SwiftUI.Color(asset: ResourceAsset.Color.black100)
        public static let black80 = SwiftUI.Color(asset: ResourceAsset.Color.black80)
        public static let black60 = SwiftUI.Color(asset: ResourceAsset.Color.black60)
        public static let black40 = SwiftUI.Color(asset: ResourceAsset.Color.black40)
        public static let black20 = SwiftUI.Color(asset: ResourceAsset.Color.black20)
        public static let error = SwiftUI.Color(asset: ResourceAsset.Color.error)
        public static let primary = SwiftUI.Color(asset: ResourceAsset.Color.primary)
        public static let secondary = SwiftUI.Color(asset: ResourceAsset.Color.secondary)
        public static let backgroundGray = SwiftUI.Color(asset: ResourceAsset.Color.bgGray)
        public static let modalBackground = SwiftUI.Color(asset: ResourceAsset.Color.bgModal)
        public static let kakaoBackground = SwiftUI.Color(asset: ResourceAsset.Color.bgKakao)
        public static let loginBackground = SwiftUI.Color(asset: ResourceAsset.Color.bgLogin)
        public static let disableButton = SwiftUI.Color(asset: ResourceAsset.Color.disableButton)
        public static let textFieldBackground = SwiftUI.Color(asset: ResourceAsset.Color.bgField)
    }
}
