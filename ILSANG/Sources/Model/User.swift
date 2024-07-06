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
