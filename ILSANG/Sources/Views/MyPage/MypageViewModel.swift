//
//  MypageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import Foundation

class MypageViewModel: ObservableObject {
    @Published var userData: User?
    @Published var challengeList: [Challenge] = []
    
    private let userNetwork: UserNetwork
    private let questNetwork: ChallengeNetwork
    private let xpNetwork: XPNetwork
    
    init(userData: User? = nil, userNetwork: UserNetwork, xpNetwork: XPNetwork, questNetwork: ChallengeNetwork) {
        self.userData = userData
        self.userNetwork = userNetwork
        self.xpNetwork = xpNetwork
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
    func getxpLog(userId: String, title: String, page: Int) async {
        let res = await xpNetwork.getXP(userId: userId, title: title, page: page, size: 10)
        
        switch res {
        case .success(let model):
            self.questXp = [model]
            Log(questXp)
            
        case .failure:
            self.questXp = nil
            
        }
    }
    
    @MainActor
    func getQuest(page: Int) async {
        let Data = await questNetwork.getChallenges(page: page)
        
        switch Data {
        case .success(let model):
            self.challengeList = model.data
            Log(self.challengeList)

        case .failure:
            self.challengeList = []
        }
    }
    
    func convertXPtoLv(XP: Int) -> Int {
        var totalXP = 0
        var level = 0
        
        while totalXP <= XP {
            level += 1
            totalXP += 50 * level
        }
        
        return level - 1
    }
    
    func xpForNextLv(XP: Int) -> String {
        let currentLevel = convertXPtoLv(XP: XP)
        let nextLevel = currentLevel + 1
        var totalXP = 0
        
        for n in 1...nextLevel {
            totalXP += 50 * n
        }
        
        return String( totalXP - XP )
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
