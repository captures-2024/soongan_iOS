//
//  LoginFeature.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/2/25.
//

import SwiftUI

import CoreAppleLogin
import CoreKakaoLogin
import CoreKeyChain
import CoreUserDefault
import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

public enum LoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
}

public enum LoginError: Error {
    case socialLogin(type: LoginType, error: Error)     // 소셜 로그인 단계 에러
    case serverAuth(Error)                              // 서버 인증 단계 에러
    case profileFetch(Error)                           // 프로필 조회 단계 에러
    case fcmTokenMissing                              // FCM 토큰 없음
}

@Reducer
public struct LoginFeature {
    
    // MARK: - Path
    
    @Reducer(state: .equatable)
    public enum LoginPath {
        case signup(SignupFeature)
        case signupSuccess(SignupSuccessFeature)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<LoginPath.State>()
        var errorMessage: String = ""
        
        var loginErrorAlert: LoginErrorType?
        
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Dependency
    
    @Dependency(\.appleLoginService) var appleLoginService
    @Dependency(\.kakaoLoginService) var kakaoLoginService
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.notificationClient) var notificationClient
    @Dependency(\.openURL) var openURL
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case path(StackActionOf<LoginPath>)
        
        case binding(BindingAction<State>)
        case onAppear
        case kakaoButtonTapped
        case appleButtonTapped
        
        case socialLoginSuccessResponse(type: LoginType, token: String)
        case socialLoginFailureResponse(type: LoginType, error: Error)
        
        case serverAuthSuccess
        case serverAuthFailure
        
        case profileFetchSuccess(Bool)  // isSignupComplete
        case profileFetchFailure
        
        case fcmFetchFailure
        
        case loginFailure(LoginError)
        
        case dismissAlert

        case skippLoginButtonTapped
        case termsOfUseButtonTapped
        case personalInformationButtonTapped
        
        // Delegate - LoginFeature -> AppFeature
        case delegate(Delegate)
        
        public enum Delegate {
            case loginSuccess
            case skippAuth
        }
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { _ in
                    let _  = await self.notificationClient.requestAuthorization()
                }
                
            case .binding(_):
                return .none
                
            case .appleButtonTapped:
                return .run { send in
                    do {
                        let oauthToken = try await appleLoginService.login()
                        await send(.socialLoginSuccessResponse(type: .apple, token: oauthToken))
                    } catch {
                        await send(.socialLoginFailureResponse(type: .apple, error: error))
                    }
                }
                
            case .kakaoButtonTapped:
                return .run { send in
                    do {
                        let idToken = try await kakaoLoginService.login()
                        await send(.socialLoginSuccessResponse(type: .kakao, token: idToken))
                    } catch {
                        await send(.socialLoginFailureResponse(type: .kakao, error: error))
                    }
                }
                
            case let .socialLoginSuccessResponse(type, token):
                return .run { send in
                    guard let fcmToken = KeychainManager.shared.load(key: .fcmToken) else { 
                        await send(.fcmFetchFailure)
                        return
                    }

                    let result: Result<AuthedResponseDTO, NetworkError> = await NetworkManager.shared.request(
                        AuthEndpoint.postLogin(
                            LoginRequestDTO(
                                provider: type.rawValue,
                                idToken: token,
                                fcmToken: fcmToken
                            )
                        )
                    )
                    
                    switch result {
                    case .success(let authedResult):
                        KeychainManager.shared.save(key: .accessToken, value: authedResult.accessToken)
                        KeychainManager.shared.save(key: .refreshToken, value: authedResult.refreshToken)
                        
                        await send(.serverAuthSuccess)
                        
                    case .failure(_):
                        await send(.serverAuthFailure)
                    }
                }
                
            case .socialLoginFailureResponse(let type, let error):
                switch type {
                case .apple:
                    state.loginErrorAlert = .socialLogin(title: "애플 로그인")
                case .kakao:
                    state.loginErrorAlert = .socialLogin(title: "카카오 로그인")
                }

                return .none
                
            /// 서버 로그인 성공
            case .serverAuthSuccess:
                return .run { send in
                    let result: Result<SearchMyProfileResponseDTO, NetworkError> = await NetworkManager.shared.request(MemberEndpoint.getMembers)
                    
                    switch result {
                    case .success(let myResult):
                        let isSignupComplete = myResult.nickname != nil && myResult.birthYear != nil
                        await send(.profileFetchSuccess(isSignupComplete))
                        
                    case .failure(_):
                        await send(.profileFetchFailure)
                    }
                }
            
            /// 서버 로그인 실패
            case .serverAuthFailure:
                state.loginErrorAlert = .serverAuth
                return .none
                
            case .profileFetchSuccess(let isSignupComplete):
                if isSignupComplete {
                    // 프로필 조회 성공 시 닉네임 저장
                    return .run { send in
                        let result: Result<SearchMyProfileResponseDTO, NetworkError> = await NetworkManager.shared.request(MemberEndpoint.getMembers)
                        
                        switch result {
                        case .success(let myResult):
                            if let nickname = myResult.nickname {
                                await userDefaultsClient.setString(nickname, forKey: UserDefaultKeys.User.username.rawValue)
                            }
                        case .failure:
                            break
                        }
                        
                        await send(.delegate(.loginSuccess))
                    }
                } else {
                    // 회원가입이 필요한 경우
                    state.path.append(.signup(SignupFeature.State()))
                    return .none
                }
                
            case .profileFetchFailure:
                state.loginErrorAlert = .profileFetch
                return .none
                
            case .loginFailure(let error):
                state.errorMessage = "로그인 실패: \(error.localizedDescription)"
                return .none
                
            case .fcmFetchFailure:
                state.loginErrorAlert = .fcmTokenMissing
                return .none

            case .termsOfUseButtonTapped:
                guard let url = URL(string: "https://www.notion.so/5724dc92a43c4e7e94fd5ccf8ab0608b?source=copy_link") else {
                    return .none
                }
                        
                return .run { _ in
                    await openURL(url)
                }
            
            case .personalInformationButtonTapped:
                guard let url = URL(string: "https://www.notion.so/71392fc225bf47b69e353739a74829db?source=copy_link") else {
                    return .none
                }
                        
                return .run { _ in
                    await openURL(url)
                }
                
            case .skippLoginButtonTapped:
                return .send(.delegate(.skippAuth))
                
            case .delegate(_):
                return .none
   
            case .path(.element(id: _, action: .signup(.delegate(.didCompleteSignup(let nickname))))):
                state.path.append(.signupSuccess(SignupSuccessFeature.State(nickname: nickname)))
                return .none
            
            case .path(.element(id: _, action: .signupSuccess(.delegate(.showMainTab)))):
                return .send(.delegate(.loginSuccess))

            case .path(.element(id: _, action: .signup(.backButtonTapped))):
                state.path.removeLast()
                return .none

            case .path:
                return .none
                
            case .dismissAlert:
                state.loginErrorAlert = nil
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

private struct AppleLoginServiceKey: DependencyKey {
    static let liveValue: any AppleLoginServiceProtocol = AppleLoginService.shared
}

private struct KakaoLoginServiceKey: DependencyKey {
    static let liveValue: any KakaoLoginServiceProtocol = KakaoLoginService.shared
}

public extension DependencyValues {
    var appleLoginService: any AppleLoginServiceProtocol {
        get { self[AppleLoginServiceKey.self] }
        set { self[AppleLoginServiceKey.self] = newValue }
    }
    
    var kakaoLoginService: any KakaoLoginServiceProtocol {
        get { self[KakaoLoginServiceKey.self] }
        set { self[KakaoLoginServiceKey.self] = newValue }
    }
}
