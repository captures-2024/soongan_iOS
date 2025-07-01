//
//  AlarmListModel.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import Foundation

public struct AlarmListModel: Identifiable, Hashable {
    public let id: Int
    public let title: String
    public let content: String
    public let isRead: Bool
    public let redirectUrl: String
    public let time: String
}
