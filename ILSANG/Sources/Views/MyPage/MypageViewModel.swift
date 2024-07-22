//
//  MypageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import Foundation
import UIKit

class MypageViewModel: ObservableObject {
    @Published var userData: User?
    @Published var challengeList: [Challenge]?
    @Published var questXp: [XPContent]?
    
    private let userNetwork: UserNetwork
    private let questNetwork: ChallengeNetwork
    private let imageNetwork: ImageNetwork
    private let xpNetwork: XPNetwork
    
    init(userData: User? = nil, userNetwork: UserNetwork, xpNetwork: XPNetwork, questNetwork: ChallengeNetwork, imageNetwork: ImageNetwork) {
        self.userData = userData
        self.userNetwork = userNetwork
        self.xpNetwork = xpNetwork
        self.questNetwork = questNetwork
        self.imageNetwork = imageNetwork
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
            Log(res)
        }
    }
    
    @MainActor
    func getxpLog(userId: String, title: String, page: Int, size: Int) async {
        let res = await xpNetwork.getXP(userId: userId, title: title, page: page, size: 10)
        
        switch res {
        case .success(let model):
            self.questXp = model.data
            Log(questXp)
            
        case .failure:
            self.questXp = nil
            Log(res)
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
            self.challengeList = nil
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
    
    func xpForNextLevel(currentXP: Int) -> Int {
        let currentLevel = convertXPtoLv(XP: currentXP)
        let nextLevel = currentLevel + 1
        var totalXPForNextLevel = 0
        
        for n in 1...nextLevel {
            totalXPForNextLevel += 50 * n
        }
        
        return totalXPForNextLevel - currentXP
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
    
    @MainActor
     func getImage(imageId: String) async -> UIImage? {
        let res = await imageNetwork.getImage(imageId: imageId)
        switch res {
        case .success(let uiImage):
            return uiImage
        case .failure:
            return nil
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
