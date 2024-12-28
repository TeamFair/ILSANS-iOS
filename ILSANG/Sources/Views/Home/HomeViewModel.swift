//
//  HomeViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/28/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    var userNickname: String = "유저123"
    var userRankList: [Rank] = [
        .init(xpType: "", xpPoint: 1220, customerId: "", nickname: "유저ABC"),
        .init(xpType: "", xpPoint: 20, customerId: "", nickname: "유저123456"),
        .init(xpType: "",xpPoint: 700, customerId: "", nickname: "일상999"),
        .init(xpType: "", xpPoint: 50, customerId: "", nickname: "유저939393"),
        .init(xpType: "", xpPoint: 20, customerId: "", nickname: "일상0213493")
    ]
    var largestRewardQuestList: [XpStat: [QuestViewModelItem]] = [
        .charm: QuestViewModelItem.mockQuestList,
        .fun: [
            QuestViewModelItem.mockQuestList[2],
            QuestViewModelItem.mockQuestList[1],
            QuestViewModelItem.mockQuestList[0]
        ],
        .sociability: [
            QuestViewModelItem.mockQuestList[1],
            QuestViewModelItem.mockQuestList[2],
            QuestViewModelItem.mockQuestList[3]
        ],
        .intellect: [
            QuestViewModelItem.mockQuestList[0],
            QuestViewModelItem.mockQuestList[2],
            QuestViewModelItem.mockQuestList[1]
        ],
        .strength: [
            QuestViewModelItem.mockQuestList[3],
            QuestViewModelItem.mockQuestList[2],
            QuestViewModelItem.mockQuestList[0]
        ]
    ]
    var recommendQuestList: [QuestViewModelItem] = QuestViewModelItem.mockQuestList
    var polularQuestList: [QuestViewModelItem] = QuestViewModelItem.mockQuestList
    
    @Published var selectedXpStat: XpStat = .strength

    @Published var showQuestSheet: Bool = false
    @Published var selectedQuest: QuestViewModelItem = .mockData
    
    func tappedQuestBtn(quest: QuestViewModelItem) {
        selectedQuest = quest
        showQuestSheet.toggle()
    }
}
