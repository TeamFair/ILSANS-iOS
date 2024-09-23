//
//  XpStats.swift
//  ILSANG
//
//  Created by Kim Andrew on 9/23/24.
//

import Foundation

struct XpstatModel: Decodable {
    let data: Xpstats
}

struct Xpstats: Decodable {
    let strengthStat: Int
    let intellectStat: Int
    let funStat: Int
    let charmStat: Int
    let sociabilityStat: Int
}
