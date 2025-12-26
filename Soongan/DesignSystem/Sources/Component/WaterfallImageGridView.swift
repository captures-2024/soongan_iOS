//
//  WaterfallImageGridView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 12/3/25.
//

import SwiftUI
import Shared

// MARK: - ScrollPositionState

struct ScrollPositionState: Equatable {
    let offsetY: CGFloat
    let reachedBottom: Bool
}

public struct WaterfallImageGridView: View {
    
    // MARK: - Properties
    
    let posts: [ContestImageModel]
    let hasMorePages: Bool
    let isLoading: Bool
    let isInitialLoading: Bool
    let onRefresh: (() -> Void)?
    let onLoadMore: (() -> Void)?
    let onImageTap: ((Int) -> Void)?
    let onScrollPositionChange: ((CGFloat) -> Void)?
    
    @State private var leftColumnPosts: [ContestImageModel] = []
    @State private var rightColumnPosts: [ContestImageModel] = []
    @State private var screenWidth: CGFloat = 0
    @State private var scrollPosition: ScrollPosition = ScrollPosition(idType: ContestImageModel.ID.self)
    @State private var isTopButtonVisible: Bool = false
    
    // MARK: - Init
    
    public init(
        posts: [ContestImageModel],
        hasMorePages: Bool,
        isLoading: Bool,
        isInitialLoading: Bool = true,
        onRefresh: (() -> Void)? = nil,
        onLoadMore: (() -> Void)? = nil,
        onImageTap: ((Int) -> Void)? = nil,
        onScrollPositionChange: ((CGFloat) -> Void)? = nil
    ) {
        self.posts = posts
        self.hasMorePages = hasMorePages
        self.isLoading = isLoading
        self.isInitialLoading = isInitialLoading
        self.onRefresh = onRefresh
        self.onLoadMore = onLoadMore
        self.onImageTap = onImageTap
        self.onScrollPositionChange = onScrollPositionChange
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                if isInitialLoading {
                    // 초기 로딩 스켈레톤 UI
                    HStack(alignment: .top, spacing: 7) {
                        // 왼쪽 스켈레톤 컬럼
                        VStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { _ in
                                SkeletonView()
                                    .frame(width: max(0, geometry.size.width / 2 - 13), height: 200)
                            }
                        }
                        
                        // 오른쪽 스켈레톤 컬럼
                        VStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { _ in
                                SkeletonView()
                                    .frame(width: max(0, geometry.size.width / 2 - 13), height: 250)
                            }
                        }
                    }
                    .padding(.horizontal, 9)
                    .transition(.opacity.animation(.easeInOut))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            HStack(alignment: .top, spacing: 7) {
                                // 왼쪽 컬럼
                                LazyVStack(spacing: 8) {
                                    ForEach(leftColumnPosts) { post in
                                        ContestImageView(
                                            model: post,
                                            onTapAction: { id in onImageTap?(id) }
                                        )
                                    }
                                }
                                
                                // 오른쪽 컬럼
                                LazyVStack(spacing: 8) {
                                    ForEach(rightColumnPosts) { post in
                                        ContestImageView(
                                            model: post,
                                            onTapAction: { id in onImageTap?(id) }
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 9)
                            
                            // 무한스크롤 로딩 인디케이터 & 트리거
                            if hasMorePages {
                                HStack {
                                    Spacer()
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .padding()
                                    } else {
                                        // 투명한 뷰로 스크롤 감지
                                        Color.clear
                                            .frame(height: 50)
                                            .onAppear {
                                                onLoadMore?()
                                            }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .refreshable {
                        onRefresh?()
                    }
                    .onAppear {
                        print("onAppear - posts 개수: \(posts.count)")
                        screenWidth = geometry.size.width
                        print("onAppear - screenWidth: \(screenWidth)")
                        if !posts.isEmpty && screenWidth > 0 {
                            print("onAppear에서 distributePosts 호출")
                            distributePosts(posts)
                        }
                    }
                    .onChange(of: geometry.size.width) { _, newWidth in
                        screenWidth = newWidth
                        print("현재 width:", screenWidth)
                        if !posts.isEmpty {
                            distributePosts(posts)
                        }
                    }
                    .onChange(of: posts) { _, newPosts in
                        print("onChange(posts) - 개수: \(newPosts.count), screenWidth: \(screenWidth)")
                        if screenWidth > 0 {
                            distributePosts(newPosts)
                        } else {
                            print("screenWidth가 0이라서 distributePosts 건너뜀")
                        }
                    }
                    .scrollPosition($scrollPosition, anchor: .bottom)
                    .onScrollGeometryChange(for: ScrollPositionState.self) { geometry in
                        let offsetY = geometry.bounds.origin.y
                        let reachedBottom = geometry.visibleRect.maxY >= geometry.contentSize.height + 100
                        return ScrollPositionState(offsetY: offsetY, reachedBottom: reachedBottom)
                    } action: { oldValue, newValue in
                        // 스크롤 위치를 외부로 전달
                        onScrollPositionChange?(newValue.offsetY)
                        
                        // 상단 버튼 표시 여부 결정
                        isTopButtonVisible = newValue.offsetY > 200
                    }
                    
                    // 상단 이동 버튼 (초기 로딩 중이 아닐 때만 표시)
                    if !isInitialLoading {
                        Button {
                            withAnimation(.easeInOut) {
                                scrollPosition.scrollTo(edge: .top)
                            }
                        } label: {
                            Image(systemName: "arrow.up")
                                .padding()
                                .background(Color.white)
                                .foregroundColor(DesignSystem.Color.black100)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                                .padding()
                        }
                        .opacity(isTopButtonVisible ? 1 : 0)
                        .allowsHitTesting(isTopButtonVisible)
                        .animation(.easeInOut, value: isTopButtonVisible)
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Waterfall 레이아웃을 위해 게시글을 좌우 두 컬럼에 균형있게 분배하는 메서드
    ///
    /// 동작 원리:
    /// 1. 각 이미지의 원본 비율을 이용해 화면에서 실제 표시될 높이를 계산
    /// 2. 좌우 컬럼의 누적 높이를 비교하여 더 낮은 쪽에 배치
    /// 3. 결과적으로 좌우 컬럼의 높이가 비슷하게 유지되어 균형잡힌 레이아웃 구현
    ///
    /// - Parameter posts: 분배할 게시글 배열
    private func distributePosts(_ posts: [ContestImageModel]) {
        // 좌우 컬럼의 누적 높이 추적 변수
        var leftHeight: CGFloat = 0
        var rightHeight: CGFloat = 0
        
        // 좌우 컬럼에 들어갈 게시글 배열
        var leftItems: [ContestImageModel] = []
        var rightItems: [ContestImageModel] = []
        
        let columnWidth = (screenWidth - 25) / 2
        
        // 모든 게시글을 순차적으로 처리
        for post in posts {
            // ratio는 width/height 비율
            // 실제 화면에서 표시될 이미지 높이 계산
            // - 현재 뷰의 폭에서 좌우 패딩(9*2) + 컬럼간격(7) = 25 제외
            // - 남은 폭을 2로 나누어 각 컬럼 폭 구하기
            // - 컬럼 폭을 ratio로 나누어서 실제 표시 높이 계산 (width/ratio = height)
            let imageHeight = columnWidth / CGFloat(post.ratio)
            
            // 현재 좌우 컬럼의 높이를 비교하여 더 낮은 쪽에 배치
            if leftHeight <= rightHeight {
                // 왼쪽이 더 낮거나 같으면 왼쪽에 추가
                leftItems.append(post)
                leftHeight += imageHeight + 8 // 이미지 높이 + 컬럼 내 간격
            } else {
                // 오른쪽이 더 낮으면 오른쪽에 추가
                rightItems.append(post)
                rightHeight += imageHeight + 8 // 이미지 높이 + 컬럼 내 간격
            }
        }
        
        // 계산 완료된 배열을 State에 적용하여 UI 업데이트 트리거
        leftColumnPosts = leftItems
        rightColumnPosts = rightItems
    }
}

//#Preview {
//    WaterfallImageGridView()
//}
