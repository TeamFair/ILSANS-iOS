//
//  RankingViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 10/7/24.
//

import UIKit
import SwiftUI
import Alamofire

class RankingViewModel: ObservableObject {
    enum ViewStatus {
        case error
        case loading
        case loaded
    }
    
    @Published var viewStatus: ViewStatus = .loading
    @Published var selectedXpStat: XpStat = .strength
    @Published var userRank: [Rank] = []
    @Published var mokData: [Rank] = [
        Rank(xpType: "CHARM", xpPoint: 200, customerId: "1234-5678-91011", nickname: "TestUser1"),
        Rank(xpType: "STRENGTH", xpPoint: 150, customerId: "2234-5678-91011", nickname: "TestUser2"),
        Rank(xpType: "CHARM", xpPoint: 300, customerId: "3234-5678-91011", nickname: "TestUser3")
    ]
    
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
        let res = await userNetwork.getUserRank(xpstat: xpStat, page: 0)
        
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
    
    //Int -> th, st, nd, rd형태로 변경
    static func convertToOrdinal(_ number: Int) -> String {
        let suffix: String
        
        let lastTwoDigits = number % 100
        if lastTwoDigits >= 11 && lastTwoDigits <= 13 {
            suffix = "th"
        } else {
            switch number % 10 {
            case 1:
                suffix = "st"
            case 2:
                suffix = "nd"
            case 3:
                suffix = "rd"
            default:
                suffix = "th"
            }
        }
        
        return "\(number)\(suffix)"
    }
}

