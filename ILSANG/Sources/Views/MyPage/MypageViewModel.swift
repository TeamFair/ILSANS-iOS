//
//  MypageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import Foundation

class MypageViewModel: ObservableObject {
    @Published var userData: User?
    
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
}

struct MypageViewModelItem: Identifiable {
    var id: UUID
    var status: String
    var nickname: String
    var couponCount: Int
    var completeChallengeCount: Int
    var xpPoint: Int
}
