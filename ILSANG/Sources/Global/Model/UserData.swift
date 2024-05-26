//
//  UserData.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/25/24.
//

import Foundation
import UIKit

//사용자 데이터는 변경 사항이 있을 수 있어서 아직 안만들었습니다.
struct UserData {
    let userName: String
    let userImage: UIImage
    let userLevel: Int
    let userXP: Int
    let userQuest: [QuestDetail]
}

struct QuestDetail : Hashable {
    let questTitle: String
    let questDetail: String
    let questXP: Int
    let status: SegmenetStatus
}

enum SegmenetStatus: String, CaseIterable {
    case QUEST
    case ACTIVITY
    case BADGE
    
    var header: String {
        switch self {
        case .QUEST:
            "퀘스트"
        case .ACTIVITY:
            "활동"
        case .BADGE:
            "뱃지"
        }
    }
}
