//
//  XpStats.swift
//  ILSANG
//
//  Created by Kim Andrew on 9/23/24.
//

import Foundation

struct XpStatModel: Decodable {
    let data: XpStat
}


struct XpStat: Decodable {
    let strength_stat: Int
    let intellect_stat: Int
    let fun_stat: Int
    let charm_stat: Int
    let sociability_stat: Int
}

