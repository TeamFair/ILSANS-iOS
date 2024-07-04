//
//  MypageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import Foundation

class MypageViewModel: ObservableObject {
    @Published var userData: User?
    @Published var QuestList: [QuestData]?
    @Published var UncompletedQuestList: [QuestData]?
    
    private let userNetwork: UserNetwork
    private let questNetwork: QuestNetwork
    
    init(userData: User? = nil, userNetwork: UserNetwork, questNetwork: QuestNetwork) {
        self.userData = userData
        self.userNetwork = userNetwork
        self.questNetwork = questNetwork
    }
    
    @MainActor
    func getUser() async {
        let res = await userNetwork.getUser()
        
        switch res {
        case .success(let model):
            self.userData = model.data
            Log(model.data)
            
        case .failure:
            self.userData = nil
        }
    }
    
    @MainActor
    func getQuest(page: Int) async {
        let Uncompleted = await questNetwork.getUncompletedQuest(page: page)
        let Completed = await questNetwork.getCompletedQuest(page: page)
        
        switch Uncompleted {
        case .success(let model):
            self.UncompletedQuestList = model.data
            
        case .failure:
            self.UncompletedQuestList = nil
        }
        
        switch Completed {
        case .success(let model):
            self.QuestList = model.data
            
        case .failure:
            self.QuestList = nil
        }
    }
}

struct MypageViewModelItem: Identifiable {
    var id: UUID
    var status: String
    var nickname: String
    var couponCount: Int
    var completeChallengeCount: Int
    var xpPoint: Int
}
