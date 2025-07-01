//
//  AlarmListFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import SwiftUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

public enum AlarmTab: String {
    case contest = "CONTEST"
    case activity = "ACTIVITY"
    case notice = "NOTICE"
    
    static func from(string: String) -> AlarmTab? {
        return AlarmTab(rawValue: string)
    }
}

public enum AlarmListError: Error {
    case deleteAlarmError
    case getNotificationError
    case unreadNotificationError
}

@Reducer
public struct AlarmListFeature {
    
    @ObservableState
    public struct State: Equatable {

        var selectedTab: AlarmTab = .contest
        
        var unreadNotificationCount = [AlarmTab: Int]()
        var alarmListModels = [AlarmTab: [AlarmListModel]]()
        
        public init() {}
    }

    // MARK: - Init

    public init() {}

    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case getNotificationSuccess(String, [NotificationsInfoData])
        case getUnreadNotificationSuccess([UnreadNotificationsResponseDTO])

        case topMenuButtonTapped(AlarmTab)
        case alarmCellTapped(AlarmListModel)
        case readNotificationSuccess(Int)
        
        case deleteAlarmButtonTapped(Int)
        case deleteAlarmSuccess
        case backButtonTapped
        
        case alarmListFailure(AlarmListError)
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .run { send in
                    let result: Result<[UnreadNotificationsResponseDTO], NetworkError> = await NetworkManager.shared.request(NotificationEndpoint.getUnreadNotificationCount)
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.getUnreadNotificationSuccess(responseResult))
                    case .failure:
                        await send(.alarmListFailure(.unreadNotificationError))
                    }
                }
                
            case .getNotificationSuccess(let type, let response):
                response.forEach {
                    if let tab = AlarmTab.from(string: type) {
                        state.alarmListModels[tab]?.append( AlarmListModel(
                            id: $0.id,
                            title: $0.title,
                            content: $0.body,
                            isRead: $0.isRead,
                            redirectUrl: $0.redirectUrl,
                            time: $0.createdAt
                        ))
                    }
                }
                
                return .none
                
            case .getUnreadNotificationSuccess(let response):
                response.forEach {
                    if let tab = AlarmTab.from(string: $0.type) {
                        state.unreadNotificationCount[tab] = $0.count
                    }
                }
                
                return .none
                
            case .alarmListFailure:
                return .none
                
            case .alarmCellTapped(let data):
                let dto = ReadNotificationsRequestDTO(notificationId: data.id)
                
                return .run { send in
                    let result: Result<Int, NetworkError> = await NetworkManager.shared.request(NotificationEndpoint.postReadNotification(dto))
                    
                    switch result {
                    case .success(let responseResult):
                        await send(.readNotificationSuccess(responseResult))
                    case .failure:
                        await send(.alarmListFailure(.unreadNotificationError))
                    }
                }
                
            case .readNotificationSuccess(let response):
                
                return .none
                
            case .deleteAlarmButtonTapped(let id):
                return .run { send in
                    let result: Result<EmptyResponseDTO, NetworkError> = await NetworkManager.shared.request(NotificationEndpoint.deleteNotification(notificationId: id))
                    
                    switch result {
                    case .success:
                        await send(.deleteAlarmSuccess)
                    case .failure:
                        await send(.alarmListFailure(.deleteAlarmError))
                    }
                }
                
            case .deleteAlarmSuccess:
                
                return .none
                
            case .binding(_):
                return .none
                
            case .backButtonTapped:
                return .none
                
            case .topMenuButtonTapped(let type):
                state.selectedTab = type
                
                return .run { send in
                    let dto = SearchNotificationsRequestDTO(type: type.rawValue)

                    let result: Result<SearchNotificationsResponseDTO, NetworkError> = await NetworkManager.shared.request(NotificationEndpoint.getNotifications(dto))

                    switch result {
                    case .success(let responseResult):
                        await send(.getNotificationSuccess(responseResult.type, responseResult.notifications))
                    case .failure:
                        await send(.alarmListFailure(.getNotificationError))
                    }
                }
            }
        }
    }
}
