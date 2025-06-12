//
//  ContestDetailFeature.swift
//  ContestFeature
//
//  Created by ParkJunHyuk on 6/1/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct ContestDetailFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var contestTitle: String = "무제"
        var contestAuthor: String = "@dkddkq222"
        var isLiked: Bool = true
        var likeCount: Int = 0
        
        var isContestOptionSheetPresented: Bool = false
        
        var activeSheet: SheetContentType?
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case likeButtonTapped
        case optionButtonTapped
        case optionSheetIsPresented(ContestReportReasonType)
        case dismissOptionSheet(Bool)
        case dismissSheet
        
        case backButtonTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .optionSheetIsPresented(let tappedOption):
                state.isContestOptionSheetPresented = false
                
                switch tappedOption {
                case .inappropriateContent:
                    break
                    
                case .hateSpeech:
                    break
                    
                case .infringement:
                    break
                    
                case .spam:
                    state.activeSheet = .spam
                    
                case .promotion:
                    break
                    
                case .other:
                    break
                }
                
                return .none
                
            case .likeButtonTapped:
                return .none
                
            case .dismissOptionSheet:
                state.isContestOptionSheetPresented = false
                return .none
                
            case .dismissSheet:
                state.activeSheet = nil
                return .none
                
            case .optionButtonTapped:
                state.isContestOptionSheetPresented = true
                
                return .none
                
            default:
                return .none
            }
        }
    }
}
