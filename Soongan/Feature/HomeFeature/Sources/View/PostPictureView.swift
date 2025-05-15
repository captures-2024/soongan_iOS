//
//  PostPictureView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI
import PhotosUI

import DesignSystem

import ComposableArchitecture

public struct PostPictureView: View {

    @Bindable var store: StoreOf<PostPictureFeature>
    @FocusState private var isFocused: Bool
    
    // MARK: - Init
    
    public init(
        store: StoreOf<PostPictureFeature>
    ) {
        self.store = store
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    // MARK: - Body
    
    public var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.dismissKeyboard()
                }
            
            VStack(spacing: 0) {
                postPictureSection()
                    .padding(.bottom, 36)
                
                VStack(alignment: .trailing, spacing: 0) {
                    TextField("", text: $store.postPictureName,
                              prompt: Text("제목을 입력해주세요.").foregroundColor(Color.init(red: 187/255, green: 187/255, blue: 187/255)))
                        .focused($isFocused)
                        .font(.bold18)
                        .padding()
                        .frame(height: 46)
                        .tint(.black100)
                        .multilineTextAlignment(.center)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(
                                    color: Color.black.opacity(0.25),
                                    radius: 5, x: 0, y: 4)
                        )
                        .foregroundColor(.black100)
                    
                    Text("\(store.textCount)/15")
                        .font(.regualr8)
                        .foregroundColor(.black100)
                        .padding(.top, 8)
                        .padding(.trailing, 5)
                }
                .padding(.horizontal, 50)
                
                Spacer(minLength: 50)
                
                CustomBottomButton(type: .submit, isEnable: $store.isButtonEnabled) {
                    store.send(.postButtonTapped)
                }
                .padding(.horizontal, 136)
                
                Text("부적절한 사진은 삭제될 수 있습니다.")
                    .font(.regualr12)
                    .foregroundColor(.black100)
                    .padding(.top, 12)
                    .padding(.bottom, 68)
            }
            .padding(.top, 50)
            .frame(maxHeight: .infinity, alignment: .top)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(
                isPresented: $store.isPostSheetPresented.sending(\.dismissPostSheet)
            ) {
                CustomSheetView(type: .postPicture(name: store.postPictureName))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.send(.backButtonTapped)
                    } label: {
                        Image.arrowBack
                            .padding(.trailing, 5)
                    }
                    .padding(.top, 26)
                    .padding(.bottom, 10)
                }
                
                ToolbarItem(placement: .principal) {
                    navigationTitle(round: store.round, weekTopic: store.weekTopic)
                        .padding(.top, 26)
                        .padding(.bottom, 10)
                }
            }
        }
    }
}

// MARK: - Private Extension View

private extension PostPictureView {
    func postPictureSection() -> some View {
        VStack {
            if let image = store.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 353)//, height: 353)
                    .shadow(
                        color: Color.black.opacity(0.25),
                        radius: 5, x: 0, y: 4)
            } else {
                PhotosPicker(
                    selection: $store.selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 353, height: 353)
                                .shadow(
                                    color: Color.black.opacity(0.25),
                                    radius: 5, x: 0, y: 4)
                            
                            VStack(spacing: 16) {
                                Image.addPlus
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                Text("출품하기")
                                    .font(.regualr14)
                                    .foregroundStyle(Color.black100)
                            }
                        }
                    }
                    .onChange(of: store.selectedItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                store.selectedImage = uiImage
                            } else {
                                // 실패 처리
                            }
                        }
                    }
            }
        }
    }
    
    func navigationTitle(round: Int, weekTopic: String) -> some View {
        HStack(spacing: 8) {
            Text("\(round)회차")
            
            Text("|")
            
            Text(weekTopic)
        }
        .font(.bold20)
        .foregroundStyle(Color.black100)
    }
}

// MARK: - Preview

#Preview {
    PostPictureView(
        store: Store(initialState:
            PostPictureFeature.State()) {
                PostPictureFeature()
            }
    )
}
