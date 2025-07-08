//
//  QuestionItemModel.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 7/8/25.
//

import Foundation

struct QuestionItemModel: Equatable, Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let subAnswers: [AnswerModel]?
    
    init(question: String, answer: String, subAnswers: [AnswerModel]? = nil) {
        self.question = question
        self.answer = answer
        self.subAnswers = subAnswers
    }
}

struct AnswerModel: Equatable, Identifiable {
    let id = UUID()
    let titleAnswer: String
    let subAnswer: String
}
