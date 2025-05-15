//
//  SheetContentType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/15/25.
//

import SwiftUI

public enum SheetContentType {
    case contestInfo
    case postPicture(name: String)
    
    var title: String {
        switch self {
        case .contestInfo:
            return "대회정보"
        case .postPicture:
            return "제목확인"
        }
    }
    
    var height: Set<PresentationDetent> {
        switch self {
        case .contestInfo:
            return [.fraction(0.75)]
        case .postPicture:
            return [.fraction(0.31)]
        }
    }
}
