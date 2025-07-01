//
//  PostPictureFeature.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI
import PhotosUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct PostPictureFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var round: Int = 0
        var textCount: Int = 0
        var weekTopic: String = "평화"
        var postPictureName: String = ""
        
        var selectedItem: PhotosPickerItem? = nil
        var selectedImage: UIImage? = nil
        
        var isUpdatePicture: Bool = false
        var isButtonEnabled: Bool = false
        var isPostSheetPresented: Bool = false
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case postButtonTapped
        case addPictureButtonTapped
        case dismissPostSheet(Bool)
        case backButtonTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.postPictureName), .binding(\.selectedImage):
                if state.postPictureName.count > 15 {
                    state.postPictureName = String(state.postPictureName.prefix(15))
                }
                
                state.textCount = state.postPictureName.count
                state.isButtonEnabled = (state.textCount > 0) && (state.selectedImage != nil)

                return .none
                
            case .onAppear:
                print("PostPicture Appear")
                return .none
            
            case .addPictureButtonTapped:
                
                return .none
                
            case .postButtonTapped:
                state.isPostSheetPresented = true
                return .none
            
            case .backButtonTapped:
                return .none
                
            case .binding(_):
                return .none
                
            case .dismissPostSheet(_):
                state.isPostSheetPresented = false
                return .none
            }
        }
    }
}
