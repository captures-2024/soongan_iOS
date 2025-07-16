//
//  QuestionsListFeature.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture

public enum QuestionsTab: Equatable {
    case nomal, contestInfo, copyright
}

@Reducer
public struct QuestionsListFeature {
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: QuestionsTab = .nomal
        var editButtonState: Bool = false
        
        var questions: [QuestionsTab: [QuestionItemModel]] = [:]
            
        var expandedQuestionID: UUID?
        
        var currentTabItems: [QuestionItemModel] {
            questions[selectedTab] ?? []
        }
        
        public init() {}
    }

    // MARK: - Init

    init() {}

    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case topMenuButtonTapped(QuestionsTab)
        case questionTapped(id: UUID)
        case backButtonTapped
    }

    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                state.questions[.nomal] = [
                    QuestionItemModel(
                        question: "Q1.'순간'이란 무엇인가요?",
                        answer: "'순간'은 여러분의 특별한 찰나를 사진으로 기록하고, 이를 통해 사람들과 소통할 수 있는 사진 공유 플랫폼입니다. 단순히 잘 찍힌 사진보다, 여러분이 느끼는 특별한 순간과 감정이 담긴 사진을 소중히 여깁니다. 서로의 행복한 순간을 공유하며, 다른 사람들의 시선을 이해하고 공감할 수 있는 공간이죠. '순간'에서 다양한 감정과 이야기를 사진으로 나누며 특별한 경험을 즐겨보세요!"),
                    QuestionItemModel(
                        question: "Q2. 제가 이 콘테스트에 왜 참가해야 할까요?",
                        answer: "'순간' 콘테스트에 참가하는 이유는 사람마다 다를 수 있지만, 크게 세 가지 이유가 있습니다!",
                        subAnswers: [
                            AnswerModel(
                                titleAnswer: "• 전문적인 사진작가",
                                subAnswer: "'순간'은 다른 사람들이 내 사진을 어떻게 느끼는지 바로 알 수 있는 기회를 제공합니다. 콘테스트에서 받은 피드백과 반응은 사진 스타일을 발전시키는 데 큰 도움이 될 거예요. 다양한 주제의 사진을 찍고 공유하면서 새로운 영감도 얻을 수 있습니다. 수상작으로 선정된다면 더 많은 사람들에게 내 작품을 알릴 수 있는 기회도 얻을 수 있죠!"
                            ),
                            AnswerModel(
                                titleAnswer: "• 아마추어 사진가",
                                subAnswer: "주어진 주제에 맞춰 사진을 찍으면서, 자신의 스타일과 시각을 찾아가는 과정을 경험할 수 있습니다. 사진에 대한 이해도를 높이고 표현력을 키우는 데 큰 도움이 될 거예요. 다른 참가자들의 작품을 보며 새로운 영감을 얻고, 나만의 독창적인 시선을 담은 사진을 발전시킬 기회를 놓치지 마세요. 공감과 피드백을 통해 사진작가로 성장할 수 있는 발판을 마련할 수 있습니다."
                            ),
                            AnswerModel(
                                titleAnswer: "• 사진 감상자",
                                subAnswer: "사진을 찍기보다는 감상하는 걸 좋아한다면? '순간'은 다양한 시선과 감성으로 가득한 사진들을 감상할 수 있는 곳이에요. 색다른 주제의 사진을 보며 일상에서 쉽게 접할 수 없는 다양한 시각과 해석을 경험할 수 있습니다. 사진 속에 담긴 감정과 이야기를 이해하고 공감할 수 있는 시간을 가져보세요."
                            )
                        ]
                    )
                ]
                
                state.questions[.contestInfo] = [
                    QuestionItemModel(
                        question: "Q1. 작품을 출품하고 싶어요. 어떻게 해야 하나요?",
                        answer: "메인 화면 중앙에 있는 + 버튼을 눌러 출품할 수 있습니다. 이미 출품한 작품이 있더라도 + 버튼을 누르면 추가로 출품이 가능합니다. (참고로 작품 제목은 20자 미만으로 입력해야 한다는 점 기억해주세요!)"),
                    QuestionItemModel(
                        question: "Q2. 콘테스트 참가 작품을 보고 싶어요!",
                        answer: "현재 진행 중인 콘테스트의 참가 작품은 메인 화면에서 우측 하단에 있는 참가 작품 아이콘을 눌러 확인할 수 있습니다. 역대 콘테스트 작품은 '역대콘' 탭에서 보고 싶은 회차를 선택해 감상할 수 있어요."),
                    QuestionItemModel(
                        question: "Q3. 콘테스트 규칙을 알고 싶어요!",
                        answer: "다음은 주요 콘테스트 규칙입니다",
                        subAnswers: [
                            AnswerModel(
                                titleAnswer: "• 출품 작품 개수",
                                subAnswer: "회차별로 최대 3개의 작품을 출품할 수 있습니다."
                            ),
                            AnswerModel(
                                titleAnswer: "• 동점자 처리 방식",
                                subAnswer: "동점일 경우, 1. 직전 회차 참가 여부 / 2. 1차 투표에서 받은 좋아요 수 / 3. 업로드 시간을 기준으로 처리됩니다."
                            ),
                            AnswerModel(
                                titleAnswer: "• TOP7 & 우승자 선정 방식",
                                subAnswer: "TOP7과 우승자는 좋아요 개수로 결정되며, 제목 또한 많은 공감을 이끌어낼 수 있는 중요한 요소입니다!"
                            ),
                            AnswerModel(
                                titleAnswer: "• 사진 변경",
                                subAnswer: "출품 후 사진 변경은 불가하지만, 제목은 언제든지 수정 가능합니다."
                            ),
                        ]
                    ),
                    QuestionItemModel(
                        question: "Q4. AI로 만든 사진도 제출할 수 있나요?",
                        answer: "아쉽지만 AI로 생성한 사진은 제출할 수 없습니다. 다만, 직접 찍은 사진에 필터나 작은 요소를 합성하는 정도의 편집은 가능합니다. AI 기반 이미지가 아닌, 여러분이 직접 찍은 사진이 기본이 되어야 합니다. 하지만 AI를 활용한 콘텐츠에 관심이 있다면 저희에게 알려주세요. '순간'의 다음 프로젝트로 발전할 수도 있거든요! ^^"),
                    QuestionItemModel(
                        question: "Q5. 우승하면 어떤 혜택이 있나요?",
                        answer: "최종 1위 우승자는 앱을 켰을 때 등장하는 메인 화면에 우승 사진이 소개됩니다. 또한 역대 콘테스트를 소개하는 대표 사진으로도 사용되죠. 마지막으로, 나만의 팁이나 이야기를 공유할 수 있는 인터뷰 기회도 제공됩니다!"),
                ]
                
                state.questions[.copyright] = [
                    QuestionItemModel(
                        question: "Q1. 사진의 저작권은 누구에게 있나요?",
                        answer: "모든 사진의 저작권은 촬영한 본인에게 있습니다. '순간'은 여러분이 자신의 작품을 자유롭게 공유하고, 시각과 감정을 표현할 수 있는 공간을 제공합니다. 다만, 콘테스트에 제출된 사진은 '순간' 앱 내에서 홍보 및 전시 목적으로 사용될 수 있습니다."),
                    QuestionItemModel(
                        question: "Q2. 사진 업로드 시 저작권 관련 주의사항이 있나요?",
                        answer: "네, 몇 가지 중요한 저작권 관련 사항이 있습니다",
                        subAnswers: [
                            AnswerModel(
                                titleAnswer: "• 타인의 작품 사용 금지",
                                subAnswer: "다른 사람의 사진, 이미지, 그래픽 등을 무단으로 사용해서는 안 됩니다. 반드시 본인이 직접 촬영한 사진만 사용해주세요."
                            ),
                            AnswerModel(
                                titleAnswer: "• 초상권",
                                subAnswer: "다른 사람의 얼굴이나 신체가 포함된 사진은 당사자의 동의를 받아야 합니다. 이를 어길 경우 사진이 삭제되거나 법적 문제가 발생할 수 있어요."
                            ),
                            AnswerModel(
                                titleAnswer: "• 상업적 사용 금지",
                                subAnswer: "상표나 로고가 포함된 사진은 상업적 목적으로 사용할 수 없습니다. 주의해서 촬영해주세요!"
                            ),
                        ]
                    ),
                    QuestionItemModel(
                        question: "Q3. TOP7 선정 후, 저작권 침해가 확인되면 어떻게 되나요?",
                        answer: "만약 TOP7에 선정되거나 최종 투표가 완료된 이후 저작권 침해가 발견될 경우 다음 조치가 취해집니다",
                        subAnswers: [
                            AnswerModel(
                                titleAnswer: "• 수상 취소 및 사진 삭제",
                                subAnswer: "해당 사진은 즉시 삭제되며 수상 자격도 박탈될 수 있습니다. 수상 혜택도 모두 회수될 수 있습니다."
                            ),
                            AnswerModel(
                                titleAnswer: "• 법적 책임",
                                subAnswer: "저작권 침해에 따른 법적 책임은 사진을 업로드한 사용자에게 있습니다. '순간'은 이런 분쟁에 관여하지 않지만, 피해자의 요청에 따라 필요한 조치를 취할 수 있습니다."
                            ),
                            AnswerModel(
                                titleAnswer: "• 계정 제한",
                                subAnswer: "저작권 침해 사례가 반복될 경우 사용자 계정이 일시적 혹은 영구적으로 제한될 수 있습니다. 이는 다른 사용자의 권리를 보호하기 위한 조치입니다."
                            ),
                        ]
                    )
                ]
                
                return .none
            
            case .binding(_):
                return .none
                
            case .backButtonTapped:
                return .none
                
            case .topMenuButtonTapped(let tab):
                state.selectedTab = tab
                state.expandedQuestionID = nil
                
                return .none
                
            case .questionTapped(let id):
                if state.expandedQuestionID == id {
                    state.expandedQuestionID = nil // 이미 열려있으면 닫기
                } else {
                    state.expandedQuestionID = id // 닫혀있으면 열기
                }
                return .none
            }
        }
    }
}
