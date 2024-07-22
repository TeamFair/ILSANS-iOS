//
//  XPNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation
import Alamofire

final class XPNetwork {
    private let url = APIManager.makeURL(CustomerTarget(path: "xp"))
    
    func getXP(userId: String, title: String, page: Int, size: Int) async -> Result<XP,Error> {
        let parameters: Parameters = ["userId": userId, "title": title,"page": page, "size": size]
        return await Network.requestData(url: url + "", method: .get, parameters: parameters, withToken: true)
    }
}
