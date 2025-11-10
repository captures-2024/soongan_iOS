//
//  NavigationCase.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 11/6/25.
//

import Foundation

public enum NavigationCase {
    case postImage(round: Int, weekTopic: String)
    case title(String)
    case backButton
    case signup
    
    var titleFont: FontStyle? {
        switch self {
        case .postImage:
            return DesignSystem.Font.bold20
        case .title:
            return DesignSystem.Font.bold16
        case .backButton:
            return nil
        case .signup:
            return DesignSystem.Font.medium24
        }
    }
}
