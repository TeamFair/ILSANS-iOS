//
//  Quest.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/22/24.
//

import UIKit

struct QuestViewModelItem {
    let id: String
    var image: UIImage?
    let imageId: String?
    let missionTitle: String
    let writer: String
    var rewardDic: [XpStat: Int]
    
    init(id: String, image: UIImage? = nil, imageId: String, missionTitle: String, writer: String, rewardDic: [XpStat: Int]) {
        self.id = id
        self.image = image
        self.imageId = imageId
        self.missionTitle = missionTitle
        self.writer = writer
        self.rewardDic = rewardDic
    }
    
    init(quest: Quest) {
        self.id = quest.questId
        self.image = nil
        self.imageId = quest.imageId
        self.missionTitle = quest.missionTitle
        self.writer = quest.writer
        self.rewardDic = [:]
        
        for reward in quest.rewardList where reward.quantity > 0 && reward.type == "XP" {
            if let content = reward.content, let stat = XpStat(rawValue: content.lowercased()) {
                rewardDic[stat] = reward.quantity
            }
        }
    }
    
    func totalRewardXP() -> Int {
        self.rewardDic.values.reduce(0, +)
    }
}

extension QuestViewModelItem {
    static let mockImageId = "IMQU2024071520500801"
    
    static let mockData: QuestViewModelItem = QuestViewModelItem(
        id: "11",
        image: .checkmark,
        imageId: mockImageId,
        missionTitle: "아메리카노 15잔 마시기",
        writer: "이디야커피",
        rewardDic: [.charm: 30, .intellect: 100, .fun: 5]
    )
    
    static let mockQuestList: [QuestViewModelItem] = [
        QuestViewModelItem(
            id: "9f8aacc9-a221-491b-98c1-f9d7d35a67fb",
            image: .checkmark,
            imageId: mockImageId,
            missionTitle: "아메리카노 15잔 마시기",
            writer: "이디야커피",
            rewardDic: [.charm: 3, .sociability: 20, .strength: 25]
        ),
        QuestViewModelItem(
            id: "9f8aacc9-98c1-f9d7d35a67fb",
            image: .checkmark,
            imageId: mockImageId,
            missionTitle: "아메리카노 15잔 마시기",
            writer: "이디야커피",
            rewardDic: [.charm: 3, .fun: 25, .sociability: 20, .strength: 25]
        ),
        QuestViewModelItem(
            id: "9f8aacc9-a221-4-f9d7d35a67fb",
            image: .checkmark,
            imageId: mockImageId,
            missionTitle: "아메리카노 15잔 마시기",
            writer: "이디야커피",
            rewardDic: [.charm: 30, .intellect: 20, .fun: 25, .sociability: 20, .strength: 25]
        ),
        QuestViewModelItem(
            id: "13",
            image: .checkmark,
            imageId: mockImageId,
            missionTitle: "카페라떼 1잔 마시기",
            writer: "투썸플레이스",
            rewardDic: [.charm: 200, .intellect: 50, .fun: 25, .sociability: 100, .strength: 25]
        )
    ]
}
