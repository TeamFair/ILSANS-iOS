//
//  UserNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation
import Alamofire

final class UserNetwork {
    private let url = APIManager.makeURL(CustomerTarget(path: "user"))
        
    func getUser() async -> Result<UserModel,Error> {
        return await Network.requestData(url: url, method: .get, parameters: nil, withToken: true)
    }
    
    @MainActor
    func putUser(nickname: String) async -> Bool {
        let parameters: Parameters = ["nickname": nickname]
        let res: Result<Response<UserModel>, Error> = await Network.requestData(url: url, method: .put, parameters: parameters, withToken: true)
        
        switch res {
        case.success:
            return true
            
        case.failure:
            return false
        }
    }
}
