//
//  Quest.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/2/24.
//

import Foundation
struct AWSQuest: Codable {
    let size: Int
    let data: [QuestData]
    let total: Int
    let page: Int
    let status: String
    let message: String
}

struct QuestData: Codable {
    let questId: String
    let marketId: String
    let missionTitle: String
    let rewardTitle: String
    let status: String
    let expireDate: String?
}
