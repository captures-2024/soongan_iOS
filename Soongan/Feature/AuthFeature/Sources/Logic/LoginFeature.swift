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
import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

public enum LoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
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
        
        public init() {}
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Dependency
    
    @Dependency(\.appleLoginService) var appleLoginService
    @Dependency(\.kakaoLoginService) var kakaoLoginService
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case path(StackActionOf<LoginPath>)
        
        case binding(BindingAction<State>)
        case kakaoButtonTapped
        case appleButtonTapped
        
        case socialLoginSuccessResponse(type: LoginType, token: String)
        case socialLoginFailureResponse(Error)
        
        case loginSuccess
        case loginFailure(Error)

        case skippLoginButtonTapped
        case termsOfUseButtonTapped
        
        // Delegate - LoginFeature -> AppFeature
        case delegate(Delegate)
        
        public enum Delegate {
            case loginSuccess
            case skippAuth
        }
        
//        case successSignup(SignupFeature.Action)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .appleButtonTapped:
                return .run { send in
                    do {
                        let oauthToken = try await appleLoginService.login()
                        await send(.socialLoginSuccessResponse(type: .apple, token: oauthToken))
                    } catch {
                        await send(.socialLoginFailureResponse(error))
                    }
                }
                
            case .kakaoButtonTapped:
                return .run { send in
                    do {
                        let idToken = try await kakaoLoginService.login()
                        await send(.socialLoginSuccessResponse(type: .kakao, token: idToken))
                    } catch {
                        await send(.socialLoginFailureResponse(error))
                    }
                }
                
            case let .socialLoginSuccessResponse(type, token):
                return .run { send in
                    guard let fcmToken = KeychainManager.shared.load(key: .fcmToken) else { return }

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
                        
                        await send(.loginSuccess)
                        
                    case .failure(let error):
                        await send(.loginFailure(error))
                    }
                }
                
            case .loginSuccess:
                state.path.append(.signup(SignupFeature.State()))
                return .none
                
            case .loginFailure(let error):
                state.errorMessage = "로그인 실패: \(error.localizedDescription)"
                return .none

            case .termsOfUseButtonTapped:
                // TODO: - 이용 약관 웹 페이지
                return .none
                
            case .skippLoginButtonTapped:
                // TODO: - 메인 화면
                return .none
                
            case .delegate(_):
                return .none
   
            case .path(.element(id: _, action: .signup(.delegate(.didCompleteSignup(let nickname))))):
                state.path.append(.signupSuccess(SignupSuccessFeature.State(nickname: nickname)))
                return .none
            
            case .path(.element(id: _, action: .signupSuccess(.delegate(.showMainTab)))):
                print("LoginFeature 로 데이터 옴")
                return .send(.delegate(.loginSuccess))
//            case .path(.element(id: _, action: .signupSuccess(T##SignupSuccessFeature.Action)))
//            case .path(.element(id: _, action: .signup(.showSignupView))):
//                state.path.append(.signup(SignupFeature.State()))
//                return .none
                
            case .path(.element(id: _, action: .signup(.backButtonTapped))):
                state.path.removeLast()
                return .none

            case .path:
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
