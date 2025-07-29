//
//  ExplainFeature.swift
//  ExplainFeature
//
//  Created by ParkJunHyuk on 7/24/25.
//

import SwiftUI

import CoreNetwork

import ComposableArchitecture

//WEEKLY_POST, DAILY_POST, COMMENT
enum ReportTargetType: String {
    case weeklyPost = "WEEKLY_POST"
    case dailyPost = "DAILY_POST"
    case comment = "COMMENT"
}

@Reducer
public struct ExplainFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var reportId: String
        var isButtonEnable: Bool = false
        var inputTextEditor: String = ""
        var textEditorPlaceHolder: String = "여기에 입력해주세요"
        
        public init(
            reportId: String
        ) {
            self.reportId = reportId
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case bottomButtonTapped
        
        case reportExplainSuccess
        case reportExplainfailure(NetworkError)
        case backButtonTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.inputTextEditor):
                state.isButtonEnable = !state.inputTextEditor.isEmpty
                return .none
                
            case .bottomButtonTapped:
                let dto = ReportExplainRequestDTO(targetId: 0, targetType: "", explain: state.inputTextEditor)
                return .run { send in
                    let result: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(ReportEndpoint.postReportExplain(dto))
                    
                    switch result {
                    case .success:
                        await send(.reportExplainSuccess)
                    case .failure(let error):
                        await send(.reportExplainfailure(error))
                    }
                }
                
            case .reportExplainSuccess:
                return .none
                
            case .reportExplainfailure(let error):
                return .none
                
            case .backButtonTapped:
                return .none
                
            case .binding(_):
                return .none
            }
        }
    }
}
