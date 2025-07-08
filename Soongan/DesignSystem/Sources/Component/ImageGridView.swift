//
//  ImageGridView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI

import Resource

import Kingfisher

public struct ImageGridView: View {
    
    private let leftImageList: [ContestImageModel]
    private let rightImageList: [ContestImageModel]
    private let onImageTap: (ContestImageModel) -> Void // ✅ 콜백 추가
    
    @State private var showScrollToTopButton = false
    @State private var initialScrollOffset: CGFloat = 0
    @State private var hasSetInitialOffset: Bool = false
    @State private var scrollOffset: CGFloat = 0
    
    @State private var isImageLoading: Bool = false
    
    // MARK: - Init
    
    public init(
        leftImageList: [ContestImageModel],
        rightImageList: [ContestImageModel],
        onImageTap: @escaping (ContestImageModel) -> Void
    ) {
        self.leftImageList = leftImageList
        self.rightImageList = rightImageList
        self.onImageTap = onImageTap
    }

    // MARK: - Body
    
    public var body: some View {
        ScrollViewReader { scrollProxy in
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    Color.clear
                        .frame(height: 0)
                        .id("TOP")
                    
                    HStack(alignment: .top) {
                        LazyVStack(spacing: 8) {
                            ForEach(leftImageList) { model in
                                KFImage(URL(string: model.imageUrl)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onTapGesture {
                                        onImageTap(model)
                                    }
                            }
                        }
                        
                        LazyVStack(spacing: 8) {
                            ForEach(rightImageList) { model in
                                KFImage(URL(string: model.imageUrl)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onTapGesture {
                                        onImageTap(model)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    GeometryReader { geometry in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geometry.frame(in: .named("scrollView")).minY
                            )
                    }
                    .frame(height: 0)
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                    
                    // 초기 오프셋 설정 (맨 위에 있을 때의 값)
                    if !hasSetInitialOffset && isImageLoading {
                        initialScrollOffset = value
                        hasSetInitialOffset = true
                        print("초기 오프셋 설정:", initialScrollOffset)
                    }
                    
                    print("스크롤 오프셋:", value)
                    
                    // 스크롤을 아래로 100포인트 이상 내렸을 때 버튼 표시
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showScrollToTopButton = initialScrollOffset - value > 100
                    }
                }

                if showScrollToTopButton {
                    Button {
                        withAnimation {
                            scrollProxy.scrollTo("TOP", anchor: .top)
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
                }
            }
        }
    }
    
    private struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

//#Preview {
//    ImageGridView(onImageTap: {_ in })
//}

public struct ContestImageModel: Identifiable, Hashable {
    public var id: String
    public let imageUrl: String
    public let nickname: String?
    
    public init(id: String, imageUrl: String, nickname: String? = nil) {
        self.id = id
        self.imageUrl = imageUrl
        self.nickname = nickname
    }
}
