//
//  RankingViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 10/7/24.
//

import UIKit
import SwiftUI

class RankingViewModel: ObservableObject {
    enum ViewStatus {
        case error
        case loading
        case loaded
    }
    
    @Published var viewStatus: ViewStatus = .loading
    @Published var selectedXpStat: XpStat = .strength
    @Published var userRank: [Rank] = []
    
    private let userNetwork: UserNetwork
    
    init(userNetwork: UserNetwork) {
        self.userNetwork = userNetwork
    }
    
    @MainActor
    func changeViewStatus(_ viewStatus: ViewStatus) {
        self.viewStatus = viewStatus
    }
    
    @MainActor
    func loadUserRank(xpStat: String) async {
        let res = await userNetwork.getUserRank(xpstat: xpStat)
        
        switch res {
        case .success(let model):
            self.userRank = model.data
            changeViewStatus(.loaded)
            Log(userRank)
            
        case .failure:
            changeViewStatus(.error)
            Log(res)
        }
    }
}

