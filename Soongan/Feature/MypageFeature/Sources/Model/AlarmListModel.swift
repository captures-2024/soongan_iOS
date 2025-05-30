//
//  AlarmListModel.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import Foundation

struct AlarmListModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
    let time: String
    
    init(title: String, content: String, time: String) {
        self.title = title
        self.content = content
        self.time = time
    }
}
