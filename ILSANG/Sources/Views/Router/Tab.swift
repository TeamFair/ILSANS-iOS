//
//  Tab.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/20/24.
//

enum Tab: CaseIterable {
    case quest
    case approval
    case mypage
    
    var icon: String {
        switch self {
        case .quest:
            return "play"
        case .approval:
            return "play"
        case .mypage:
            return "play"
        }
    }
    
    var title: String {
        switch self {
        case .quest:
            return "퀘스트"
        case .approval:
            return "인증"
        case .mypage:
            return "마이"
        }
    }
}
