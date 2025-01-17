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
    @Published var userRank: [XpStat: [StatRank]] = Dictionary(uniqueKeysWithValues: XpStat.allCases.map { ($0, []) })
   
    private let userNetwork: UserNetwork
    
    init(userNetwork: UserNetwork) {
        self.userNetwork = userNetwork
    }
    
    @MainActor
    func changeViewStatus(_ viewStatus: ViewStatus) {
        self.viewStatus = viewStatus
    }
    
    func loadAllUserRank() async {
        for xpStat in XpStat.allCases {
            await loadUserRank(xpStat: xpStat)
        }
    }
    
    @MainActor
    func loadUserRank(xpStat: XpStat) async {
        let res = await userNetwork.getUserRank(xpstat: xpStat.parameterText)
        
        switch res {
        case .success(let model):
            var updatedRank = self.userRank
            updatedRank[xpStat] = model.data
            self.userRank = updatedRank
            
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

