//
//  UserModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation

struct UserModel: Decodable {
    let data: User?
    let status: String
    let message: String
}

struct User: Decodable {
    let status: String
    let nickname: String
    let couponCount: Int
    let completeChallengeCount: Int
    let xpPoint: Int
}
