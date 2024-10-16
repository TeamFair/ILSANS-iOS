//
//  Challenge.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/26/24.
//

import Foundation

// TODO: userNickName 옵셔널 해제
struct Challenge: Codable {
    let challengeId: String
    let userNickName: String?
    let missionTitle: String?
    let receiptImageId, status: String
    let questImageId: String?
    let createdAt: String
    let likeCnt, hateCnt: Int
    
    static let challengeMockData = Challenge(challengeId: "", userNickName: "일상유저123", missionTitle: "바닐라라떼 마시기", receiptImageId: "", status: "", questImageId: "", createdAt: "2024-01-01'T'00:00:00", likeCnt: 3, hateCnt: 0)
}

/// 서버에서 사용되는 Quest Entity
struct QuestEntity: Codable {
    let questId: String
    let missions: [Mission]
    let rewards: [Reward]
}

struct Mission: Codable {
    let content: String
    let target: String?
    let quantity: Int
    let type, title: String
}

struct Reward: Codable {
    let quantity: Int
    let content: String?
    let type: String
}
