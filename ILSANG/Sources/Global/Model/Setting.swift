//
//  Setting.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/29/24.
//

import Foundation

struct Setting : Identifiable {
    //arrow가 False일때 subInfo 작성
    let id = UUID()
    let title: String
    let arrow: Bool
    let subInfo: String?
}
