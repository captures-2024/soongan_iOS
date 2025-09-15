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
    
    /// 이미지 뷰를 구성하는데 필요한 데이터 모델 (`id`, `imageUrl`, `height`)
    let model: ContestImageModel
    
    /// 부모 뷰의 크기 정보를 제공하는 `GeometryProxy`
    let geometry: GeometryProxy
    
    /// 이미지 로드 성공 시 호출될 클로저. 이미지의 `id`와 계산된 `height`를 전달합니다.
    let onSuccessAction: (Int, CGFloat) -> Void
    
    /// 이미지를 탭했을 때 호출될 클로저. 탭된 이미지의 `id`를 전달합니다.
    let onTapAction: (Int) -> Void
    
    // MARK: - Init
    
    public init(
        model: ContestImageModel,
        geometry: GeometryProxy,
        onSuccessAction: @escaping (Int, CGFloat) -> Void,
        onTapAction: @escaping (Int) -> Void
    ) {
        self.model = model
        self.geometry = geometry
        self.onSuccessAction = onSuccessAction
        self.onTapAction = onTapAction
    }
    
    // MARK: - Body

    public var body: some View {
        KFImage(URL(string: model.imageUrl))
            .placeholder {
                SkeletonView()
            }
            .onSuccess { result in
                // 원본 이미지의 사이즈와 비율을 가져옴
                let size = result.image.size
                let ratio = size.height / size.width
                
                // 화면의 절반 너비를 기준으로 이미지의 너비를 계산 (양쪽 패딩 24 고려)
                let width = (geometry.size.width - 24) / 2
                
                // 계산된 너비와 원본 이미지 비율을 사용하여 최종 높이를 계산
                let calculatedHeight = CGFloat(width) * ratio
                
                // 모델의 높이 값이 아직 설정되지 않은 경우에만 높이 업데이트 액션을 호출
                // (이미 높이가 계산된 경우 중복 호출 방지)
                if model.height == nil {
                    onSuccessAction(model.id, calculatedHeight)
                }
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: (geometry.size.width - 24) / 2, height: model.height)
            .onTapGesture {
                onTapAction(model.id)
            }
    }
}
