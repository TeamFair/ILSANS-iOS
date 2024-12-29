//
//  HomeViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/28/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    var recommendQuestTitle: String {
        if let nickname = UserService.shared.currentUser?.nickname {
            return nickname + "님을 위한 추천 퀘스트"
        } else {
            return "추천 퀘스트"
        }
    }
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
    var recommendQuestList: [QuestViewModelItem] = QuestViewModelItem.mockQuestList // 10개
    var popularQuestList: [QuestViewModelItem] = QuestViewModelItem.mockQuestList // 4n개
    
    @Published var selectedXpStat: XpStat = .strength

    @Published var showQuestSheet: Bool = false
    @Published var selectedQuest: QuestViewModelItem = .mockData
    @Published var showSubmitRouterView: Bool = false {
        didSet {
            // TODO: 해당 섹션 데이터만 다시 불러오도록 수정
            if showSubmitRouterView == false {
                Task {
                    await loadInitialData()
                }
            }
        }
    }
    
    func loadInitialData() async {
        
    }
    
    func tappedQuestBtn(quest: QuestViewModelItem) {
        selectedQuest = quest
        showQuestSheet.toggle()
    }
    
    func tappedQuestApprovalBtn() {
        showSubmitRouterView.toggle()
        showQuestSheet.toggle()
    }
}
