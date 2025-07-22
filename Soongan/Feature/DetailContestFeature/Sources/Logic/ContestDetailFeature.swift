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
        var postId: String
        var userId: Int?
        var myNickname: String?
        
        var contestTitle: String?
        var imageUrl: String?
        var contestAuthor: String?
        var isLiked: Bool?
        var likeCount: String?
        
        var isDeleteAlertPresented: Bool = false
        var isDeleteCompleteAlertPresented: Bool = false
        var isContestOptionSheetPresented: Bool = false
        var isReportOptionSheetPresented: Bool = false
        var isFullSizeImageSheetPresented: Bool = false
        var isReportInputReasonSheetPresented: Bool = false
        
        var activeSheet: SheetContentType?
        var reportReasonSheet: SheetContentType?
        
        var isWriter: Bool {
            return myNickname == contestAuthor
        }
        
        public init (
            postId: String
        ) {
            self.postId = postId
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Dependency
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case reportReasonButtonTapped(type: ContestReportReasonType, reason: String)
        case postReport(type: ContestReportReasonType, reason: String?)
        case reportSuccess(ReportResponseDTO)
        
        case likeButtonTapped
        case optionButtonTapped
        case deleteOptionButtonTapped
        case deleteButtonTapped
        case contestImageTapped
        
        case reportSheetIsPresented
        case optionSheetIsPresented(ContestReportReasonType)
        case dismissOptionSheet(Bool)
        case dismissReportOptionSheet(Bool)
        case dismissFullSizeImageSheet(Bool)
        case dismissReportIntputReasonSheet(Bool)
        case dismissSheet(Bool)
        case userDataLoaded(String?)
        
        case backButtonTapped
        
        case onAppearSuccess(SearchDetailContestResponseDTO)
        case likeButtonTappedSuccess(isLike: Bool, PostLikeResponseDTO)
        case deleteActionResult(Bool)
        case deleteCompletedButtonTapped
        case presentDeleteAlert
        case dismissDeleteAlert
        case contestDetailError(Error)
        
        case delegate(DelegateAction)

        public enum DelegateAction {
            case backConfirmed
        }
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
                        await send(.onAppearSuccess(responseResult))
                    case .failure(let error):
                        await send(.contestDetailError(error))
                    }
                }
                
            case .onAppearSuccess(let response):
                state.userId = response.memberId
                state.contestTitle = response.title
                state.contestAuthor = response.nickname
                state.imageUrl = response.imageUrl
                state.isLiked = response.isLiked
                state.likeCount = formatLikeCount(response.likeCount)
                
                return .none
                
            case .reportSheetIsPresented:
                state.isContestOptionSheetPresented = false
                state.isReportOptionSheetPresented = true
                
                return .none
                
            case .optionSheetIsPresented(let tappedOption):
                state.isReportOptionSheetPresented = false
                
                switch tappedOption {
                case .inappropriateContent:
                    state.activeSheet = .inappropriateContent
                    
                case .hateSpeech:
                    state.activeSheet = .hateSpeech
                    
                case .infringement:
                    state.activeSheet = .infringement
                    
                case .spam:
                    state.activeSheet = .spam
                    
                case .promotion:
                    state.activeSheet = .promotion
                    
                case .other:
                    state.activeSheet = .other
                }
                
                return .none
                
            case .likeButtonTapped:
                let dto = PostLikeRequestDTO(postId: state.postId, contestType: "WEEKLY")
                
                let isLiked = state.isLiked ?? false
                
                return .run { send in
                    let result: Result<PostLikeResponseDTO, NetworkError> = await NetworkManager.shared.request(isLiked ? PostLikeEndpoint.deletePostLike(dto) : PostLikeEndpoint.putPostLike(dto))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.likeButtonTappedSuccess(isLike: isLiked, responseResult))
                    case .failure(let error):
                        await send(.contestDetailError(error))
                    }
                }
            
            case .likeButtonTappedSuccess(let isLike, let response):
                state.likeCount = formatLikeCount(response.likeCount)
                state.isLiked = !isLike
                
                return .none
                
            case .deleteButtonTapped:
                state.isDeleteAlertPresented = false
                
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
                    state.isDeleteCompleteAlertPresented = true
                    return .none
                } else {
                    return .none
                }
            
            case .deleteOptionButtonTapped:
                state.isContestOptionSheetPresented = false
                
                return .run { send in
                    try await Task.sleep(nanoseconds: 500_000_000)
                    await send(.presentDeleteAlert)
                }
                
            case .presentDeleteAlert:
                state.isDeleteAlertPresented = true
                
                return .none
            
            case .deleteCompletedButtonTapped:
                state.isDeleteCompleteAlertPresented = false
                
                return .run { send in
                    try await Task.sleep(nanoseconds: 300_000_000)
                    await send(.delegate(.backConfirmed))
                }
                
            case .dismissDeleteAlert:
                state.isDeleteAlertPresented = false
                
                return .none
                
            case .dismissOptionSheet:
                state.isContestOptionSheetPresented = false
                return .none
                
            case .dismissReportOptionSheet:
                state.isReportOptionSheetPresented = false
                return .none
                
            case .dismissSheet:
                state.activeSheet = nil
                return .none
            
            case .contestImageTapped:
                state.isFullSizeImageSheetPresented = true
                
                return .none
                
            case .dismissFullSizeImageSheet:
                state.isFullSizeImageSheetPresented = false
                
                return .none
                
            case .dismissReportIntputReasonSheet:
                state.isReportInputReasonSheetPresented = false
                
                return .none
                
            case .optionButtonTapped:
                state.isContestOptionSheetPresented = true
                
                return .none
                
            case .userDataLoaded(let nickname):
                state.myNickname = nickname
                return .none
                
            case .backButtonTapped:
                return .send(.delegate(.backConfirmed))
                
            case .postReport(let type, let reason):
                guard let id = state.userId else { return .none }
                
                let dto = ReportRequestDTO(
                    targetId: id,
                    targetType: "WEEKLY_POST",
                    reportType: type.typeTitle,
                    reason: reason
                )
                
                return .run { send in
                    let result: Result<ReportResponseDTO, NetworkError> = await NetworkManager.shared.request(ReportEndpoint.postReport(dto))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.reportSuccess(responseResult))
                    case .failure(let error):
                        break
                    }
                }
                
            case .reportSuccess(let response):
                
                return .none
                
            case .reportReasonButtonTapped(let type, let reason):
                return .send(.postReport(type: type, reason: reason))
                
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
