//
//  UserModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation

struct User: Decodable {
    let status: String
    let nickname: String
    let couponCount: Int
    let completeChallengeCount: Int
    let xpPoint: Int
}

struct UserRank: Decodable {
    let data: [Rank]
    let status: String
    let message: String
}

struct Rank: Decodable {
    let xpType: String
    let xpPoint: Int
    let customerId: String
    let nickname: String
}
