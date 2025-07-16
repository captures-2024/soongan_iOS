//
//  AlarmListView.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

public struct AlarmListView: View {
    
    @Bindable var store: StoreOf<AlarmListFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<AlarmListFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 18) {
                TopTabButtonView(
                    title: "대회 알림" + (store.unreadNotificationCount[.contest].flatMap { $0 > 0 ? " \($0)" : nil } ?? ""),
                    isSelected: store.selectedTab == .contest,
                    action: { store.send(.topMenuButtonTapped(.contest)) }
                )
                
                TopTabButtonView(
                    title: "활동 알림" + (store.unreadNotificationCount[.activity].flatMap { $0 > 0 ? " \($0)" : nil } ?? ""),
                    isSelected: store.selectedTab == .activity,
                    action: { store.send(.topMenuButtonTapped(.activity)) }
                )

                TopTabButtonView(
                    title: "공지 알림" + (store.unreadNotificationCount[.notice].flatMap { $0 > 0 ? " \($0)" : nil } ?? ""),
                    isSelected: store.selectedTab == .notice,
                    action: { store.send(.topMenuButtonTapped(.notice)) }
                )
            }
            .padding(.top, 26)
            .background(DesignSystem.Color.soonganBG)
            
            Divider()
                .background(DesignSystem.Color.black80)
                .frame(height: 2)
                .offset(y: -1)
            
            Group {
                alarmList(store.selectedTab)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            store.send(.onAppear)
            store.send(.topMenuButtonTapped(.contest))
        }
        .background(DesignSystem.Color.soonganBG)
        .background(InteractivePopGestureEnabler())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    HStack(spacing: 0) {
                        Image.arrowBack
                            .padding(.trailing, 5)
                    }
                }
                .padding(.top, 16)
            }
            
            ToolbarItem(placement: .principal) {
                Text("알림")
                    .font(.bold16)
                    .foregroundColor(DesignSystem.Color.black100)
                    .padding(.top, 16)
            }
        }
    }
    
    @ViewBuilder
    func alarmList(_ tab: AlarmTab) -> some View {
        if let alarmList = store.alarmListModels[store.selectedTab] {
            List {
                ForEach(alarmList) { alarmData in
                    VStack(alignment: .leading, spacing: 0) {
                        alarmListContent(data: alarmData)
                            .padding(.leading, alarmData.isRead ? 20 : 12)
                            .padding(.trailing, 20)
                            .padding(.horizontal, 12)
                        
                        Divider()
                            .frame(height: 0.7)
                            .background(DesignSystem.Color.black40)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .onTapGesture {
                        store.send(.alarmCellTapped(alarmData)) // Action 추가
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            store.send(.deleteAlarmButtonTapped(alarmData.id))
                        } label: {
                            Image.deleteList
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .listStyle(.plain)
        } else {
            Text("알람이 없습니다.")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Private Extension View

private extension AlarmListView {
    private func alarmListContent(data: AlarmListModel) -> some View {
        HStack(spacing: 12) {
            if !data.isRead {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(DesignSystem.Color.primary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(data.title)
                    .font(.bold16)
                    .foregroundColor(DesignSystem.Color.black100)
                
                Text(data.content)
                    .font(.bold12)
                    .foregroundColor(DesignSystem.Color.black100)
                
                Text(data.time)
                    .font(.regular12)
                    .foregroundColor(DesignSystem.Color.black100)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    NavigationStack {
//        AlarmListView()
//    }
////    AlarmListView()
//}
