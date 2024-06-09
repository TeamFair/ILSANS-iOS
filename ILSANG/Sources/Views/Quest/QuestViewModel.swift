//
//  QuestViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/23/24.
//

import Foundation

class QuestViewModel: ObservableObject {
    @Published var selectedHeader: QuestStatus = .ACTIVE
    @Published var activeQuestList: [Quest] = Quest.mockActiveDataList
    @Published var inactiveQuestList: [Quest] = Quest.mockInactiveDataList
    @Published var showQuestSheet: Bool = false
    @Published var selectedQuest: Quest = Quest.mockData
    @Published var showSubmitRouterView: Bool = false

    var isCurrentListEmpty: Bool {
        switch selectedHeader {
        case .ACTIVE:
            return activeQuestList.isEmpty
        case .INACTIVE:
            return inactiveQuestList.isEmpty
        }
    }
    
    func tappedQuestBtn(quest: Quest) {
        selectedQuest = quest
        showQuestSheet.toggle()
    }
    
    func tappedQuestApprovalBtn() {
        showSubmitRouterView.toggle()
        showQuestSheet.toggle()
    }
}
