//
//  Quest.swift
//  ILSANG
//
//  Created by Lee Jinhee on 7/18/24.
//

struct Quest: Codable {
    let questId: String
    let writer: String
    let missionTitle: String
    let status: String
    let creatorRole: String
    let imageId: String?
    let rewardList: [Reward]
    let type: String
    let target: String
    let score: Int?
}

struct Reward: Codable {
    let quantity: Int
    let content: String?
    let type: String
}
