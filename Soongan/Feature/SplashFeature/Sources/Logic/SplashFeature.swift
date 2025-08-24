//
//  SplashFeature.swift
//  SplashFeature
//
//  Created by ParkJunHyuk on 8/24/25.
//

//import SwiftUI

import AppDependencies
import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct SplashFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var currentVersion: String?
        var isUpdateAlertPresented: Bool = false
        
        public init() {}
    }
    
    // MARK: - Init

    public init() {}
    
    // MARK: - Dependency
    
    @Dependency(\.appVersionClient) var appVersionClient
    @Dependency(\.continuousClock) var clock
    
    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case delayCompleted
        case appVersionResponse(String)
        
        case fetchRequiredVersion
        case requiredVersionResponse(Result<String, Error>)
        case setUpdateAlert(isPresented: Bool)
        case updateButtonTapped
        
        case delegate(Delegate)
        
        public enum Delegate {
            case versionCheckCompleted
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await self.clock.sleep(for: .seconds(1.5))
                    await send(.delayCompleted)
                }

            case .delayCompleted:
                return .run { send in
                    let version = self.appVersionClient.getCurrentVersion()
                    await send(.appVersionResponse(version))
                    await send(.fetchRequiredVersion)
                }
                
            case .appVersionResponse(let version):
                state.currentVersion = version
                return .none
                
            case .fetchRequiredVersion:
                return .run { send in
                    // TODO: 서버에서 최소 버전 가져오는 API 호출
                    await send(.requiredVersionResponse(.success("0.1.0")))
                }
                
            case .requiredVersionResponse(.success(let requiredVersion)):
                if let currentVersion = state.currentVersion, currentVersion.compare(requiredVersion, options: .numeric) == .orderedAscending {
                    state.isUpdateAlertPresented = true
                } else {
                    return .send(.delegate(.versionCheckCompleted))
                }
                return .none
                
            case .requiredVersionResponse(.failure):
                return .send(.delegate(.versionCheckCompleted))
                
            case .setUpdateAlert(let isPresented):
                state.isUpdateAlertPresented = isPresented
                return .none
                
            case .updateButtonTapped:
                print("앱 스토어로 이동")
                // TODO: App Store URL 열기
                state.isUpdateAlertPresented = false
                return .none
                
            case .binding:
                return .none
                
            case .delegate(_):
                return .none
            }
        }
    }
}
