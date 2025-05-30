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
    
    private var alarmListModels = [
        AlarmListModel(title: "<위클리 콘> 새로운 주제가 발표됐어요~", content: "이번 콘테스트의 주제는 무엇일까요?\n지금 바로 확인해보세요!", time: "2일 전"),
        AlarmListModel(title: "<위클리 콘> 새로운 주제가 발표됐어요~", content: "이번 콘테스트의 주제는 무엇일까요?\n지금 바로 확인해보세요!", time: "3일 전"),
        AlarmListModel(title: "<위클리 콘> 새로운 주제가 발표됐어요~", content: "이번 콘테스트의 주제는 무엇일까요?\n지금 바로 확인해보세요!\n콘테스트의 주제는 무엇일까요?\n지금 바로 확인해보세요!", time: "5일전"),
        AlarmListModel(title: "<위클리 콘> 새로운 주제가 발표됐어요~", content: "이번 콘테스트의 주제는 무엇일까요?\n지금 바로 확인해보세요!", time: "10일전")
    ]
    
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
                    title: "대회 알림",
                    isSelected: store.selectedTab == .home,
                    action: { store.send(.topMenuButtonTapped(.home)) }
                )
                
                TopTabButtonView(
                    title: "활동 알림",
                    isSelected: store.selectedTab == .search,
                    action: { store.send(.topMenuButtonTapped(.search)) }
                )

                TopTabButtonView(
                    title: "공지 알림",
                    isSelected: store.selectedTab == .profile,
                    action: { store.send(.topMenuButtonTapped(.profile)) }
                )
            }
            .padding(.top, 26)
            .background(DesignSystem.Color.soonganBG)
            
            Divider()
                .background(DesignSystem.Color.black80)
                .frame(height: 2)
            
            // 선택된 화면 보여주기
            Group {
                switch store.selectedTab {
                case .home:
                    List {
                        ForEach(alarmListModels) { alarmData in
                            VStack(alignment: .leading, spacing: 0) {
                                alarmListContent(data: alarmData)
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 12)
                                
                                Divider()
                                    .frame(height: 0.7)
                                    .background(DesignSystem.Color.black40)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            .swipeActions {
                                Button(role: .destructive) {
                                    // delete(item: item)
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
                    
                case .search:
                    Text("asdfasdfasdfasdf")
                    
                case .profile:
                    Text("asdfasdf")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(DesignSystem.Color.soonganBG)
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
    
    func delete(item: AlarmListModel) {
//        if let index = items.firstIndex(where: { $0.id == item.id }) {
//            items.remove(at: index)
//        }
    }
}

// MARK: - Private Extension View

private extension AlarmListView {
    private func alarmListContent(data: AlarmListModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(data.title)
                .font(.bold16)
                .foregroundColor(DesignSystem.Color.black100)
            
            Text(data.content)
                .font(.bold12)
                .foregroundColor(DesignSystem.Color.black100)
            
            Text(data.time)
                .font(.regualr12)
                .foregroundColor(DesignSystem.Color.black100)
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
