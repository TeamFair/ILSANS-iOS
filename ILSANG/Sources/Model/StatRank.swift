//
//  Rank.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/11/24.
//

struct StatRank: Decodable {
    let xpType: String
    let xpPoint: Int
    let customerId: String
    let nickname: String
}

struct TopRank: Decodable {
    let lank: Int
    let xpSum: Int
    let nickname: String
}
