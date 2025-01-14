//
//  MyPageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import UIKit

final class MyPageViewModel: ObservableObject {
    @Published var userData: User?
    @Published var selectedTab: MyPageTab = .quest

    @Published var xpStats: [XpStat: Int] = [:]
    @Published var xpLogList: [XpLog] = []
    @Published var challengeList: [Challenge] = []
    
    @Published var challengeDelete = false
    
    private let userNetwork: UserNetwork
    private let challengeNetwork: ChallengeNetwork
    private let imageNetwork: ImageNetwork
    private let xpNetwork: XPNetwork
    
    init(userNetwork: UserNetwork, challengeNetwork: ChallengeNetwork, imageNetwork: ImageNetwork, xpNetwork: XPNetwork) {
        self.userNetwork = userNetwork
        self.challengeNetwork = challengeNetwork
        self.imageNetwork = imageNetwork
        self.xpNetwork = xpNetwork
        
        self.userData = UserService.shared.currentUser
    }
    
    @MainActor
    func getUser() async {
        let res = await userNetwork.getUser()
        
        switch res {
        case .success(let model):
            self.userData = model.data
        case .failure(let err):
            self.userData = nil
            Log(err)
        }
    }
    
    @MainActor
    func getXpLog(page: Int, size: Int) async {
        let res = await xpNetwork.getXpHistory(page: page, size: 10)
        
        switch res {
        case .success(let model):
            self.xpLogList = model.data
            
        case .failure(let err):
            self.xpLogList = []
            Log(err)
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
        let res = await challengeNetwork.getChallenges(page: page)
        
        switch res {
        case .success(let model):
            self.challengeList = model.data
        case .failure:
            self.challengeList = []
        }
    }
    
    @MainActor
    func updateChallengeStatus(challengeId: String, ImageId: String) async -> Bool {
        let deleteChallengeRes = await challengeNetwork.deleteChallenge(challengeId: challengeId)
        let deleteImageRes = await imageNetwork.deleteImage(imageId: ImageId)
                
        return deleteChallengeRes && deleteImageRes
    }
    
    func getImage(imageId: String) async -> UIImage? {
        await ImageCacheService.shared.loadImageAsync(imageId: imageId)
    }
}
