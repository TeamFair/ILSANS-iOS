//
//  Logout.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/22/24.
//

import Foundation

struct LogoutModel: Decodable {
    let data: Logout
    let status: String
    let message: String
}

struct Logout: Decodable {
    let mok: String?
}
