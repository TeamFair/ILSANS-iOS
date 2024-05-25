//
//  Quest.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/22/24.
//

import UIKit

struct Quest {
    let missionImage: UIImage
    let missionTitle: String
    let missionCompany: String
    let reward: Int
    let status: QuestStatus
}

extension Quest {
    static let mockData: Quest = Quest(
        missionImage: .checkmark,
        missionTitle: "아메리카노 15잔 마시기",
        missionCompany: "이디야커피",
        reward: 50,
        status: .ACTIVE
    )
    
    static let mockDataList: [Quest] = [
        Quest(
            missionImage: .checkmark,
            missionTitle: "아메리카노 15잔 마시기",
            missionCompany: "이디야커피",
            reward: 50,
            status: .ACTIVE
        ),
        Quest(
            missionImage: .checkmark,
            missionTitle: "카페라떼 1잔 마시기",
            missionCompany: "투썸플레이스",
            reward: 150,
            status: .INACTIVE
        )
    ]
}

enum QuestStatus: String, CaseIterable {
    case ACTIVE
    case INACTIVE
    
    var headerText: String {
        switch self {
        case .ACTIVE:
            "퀘스트"
        case .INACTIVE:
            "완료"
        }
    }
}
