//
//  HomeFeature.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct HomeFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum HomePath {
        case postPicture(PostPictureFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<HomePath.State>()
        var weekTopic: String = ""
        var startPeriod: String = ""
        var endPeriod: String = ""
        var isInfoSheetPresented: Bool = false
        
        // CustomTabBar 가시성
        public var isTabBarVisible: Bool {
            path.isEmpty
        }
        
        public init(
            weekTopic: String,
            startPeriod: String,
            endPeriod: String
        ) {
            self.weekTopic = weekTopic
            self.startPeriod = startPeriod
            self.endPeriod = endPeriod
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action {
        case path(StackActionOf<HomePath>)
        
        case onAppear
        case addPictureButtonTapped
        case infoButtonTapped
        case dismissInfoSheet(Bool)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print("Home Appear")
                return .none
                
            case .addPictureButtonTapped:
                state.path.append(.postPicture(PostPictureFeature.State()))
                
                return .none
                
            case .infoButtonTapped:
                state.isInfoSheetPresented = true
                return .none
                
            case .dismissInfoSheet(let isPresented):
                state.isInfoSheetPresented = isPresented
                return .none
                
            case .path(.popFrom(id: let id)):
                print("Popping from path, id: \(id), isTabBarVisible: \(state.isTabBarVisible)")
                return .none
                
            case .path(.element(id: _, action: .postPicture(.backButtonTapped))):
                state.path.removeLast()
                
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
