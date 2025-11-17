//
//  QuestionsListView.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

struct QuestionsListView: View {
    
    @Bindable var store: StoreOf<QuestionsListFeature>
    
    // MARK: - Init
    
    public init(
        store: StoreOf<QuestionsListFeature>
    ) {
        self.store = store
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(navigationCase: .title("FAQ")) {
                store.send(.backButtonTapped)
            }
            
            HStack(alignment: .bottom, spacing: 18) {
                TopTabButtonView(
                    title: "기본",
                    isSelected: store.selectedTab == .nomal,
                    action: { store.send(.topMenuButtonTapped(.nomal)) }
                )
                
                TopTabButtonView(
                    title: "대회 안내",
                    isSelected: store.selectedTab == .contestInfo,
                    action: { store.send(.topMenuButtonTapped(.contestInfo)) }
                )

                TopTabButtonView(
                    title: "저작권",
                    isSelected: store.selectedTab == .copyright,
                    action: { store.send(.topMenuButtonTapped(.copyright)) }
                )
            }
            .padding(.top, 14)
            .background(DesignSystem.Color.soonganBG)
            
            Divider()
                .background(DesignSystem.Color.black80)
                .frame(height: 2)
                .offset(y: -1)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(store.currentTabItems) { item in
                        questionsSection(item: item)
                    }
                }
                .listRowBackground(Color.clear)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .listStyle(.plain)
            
            Spacer()
            
            moreQuestionsSection()
                .padding(.top, 10)
                .padding(.bottom, 77)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.Color.soonganBG)
        .background(InteractivePopGestureEnabler())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    func questionsSection(item: QuestionItemModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 15) {
                Text(item.question)
                    .font(DesignSystem.Font.bold16, lineHeight: 20)
                    .foregroundStyle(DesignSystem.Color.black100)
                
                if store.expandedQuestionID == item.id {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(item.answer)
                            
                        if let data = item.subAnswers {
                            ForEach(data) { subAnswer in
                                VStack(alignment: .leading, spacing: 7) {
                                    Text(subAnswer.titleAnswer)
                                    
                                    Text(subAnswer.subAnswer)
                                        .padding(.leading, 9)
                                }
                            }
                        }
                    }
                    .font(DesignSystem.Font.bold12)
                    .foregroundStyle(DesignSystem.Color.gray55)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.vertical, 20)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    if store.expandedQuestionID == item.id {
                        store.expandedQuestionID = nil
                    } else {
                        store.expandedQuestionID = item.id
                    }
                }
            }
            
            Rectangle()
                .fill(Color(red: 187/255, green: 187/255, blue: 187/255))
                .frame(maxWidth: .infinity)
                .frame(height: 0.7)
                .padding(.horizontal, 24)
        }
    }
    
    func moreQuestionsSection() -> some View {
        VStack(spacing: 12) {
            Text("추가적인 문의가 있으신가요 ?")
            
            Link(destination: URL(string: "https://forms.gle/u6sUFeEq2oo3F7tG8")!) {
                VStack(spacing: 2) {
                    Text("문의하기")
                    
                    Divider()
                        .frame(width: 46, height: 1)
                        .background(DesignSystem.Color.black100)
                }
            }
        }
        .font(DesignSystem.Font.bold12)
        .foregroundStyle(DesignSystem.Color.gray55)
    }
}

#Preview {
    QuestionsListView(store: Store(initialState: QuestionsListFeature.State()) {
            QuestionsListFeature()
        }
    )
}
