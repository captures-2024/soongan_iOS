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
        case contestDetail(ContestDetailFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.appStorage("AuthState")) var authState: AuthType = .loggedOut
        var path = StackState<MypagePath.State>()
        
        var leftContestImageList = [ContestImageModel]()
        var rightContestImageList = [ContestImageModel]()
        
        var drawInputText = ""
        var isOptionSheetPresented: Bool = false
        var shouldNavigateToEditProfile: Bool = false
        var shouldNavigateToQuestionsList: Bool = false
        
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
    
    @Dependency(\.openURL) var openURL
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case path(StackActionOf<MypagePath>)
        
        case binding(BindingAction<State>)
        
        case onAppear
        case alarmButtonTapped
        case joinToContestButtonTapped
        case optionButtonTapped
        case optionSheetIsPresented(MyprofileOptionType)
        case profileOptionTapped(MyprofileOptionType)
        case presentSheet(SheetContentType)
        case dismissOptionSheet(Bool)
        case dismissSheet
        
        case myInfoSuccess(SearchMyProfileResponseDTO)
        case myContestInfoSuccess(SearchMyContestResponseDTO)
        
        case logoutSuccess
        case withdrawSuccess
        
        case myInfoActionSuccess(MyprofileOptionType)
        case successSheetComplete(MypageSuccessSheetType)
        case contestDetailImageTapped(String)
        
        case deleteMyInfomation
        
        case delegate(Delegate)
                
        public enum Delegate {
            case moveToJoinContest
        }
    }
    
    // MARK: - Body
     
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                let dto = SearchMyContestRequestDTO(page: 0, pageSize: 50)
                
                return .run { send in
                    async let myInfoResult: Result<SearchMyProfileResponseDTO, NetworkError> = NetworkManager.shared.request(MemberEndpoint.getMembers)
                    async let myContestInfoResult: Result<SearchMyContestResponseDTO, NetworkError> = NetworkManager.shared.request(WeeklyContestEndpoint.getMyContest(dto))
                    
                    let (infoResult, contestResult) = await (myInfoResult, myContestInfoResult)
                    
                    switch infoResult {
                    case .success(let info):
                        await send(.myInfoSuccess(info))
                    case .failure(let error):
                        print("Profile Error: \(error.localizedDescription)")
//                        await send(.myInfoFailure(error))
                    }

                    switch contestResult {
                    case .success(let contest):
                        await send(.myContestInfoSuccess(contest))
                    case .failure(let error):
                        print("Contest Error: \(error.localizedDescription)")
//                        await send(.myContestFailure(error))
                    }
                }
                
            case .myInfoSuccess(let response):
                state.userName = response.nickname ?? ""
                state.userIntroduce = response.selfIntroduction ?? "본인을 소개시켜주세요"
                state.userProfileImageUrl = response.profileImageUrl
                
                return .none
                
            case .myContestInfoSuccess(let response):
                state.leftContestImageList.removeAll()
                state.rightContestImageList.removeAll()
                
                for (index, item) in response.postInfo.enumerated() {
                    let model = ContestImageModel(id: String(item.postId), imageUrl: item.imageUrl)
                    if index % 2 == 0 {
                        state.leftContestImageList.append(model)
                    } else {
                        state.rightContestImageList.append(model)
                    }
                }

                return .none
                
            case let .path(.element(id: _, action: action)):
                switch action {
                case .editProfile(.backButtonTapped), .editProfile(.delegate(.backButtonTapped)), .alarmList(.backButtonTapped), .questionsList(.backButtonTapped):
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
                
            case .optionSheetIsPresented(let tappedOption):
                state.isOptionSheetPresented = false
                
                switch tappedOption {
                case .editMyProfile:
                    state.shouldNavigateToEditProfile = true

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
                    state.activeSheet = .withdraw
                    
                case .logout:
                    state.activeSheet = .logout
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
                state.$authState.withLock { $0 = .loggedOut }
                KeychainManager.shared.clearTokens()
                
                return .none
                
            case .contestDetailImageTapped(let postId):
                state.path.append(.contestDetail(ContestDetailFeature.State(postId: postId)))
                return .none
                
            case .joinToContestButtonTapped:
                return .send(.delegate(.moveToJoinContest))
                
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
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
