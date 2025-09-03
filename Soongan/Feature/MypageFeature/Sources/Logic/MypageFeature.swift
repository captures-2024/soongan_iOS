//
//  MypageFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/15/25.
//

import SwiftUI

import CoreNetwork
import CoreKeyChain
import DetailContestFeature
import DesignSystem
import PostPictureFeature
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
        case postPicture(PostPictureFeature)
        case contestDetail(ContestDetailFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.appStorage("AuthState")) var authState: AuthType = .loggedOut
        var path = StackState<MypagePath.State>()
        
        var leftContestImageList = [ContestImageModel]()
        var rightContestImageList = [ContestImageModel]()
        
        var scrollPosition: ScrollPosition = ScrollPosition(idType: ContestIndexModel.ID.self)
        var scrollOffset: CGFloat = 0
        
        var drawInputText = ""
        var isOptionSheetPresented: Bool = false
        var shouldNavigateToEditProfile: Bool = false
        var shouldNavigateToQuestionsList: Bool = false
        var isLoginAlertPresented: Bool = false
        
        var userName = ""
        var userIntroduce = ""
        var userProfileImageUrl: String?
        
        var activeSheet: SheetContentType?
        var successSheet: SheetContentType?
        
        // CustomTabBar 가시성
        public var isTabBarVisible: Bool {
            path.isEmpty
        }
        
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Dependency
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.openURL) var openURL
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case path(StackActionOf<MypagePath>)
        
        case binding(BindingAction<State>)
        
        case onAppear
        case alertAction(AlertAction)
        case networkAction(NetworkAction)
        case uiAction(UIAction)
        
        case optionButtonTapped
        case optionSheetIsPresented(MyprofileOptionType)
        case profileOptionTapped(MyprofileOptionType)
        case presentSheet(SheetContentType)
        case dismissOptionSheet(Bool)
        case dismissSheet
        case dismissLoginAlert
        case dismissAlertButtonTapped
        
        case logoutSuccess
        case withdrawSuccess
        
        case myInfoActionSuccess(MyprofileOptionType)
        case successSheetComplete(MypageSuccessSheetType)
        case contestDetailImageTapped(Int)
        
        case updateLeftImageModel(Int, CGFloat)
        case updateRightImageModel(Int, CGFloat)
        
        case deleteMyInfomation
        
        case delegate(Delegate)
                
        public enum Delegate {
            case moveToJoinContest
            case didRequestLogout
        }
    }
    
    public enum AlertAction {
        case presentLoginAlert
    }
    
    public enum NetworkAction {
        case onAppearMyInfoSuccess(SearchMyProfileResponseDTO)
        case onAppearMyContestInfoSuccess(SearchMyContestResponseDTO)
        case onAppearMyInfoFailure(NetworkError)
        case onAppearMyContestInfoFailure(NetworkError)
    }
    
    public enum UIAction {
        case alarmButtonTapped
        case joinToContestButtonTapped
    }
    
    // MARK: - Body
     
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.authState == .skipped {
                    state.userName = "로그인이 필요해요"
                    state.userIntroduce = "로그인 후 본인을 소개해주세요"
                    return .none
                }

                let dto = SearchMyContestRequestDTO(page: 0, pageSize: 50)
                
                return .run { send in
                    async let myInfoResult: Result<SearchMyProfileResponseDTO, NetworkError> = NetworkManager.shared.request(MemberEndpoint.getMembers)
                    async let myContestInfoResult: Result<SearchMyContestResponseDTO, NetworkError> = NetworkManager.shared.request(WeeklyContestEndpoint.getMyContest(dto))
                    
                    let (infoResult, contestResult) = await (myInfoResult, myContestInfoResult)
                    
                    switch infoResult {
                    case .success(let info):
                        await send(.networkAction(.onAppearMyInfoSuccess(info)))
                    case .failure(let error):
                        await send(.networkAction(.onAppearMyInfoFailure(error)))
                    }

                    switch contestResult {
                    case .success(let contest):
                        await send(.networkAction(.onAppearMyContestInfoSuccess(contest)))
                    case .failure(let error):
                        await send(.networkAction(.onAppearMyContestInfoFailure(error)))
                    }
                }
                
            case .networkAction(.onAppearMyInfoSuccess(let response)):
                state.userName = response.nickname ?? ""
                state.userIntroduce = response.selfIntroduction ?? "본인을 소개시켜주세요"
                state.userProfileImageUrl = response.profileImageUrl
                
                return .none
                
            case .networkAction(.onAppearMyContestInfoSuccess(let response)):
                state.leftContestImageList.removeAll()
                state.rightContestImageList.removeAll()
                
                for (index, item) in response.postInfo.enumerated() {
                    let model = ContestImageModel(id: item.postId, imageUrl: item.imageUrl)
                    if index % 2 == 0 {
                        state.leftContestImageList.append(model)
                    } else {
                        state.rightContestImageList.append(model)
                    }
                }

                return .none
                
            case .networkAction(.onAppearMyInfoFailure):
                state.userName = "정보 없음"
                state.userIntroduce = "본인을 소개시켜주세요"
                return .none
                
            case .networkAction(.onAppearMyContestInfoFailure):
                state.leftContestImageList.removeAll()
                state.rightContestImageList.removeAll()
                return .none
                
            case let .path(.element(id: _, action: action)):
                switch action {
                case .editProfile(.backButtonTapped), .editProfile(.delegate(.backButtonTapped)), .alarmList(.backButtonTapped), .questionsList(.backButtonTapped):
                    state.path.removeLast()
                    return .none
                    
                case .contestDetail(.delegate(.backConfirmed)):
                    state.path.removeLast()
                    return .none
                    
                case .contestDetail(.delegate(.editRequested(let contestId, let title, let imageURL, let weekTopic))):
                    let editState = PostPictureFeature.State(
                        mode: .edit(
                            contestId: contestId,
                            weekTopic: weekTopic,
                            existingTitle: title,
                            imageURL: imageURL
                        )
                    )
                    state.path.append(.postPicture(editState))
                    return .none
                    
                case .postPicture(.delegate(.editCompleted)):
                    state.path.removeLast()
                    return .send(.onAppear) // 수정 완료 후 새로고침
                
                case .postPicture(.delegate(.backConfirmed)):
                    state.path.removeLast()
                    return .none
                    
                default:
                    return .none
                }
                
            case .binding(_):
                return .none
                
            case .uiAction(.alarmButtonTapped):
                state.path.append(.alarmList(AlarmListFeature.State()))
                return .none
                
            case .optionButtonTapped:
                state.isOptionSheetPresented = true
                return .none
                
            case .optionSheetIsPresented(let tappedOption):
                state.isOptionSheetPresented = false
                
                switch tappedOption {
                case .editMyProfile:
                    switch state.authState {
                    case .skipped:
                        state.activeSheet = nil
                        return .run { send in
                            try await Task.sleep(nanoseconds: 100_000_000)
                            await send(.alertAction(.presentLoginAlert))
                        }
                        
                    case .loggedIn:
                        state.shouldNavigateToEditProfile = true
                    default:
                        break
                    }
                    
                case .pushAlarmSetting:
                    state.activeSheet = .alarmSetting
                    
                case .terms:
                    guard let url = URL(string: "https://www.notion.so/5724dc92a43c4e7e94fd5ccf8ab0608b?source=copy_link") else {
                        return .none
                    }
                            
                    return .run { _ in
                        await openURL(url)
                    }
                    
                case .faq:
                    state.shouldNavigateToQuestionsList = true
                    
                case .withdraw:
                    switch state.authState {
                    case .skipped:
                        state.activeSheet = nil
                        return .run { send in
                            try await Task.sleep(nanoseconds: 100_000_000)
                            await send(.alertAction(.presentLoginAlert))
                        }

                    case .loggedIn:
                        state.activeSheet = .withdraw
                    default:
                        break
                    }
                    
                case .logout:
                    switch state.authState {
                    case .skipped:
                        state.activeSheet = nil
                        return .run { send in
                            try await Task.sleep(nanoseconds: 100_000_000)
                            await send(.alertAction(.presentLoginAlert))
                        }
                        
                    case .loggedIn:
                        state.activeSheet = .logout
                    default:
                        break
                    }
                }
                
                return .none
            
            case .profileOptionTapped(let tappedOption):
                state.activeSheet = nil
                
                switch tappedOption {
                case .withdraw:
                    return .run { send in
                        let result: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(AuthEndpoint.postWithdraw)
                        
                        switch result {
                        case .success:
                            await send(.myInfoActionSuccess(.withdraw))
                        case .failure(let error):
                            break
                        }
                    }
                    
                case .logout:
                    return .run { send in
                        let result: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(AuthEndpoint.postLogout)
                        
                        switch result {
                        case .success:
                            await send(.myInfoActionSuccess(.logout))
                        case .failure(let error):
                            break
                        }
                    }
                    
                default:
                    break
                }
                
                return .none
                
            case .myInfoActionSuccess(let type):
                state.activeSheet = nil
                return .run { send in
                    try await Task.sleep(nanoseconds: 1000_000_000)
                    await send(.successSheetComplete(type == .logout ? .logout : .withdraw))
                }
                
            case .successSheetComplete(let type):
                state.successSheet = type == .logout ? .logoutSuccess : .withdrawSuccess
                
                return .none
                
            case .deleteMyInfomation:
                // 1. Keychain에 저장된 모든 토큰 삭제
                KeychainManager.shared.clearTokens()
                
                // 2. UserDefaults에 저장된 모든 관련 정보 삭제
                return .run { [userDefaultsClient] send in
                    // User 관련 정보 삭제
                    await userDefaultsClient.remove(UserDefaultKeys.User.username.rawValue)
                    await userDefaultsClient.remove(UserDefaultKeys.User.userID.rawValue)
                    
                    // Settings 관련 정보 삭제
                    await userDefaultsClient.remove(UserDefaultKeys.Settings.isNotificationEnabled.rawValue)
                    
                    // 3. 모든 정보 삭제 후, 로그아웃 신호를 부모에게 전달
                    await send(.delegate(.didRequestLogout))
                }
                
            case .contestDetailImageTapped(let postId):
                state.path.append(.contestDetail(ContestDetailFeature.State(postId: postId, weekTopic: "")))
                return .none
                
            case .uiAction(.joinToContestButtonTapped):
                if state.authState == .skipped {
                    state.isLoginAlertPresented = true
                    return .none
                }
                
                return .send(.delegate(.moveToJoinContest))
                
            case .dismissLoginAlert:
                state.isLoginAlertPresented = false
                return .none
                
            case .dismissAlertButtonTapped:
                state.isLoginAlertPresented = false
                return .send(.delegate(.didRequestLogout))
                
            case .dismissOptionSheet(_):
                state.isOptionSheetPresented = false
                
                if state.shouldNavigateToEditProfile {
                    state.shouldNavigateToEditProfile = false
                    state.path.append(.editProfile(EditProfileFeature.State(
                        baseNickname: state.userName,
                        baseIntroduce: state.userIntroduce,
                        baseProfileImageUrl: state.userProfileImageUrl))
                    )
                }
                
                if state.shouldNavigateToQuestionsList {
                    state.shouldNavigateToQuestionsList = false
                    state.path.append(.questionsList(QuestionsListFeature.State()))
                }
                
                return .none
                
            case .dismissSheet:
                state.activeSheet = nil
                return .none
            
            case .alertAction(.presentLoginAlert):
                state.isLoginAlertPresented = true
                return .none
                
            case .updateLeftImageModel(let modelId, let imageRatio):
                if let index = state.leftContestImageList.firstIndex(where: { $0.id == modelId }) {
                    state.leftContestImageList[index].height = imageRatio
                }
                
                return .none
                
            case .updateRightImageModel(let modelId, let imageRatio):
                if let index = state.rightContestImageList.firstIndex(where: { $0.id == modelId }) {
                    state.rightContestImageList[index].height = imageRatio
                }
                
                return .none
                
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
