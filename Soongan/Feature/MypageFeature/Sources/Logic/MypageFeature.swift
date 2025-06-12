//
//  MypageFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/15/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct MypageFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum MypagePath {
        case editProfile(EditProfileFeature)
        case alarmList(AlarmListFeature)
        case questionsList(QuestionsListFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<MypagePath.State>()
        
        var drawInputText = ""
        var isOptionSheetPresented: Bool = false
        var shouldNavigateToEditProfile: Bool = false
        var shouldNavigateToQuestionsList: Bool = false
        
        var activeSheet: SheetContentType?
        
        // CustomTabBar 가시성
        public var isTabBarVisible: Bool {
            path.isEmpty
        }
        
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case path(StackActionOf<MypagePath>)
        
        case binding(BindingAction<State>)
        case alarmButtonTapped
        case optionButtonTapped
        case optionSheetIsPresented(MyprofileOptionType)
        case presentSheet(SheetContentType)
        case dismissOptionSheet(Bool)
        case dismissSheet
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .path(.element(id: _, action: action)):
                switch action {
                case .editProfile(.backButtonTapped), .alarmList(.backButtonTapped), .questionsList(.backButtonTapped):
                    state.path.removeLast()
                    return .none
                default:
                    return .none
                }
                
            case .binding(_):
                return .none
                
            case .alarmButtonTapped:
                state.path.append(.alarmList(AlarmListFeature.State()))
                return .none
                
            case .optionButtonTapped:
                state.isOptionSheetPresented = true
                return .none
                
//            case .presentSheet(let type):
//                state.activeSheet = type
//                return .none
                
            case .optionSheetIsPresented(let tappedOption):
                state.isOptionSheetPresented = false
                
                switch tappedOption {
                case .editMyProfile:
                    state.shouldNavigateToEditProfile = true

                case .pushAlarmSetting:
                    state.activeSheet = .alarmSetting
                    
                case .terms:
                    break
                    
                case .faq:
                    state.shouldNavigateToQuestionsList = true
                    
                case .withDraw:
                    state.activeSheet = .withdraw
                    
                case .logout:
                    state.activeSheet = .logout
                }
                
                return .none
                
            case .dismissOptionSheet(_):
                state.isOptionSheetPresented = false
                
                if state.shouldNavigateToEditProfile {
                    state.shouldNavigateToEditProfile = false
                    state.path.append(.editProfile(EditProfileFeature.State()))
                }
                
                if state.shouldNavigateToQuestionsList {
                    state.shouldNavigateToQuestionsList = false
                    state.path.append(.questionsList(QuestionsListFeature.State()))
                }
                
                
                return .none
                
            case .dismissSheet:
                state.activeSheet = nil
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
