//
//  ContestDetailFeature.swift
//  DetailContestFeature
//
//  Created by ParkJunHyuk on 6/1/25.
//

import SwiftUI

import AppDependencies
import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct ContestDetailFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.appStorage("AuthState")) var authState: AuthType = .loggedOut
        
        var postId: Int
        var postRound: Int?
        var postUserId: Int?
        var myNickname: String?
        var weekTopic: String
        
        var contestTitle: String?
        var imageUrl: String?
        var contestAuthor: String?
        var isLiked: Bool?
        var likeCount: String?
        var isTop7: Bool?
        
        var reportReason: String?
        
        var isDeleteAlertPresented: Bool = false
        var isDeleteCompleteAlertPresented: Bool = false
        var isContestOptionSheetPresented: Bool = false
        var isReportOptionSheetPresented: Bool = false
        var isFullSizeImageSheetPresented: Bool = false
        var isReportInputReasonSheetPresented: Bool = false
        var isLoginAlertPresented: Bool = false
        
        var activeSheet: SheetContentType?
        var reportReasonSheet: SheetContentType?
        var completeReportSheet: SheetContentType?
        
        var alertSheet: AlertType?
        
        var pendingSheetAction: DetailContestOptionType? = nil
        
        var isWriter: Bool {
            return myNickname == contestAuthor
        }
        
        public init (
            postId: Int,
            weekTopic: String
        ) {
            self.postId = postId
            self.weekTopic = weekTopic
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Dependency
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case alertAction(AlertAction)
        case networkAction(NetworkAction)
        case uiAction(UIAction)
        case sheetAction(SheetAction)
        
        case onAppear

        case deleteButtonTapped
        case optionSheetIsPresented(ContestReportReasonType)
        case completeReportSheetIsPresented(ContestReportReasonType)
        case dismissOptionSheet(Bool)
        case dismissReportOptionSheet(Bool)
        case dismissFullSizeImageSheet(Bool)
        case dismissReportIntputReasonSheet(Bool)
        case dismissSheet(Bool)
        case userDataLoaded(String?)
        
        case backButtonTapped
        
        case deleteActionResult(Bool)
        case deleteCompletedButtonTapped
        case presentDeleteAlert
        
        case delegate(DelegateAction)

        public enum DelegateAction {
            case backConfirmed
            case didRequestLogout
            case editRequested(contestId: Int, round: Int, title: String, imageURL: String, weekTopic: String)
            case reportCompleted(postId: Int)
        }
    }
    
    public enum AlertAction {
        case notAuthUserAlert
        case presentLoginAlert
        case dismissAlertButtonTapped
        case dismissLoginAlert
        case dismissAlert
        
        case presentEditTop7Alert
        case presentDeleteTop7Alert
    }
    
    public enum SheetAction {
        case optionSheetDismissed
        
        case reportReasonButtonTapped(type: ContestReportReasonType, reason: String)
        case editButtonTapped
        case deleteOptionButtonTapped
        case reportSheetIsPresented
        case completeReportButtonTapped
    }
    
    public enum NetworkAction {
        case onAppearDetailContestSuccess(SearchDetailContestResponseDTO)
        case onAppearDetailContestFailure(NetworkError)
        case fetchLikeContest
        case likeContestSuccess(isLike: Bool, PostLikeResponseDTO)
        case likeContestFailure(NetworkError)
        case postReport(type: ContestReportReasonType)
        case reportSuccess(ReportResponseDTO, ContestReportReasonType)
    }
    
    public enum UIAction {
        case likeButtonTapped
        case optionButtonTapped
        case contestImageTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                let postId = state.postId
                
                return .run { send in
                    async let loadedNickname = userDefaultsClient.getString(forKey: UserDefaultKeys.User.username.rawValue)

                    async let postResult: Result<SearchDetailContestResponseDTO,NetworkError> = NetworkManager.shared.request(WeeklyContestEndpoint.getDetailContest(postId: postId))
                    
                    let (myNicknameResult, contestResult) = await (loadedNickname, postResult)
                    
                    await send(.userDataLoaded(myNicknameResult))
                    
                    switch contestResult {
                    case .success(let responseResult):
                        await send(.networkAction(.onAppearDetailContestSuccess(responseResult)))
                    case .failure(let error):
                        await send(.networkAction(.onAppearDetailContestFailure(error)))
                    }
                }
                
            case .networkAction(.onAppearDetailContestSuccess(let response)):
                state.postUserId = response.authorMemberId
                state.postRound = response.weeklyContestRound
                state.weekTopic = response.weeklyContestSubject
                state.isTop7 = response.isTop7
                state.contestTitle = response.title
                state.contestAuthor = response.nickname
                state.imageUrl = response.imageUrl
                state.isLiked = response.isLiked
                state.likeCount = formatLikeCount(response.likeCount)
                
                return .none
                
            case .networkAction(.onAppearDetailContestFailure(let error)):
                // TODO: - Error 처리
                
                return .none
                
            case .optionSheetIsPresented(let tappedOption):
                state.isReportOptionSheetPresented = false
                
                switch tappedOption {
                case .inappropriateContent:
                    state.activeSheet = .inappropriateContent
                    
                case .hateSpeech:
                    state.activeSheet = .hateSpeech
                    
                case .infringement:
                    state.reportReasonSheet = .infringement(inputState: false)
                    
                case .spam:
                    state.activeSheet = .spam
                    
                case .promotion:
                    state.activeSheet = .promotion
                    
                case .other:
                    state.reportReasonSheet = .other(inputState: false)
                }
                
                return .none
                
            case .sheetAction(.optionSheetDismissed):
                guard let action = state.pendingSheetAction else { return .none }
                state.pendingSheetAction = nil
                
                switch action {
                case .edit:
                    guard let title = state.contestTitle,
                          let imageURL = state.imageUrl,
                          let round = state.postRound else { return .none }
                    
                    return .run { [contestId = state.postId, weekTopic = state.weekTopic] send in
                        await send(.delegate(.editRequested(
                            contestId: contestId,
                            round: round,
                            title: title,
                            imageURL: imageURL,
                            weekTopic: weekTopic
                        )))
                    }
                    
                case .delete:
                    return .send(.presentDeleteAlert)
                    
                case .report:
                    state.isReportOptionSheetPresented = true
                    return .none
                }
                
            case .completeReportSheetIsPresented(let type):
                state.completeReportSheet = .reportComplete(type: type)
                
                return .none
                
            case .uiAction(.likeButtonTapped):
                if state.authState == .skipped {
                    return .send(.alertAction(.presentLoginAlert))
                }
                    
                return .send(.networkAction(.fetchLikeContest))
                
            case .networkAction(.fetchLikeContest):
                let dto = PostLikeRequestDTO(postId: state.postId, contestType: "WEEKLY")
                
                let isLiked = state.isLiked ?? false
                
                return .run { send in
                    let result: Result<PostLikeResponseDTO, NetworkError> = await NetworkManager.shared.request(isLiked ? PostLikeEndpoint.deletePostLike(dto) : PostLikeEndpoint.putPostLike(dto))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.networkAction(.likeContestSuccess(isLike: isLiked, responseResult)))
                    case .failure(let error):
                        await send(.networkAction(.likeContestFailure(error)))
                    }
                }
            
            case .networkAction(.likeContestSuccess(let isLike, let response)):
                state.likeCount = formatLikeCount(response.likeCount)
                state.isLiked = !isLike
                
                return .none
            
            case .networkAction(.likeContestFailure(let error)):
                // TODO: - 좋아요 에러
                return .none
              
            /// 게시글 옵션 Sheet 에서 수정하기 버튼을 눌렀을때
            case .sheetAction(.editButtonTapped):
                guard let isTop7 = state.isTop7 else { return .none }
                
                state.isContestOptionSheetPresented = false
                
                if isTop7 {
                    return .run { send in
                        try await Task.sleep(nanoseconds: 300_000_000)
                        await send(.alertAction(.presentEditTop7Alert))
                    }
                } else {
                    state.pendingSheetAction = .edit
                    return .none
                }
            
            /// 게시글 옵션 Sheet 에서 삭제하기 버튼을 눌렀을때
            case .sheetAction(.deleteOptionButtonTapped):
                guard let isTop7 = state.isTop7 else { return .none }
                
                state.isContestOptionSheetPresented = false
                
                if isTop7 {
                    return .run { send in
                        try await Task.sleep(nanoseconds: 300_000_000)
                        await send(.alertAction(.presentDeleteTop7Alert))
                    }
                } else {
                    state.pendingSheetAction = .delete
                    return .none
                }
                
            /// 게시글 옵션 Sheet 에서 신고하기 버튼을 눌렀을때
            case .sheetAction(.reportSheetIsPresented):
                state.pendingSheetAction = .report
                state.isContestOptionSheetPresented = false
                
                return .none
                
            case .deleteButtonTapped:
                state.alertSheet = nil

                let postId = state.postId
                return .run { send in
                    let result: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(WeeklyContestEndpoint.deleteContest(postId: postId))
                    
                    switch result {
                    case .success:
                        try await Task.sleep(nanoseconds: 500_000_000)
                        await send(.deleteActionResult(true))
                    case .failure(let error):
                        print(error)
                        await send(.deleteActionResult(false))
                    }
                }
                
            case .deleteActionResult(let result):
                if result {
                    state.alertSheet = .deletePostComplete
                    return .none
                } else {
                    return .none
                }
                
            case .presentDeleteAlert:
                state.alertSheet = .deletePost
                return .none
            
            case .deleteCompletedButtonTapped:
                state.alertSheet = nil
                
                return .run { send in
                    try await Task.sleep(nanoseconds: 300_000_000)
                    await send(.delegate(.backConfirmed))
                }
            
            case .dismissOptionSheet:
                state.isContestOptionSheetPresented = false
                return .none
                
            case .dismissReportOptionSheet:
                state.isReportOptionSheetPresented = false
                return .none
                
            case .dismissSheet:
                state.activeSheet = nil
                return .none
            
            case .uiAction(.contestImageTapped):
                state.isFullSizeImageSheetPresented = true
                
                return .none
                
            case .dismissFullSizeImageSheet:
                state.isFullSizeImageSheetPresented = false
                
                return .none
                
            case .dismissReportIntputReasonSheet:
                state.isReportInputReasonSheetPresented = false
                
                return .none
                
            case .uiAction(.optionButtonTapped):
                state.isContestOptionSheetPresented = true
                
                return .none
                
            case .userDataLoaded(let nickname):
                state.myNickname = nickname
                return .none
                
            case .backButtonTapped:
                return .send(.delegate(.backConfirmed))
                
            case .networkAction(.postReport(let type)):
                let dto = ReportRequestDTO(
                    targetId: state.postId,
                    targetType: "WEEKLY_POST",
                    reportType: type.typeTitle,
                    reason: state.reportReason
                )
                
                return .run { send in
                    let result: Result<ReportResponseDTO, NetworkError> = await NetworkManager.shared.request(ReportEndpoint.postReport(dto))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.networkAction(.reportSuccess(responseResult, type)))
                    case .failure(let error):
                        break
                    }
                }
                
            case .networkAction(.reportSuccess(let response, let type)):
                state.reportReason = nil
                return .send(.completeReportSheetIsPresented(type))
                
            case .sheetAction(.reportReasonButtonTapped(let type, let reason)):
                state.reportReason = reason

                switch type {
                  case .other:
                      state.activeSheet = .other(inputState: true)
                  case .infringement:
                      state.activeSheet = .infringement(inputState: true)
                  default:
                      break
                  }
                
                return .none
            
            case .sheetAction(.completeReportButtonTapped):
                state.completeReportSheet = nil
                return .none
                
            case .alertAction(.presentEditTop7Alert):
                state.alertSheet = .editContainPostToTop7
                return .none
                
            case .alertAction(.presentDeleteTop7Alert):
                state.alertSheet = .deleteContainPostToTop7
                return .none
                
            case .alertAction(.notAuthUserAlert):
                state.isContestOptionSheetPresented = false

                return .run { send in
                    try await Task.sleep(nanoseconds: 100_000_000)
                    await send(.alertAction(.presentLoginAlert))
                }
                
            case .alertAction(.presentLoginAlert):
                state.isLoginAlertPresented = true
                return .none
            
            case .alertAction(.dismissAlertButtonTapped):
                state.isLoginAlertPresented = false
                return .send(.delegate(.didRequestLogout))
                
            case .alertAction(.dismissLoginAlert):
                state.isLoginAlertPresented = false
                return .none
            
            case .alertAction(.dismissAlert):
                state.alertSheet = nil
                state.pendingSheetAction = nil
                return .none
                
            default:
                return .none
            }
        }
    }
}

private extension ContestDetailFeature {
    func formatLikeCount(_ count: Int) -> String {
        let thousand = 1_000
        let million = 1_000_000

        switch count {
        case 0..<thousand:
            return "\(count)"
        case thousand..<million:
            let formatted = Double(count) / Double(thousand)
            return String(format: formatted.truncatingRemainder(dividingBy: 1) == 0 ? "%.0fk" : "%.2fk", formatted)
        default:
            let formatted = Double(count) / Double(million)
            return String(format: formatted.truncatingRemainder(dividingBy: 1) == 0 ? "%.0fm" : "%.2fm", formatted)
        }
    }
}
