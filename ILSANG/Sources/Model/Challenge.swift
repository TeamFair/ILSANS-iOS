//
//  Challenge.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/26/24.
//

import Foundation

// TODO: ResponseWithPage와 응답 형식 통일 요청 후 수정
// MARK: - ICH004 에서 사용되는 모델
struct RandomChallengeList: Codable {
    let content: [Challenge]
    let last: Bool?
}

// TODO: userNickName 옵셔널 해제
struct Challenge: Codable {
    let challengeId: String
    let userNickName: String?
    let quest: QuestEntity
    let receiptImageId, status: String
    let createdAt: String
    let likeCnt, hateCnt: Int
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
    let type: String
}
