//
//  MypageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import SwiftUI

final class MypageViewModel: ObservableObject {
    
    @Published var segmentSelect = 0
    
    @Published var userData: User?
    @Published var xpStats: [XpStat: Int] = [:]
    @Published var xpLogList: [XPContent] = []
    @Published var challengeList: [Challenge] = []
    
    @Published var challengeDelete = false
    
    let mockXpStats: [XpStat: Int] = [
        .strength: 0,
        .intellect: 10,
        .fun: 20,
        .charm: 30,
        .sociability: 40
    ]
    
    private let userNetwork: UserNetwork
    private let challengeNetwork: ChallengeNetwork
    private let imageNetwork: ImageNetwork
    private let xpNetwork: XPNetwork
    
    init(userData: User? = nil, userNetwork: UserNetwork, challengeNetwork: ChallengeNetwork, imageNetwork: ImageNetwork, xpNetwork: XPNetwork) {
        self.userData = userData
        self.userNetwork = userNetwork
        self.challengeNetwork = challengeNetwork
        self.imageNetwork = imageNetwork
        self.xpNetwork = xpNetwork
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
    func getxpLog(page: Int, size: Int) async {
        let res = await xpNetwork.getXP(page: page, size: 10)
        
        switch res {
        case .success(let model):
            self.xpLogList = model.data
            
        case .failure:
            self.xpLogList = []
            Log(res)
        }
    }
    
    @MainActor
    func getXpStat() async {
        let res = await xpNetwork.getXpStats()
        
        switch res {
        case .success(let model):
            let xpData = model.data
            self.xpStats = [
                .strength: xpData.strengthStat,
                .intellect: xpData.intellectStat,
                .fun: xpData.funStat,
                .charm: xpData.charmStat,
                .sociability: xpData.sociabilityStat
            ]
            Log(xpStats)
            
        case .failure:
            self.xpStats = [:]
        }
    }
    
    @MainActor
    func getChallenges(page: Int) async {
        let Data = await challengeNetwork.getChallenges(page: page)
        
        switch Data {
        case .success(let model):
            self.challengeList = model.data
            Log(self.challengeList)

        case .failure:
            self.challengeList = []
        }
    }
    
    @MainActor
    func updateChallengeStatus(challengeId: String, ImageId: String) async -> Bool {
        let deleteChallengeRes = await challengeNetwork.deleteChallenge(challengeId: challengeId)
        let deleteImageRes = await imageNetwork.deleteImage(imageId: ImageId)
        
        Log(deleteChallengeRes); Log(deleteImageRes)
        
        return deleteChallengeRes && deleteImageRes
    }
    
    //XP를 레벨로 변경
    func convertXPtoLv(XP: Int) -> Int {
        var totalXP = 0
        var level = 0
        
        while totalXP <= XP {
            level += 1
            totalXP += 50 * level
        }
        
        return max(0, level - 1)
    }
    
    //이전,다음 레벨 XP
    func xpGapBtwLevels(XP: Int) -> (currentLevelXP: Int, nextLevelXP: Int) {
        let sanitizedXP = max(0, XP)
        
        let currentLevel = convertXPtoLv(XP: sanitizedXP)
        let nextLevelXP = 50 * (currentLevel + 1)
        
        var totalXP = 0
        
        if currentLevel > 0 {
            for n in 1..<currentLevel + 1 {
                totalXP += 50 * n
            }
        }
        
        return (sanitizedXP - totalXP, nextLevelXP)
    }
    
    //다음 레벨까지 남은 값 
    func xpForNextLv(XP: Int) -> Int {
        let sanitizedXP = max(0, XP)
        let currentLevel = convertXPtoLv(XP: sanitizedXP)
        let nextLevel = currentLevel + 1
        var totalXP = 0
        
        for n in 1...nextLevel {
            totalXP += 50 * n
        }
        
        Log(totalXP)
        return totalXP - sanitizedXP
    }
    
    func getImage(imageId: String) async -> UIImage? {
        await ImageCacheService.shared.loadImageAsync(imageId: imageId)
    }
}

extension ChangeNickNameView {
    func isValidNickname(_ name: String) -> Bool {
        let language = ".*[가-힣a-zA-Z0-9]+.*"
        let isMatche = NSPredicate(format: "SELF MATCHES %@", language).evaluate(with: name)
        let isValidLength = (2...12).contains(name.count)
        
        return isMatche && isValidLength
    }
}
