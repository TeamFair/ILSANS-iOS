//
//  Quest.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/22/24.
//

import UIKit

struct Quest {
    let id: String
    let missionImage: UIImage
    let missionTitle: String
    let missionCompany: String
    let reward: Int
    let status: QuestStatus
}

extension Quest {
    static let mockData: Quest = Quest(
        id: "11",
        missionImage: .checkmark,
        missionTitle: "아메리카노 15잔 마시기",
        missionCompany: "이디야커피",
        reward: 50,
        status: .ACTIVE
    )
    
    static let mockActiveDataList: [Quest] = [
        Quest(
            id: "9f8aacc9-a221-491b-98c1-f9d7d35a67fb",
            missionImage: .checkmark,
            missionTitle: "아메리카노 15잔 마시기",
            missionCompany: "이디야커피",
            reward: 50,
            status: .ACTIVE
        ),
        Quest(
            id: "13",
            missionImage: .checkmark,
            missionTitle: "카페라떼 1잔 마시기",
            missionCompany: "투썸플레이스",
            reward: 150,
            status: .ACTIVE
        )
    ]
    
    static let mockInactiveDataList: [Quest] = [
        Quest(
            id: "12",
            missionImage: .checkmark,
            missionTitle: "아메리카노 15잔 마시기",
            missionCompany: "이디야커피",
            reward: 50,
            status: .INACTIVE
        ),
        Quest(
            id: "13",
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
    
    var emptyTitle: String {
        switch self {
        case .ACTIVE:
            "퀘스트를 모두 완료하셨어요!"
        case .INACTIVE:
            "완료된 퀘스트가 없어요"
        }
    }
    
    var emptySubTitle: String {
        switch self {
        case .ACTIVE:
            "상상할 수 없는 퀘스트를 준비 중이니\n다음 업데이트를 기대해 주세요!"
        case .INACTIVE:
            "퀘스트를 수행하러 가볼까요?"
        }
    }
}
