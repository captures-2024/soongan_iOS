//
//  Font.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 7/22/25.
//

import SwiftUI
import Resource

public struct FontStyle {
    let name: String
    let size: CGFloat
    
    // SwiftUI Font를 생성하는 헬퍼
    public var swiftUIFont: Font {
        return Font.custom(name, size: size)
    }
    
    // UIFont를 생성하는 헬퍼
    public var uiFont: UIFont {
        // 이 부분은 FontLoader를 통해 폰트가 미리 등록되어 있어야 정상 동작합니다.
        guard let font = UIFont(name: name, size: size) else {
            fatalError("🚨 폰트를 로드할 수 없습니다: \(name)")
        }
        return font
    }
}

public extension DesignSystem {
    enum Font {
        // MARK: - Bold
        public static var bold12: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 12) }
        public static var bold16: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 16) }
        public static var bold18: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 18) }
        public static var bold20: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 20) }
        public static var bold24: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 24) }
        public static var bold42: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 42) }
        
        // MARK: - SemiBold
        public static var semibold11: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.semiBold.name, size: 11) }
        public static var semibold12: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.semiBold.name, size: 12) }
        public static var semibold14: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.semiBold.name, size: 14) }
        public static var semibold16: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.semiBold.name, size: 16) }
        public static var semibold18: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.semiBold.name, size: 18) }
        public static var semibold20: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.semiBold.name, size: 20) }
        public static var semibold36: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.semiBold.name, size: 36) }
        
        // MARK: - Medium
        public static var title80: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.medium.name, size: 80) }
        public static var medium12: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.medium.name, size: 12) }
        public static var medium14: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.medium.name, size: 14) }
        public static var medium16: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.medium.name, size: 16) }
        public static var medium20: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.medium.name, size: 20) }
        public static var medium24: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.medium.name, size: 24) }
        
        // MARK: - Regular
        public static var regular8: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 8) }
        public static var regular12: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 12) }
        public static var regular14: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 14) }
        public static var regular15: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 15) }
        public static var regular16: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 16) }
        public static var regular18: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 18) }

        // MARK: - Headline (Bold)
        public static var headline24: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 24) }
        public static var headline18: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 18) }
        public static var headline16: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 16) }
        
        // MARK: - SubTitle (Bold)
        public static var subTitle15: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 15) }
        public static var subTitle14: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 14) }
        public static var subTitle13: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.bold.name, size: 13) }
        
        // MARK: - Body (Regular)
        public static var body15: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 15) }
        public static var body14: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 14) }
        
        // MARK: - Info (Regular)
        public static var info15: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 15) }
        public static var info14: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 14) }
        public static var info13: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 13) }
        public static var info12: FontStyle { FontStyle(name: ResourceFontFamily.Pretendard.regular.name, size: 12) }
    }
}
