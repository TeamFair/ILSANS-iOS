//
//  XP.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation

struct XPModel: Decodable {
    let data: XP
}

struct XP: Decodable {
    let content: XPContent
    let pageable: Int
    let status: String
    let message: String
}

struct XPContent: Decodable {
    let Title: String
    let Detail: String
    let Xp: Int
}
