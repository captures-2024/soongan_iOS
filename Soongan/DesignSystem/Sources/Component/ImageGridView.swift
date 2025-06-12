//
//  ImageGridView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/30/25.
//

import SwiftUI

import Resource

public struct ImageGridView: View {

    let imageModels1 = [
        ContestImageModel(imageName: "dumy2", contestImage: ResourceAsset.Image.dumy2.swiftUIImage),
        ContestImageModel(imageName: "dumy1", contestImage: ResourceAsset.Image.dumy1.swiftUIImage),
        ContestImageModel(imageName: "dumy4", contestImage: ResourceAsset.Image.dumy4.swiftUIImage),
        ContestImageModel(imageName: "dumy3", contestImage: ResourceAsset.Image.dumy3.swiftUIImage),
        ContestImageModel(imageName: "dumy9", contestImage: ResourceAsset.Image.dumy2.swiftUIImage),
        ContestImageModel(imageName: "dumy10", contestImage: ResourceAsset.Image.dumy1.swiftUIImage),
        ContestImageModel(imageName: "dumy11", contestImage: ResourceAsset.Image.dumy4.swiftUIImage),
        ContestImageModel(imageName: "dumy12", contestImage: ResourceAsset.Image.dumy3.swiftUIImage)
    ]
    
    let imageModels2 = [
        ContestImageModel(imageName: "dumy7", contestImage: ResourceAsset.Image.dumy7.swiftUIImage),
        ContestImageModel(imageName: "dumy6", contestImage: ResourceAsset.Image.dumy6.swiftUIImage),
        ContestImageModel(imageName: "dumy5", contestImage: ResourceAsset.Image.dumy5.swiftUIImage),
        ContestImageModel(imageName: "dumy8", contestImage: ResourceAsset.Image.dumy8.swiftUIImage),
        ContestImageModel(imageName: "dumy13", contestImage: ResourceAsset.Image.dumy7.swiftUIImage),
        ContestImageModel(imageName: "dumy14", contestImage: ResourceAsset.Image.dumy6.swiftUIImage),
        ContestImageModel(imageName: "dumy15", contestImage: ResourceAsset.Image.dumy5.swiftUIImage),
        ContestImageModel(imageName: "dumy16", contestImage: ResourceAsset.Image.dumy8.swiftUIImage)
    ]
    
    let onImageTap: (ContestImageModel) -> Void // ✅ 콜백 추가
    
    @State private var showScrollToTopButton = false
    @State private var initialScrollOffset: CGFloat = 0
    @State private var hasSetInitialOffset: Bool = false
    @State private var scrollOffset: CGFloat = 0
    
    @State private var isImageLoading: Bool = false
    
    // MARK: - Init
    
    public init(
        onImageTap: @escaping (ContestImageModel) -> Void
    ) {
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
                            ForEach(imageModels1) { model in
                                model.contestImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onAppear {
                                        print("1열", model.imageName)
                                        isImageLoading = true
                                    }
                                    .onTapGesture {
                                        onImageTap(model) // ✅ 콜백 호출
                                    }
                            }
                        }
                        
                        LazyVStack(spacing: 8) {
                            ForEach(imageModels2) { model in
                                model.contestImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onAppear {
                                        print("2열", model.imageName)
                                        isImageLoading = true
                                    }
                                    .onTapGesture {
                                        onImageTap(model) // ✅ 콜백 호출
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

#Preview {
    ImageGridView(onImageTap: {_ in })
}

public struct ContestImageModel: Identifiable, Hashable {
    public let id = UUID()
    let imageName: String // 원본 이미지 이름 추가
    let contestImage: Image
    
    public init(imageName: String, contestImage: Image) {
        self.imageName = imageName
        self.contestImage = contestImage
    }
    
    public static func == (lhs: ContestImageModel, rhs: ContestImageModel) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
