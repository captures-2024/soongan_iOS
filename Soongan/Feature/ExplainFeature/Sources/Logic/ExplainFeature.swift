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
    case unknown
    
    init(from string: String) {
        self = ReportTargetType(rawValue: string) ?? .unknown
    }
}

@Reducer
public struct ExplainFeature {
    
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        
        var reportId: Int
        var reportType: ReportTargetType
        var imageUrl: String?
        var contestTitle: String?
        var isButtonEnable: Bool = false
        var inputTextEditor: String = ""
        var textEditorPlaceHolder: String = "여기에 입력해주세요"
        
        var isFullSizeImageSheetPresented: Bool = false
        var isTextEditorFocused: Bool = false
        
        public init(
            reportId: Int,
            targetType: String
        ) {
            self.reportId = reportId
            self.reportType = ReportTargetType(from: targetType)
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case networkAction(NetworkAction)
        
        case onAppear
        case bottomButtonTapped
        case backButtonTapped
        case contestImageTapped
        case dismissFullSizeImageSheet(Bool)
        case textEditorFocusChanged(Bool)
        
        case delegate(Delegate)
    }
    
    public enum Delegate {
        case dismissExplain
        case backConfirmed
        case showCompleteExplain(CompleteExplainFeature.State)
    }
    
    public enum NetworkAction {
        case onAppearDetailContestSuccess(SearchDetailContestResponseDTO)
        case onAppearDetailContestFailure(NetworkError)
        case reportExplainSuccess
        case reportExplainfailure(NetworkError)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.inputTextEditor):
                state.isButtonEnable = !state.inputTextEditor.isEmpty
                return .none
                
            case .onAppear:
                let postId = state.reportId
                
                return .run { send in
                    let result: Result<SearchDetailContestResponseDTO,NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.getDetailContest(postId: postId))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.networkAction(.onAppearDetailContestSuccess(responseResult)))
                    case .failure(let error):
                        await send(.networkAction(.onAppearDetailContestFailure(error)))
                    }
                }
                
            case .networkAction(.onAppearDetailContestSuccess(let response)):
                state.imageUrl = response.imageUrl
                state.contestTitle = response.title
                return .none
                
            case .networkAction(.onAppearDetailContestFailure(let error)):
                // TODO: - Error 처리
                
                return .none
                
            case .bottomButtonTapped:
                let reportId = state.reportId
                let type = state.reportType.rawValue
                
                let dto = ReportExplainRequestDTO(targetId: reportId, targetType: type, explain: state.inputTextEditor)
                return .run { send in
                    let result: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(ReportEndpoint.postReportExplain(dto))
                    
                    switch result {
                    case .success:
                        await send(.networkAction(.reportExplainSuccess))
                    case .failure(let error):
                        await send(.networkAction(.reportExplainfailure(error)))
                    }
                }
                
            case .networkAction(.reportExplainSuccess):
                return .send(.delegate(.showCompleteExplain(CompleteExplainFeature.State())))
                
            case .networkAction(.reportExplainfailure(let error)):
                return .none
                
            case .backButtonTapped:
                return .send(.delegate(.backConfirmed))
                
            case .contestImageTapped:
                state.isFullSizeImageSheetPresented = true
                
                return .none
                
            case .dismissFullSizeImageSheet:
                state.isFullSizeImageSheetPresented = false
                
                return .none
                
            case .textEditorFocusChanged(let isFocused):
                state.isTextEditorFocused = isFocused
                
                return .none
                
            case .binding(_):
                return .none
                
            default:
                return .none
            }
        }
    }
}
