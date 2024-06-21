//
//  Customer.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation

struct CustomerModel: Decodable {
    let data: Customer
    let status: String
    let message: String
}

struct Customer: Decodable {
    let status: String
    let nickname: String
    let couponCount: Int
    let completeChallengeCount: Int
    let xpPoint: Int
}
