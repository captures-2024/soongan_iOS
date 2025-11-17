//
//  NotificationSettingFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 11/17/25.
//

import SwiftUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct NotificationSettingFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        // 알림 설정
        var contestPush: Bool = false
        var activityPush: Bool = false
        var noticePush: Bool = false
        
        public init() {}
    }
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case updateNotificationSetting(AlaramSettingOptionType, Bool)
        case saveNotificationSettingsToUserDefaults
        
        case networkAction(NetworkAction)
        case delegate(Delegate)
        
        public enum NetworkAction {
            case getNotificationSettingSuccess(NotificationsSettingResponseDTO)
            case getNotificationSettingFailure(NetworkError)
            case updateNotificationSettingSuccess(AlaramSettingOptionType, Bool)
            case updateNotificationSettingFailure(NetworkError)
        }
        
        public enum Delegate {
            case settingsLoaded(contestPush: Bool, activityPush: Bool, noticePush: Bool)
            case settingsUpdated(contestPush: Bool, activityPush: Bool, noticePush: Bool)
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Dependency
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 알림 설정 조회
                return .run { send in
                    let result: Result<NotificationsSettingResponseDTO, NetworkError> = await NetworkManager.shared.request(NotificationEndpoint.getNotificationSetting)
                    
                    switch result {
                    case .success(let setting):
                        await send(.networkAction(.getNotificationSettingSuccess(setting)))
                    case .failure(let error):
                        await send(.networkAction(.getNotificationSettingFailure(error)))
                    }
                }
                
            case .networkAction(.getNotificationSettingSuccess(let response)):
                state.contestPush = response.contestPush
                state.activityPush = response.activityPush
                state.noticePush = response.noticePush
                
                // UserDefaults에 저장
                let contestPush = response.contestPush
                let activityPush = response.activityPush
                let noticePush = response.noticePush
                
                return .run { send in
                    await userDefaultsClient.setBool(contestPush, forKey: UserDefaultKeys.Settings.contestPush.rawValue)
                    await userDefaultsClient.setBool(activityPush, forKey: UserDefaultKeys.Settings.activityPush.rawValue)
                    await userDefaultsClient.setBool(noticePush, forKey: UserDefaultKeys.Settings.noticePush.rawValue)
                    
                    // 부모에게 로딩 완료 알림
                    await send(.delegate(.settingsLoaded(contestPush: contestPush, activityPush: activityPush, noticePush: noticePush)))
                }
                
            case .networkAction(.getNotificationSettingFailure):
                // UserDefaults에서 저장된 값 불러오기
                return .run { send in
                    let contestPush = await userDefaultsClient.bool(forKey: UserDefaultKeys.Settings.contestPush.rawValue)
                    let activityPush = await userDefaultsClient.bool(forKey: UserDefaultKeys.Settings.activityPush.rawValue)
                    let noticePush = await userDefaultsClient.bool(forKey: UserDefaultKeys.Settings.noticePush.rawValue)
                    
                    // 캐시된 설정으로 상태 업데이트
                    await send(.networkAction(.getNotificationSettingSuccess(
                        NotificationsSettingResponseDTO(
                            contestPush: contestPush,
                            activityPush: activityPush,
                            noticePush: noticePush
                        )
                    )))
                }
                
            case .updateNotificationSetting(let settingType, let isEnabled):
                // 새로운 설정값 계산
                var newContestPush = state.contestPush
                var newActivityPush = state.activityPush
                var newNoticePush = state.noticePush
                
                switch settingType {
                case .contestAlarm:
                    newContestPush = isEnabled
                case .activeAlarm:
                    newActivityPush = isEnabled
                case .noticeAlarm:
                    newNoticePush = isEnabled
                case .allAlarm:
                    // 전체 알림은 모든 개별 알림을 토글
                    newContestPush = isEnabled
                    newActivityPush = isEnabled
                    newNoticePush = isEnabled
                }
                
                let requestDTO = NotificationsSettingRequestDTO(
                    contestPush: newContestPush,
                    activityPush: newActivityPush,
                    noticePush: newNoticePush
                )
                
                return .run { send in
                    let result: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(NotificationEndpoint.patchNotificationsSetting(requestDTO))
                    
                    switch result {
                    case .success:
                        await send(.networkAction(.updateNotificationSettingSuccess(settingType, isEnabled)))
                    case .failure(let error):
                        await send(.networkAction(.updateNotificationSettingFailure(error)))
                    }
                }
                
            case .networkAction(.updateNotificationSettingSuccess(let settingType, let isEnabled)):
                // 성공 시에만 UI 상태 업데이트
                switch settingType {
                case .contestAlarm:
                    state.contestPush = isEnabled
                case .activeAlarm:
                    state.activityPush = isEnabled
                case .noticeAlarm:
                    state.noticePush = isEnabled
                case .allAlarm:
                    // 전체 알림은 모든 개별 알림을 토글
                    state.contestPush = isEnabled
                    state.activityPush = isEnabled
                    state.noticePush = isEnabled
                }
                
                return .send(.saveNotificationSettingsToUserDefaults)
                
            case .networkAction(.updateNotificationSettingFailure(_)):
                // 실패 시 UI는 그대로 유지 (아무것도 하지 않음)
                return .none
                
            case .saveNotificationSettingsToUserDefaults:
                // UserDefaults에 현재 알림 설정 저장
                let contestPush = state.contestPush
                let activityPush = state.activityPush
                let noticePush = state.noticePush
                
                return .run { send in
                    await userDefaultsClient.setBool(contestPush, forKey: UserDefaultKeys.Settings.contestPush.rawValue)
                    await userDefaultsClient.setBool(activityPush, forKey: UserDefaultKeys.Settings.activityPush.rawValue)
                    await userDefaultsClient.setBool(noticePush, forKey: UserDefaultKeys.Settings.noticePush.rawValue)
                    
                    // 부모에게 설정 변경 알림
                    await send(.delegate(.settingsUpdated(contestPush: contestPush, activityPush: activityPush, noticePush: noticePush)))
                }
                
            case .binding(_):
                return .none
                
            case .delegate(_):
                return .none
            }
        }
    }
}
