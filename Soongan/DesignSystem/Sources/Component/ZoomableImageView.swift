//
//  ZoomableImageView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 9/9/25.
//

import SwiftUI

import Shared

import Kingfisher

public struct ZoomableImageView: View {
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var anchor: UnitPoint = .center
    @Environment(\.dismiss) var dismiss
    
    let url: String?
    
    public init(url: String?) {
        self.url = url
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    
                    if let url = url {
                        KFImage(URL(string: url))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scale, anchor: anchor)
                            .offset(offset)
                            .gesture(gestureHandler(geometry: geometry))
                            .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.8)
                    }
                }
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.leading, 5)
                }
                .padding()
                .opacity(scale > 1.0 ? 0 : 1.0)
                .animation(.easeInOut, value: scale)
            }
        }
    }
    
    // MARK: - Gesture Handler
    
    /// 통합 제스처 핸들러
    /// ExclusiveGesture를 사용하여 더블탭이 다른 제스처보다 우선순위를 갖도록 함
    ///
    /// 제스처 우선순위:
    /// 1. 더블탭 (TapGesture count: 2) - 최우선
    /// 2. 확대/축소 + 드래그 (SimultaneousGesture) - 동시 처리
    private func gestureHandler(geometry: GeometryProxy) -> some Gesture {
        ExclusiveGesture(
            // 1순위: 더블탭 제스처 - 확대 상태에서 원본으로 복원
            doubleTapGesture(),
            
            // 2순위: 확대/축소와 드래그를 동시에 처리
            SimultaneousGesture(
                magnifyGesture(geometry: geometry),
                dragGesture(geometry: geometry)
            )
        )
    }
    
    /// 더블탭 제스처 처리
    ///
    /// 동작:
    /// - 확대된 상태(scale > 1.0)에서만 작동
    /// - 모든 상태값을 초기값으로 복원 (scale, offset, anchor)
    /// - 0.3초 애니메이션과 함께 부드럽게 복원
    private func doubleTapGesture() -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                if scale > 1.0 {
                    // 확대된 상태에서 더블탭하면 원본으로 복원
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scale = 1.0
                        lastScale = 1.0
                        offset = .zero
                        lastOffset = .zero
                        anchor = .center
                    }
                }
            }
    }
    
    /// 확대/축소 제스처 처리 (핀치 투 줌)
    ///
    /// 동작 과정:
    /// 1. onChanged 첫 호출 시: 터치 위치를 anchor로 설정
    /// 2. onChanged 진행 중: 실시간으로 scale 업데이트 (최소 1.0 유지)
    /// 3. onEnded: 제스처 완료 후 최종 처리
    ///    - scale < 1.0: 자동으로 원본 크기로 복원
    ///    - scale >= 1.0: anchor를 center로 변경하고 적절한 offset 계산
    ///
    /// 핵심 기능:
    /// - 사용자가 터치한 위치(startLocation)를 기준으로 확대
    /// - anchor 시스템을 통해 터치 위치 중심 확대 구현
    /// - 제스처 완료 후 드래그 가능한 상태로 전환
    private func magnifyGesture(geometry: GeometryProxy) -> some Gesture {
        MagnifyGesture()
            .onChanged { value in
                // 제스처 시작 시점 감지: lastScale과 scale이 동일하면 새로운 제스처 시작
                if lastScale == scale {
                    let location = value.startLocation
                    
                    // 터치 위치를 UnitPoint로 변환하여 anchor 설정
                    // UnitPoint: (0,0) = 좌상단, (1,1) = 우하단
                    anchor = UnitPoint(
                        x: location.x / geometry.size.width,
                        y: location.y / (geometry.size.height * 0.8)  // 이미지 영역 높이 고려
                    )
                }
                
                // 실시간 배율 업데이트 (최소 1.0 유지)
                let newScale = lastScale * value.magnification
                self.scale = max(1.0, newScale)
            }
            .onEnded { value in
                // 최종 배율 계산 및 저장
                let newScale = lastScale * value.magnification
                self.lastScale = max(1.0, newScale)
                self.scale = self.lastScale
                
                if newScale < 1.0 {
                    // 축소로 인한 원본 크기 미만일 때 자동 복원
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scale = 1.0
                        lastScale = 1.0
                        offset = .zero
                        lastOffset = .zero
                        anchor = .center
                    }
                } else if scale > 1.0 {
                    // 확대 완료 후 드래그 가능한 상태로 전환
                    // anchor를 center로 변경하면서 이미지 위치 보정
                    let adjustmentOffset = calculateAnchorAdjustment(
                        anchor: anchor,
                        scale: scale,
                        geometry: geometry
                    )
                    
                    withAnimation(.easeInOut(duration: 0.2)) {
                        anchor = .center  // 드래그 시 center 기준으로 변경
                        offset = CGSize(
                            width: lastOffset.width + adjustmentOffset.width,
                            height: lastOffset.height + adjustmentOffset.height
                        )
                        // 경계 제한 적용 후 최종 저장
                        lastOffset = limitOffset(offset, geometry: geometry)
                        offset = lastOffset
                    }
                }
            }
    }
    
    /// 드래그 제스처 처리 (확대 상태에서 이미지 이동)
    ///
    /// 동작:
    /// - scale > 1.0 (확대 상태)에서만 활성화
    /// - 실시간으로 이미지 위치 업데이트
    /// - 화면 경계를 벗어나지 않도록 제한
    ///
    /// onChanged: 드래그 진행 중 실시간 위치 업데이트
    /// onEnded: 드래그 완료 후 최종 위치 저장 및 경계 제한 적용
    private func dragGesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if scale > 1.0 {
                    // 이전 오프셋 + 현재 드래그 변위 = 새로운 위치
                    let newOffset = CGSize(
                        width: lastOffset.width + value.translation.width,
                        height: lastOffset.height + value.translation.height
                    )
                    // 실시간으로 경계 제한 적용
                    self.offset = limitOffset(newOffset, geometry: geometry)
                }
            }
            .onEnded { value in
                if scale > 1.0 {
                    // 최종 위치 계산
                    let newOffset = CGSize(
                        width: lastOffset.width + value.translation.width,
                        height: lastOffset.height + value.translation.height
                    )
                    // 경계 제한 적용 후 다음 드래그의 기준점으로 저장
                    self.lastOffset = limitOffset(newOffset, geometry: geometry)
                    self.offset = self.lastOffset
                }
            }
    }
    
    // MARK: - Helper Functions
    
    /// 오프셋을 화면 경계 내에서 제한하는 함수
    private func limitOffset(_ offset: CGSize, geometry: GeometryProxy) -> CGSize {
        let maxHeight = geometry.size.height * 0.8
        let scaledWidth = geometry.size.width * scale
        let scaledHeight = maxHeight * scale
        
        let maxOffsetX = max(0, (scaledWidth - geometry.size.width) / 2)
        let maxOffsetY = max(0, (scaledHeight - maxHeight) / 2)
        
        let limitedX = max(-maxOffsetX, min(maxOffsetX, offset.width))
        let limitedY = max(-maxOffsetY, min(maxOffsetY, offset.height))
        
        return CGSize(width: limitedX, height: limitedY)
    }
    
    /// anchor 위치에서 center로 변경할 때의 offset 조정 계산
    private func calculateAnchorAdjustment(anchor: UnitPoint, scale: CGFloat, geometry: GeometryProxy) -> CGSize {
        let imageWidth = geometry.size.width
        let imageHeight = geometry.size.height * 0.8
        
        // anchor에서 center까지의 거리를 scale 배율로 계산
        let deltaX = (0.5 - anchor.x) * imageWidth * (scale - 1)
        let deltaY = (0.5 - anchor.y) * imageHeight * (scale - 1)
        
        return CGSize(width: deltaX, height: deltaY)
    }
}
