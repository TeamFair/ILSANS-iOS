//
//  MypageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import Foundation
import UIKit
import SwiftUI

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
    
    //XP를 레벨로 변경
    func convertXPtoLv(XP: Int) -> Int {
        var totalXP = 0
        var level = 0
        
        while totalXP <= XP {
            level += 1
            totalXP += 50 * level
        }
        
        return level - 1
    }
    
    //이전,다음 레벨 XP
    func xpGapBtwLevels(XP: Int) -> (currentLevelXP: Int, nextLevelXP: Int) {
        let currentLevel = convertXPtoLv(XP: XP)
        let nextLevelXP = 50 * (currentLevel + 1)
        
        var totalXP = 0
        
        for n in 1..<currentLevel + 1 {
            totalXP += 50 * n
        }
        
        return (XP - totalXP, nextLevelXP)
    }
    
    //다음 레벨까지 남은 값 
    func xpForNextLv(XP: Int) -> Int {
        let currentLevel = convertXPtoLv(XP: XP)
        let nextLevel = currentLevel + 1
        var totalXP = 0
        
        for n in 1...nextLevel {
            totalXP += 50 * n
        }
        Log(totalXP)
        return totalXP - XP
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
    
    func ProgressBar(userXP: Int) -> some View {
        let progress = calculateProgress(userXP: xpGapBtwLevels(XP: userXP).currentLevelXP, levelXP: xpGapBtwLevels(XP: userXP).nextLevelXP)
        
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 11)
                    .cornerRadius(6)
                    .opacity(0.3)
                    .foregroundColor(.gray100)
                
                Rectangle()
                    .frame(width: CGFloat(progress) * geometry.size.width, height: 10)
                    .cornerRadius(6)
                    .foregroundColor(.accentColor)
            }
            .onAppear {
                Log("Progress: \(progress)")
                Log(self.xpGapBtwLevels(XP: userXP).currentLevelXP)
                Log(self.xpGapBtwLevels(XP: userXP).nextLevelXP)
            }
        }
    }
    
    func calculateProgress(userXP: Int, levelXP: Int) -> Double {
        guard levelXP != 0 else { return 0 }
        return Double(userXP) / Double(levelXP)
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
