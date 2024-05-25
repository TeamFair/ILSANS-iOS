//
//  QuestViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/23/24.
//

import Foundation

class QuestViewModel: ObservableObject {
    @Published var selectedHeader: QuestStatus = .ACTIVE
    @Published var questList: [Quest] = Quest.mockDataList
    @Published var showQuestSheet: Bool = false
    @Published var selectedQuest: Quest = Quest.mockData

    func tappedQuestBtn(quest: Quest) {
        selectedQuest = quest
        showQuestSheet.toggle()
    }
}
