//
//  PostPictureView.swift
//  PostPictureFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI
import PhotosUI

import DesignSystem
import Shared

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
        appearance.backgroundColor = UIColor(DesignSystem.Color.soonganBG)
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            DesignSystem.Color.soonganBG
                .ignoresSafeArea()
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
                    .font(DesignSystem.Font.bold18, lineHeight: 22)
                    .padding()
                    .frame(height: 46)
                    .tint(.black100)
                    .multilineTextAlignment(.center)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .shadow(
                                color: Color.black.opacity(0.25),
                                radius: 5, x: 0, y: 4)
                    )
                    .foregroundColor(.black100)
                    
                    Text("\(store.textCount)/15")
                        .font(DesignSystem.Font.regular8)
                        .foregroundColor(.black100)
                        .padding(.top, 8)
                        .padding(.trailing, 5)
                }
                .padding(.horizontal, 50)
                
                Spacer(minLength: 50)
                
                CustomBottomButton(
                    type: store.isEditMode ? .editComplete : .submit,
                    isEnable: $store.isButtonEnabled
                ) {
                    store.send(.postButtonTapped)
                }
                .padding(.horizontal, 136)
                .padding(.bottom, 95)
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
                CustomSheetView<NeverOption>(type: .postPicture(name: store.postPictureName)) {
                    store.send(.postButtonTappedInSheet)
                }
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
        .background(alertHostingView)
        .gesture(
            DragGesture()
                .onChanged { _ in }
        )
    }
    
    @ViewBuilder
    private var alertHostingView: some View {
        Color.clear.fullScreenCover(isPresented: $store.isAlertPresented) {
            if let type = store.alertPresentedType {
                switch type {
                case .backPostContest, .backEditContest:
                    CustomAlertView(
                        type: type,
                        leftButtonAction: {
                            store.send(.dismissAlertButtonTapped)
                        },
                        rightButtonAction: {
                            store.send(.dismissAlertButtonTapped)
                            store.send(.delegate(.backConfirmed))
                        }
                    )
                    .presentationBackground(.clear)
                    
                case .postContestError:
                    CustomAlertView(
                        type: type,
                        centerButtonAction: {
                            store.send(.dismissAlertButtonTapped)
                            store.send(.delegate(.backConfirmed))
                        }
                    )
                    .presentationBackground(.clear)
                    
                case .showLoginView:
                    CustomAlertView(
                        type: type,
                        centerButtonAction: {
                            store.send(.dismissAlertButtonTapped)
                            store.send(.delegate(.backConfirmed))
                        }
                    )
                    .presentationBackground(.clear)
                    
                default:
                    EmptyView()
                }
            }
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
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
                    .frame(width: 353)
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
                                
                                Text(store.isEditMode ? "이미지 변경" : "출품하기")
                                    .font(DesignSystem.Font.regular14)
                                    .foregroundStyle(Color.black100)
                            }
                        }
                    }
                    .onChange(of: store.selectedItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                store.selectedImage = uiImage
                                store.imageData = data
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
                .font(DesignSystem.Font.medium20)
            
            Text(weekTopic)
        }
        .font(DesignSystem.Font.bold20)
        .foregroundStyle(Color.black100)
    }
}

// MARK: - Preview

//#Preview {
//    PostPictureView(
//        store: Store(initialState:
//                        PostPictureFeature.State(weekTopic: "")) {
//                            PostPictureFeature()
//                        }
//    )
//}
