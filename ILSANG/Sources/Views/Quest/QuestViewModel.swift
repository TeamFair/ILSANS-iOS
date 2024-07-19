//
//  QuestViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/23/24.
//

import UIKit

class QuestViewModel: ObservableObject {
    enum ViewStatus {
        case error
        case loading
        case loaded
    }
    
    @Published var viewStatus: ViewStatus = .loading
    @Published var selectedHeader: QuestStatus = .uncompleted
    @Published var selectedQuest: QuestViewModelItem = .mockData
    @Published var showQuestSheet: Bool = false
    @Published var showSubmitRouterView: Bool = false
    
    @Published var itemListByStatus: [QuestStatus: [QuestViewModelItem]] = [
        .uncompleted: [],
        .completed: []
    ]
    
    var isCurrentListEmpty: Bool {
        switch selectedHeader {
        case .uncompleted:
            return itemListByStatus[.uncompleted, default: []].isEmpty
        case .completed:
            return itemListByStatus[.completed, default: []].isEmpty
        }
    }
    
    private let imageNetwork: ImageNetwork
    private let questNetwork: QuestNetwork
    
    init(imageNetwork: ImageNetwork, questNetwork: QuestNetwork) {
        self.imageNetwork = imageNetwork
        self.questNetwork = questNetwork
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
