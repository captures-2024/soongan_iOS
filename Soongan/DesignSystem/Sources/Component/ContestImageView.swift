//
//  ContestImageView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 8/9/25.
//

import SwiftUI

import Shared

import Kingfisher

/// Contest, Mypage View 에 표시될 개별 이미지 뷰입니다.
/// 이미지를 비동기적으로 로드하고, 로드 성공 시 이미지의 비율에 맞는 높이를 계산하여 부모 뷰에 전달합니다.
public struct ContestImageView: View {
    
    // MARK: - Properties
    
    /// 이미지 뷰를 구성하는데 필요한 데이터 모델
    let model: ContestImageModel
    
    /// 이미지를 탭했을 때 호출될 클로저. 탭된 이미지의 `id`를 전달합니다.
    let onTapAction: (Int) -> Void
    
    // MARK: - Init
    
    public init(
        model: ContestImageModel,
        onTapAction: @escaping (Int) -> Void
    ) {
        self.model = model
        self.onTapAction = onTapAction
    }
    
    // MARK: - Body

    public var body: some View {
        KFImage(URL(string: model.imageUrl))
            .placeholder {
                SkeletonView()
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
                onTapAction(model.id)
            }
    }
}
