//
//  CircleButtonType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

public enum CircleButtonType {
    case info
    case rightArrow
    
    var title: String {
        switch self {
        case .info:
            return "대회정보"
        case .rightArrow:
            return "참가작품"
        }
    }
    
    var image: Image {
        switch self {
        case .info:
            return .infoCircle
        case .rightArrow:
            return .rightArrow
        }
    }
    
    var size: (width: CGFloat, height: CGFloat) {
        switch self {
        case .info:
            return (width: 24, height: 24)
        case .rightArrow:
            return (width: 20, height: 16)
        }
    }
}
